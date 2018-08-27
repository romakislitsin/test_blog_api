# Test Blog API 

[Test task](https://drive.google.com/file/d/0B9gbscdfWqaqMnZPb2NOZjREQ3M/edit)

## Endpoints for User authentication:

**Create new user:**

 - Request: 
 ```bash
 curl -d '{"email":"piter@parker.com","password":"password","nickname":"spiderman"}'
-H "Content-Type: application/json"
-X POST https://test-blog-api-volt.herokuapp.com/users/create.json
```

- Success response:
```json
{
  "status": 200,
  "msg": "User was created."
}
```

- Fail response:
```json
{
  "errors": {
    "email": ["has already been taken"],
    "nickname": ["has already been taken"]
  }
}
```

**Get JWT token:**

 - Request: 
 ```bash
 curl -d '{"auth":{"email":"piter@parker.com", "password":"password"}}'
-H "Content-Type: application/json"
-X POST https://test-blog-api-volt.herokuapp.com/user_token.json
```
- Response:
```json
{
"jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MzYwMDU1ODYsInN1YiI6MTJ9.4Wi-KhFjRP8jgeSlcur6YO7ioz0tWhu2nwIXM8dUxlU"
}
```
**Get current user:**

 - Request: 
 ```bash 
 curl 
-H "Content-Type: application/json"
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MzYwMDU1ODYsInN1YiI6MTJ9.4Wi-KhFjRP8jgeSlcur6YO7ioz0tWhu2nwIXM8dUxlU"
-X GET https://test-blog-api-volt.herokuapp.com/users/current.json
```
- Response:
```json
{
  "id": 12,
  "email": "piter@parker.com", 
  "nickname": "spiderman",
  "role": "user",
  "created_at":"2018-08-27T19:28:53.099Z",
  "updated_at":"2018-08-27T20:19:25.429Z",
  "last_login":"2018-08-27T20:19:25.422Z"
}
```
