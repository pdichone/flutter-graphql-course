In order to establish the connection to MongoDB Atlas, you'll need to

1.  Go to: https://www.mongodb.com/ and open an account and create a cluster
2.  In your project's root level, create a json file named nodemon.json.
    
    The contents of this file should be:
    ```
       {
           "env": {
            "mongoDatabase": "add_your_db_name" ,
            "mongoUserName": "add_your_username",
            "mongoUserPassword": "add_db_password"

          }

        }
      ```

The nodemon.json file will contain your mongodb credentials.
