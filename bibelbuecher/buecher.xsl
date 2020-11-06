<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bible="https://github.com/dariok/needful-things/bibel"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:function name="bible:toGn">
    <xsl:param name="number" />
    
    <xsl:variable name="books" select="(
      'Gn', 'Ex', 'Lv', 'Nm', 'Dt', 'Ios', 'Idc', 'Rt', '1Sm', '2Sm', '3Rg', '4Rg', '1Par', '2Par', 'Esr', 'Neh', 'Tb',
      'Idt', 'Est', '1Mcc', '2Mcc', '3Mcc', '4Mcc', 'Iob', 'Ps', 'Prv', 'Ecl', 'Ct', 'Sap', 'Sir', 'Is', 'Ier', 'Lam',
      'Bar', 'Ez', 'Dn', 'Os', 'Ioel', 'Am', 'Abd', 'Ion', 'Mi', 'Na', 'Hab', 'So', 'Agg', 'Za', 'Mal', 'Mt', 'Mc', 'Lc',
      'Io', 'Act', 'Rm', '1Cor', '2Cor', 'Gal', 'Eph', 'Phil', 'Col', '1Th', '2Th', '1Tim', '2Tim', 'Tit', 'Phlm', 'Hbr',
      'Iac', '1Pt', '2Pt', '1Io', '2Io', '3Io', 'Iud', 'Apc', 'OrMan', 'Laod', '3Esr', '4Esr')"/>
    
    <xsl:value-of select="$books[$number]" />
  </xsl:function>
  
  <xsl:function name="bible:Gn2num" as="xs:integer">
    <xsl:param name="book" />
    
    <xsl:variable name="books" select="(
      'Gn', 'Ex', 'Lv', 'Nm', 'Dt', 'Ios', 'Idc', 'Rt', '1Sm', '2Sm', '3Rg', '4Rg', '1Par', '2Par', 'Esr', 'Neh', 'Tb',
      'Idt', 'Est', '1Mcc', '2Mcc', '3Mcc', '4Mcc', 'Iob', 'Ps', 'Prv', 'Ecl', 'Ct', 'Sap', 'Sir', 'Is', 'Ier', 'Lam',
      'Bar', 'Ez', 'Dn', 'Os', 'Ioel', 'Am', 'Abd', 'Ion', 'Mi', 'Na', 'Hab', 'So', 'Agg', 'Za', 'Mal', 'Mt', 'Mc', 'Lc',
      'Io', 'Act', 'Rm', '1Cor', '2Cor', 'Gal', 'Eph', 'Phil', 'Col', '1Th', '2Th', '1Tim', '2Tim', 'Tit', 'Phlm', 'Hbr',
      'Iac', '1Pt', '2Pt', '1Io', '2Io', '3Io', 'Iud', 'Apc', 'OrMan', 'Laod', '3Esr', '4Esr')"/>
    
    <xsl:value-of select="index-of($books, $book)" />
  </xsl:function>
  
  <xsl:function name="bible:LoccI2num" as="xs:integer">
    <xsl:param name="book" />
    
    <xsl:variable name="books" select="(
      'Gen', 'Ex', 'Lev', 'Num', 'Dtn', 'Jos', 'Ri', 'Rut', 'ISam', 'IISam', 'IKön', 'IIKön', 'IChr', 'IIChr', 'Esra',
      'Neh', 'Tob', 'Jdt', 'Est', 'IMakk', 'IIMakk', 'IIIMakk', 'IVMakk', 'Ijob', 'Ps', 'Spr', 'Koh', 'Hld', 'Weish',
      'Sir', 'Jes', 'Jer', 'Klgl', 'Bar', 'Ez', 'Dan', 'Hos', 'Joel', 'Am', 'Obd', 'Jona', 'Mi', 'Nah', 'Hab', 'Zef',
      'Hag', 'Sach', 'Mal', 'Mt', 'Mk', 'Lk', 'Joh', 'Apg', 'Röm', 'IKor', 'IIKor', 'Gal', 'Eph', 'Phil', 'Kol',
      'IThess', 'IIThess', 'ITim', 'IITim', 'Tit', 'Phlm', 'Hebr', 'Jak', 'IPetr', 'IIPetr', 'IJoh', 'IIJoh', 'IIIJoh',
      'Jud', 'Offb', 'OrMan', 'Laod', 'IIIEsr', 'IVEsr')"/>
    
    <xsl:value-of select="index-of($books, $book)" />
  </xsl:function>
  
  <xsl:function name="bible:toLoccI" as="xs:string">
    <xsl:param name="number" />
    
    <xsl:variable name="books" select="(
      'Gen', 'Ex', 'Lev', 'Num', 'Dtn', 'Jos', 'Ri', 'Rut', 'ISam', 'IISam', 'IKön', 'IIKön', 'IChr', 'IIChr', 'Esra',
      'Neh', 'Tob', 'Jdt', 'Est', 'IMakk', 'IIMakk', 'IIIMakk', 'IVMakk', 'Ijob', 'Ps', 'Spr', 'Koh', 'Hld', 'Weish',
      'Sir', 'Jes', 'Jer', 'Klgl', 'Bar', 'Ez', 'Dan', 'Hos', 'Joel', 'Am', 'Obd', 'Jona', 'Mi', 'Nah', 'Hab', 'Zef',
      'Hag', 'Sach', 'Mal', 'Mt', 'Mk', 'Lk', 'Joh', 'Apg', 'Röm', 'IKor', 'IIKor', 'Gal', 'Eph', 'Phil', 'Kol',
      'IThess', 'IIThess', 'ITim', 'IITim', 'Tit', 'Phlm', 'Hebr', 'Jak', 'IPetr', 'IIPetr', 'IJoh', 'IIJoh', 'IIIJoh',
      'Jud', 'Offb', 'OrMan', 'Laod', 'IIIEsr', 'IVEsr')"/>
    
    <xsl:value-of select="$books[$number]" />
  </xsl:function>
  
  <xsl:function name="bible:Locc12num" as="xs:integer">
    <xsl:param name="book" />
    
    <xsl:variable name="books" select="(
      'Gen', 'Ex', 'Lev', 'Num', 'Dtn', 'Jos', 'Ri', 'Rut', '1Sam', '2Sam', '1Kön', '2Kön', '1Chr', '2Chr', 'Esra',
      'Neh', 'Tob', 'Jdt', 'Est', '1Makk', '2Makk', '3Makk', '4Makk', 'Ijob', 'Ps', 'Spr', 'Koh', 'Hld', 'Weish', 'Sir',
      'Jes', 'Jer', 'Klgl', 'Bar', 'Ez', 'Dan', 'Hos', 'Joel', 'Am', 'Obd', 'Jona', 'Mi', 'Nah', 'Hab', 'Zef', 'Hag',
      'Sach', 'Mal', 'Mt', 'Mk', 'Lk', 'Joh', 'Apg', 'Röm', '1Kor', '2Kor', 'Gal', 'Eph', 'Phil', 'Kol', '1Thess',
      '2Thess', '1Tim', '2Tim', 'Tit', 'Phlm', 'Hebr', 'Jak', '1Petr', '2Petr', '1Joh', '2Joh', '3Joh', 'Jud',
      'Offb', 'OrMan', 'Laod', '3Esr', '4Esr')"/>
    
    <xsl:value-of select="index-of($books, $book)" />
  </xsl:function>
  
  <xsl:function name="bible:toLocc1" as="xs:string">
    <xsl:param name="number" />
    
    <xsl:variable name="books" select="(
      'Gen', 'Ex', 'Lev', 'Num', 'Dtn', 'Jos', 'Ri', 'Rut', '1Sam', '2Sam', '1Kön', '2Kön', '1Chr', '2Chr', 'Esra',
      'Neh', 'Tob', 'Jdt', 'Est', '1Makk', '2Makk', '3Makk', '4Makk', 'Ijob', 'Ps', 'Spr', 'Koh', 'Hld', 'Weish', 'Sir',
      'Jes', 'Jer', 'Klgl', 'Bar', 'Ez', 'Dan', 'Hos', 'Joel', 'Am', 'Obd', 'Jona', 'Mi', 'Nah', 'Hab', 'Zef', 'Hag',
      'Sach', 'Mal', 'Mt', 'Mk', 'Lk', 'Joh', 'Apg', 'Röm', '1Kor', '2Kor', 'Gal', 'Eph', 'Phil', 'Kol', '1Thess',
      '2Thess', '1Tim', '2Tim', 'Tit', 'Phlm', 'Hebr', 'Jak', '1Petr', '2Petr', '1Joh', '2Joh', '3Joh', 'Jud',
      'Offb', 'OrMan', 'Laod', '3Esr', '4Esr')"/>
    
    <xsl:value-of select="$books[$number]" />
  </xsl:function>
  
</xsl:stylesheet>