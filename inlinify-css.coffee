# vim: nowrap

window.CSS_TEXT=CSS_TEXT="""
.gist{color:#000}.gist .gist-file{border:1px solid #dedede;font-family:Consolas, "Liberation Mono", Courier, monospace;margin-bottom:1em}.gist .gist-file .gist-meta{font-family:Helvetica, arial, freesans, clean, sans-serif;overflow:hidden;font-size:85%;padding:.5em;color:#666;background-color:#eaeaea}.gist .gist-file .gist-meta a{color:#369}.gist .gist-file .gist-meta a:visited{color:#737}.gist .gist-file .gist-data{overflow:auto;word-wrap:normal;background-color:#f8f8ff;border-bottom:1px solid #ddd;font-size:100%}.gist .gist-file .gist-data .line-data{padding:.5em !important}.gist .gist-file .gist-data .line-pre{font-family:Consolas, "Liberation Mono", Courier, monospace;background:transparent !important;border:none !important;margin:0 !important;padding:0 !important}.gist .gist-file .gist-data .gist-highlight{background:transparent !important}.gist .gist-file .gist-data .line-numbers{background-color:#ececec;color:#aaa;border-right:1px solid #ddd;text-align:right;padding:.5em}.gist .gist-file .gist-data .line-numbers .line-number{clear:right;display:block}.gist-syntax{background:#ffffff}.gist-syntax .c{color:#999988;font-style:italic}.gist-syntax .err{color:#a61717;background-color:#e3d2d2}.gist-syntax .k{color:#000000;font-weight:bold}.gist-syntax .o{color:#000000;font-weight:bold}.gist-syntax .cm{color:#999988;font-style:italic}.gist-syntax .cp{color:#999999;font-weight:bold}.gist-syntax .c1{color:#999988;font-style:italic}.gist-syntax .cs{color:#999999;font-weight:bold;font-style:italic}.gist-syntax .gd{color:#000000;background-color:#ffdddd}.gist-syntax .gd .x{color:#000000;background-color:#ffaaaa}.gist-syntax .ge{color:#000000;font-style:italic}.gist-syntax .gr{color:#aa0000}.gist-syntax .gh{color:#999999}.gist-syntax .gi{color:#000000;background-color:#ddffdd}.gist-syntax .gi .x{color:#000000;background-color:#aaffaa}.gist-syntax .go{color:#888888}.gist-syntax .gp{color:#555555}.gist-syntax .gs{font-weight:bold}.gist-syntax .gu{color:#aaaaaa}.gist-syntax .gt{color:#aa0000}.gist-syntax .kc{color:#000000;font-weight:bold}.gist-syntax .kd{color:#000000;font-weight:bold}.gist-syntax .kp{color:#000000;font-weight:bold}.gist-syntax .kr{color:#000000;font-weight:bold}.gist-syntax .kt{color:#445588;font-weight:bold}.gist-syntax .m{color:#009999}.gist-syntax .sel{color:#d14}.gist-syntax .na{color:#008080}.gist-syntax .nb{color:#0086B3}.gist-syntax .nc{color:#445588;font-weight:bold}.gist-syntax .no{color:#008080}.gist-syntax .ni{color:#800080}.gist-syntax .ne{color:#990000;font-weight:bold}.gist-syntax .nf{color:#990000;font-weight:bold}.gist-syntax .nn{color:#555555}.gist-syntax .nt{color:#000080}.gist-syntax .nv{color:#008080}.gist-syntax .ow{color:#000000;font-weight:bold}.gist-syntax .w{color:#bbbbbb}.gist-syntax .mf{color:#009999}.gist-syntax .mh{color:#009999}.gist-syntax .mi{color:#009999}.gist-syntax .mo{color:#009999}.gist-syntax .sb{color:#d14}.gist-syntax .sc{color:#d14}.gist-syntax .sd{color:#d14}.gist-syntax .s2{color:#d14}.gist-syntax .se{color:#d14}.gist-syntax .sh{color:#d14}.gist-syntax .si{color:#d14}.gist-syntax .sx{color:#d14}.gist-syntax .sr{color:#009926}.gist-syntax .s1{color:#d14}.gist-syntax .ss{color:#990073}.gist-syntax .bp{color:#999999}.gist-syntax .vc{color:#008080}.gist-syntax .vg{color:#008080}.gist-syntax .vi{color:#008080}.gist-syntax .il{color:#009999}
"""

window.getSpec=getSpec=(x)->
  SPECIFICITY.calculate(x)[0].specificity.split(',').map(Number)

window.cmp=cmp=(a, b)->
  switch
    when a<b then -1
    when a>b then +1
    else 0

window.cmpSpec=cmpSpec=(a, b)->
  for i in [0...4]
    if (c=cmp(a[i], b[i])) then return c
  return 0

MARKER='inl'
arrayize=(a)->[].slice.call(a)
window.inlinify=inlinify=(root, rules)->
  arrayize(rules).forEach (r)->
    sel=r.selectorText
    spec=getSpec(sel)
    if (selected=root.querySelectorAll(sel))?
      arrayize(selected).forEach (el)->
        if !el.stylePlus?
          el.stylePlus={}
          el.dataset[MARKER]=''
        for key in (style=r.style)
          value=style[key] # r.style is double array-dict
          unless (orig=el.stylePlus[key])? && cmpSpec(orig.spec, spec)>0
            el.stylePlus[key]={spec, value}
        null
  if (selected=root.querySelectorAll("[data-#{MARKER}]"))?
    arrayize(selected).forEach (el)->
      for k, p of el.stylePlus
        el.style[k]||=p.value
      delete el.stylePlus
      delete el.dataset[MARKER]
      null
  null

$ ->
  window.rules=document.styleSheets[0].cssRules
  window.c=cssParser.parse(cssParser.tokenize(CSS_TEXT))
