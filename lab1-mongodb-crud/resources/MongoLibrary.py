from pymongo import MongoClient
from robot.api.deco import keyword, library
from bson.objectid import ObjectId
from bson.errors import InvalidId
from robot.api import Error as RobotError
from copy import deepcopy  # <-- Ajouté

@library
class MongoLibrary:
    def __init__(self):
        self.client = None
        self.db = None

    @keyword
    def connect_to_mongo(self, uri, db_name):
        self.client = MongoClient(uri)
        self.db = self.client[db_name]

    def _convert_ids_in_doc(self, doc):
        # Convert userId in carts
        if 'userId' in doc and isinstance(doc['userId'], str) and len(doc['userId']) == 24:
            try:
                doc['userId'] = ObjectId(doc['userId'])
            except Exception:
                pass
        # Convert productId in products list in carts
        if 'products' in doc and isinstance(doc['products'], list):
            for prod in doc['products']:
                if 'productId' in prod and isinstance(prod['productId'], str) and len(prod['productId']) == 24:
                    try:
                        prod['productId'] = ObjectId(prod['productId'])
                    except Exception:
                        pass
        return doc

    def _convert_objectid_to_str(self, doc):
        if doc is None:
            return None
        for key in doc:
            if isinstance(doc[key], ObjectId):
                doc[key] = str(doc[key])
            elif isinstance(doc[key], list):
                for item in doc[key]:
                    if isinstance(item, dict):
                        for subkey in item:
                            if isinstance(item[subkey], ObjectId):
                                item[subkey] = str(item[subkey])
        return doc 


    @keyword
    def insert_document(self, collection, document):
        if collection == "carts":
            document = self._convert_ids_in_doc(document)
        if collection == "users":
            if 'email' not in document or not document['email']:
                raise RobotError("Le champ 'email' est obligatoire")
            if 'password' not in document or not document['password']:
                raise RobotError("Le champ 'password' est obligatoire")
        if collection == "categories":
            if 'name' not in document or not document['name']:
                raise RobotError("Le champ 'name' est obligatoire dans une catégorie")
        if collection == "products" and 'price' in document:
            try:
                price = float(document['price'])
                if price < 0:
                    raise RobotError("Le prix ne peut pas être négatif")
            except Exception:
                raise RobotError("Le prix ne peut pas être négatif")

        col = self.db[collection]
        inserted_id = col.insert_one(document).inserted_id
        return str(inserted_id)

    @keyword
    def find_document(self, collection, query):
        col = self.db[collection]
        query_copy = deepcopy(query)  # copie profonde
        if '_id' in query_copy:
            if not isinstance(query_copy['_id'], ObjectId):
                try:
                    query_copy['_id'] = ObjectId(query_copy['_id'])
                except (InvalidId, TypeError):
                    return None
        doc = col.find_one(query_copy)
        return self._convert_objectid_to_str(doc)


    @keyword
    def update_document(self, collection, query, new_values):
        col = self.db[collection]
        query_copy = deepcopy(query)  # copie profonde

        if collection == "carts":
            new_values = self._convert_ids_in_doc(new_values)
        if collection == "users":
            if 'email' in new_values and not new_values['email']:
                raise RobotError("Le champ 'email' ne peut pas être vide")
            if 'password' in new_values and not new_values['password']:
                raise RobotError("Le champ 'password' ne peut pas être vide")
        if collection == "categories":
            if 'name' in new_values and not new_values['name']:
                raise RobotError("Le champ 'name' est obligatoire dans une catégorie")
        if collection == "products" and 'price' in new_values:
            try:
                price = float(new_values['price'])
                if price < 0:
                    raise RobotError("Le prix ne peut pas être négatif")
            except Exception:
                raise RobotError("Le prix ne peut pas être négatif")

        if '_id' in query_copy:
            if not isinstance(query_copy['_id'], ObjectId):
                try:
                    query_copy['_id'] = ObjectId(query_copy['_id'])
                except (InvalidId, TypeError):
                    return 0
        return col.update_one(query_copy, {'$set': new_values}).modified_count

    @keyword
    def delete_document(self, collection, query):
        col = self.db[collection]
        query_copy = deepcopy(query)  # copie profonde
        if '_id' in query_copy:
            if not isinstance(query_copy['_id'], ObjectId):
                try:
                    query_copy['_id'] = ObjectId(query_copy['_id'])
                except (InvalidId, TypeError):
                    return 0
        return col.delete_one(query_copy).deleted_count
