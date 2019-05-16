# OSAPIResponse
This is a base class and protocol to be used to parse responses from OS's REST APIs.

## Usage
Add `github "OrdnanceSurvey/osapiresponse-swift"` to your Cartfile, then

```
class SearchResult: NSObject, Decodable {
    let text: String
    init(text: String) {
        self.text = text
        super.init()
    }
    convenience required init?(json: JSON) {
        guard let text = json.stringValueForKey("text") else {
            return nil
        }
        self.init(text: text)
    }
}
class SearchResponse: Response, Parsable {
    typealias Payload = SearchResult
    let results: [SearchResult]
    required init(results: [SearchResult], header: Header) {
        self.results = results
        super.init(header: header)
    }
}

let response = SearchResponse.create(json)
```
