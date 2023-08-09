xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace my="http://random.org/my";

(: takes in a set of CEI files with a transcription in cei:tenor :)
(: finds the correct charter for the transcription and inserts it there, overwriting any previous transcription :)
(: takes in the CEI-converted transcription from Transkribus :)
(: to be used for the Czech transcriptions :)

let $transcription_collection := collection('/db/niklas/cei_transcriptions/cei')
let $arch_path := '/db/mom-data/metadata.charter.public/CZ-NA/'
let $schema := doc('/db/XRX.src/mom/app/cei/xsd/cei.xsd')

(: this gets the correct title for the charter in MOM :)
for $cei_transcript in $transcription_collection//cei:cei
let $orig_title := $cei_transcript/cei:teiHeader[1]/cei:fileDesc[1]/cei:titleStmt[1]/cei:title[1]
let $fixed_letters := replace($orig_title, 'Č', 'C')
let $momified_title := replace($fixed_letters, '([A-Za-z]+_\d+[A-Za-z]*).*', '$1')
let $final_char := substring($momified_title, string-length($momified_title))
let $final_char_lowercase := if ($final_char = 'A') then 'a' else $final_char
let $fixed_title:= replace($momified_title, '([A-Za-z]+_\d+[A-Za-z]*)' || $final_char || '$', '$1' || $final_char_lowercase)

(: get the path to the existing charter in MOM :)
let $path_end := replace($fixed_title, '_', '/')
let $full_path := concat($arch_path, $path_end, '.cei.xml')
let $charter := doc($full_path)

(: replace existing tenor with Transkribus tenor, then validate the file :)
return 
  if (exists($charter)) then
    let $transcript_tenor := $cei_transcript//cei:tenor
    return
    (
    update delete $charter//cei:tenor,
    update insert $transcript_tenor following $charter//cei:chDesc,
    let $cei_charter := <cei:cei>{$charter//cei:text}</cei:cei>
    let $validation := validation:jaxv-report($cei_charter, $schema, 'http://www.w3.org/XML/XMLSchema/v1.1')
    return if ($validation//status = 'invalid') then <charter charter="{$charter/base-uri()}" transcript="{$cei_transcript/base-uri()}">{$validation//message}</charter> else ()
    )
  else
    fn:error(xs:QName("my:error"), concat("Charter does not exist: ", $full_path))
    
(: TODO: normalize space? :)
