# Simple REST key-value storage based on [Tarantool](https://tarantool.io)

## Online demo: [http://trntl.yarysh.com/kv](http://trntl.yarysh.com/kv)

<br>

**Get value for existing key**

* **URL**

  /kv/{id}

* **Method:**

  `GET`
  
*  **URL Params**

   **Required:**
 
   `id=[string]`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{SOME ARBITRARY JSON}`
 
* **Error Response:**

  * **Code:** 404<br />
    **Content:** `No such key`
<br>

**Create new key-value item**

* **URL**

  /kv

* **Method:**

  `POST`
  
* **URL Params**

  None

* **Data Params**

  `{"key": "KEY_NAME", "value": {SOME ARBITRARY JSON}}`

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** `{"key": "KEY_NAME", "value": {SOME ARBITRARY JSON}}`
 
* **Error Response:**

  * **Code:** 400<br />
    **Content:** `Invalid request body`
    
    OR

  * **Code:** 409<br />
    **Content:** `Key already exists`

<br>

**Edit value for existing key**

* **URL**

  /kv/{id}

* **Method:**

  `PUT`
  
*  **URL Params**

   **Required:**
 
   `id=[string]`

* **Data Params**

  `{"value": {SOME ARBITRARY JSON}}`

* **Success Response:**

  * **Code:** 204 <br />
 
* **Error Response:**

  * **Code:** 400<br />
    **Content:** `Invalid request body`
   
   OR

  * **Code:** 404<br />
    **Content:** `No such key` 
<br>

**Delete existing key**

* **URL**

  /kv/{id}

* **Method:**

  `DELETE`
  
*  **URL Params**

   **Required:**
 
   `id=[string]`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 204 <br />
 
* **Error Response:**
    
  * **Code:** 404<br />
    **Content:** `No such key`
