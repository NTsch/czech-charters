xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $row in doc('HOME_german_index_edited.xml')//tei:row[position() > 1 and */text()]
let $id := $row/tei:cell[12]
return
    if (not(contains($row/tei:cell[15], 'line'))) (: TODO: Unterschrift-Angaben (?) sind so: line_1564479799489_48 :)
    then
        let $line := tokenize($row/tei:cell[15], 'l')[last()]
        let $length := $row/tei:cell[21]
        let $charter := doc(concat('/home/niklas/Documents/uni/becore/data/transkribus_export/transcriptions/cei/tk_cei_44923_', $id, '.xml'))/cei:cei
        return
            <name charter='{$id}'>{$charter//cei:lb[ends-with(@facs, concat('l', $line))]/following-sibling::cei:persName[string-length() = $length]}</name>
    else
        ()