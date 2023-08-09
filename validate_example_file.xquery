xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace validation = "http://exist-db.org/xquery/validation";

(:let $xml := doc('/db/niklas/test/test-xml.xml')
let $schema := doc('/db/niklas/test/test-schema.xsd'):)

let $xml := <cei:cei>{doc('/db/niklas/example_cei.xml')//cei:text}</cei:cei>
let $schema := doc('/db/XRX.src/mom/app/cei/xsd/cei.xsd')

let $valid := validation:jaxv-report($xml, $schema, 'http://www.w3.org/XML/XMLSchema/v1.1')
return $valid