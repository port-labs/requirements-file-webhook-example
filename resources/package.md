```json showLineNumbers
{
  "identifier": "packages",
  "description": "This blueprint represents a software package file in our catalog",
  "title": "Package",
  "icon": "Package",
  "schema": {
    "properties": {
      "version": {
        "type": "string",
        "title": "Depedency Version"
      }
    },
    "required": []
  },
  "mirrorProperties": {},
  "calculationProperties": {},
  "relations": {
    "microservice": {
      "title": "Service",
      "target": "microservice",
      "required": true,
      "many": false
    }
  }
}
```