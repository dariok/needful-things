xquery version "3.1";

module namespace wdbPF	= "https://github.com/dariok/wdbplus/projectFiles";

import module namespace wdb	= "https://github.com/dariok/wdbplus/wdb" at "/db/apps/edoc/modules/app.xqm";
declare namespace tei  = "http://www.tei-c.org/ns/1.0";
declare namespace meta  = "https://github.com/dariok/wdbplus/wdbmeta";

declare function wdbPF:getProjectFiles ( $model as map(*) ) as node()* {
 (
   <link rel="stylesheet" type="text/css" href="{wdb:getUrl($model?pathToEd || '/scripts/project.css')}" />,
   <script src="{wdb:getUrl($model?pathToEd || '/scripts/project.js')}" />,
   <script src="https://cdn.jsdelivr.net/npm/openseadragon@2.4/build/openseadragon/openseadragon.min.js"/>
 )
};

declare function wdbPF:getHeader ( $model as map(*) ) as node()* {
  let $file := doc($model("fileLoc"))
  return ( 
    <h1>Vier Bücher von wahrem Christentum</h1>,
    <h2>{normalize-space($file//tei:titleStmt//tei:title[@type = 'sub'])}</h2>,
    <span class="dispOpts"><button type="button" onclick="$('#texts').toggle();">Textzeugen</button></span>,
    <form id="texts" style="display: none;">
        <label>Textzeugen auswählen</label>
        <br />
        {
        for $wit in $file//tei:listWit//tei:witness[not(contains(tei:abbr, 'Corr'))] return (
            <label for="t{$wit/@xml:id}">{normalize-space($wit/tei:abbr)}</label>,
            <input type="checkbox" id="t{$wit/@xml:id}" onchange="toggleTexts(this)" />,
            <br />
        )}
    </form>,
    <span class="dispOpts"><button type="button" onclick="$('#images').toggle();">Bildquellen</button></span>,
    <form id="images" style="display: none;">
      <label for="imageSource">Bildquelle auswählen</label>
      <select id="imageSource">{
        for $facs in $file//tei:surface[1][string-length(tei:graphic/@url) > 0]
          let $wit := substring($facs//@xml:id, 1 ,1)
          order by $wit
          return
          <option id="img{$wit}">{(
            if($wit = 'E') then attribute selected {"selected"} else (),
            $wit
          )}</option>
        }
      </select>
    </form>
  )
};

declare function wdbPF:getPreProc ($id as xs:string) {
  (
    <option>scripts/preprocess.xsl</option>
  )
};

declare function wdbPF:getRestView ($fileID as xs:string) {
  let $doc := collection($wdb:data)/id($fileID)[self::tei:TEI]
  return
  <view file="{$fileID}" label="{$doc//tei:titleStmt/tei:author}, {$doc//tei:titleStmt/tei:title[@type = 'main']}" xmlns="https://github.com/dariok/wdbplus/wdbmeta"/>
};

(:declare function wdbPF:getImages ($id as xs:string, $page as xs:string) as xs:string {
  "none"
};
:)
(:declare function wdbPF:getStart ($model as map(*)) {:)
(:  let $meta := doc("/db/apps/edoc/data/e000005/wdbmeta.xml"):)
(:  return :)
(:	for $st in $meta//meta:struct[meta:view]:)
(:    let $om := number($st/@order):)
(:    order by $om:)
(:    return <div>:)
(:      {:)
(:      for $v in $st/meta:view[not(@private = 'true' and not(sm:has-access($model("pathToEd"), 'w')))]:)
(:        let $file := doc(substring-before(base-uri($meta), 'wdbmeta') || $meta//meta:file[@xml:id = $v/@file]/@path):)
(:        order by number($v/@order):)
(:        let $title := string($v/@label):)
(:        return:)
(:          <p class="issue">:)
(:            <a href="view.html?id={$v/@file}" title="{$title}">:)
(:              <img src="{$file//tei:surface[1]/tei:graphic/@url}":)
(:                alt="Titelseite von {$title}":)
(:                title="{$title}"/>:)
(:            </a>:)
(:            <a href="view.html?id={$v/@file}" title="{$title}" class="title">{$title}</a>:)
(:          </p>:)
(:    }</div>:)
(:};:)
