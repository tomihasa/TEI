<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
<xsl:param name="date">      
  <xsl:value-of select="format-dateTime(current-dateTime(),'[Y]-[M02]-[D02]')"/>
</xsl:param>
<xsl:param name="file"/>


<xsl:key name="I" match="attDef/gloss[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,local-name())"/>
<xsl:key name="I" match="valItem/gloss[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,parent::valItem/@ident,local-name())"/>
<xsl:key name="I" match="attDef/desc[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,local-name())"/>
<xsl:key name="I" match="valItem/desc[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,parent::valItem/@ident,local-name())"/>

<xsl:key name="I" match="attDef/remarks[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,local-name())"/>
<xsl:key name="I" match="valItem/remarks[not(@xml:lang) or @xml:lang='en']" use="concat(ancestor::attDef/parent::attList/parent::*/@ident,ancestor::attDef/@ident,parent::valItem/@ident,local-name())"/>

<xsl:key name="I" match="elementSpec/gloss[not(@xml:lang) or @xml:lang='en']" use="concat(parent::elementSpec/@ident,local-name())"/>
<xsl:key name="I" match="classSpec/gloss[not(@xml:lang) or @xml:lang='en']" use="concat(parent::classSpec/@ident,local-name())"/>
<xsl:key name="I" match="macroSpec/gloss[not(@xml:lang) or @xml:lang='en']" use="concat(parent::macroSpec/@ident,local-name())"/>

<xsl:key name="I" match="elementSpec/desc[not(@xml:lang) or @xml:lang='en']" use="concat(parent::elementSpec/@ident,local-name())"/>
<xsl:key name="I" match="classSpec/desc[not(@xml:lang) or @xml:lang='en']" use="concat(parent::classSpec/@ident,local-name())"/>
<xsl:key name="I" match="macroSpec/desc[not(@xml:lang) or @xml:lang='en']" use="concat(parent::macroSpec/@ident,local-name())"/>

<xsl:key name="I" match="elementSpec/remarks[not(@xml:lang) or @xml:lang='en']" use="concat(parent::elementSpec/@ident,local-name())"/>
<xsl:key name="I" match="classSpec/remarks[not(@xml:lang) or @xml:lang='en']" use="concat(parent::classSpec/@ident,local-name())"/>
<xsl:key name="I" match="macroSpec/remarks[not(@xml:lang) or @xml:lang='en']" use="concat(parent::macroSpec/@ident,local-name())"/>

<xsl:output 
   method="xml"
   indent="yes"
   encoding="utf-8"/>

<xsl:template 
    match="@*|text()|comment()|processing-instruction()"  >
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="*">
  <xsl:copy>
    <xsl:apply-templates 
	select="*|@*|processing-instruction()|comment()|text()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="gloss[not(@xml:lang) or @xml:lang='en']">
  <xsl:call-template name="check"/>
</xsl:template>
<xsl:template match="desc[not(@xml:lang) or @xml:lang='en']">
  <xsl:call-template name="check"/>
</xsl:template>
<xsl:template match="remarks[not(@xml:lang) or @xml:lang='en']">
  <xsl:call-template name="check"/>
</xsl:template>

  <xsl:template name="check">
  <xsl:variable name="identifier">
      <xsl:value-of select="(ancestor::*[@ident]/@ident,local-name())"
		    separator=""/>
  </xsl:variable>
  <xsl:variable name="new" select="normalize-space(.)"/>
  <xsl:variable name="old"
		select="normalize-space(doc(resolve-uri($file,base-uri(/*)))/key('I',$identifier))"/>
  <!--<xsl:message>check <xsl:value-of select="($identifier,$date,$old,$new)"	separator=" | "/></xsl:message>-->
  <xsl:copy>
    <xsl:choose>
      <xsl:when test="$old=$new">
	<xsl:message>Reset date for <xsl:value-of select="($identifier,$date)"
	separator=" to "/></xsl:message>
	<xsl:attribute name="versionDate" select="$date"/>
	<xsl:attribute name="xml:lang">en</xsl:attribute>
	<xsl:apply-templates 
	    select="*|processing-instruction()|comment()|text()"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates 
	    select="@*|*|processing-instruction()|comment()|text()"/>	
      </xsl:otherwise>
  </xsl:choose>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
