<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/">
        <tei:TEI>
            <xsl:apply-templates/>
        </tei:TEI>
    </xsl:template>

    <xsl:template match="teiHeader//descendant-or-self::*">
        <xsl:element name="tei:{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="head"/>

    <xsl:template match="body/table[1]">
        <tei:text>
            <tei:body>
                <tei:listPerson>
                    <xsl:apply-templates/>
                </tei:listPerson>
            </tei:body>
        </tei:text>
    </xsl:template>
    
    <xsl:template match="row[1]"/>

    <xsl:template match="row[parent::table[1] and position() > 1]">
        <xsl:if test="cell[1]/text() != '' and not(cell[1]/text() = preceding-sibling::*/cell[1]/text())">
            <tei:person xml:id="{concat('home_ger_', replace(cell[1], '/', '_'))}">
                <xsl:if test="cell[3]/text() != ''">
                    <tei:persName xml:lang="cz">
                        <xsl:value-of select="cell[3]"/>
                    </tei:persName>
                </xsl:if>
                <xsl:if test="cell[4]/text() != ''">
                    <tei:persName xml:lang="de">
                        <xsl:value-of select="cell[4]"/>
                    </tei:persName>
                </xsl:if>
                <xsl:if test="cell[5]/text() != ''">
                    <tei:persName xml:lang="lat">
                        <xsl:value-of select="cell[5]"/>
                    </tei:persName>
                </xsl:if>
                <xsl:if test="cell[17]/text() != 'null' and cell[25]/text() != 'null'">
                    <tei:persName xml:lang="lat">
                        <tei:forename>
                            <xsl:value-of select="cell[17]/text()"/>
                        </tei:forename>
                        <tei:surname>
                            <xsl:value-of select="cell[25]/text()"/>
                        </tei:surname>
                    </tei:persName>
                </xsl:if>
                <xsl:if test="cell[6]/text() != ''">
                    <tei:note>
                        <xsl:value-of select="cell[6]/text()"/>
                    </tei:note>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="cell[7]/ptr/@target">
                        <tei:note>
                            <xsl:value-of select="cell[7]/ptr/@target"/>
                        </tei:note>
                    </xsl:when>
                    <xsl:when test="cell[7]/text() != ''">
                        <tei:note>
                            <xsl:value-of select="cell[7]/ptr/@target"/>
                        </tei:note>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:if test="cell[2]/text() != ''">
                    <tei:certainty locus="name">
                        <tei:desc>
                            <xsl:value-of select="cell[2]/text()"/>
                        </tei:desc>
                    </tei:certainty>
                </xsl:if>
            </tei:person>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
