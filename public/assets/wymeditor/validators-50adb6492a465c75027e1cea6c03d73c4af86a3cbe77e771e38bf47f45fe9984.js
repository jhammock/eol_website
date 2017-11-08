/**
* XhtmlValidator for validating tag attributes
*
* @author Bermi Ferrer - http://bermi.org
*/

WYMeditor.XhtmlValidator = {
  "_attributes":
  {
    "core":
    {
      "except":["base", "head", "html", "meta", "param", "script", "style", "title"],
      "attributes":[
      "class",
      "id",
      "style",
      "title",
      "accesskey",
      "tabindex",
      "data",
      "^data-.*"
      ]
    },
    "language":
    {
      "except":["base", "br", "hr", "iframe", "param", "script"],
      "attributes":
      {
        "dir":[
        "ltr",
        "rtl"
        ],
        "0":"lang",
        "1":"xml:lang"
      }
    },
    "keyboard":
    {
      "attributes":
      {
        "accesskey":/^(\w){1}$/,
        "tabindex":/^(\d)+$/
      }
    }
  },
  "_events":
  {
    "window":
    {
      "only":[
      "body"
      ],
      "attributes":[
      "onload",
      "onunload"
      ]
    },
    "form":
    {
      "only":[
      "form",
      "input",
      "textarea",
      "select",
      "a",
      "label",
      "button"
      ],
      "attributes":[
      "onchange",
      "onsubmit",
      "onreset",
      "onselect",
      "onblur",
      "onfocus"
      ]
    },
    "keyboard":
    {
      "except":["base", "bdo", "br", "frame", "frameset", "head", "html", "iframe", "meta", "param", "script", "style", "title"],
      "attributes":[
      "onkeydown",
      "onkeypress",
      "onkeyup"
      ]
    },
    "mouse":
    {
      "except":["base", "bdo", "br", "head", "html", "meta", "param", "script", "style", "title"],
      "attributes":[
      "onclick",
      "ondblclick",
      "onmousedown",
      "onmousemove",
      "onmouseover",
      "onmouseout",
      "onmouseup"
      ]
    }
  },
  "_tags":
  {
    "a":
    {
      "attributes":
      {
        "0":"charset",
        "1":"coords",
        "2":"href",
        "3":"hreflang",
        "4":"name",
        "rel":/^(alternate|designates|stylesheet|start|next|nofollow|prev|contents|index|glossary|copyright|chapter|section|subsection|appendix|help|bookmark| |shortcut|icon|moodalbox)+$/,
        "rev":/^(alternate|designates|stylesheet|start|next|prev|contents|index|glossary|copyright|chapter|section|subsection|appendix|help|bookmark| |shortcut|icon|moodalbox)+$/,
        "shape":/^(rect|rectangle|circ|circle|poly|polygon)$/,
        "5":"type",
    "target":/^(_blank)+$/
      }
    },
    "0":"abbr",
    "1":"acronym",
    "2":"address",
    "area":
    {
      "attributes":
      {
        "0":"alt",
        "1":"coords",
        "2":"href",
        "nohref":/^(true|false)$/,
        "shape":/^(rect|rectangle|circ|circle|poly|polygon)$/
      },
      "required":[
      "alt"
      ]
    },
    "3":"b",
    "base":
    {
      "attributes":[
      "href"
      ],
      "required":[
      "href"
      ]
    },
    "bdo":
    {
      "attributes":
      {
        "dir":/^(ltr|rtl)$/
      },
      "required":[
      "dir"
      ]
    },
    "4":"big",
    "blockquote":
    {
      "attributes":[
      "cite"
      ]
    },
    "5":"body",
    "6":"br",
    "button":
    {
      "attributes":
      {
        "disabled":/^(disabled)$/,
        "type":/^(button|reset|submit)$/,
        "0":"value"
      },
      "inside":"form"
    },
    "7":"caption",
    "8":"cite",
    "9":"code",
    "col":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify)$/,
        "0":"char",
        "1":"charoff",
        "span":/^(\d)+$/,
        "valign":/^(top|middle|bottom|baseline)$/,
        "2":"width"
      },
      "inside":"colgroup"
    },
    "colgroup":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify)$/,
        "0":"char",
        "1":"charoff",
        "span":/^(\d)+$/,
        "valign":/^(top|middle|bottom|baseline)$/,
        "2":"width"
      }
    },
    "10":"dd",
    "del":
    {
      "attributes":
      {
        "0":"cite",
        "datetime":/^([0-9]){8}/
      }
    },
    "11":"div",
    "12":"dfn",
    "13":"dl",
    "14":"dt",
    "15":"em",
    "fieldset":
    {
      "inside":"form"
    },
    "form":
    {
      "attributes":
      {
        "0":"action",
        "1":"accept",
        "2":"accept-charset",
        "3":"enctype",
        "method":/^(get|post)$/
      },
      "required":[
      "action"
      ]
    },
    "head":
    {
      "attributes":[
      "profile"
      ]
    },
    "16":"h1",
    "17":"h2",
    "18":"h3",
    "19":"h4",
    "20":"h5",
    "21":"h6",
    "22":"hr",
    "html":
    {
      "attributes":[
      "xmlns"
      ]
    },
    "23":"i",
    "iframe":
    {
      "attributes":[
        "src",
        "width",
        "height",
        "frameborder",
        "allowfullscreen",
        "rel",
        "scrolling",
        "marginheight",
        "marginwidth"
      ],
      "required":[
        "src"
      ]
    },
    "img":
    {
      "attributes":{
      "align":/^(right|left|center|justify)$/,
      "0":"alt",
      "1":"src",
      "2":"height",
      "3":"ismap",
      "4":"longdesc",
      "5":"usemap",
      "6":"width",
      "7":"rel"
      },
      "required":[
      "alt",
      "src"
      ]
    },
    "input":
    {
      "attributes":
      {
        "0":"accept",
        "1":"alt",
        "checked":/^(checked)$/,
        "disabled":/^(disabled)$/,
        "maxlength":/^(\d)+$/,
        "2":"name",
        "readonly":/^(readonly)$/,
        "size":/^(\d)+$/,
        "3":"src",
        "type":/^(button|checkbox|file|hidden|image|password|radio|reset|submit|text|tel|search|url|email|datetime|date|month|week|time|datetime-local|number|range|color)$/,
        "4":"value",
        "5":"placeholder"
      },
      "inside":"form"
    },
    "ins":
    {
      "attributes":
      {
        "0":"cite",
        "datetime":/^([0-9]){8}/
      }
    },
    "24":"kbd",
    "label":
    {
      "attributes":[
      "for"
      ],
      "inside":"form"
    },
    "25":"legend",
    "26":"li",
    "link":
    {
      "attributes":
      {
        "0":"charset",
        "1":"href",
        "2":"hreflang",
        "media":/^(all|braille|print|projection|screen|speech|,|;| )+$/i,
        //next comment line required by Opera!
        /*"rel":/^(alternate|appendix|bookmark|chapter|contents|copyright|glossary|help|home|index|next|prev|section|start|stylesheet|subsection| |shortcut|icon)+$/i,*/
        "rel":/^(alternate|appendix|bookmark|chapter|contents|copyright|glossary|help|home|index|next|nofollow|prev|section|start|stylesheet|subsection| |shortcut|icon)+$/i,
        "rev":/^(alternate|appendix|bookmark|chapter|contents|copyright|glossary|help|home|index|next|prev|section|start|stylesheet|subsection| |shortcut|icon)+$/i,
        "3":"type"
      },
      "inside":"head"
    },
    "map":
    {
      "attributes":[
      "id",
      "name"
      ],
      "required":[
      "id"
      ]
    },
    "meta":
    {
      "attributes":
      {
        "0":"content",
        "http-equiv":/^(content\-type|expires|refresh|set\-cookie)$/i,
        "1":"name",
        "2":"scheme"
      },
      "required":[
      "content"
      ]
    },
    "27":"noscript",
    "28":"ol",
    "optgroup":
    {
      "attributes":
      {
        "0":"label",
        "disabled": /^(disabled)$/
      },
      "required":[
      "label"
      ]
    },
    "option":
    {
      "attributes":
      {
        "0":"label",
        "disabled":/^(disabled)$/,
        "selected":/^(selected)$/,
        "1":"value"
      },
      "inside":"select"
    },
    "29":"p",
    "param":
    {
      "attributes":
      [
        "type",
        "value",
    "name"
      ],
      "required":[
      "name"
      ],
      "inside":"object"
    },
    "embed":
    {
      "attributes":
      [
        "width",
        "height",
        "allowfullscreen",
        "allowscriptaccess",
        "wmode",
        "type",
        "src",
        "flashvars"
      ],
    "inside":"object"
    },
    "object":
    {
      "attributes":[
      "archive",
      "classid",
      "codebase",
      "codetype",
      "data",
      "declare",
      "height",
      "name",
      "standby",
      "type",
      "usemap",
      "width"
      ]
    },
    "30":"pre",
    "q":
    {
      "attributes":[
      "cite"
      ]
    },
    "31":"samp",
    "script":
    {
      "attributes":
      {
        "type":/^(text\/ecmascript|text\/javascript|text\/jscript|text\/vbscript|text\/vbs|text\/xml)$/,
        "0":"charset",
        "defer":/^(defer)$/,
        "1":"src"
      },
      "required":[
      "type"
      ]
    },
    "select":
    {
      "attributes":
      {
        "disabled":/^(disabled)$/,
        "multiple":/^(multiple)$/,
        "0":"name",
        "1":"size"
      },
      "inside":"form"
    },
    "32":"small",
    "33":"span",
    "34":"strong",
    "style":
    {
      "attributes":
      {
        "0":"type",
        "media":/^(screen|tty|tv|projection|handheld|print|braille|aural|all)$/
      },
      "required":[
      "type"
      ]
    },
    "35":"sub",
    "36":"sup",
    "table":
    {
      "attributes":
      {
        "0":"border",
        "1":"cellpadding",
        "2":"cellspacing",
        "frame":/^(void|above|below|hsides|lhs|rhs|vsides|box|border)$/,
        "rules":/^(none|groups|rows|cols|all)$/,
        "3":"summary",
        "4":"width"
      }
    },
    "tbody":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify)$/,
        "0":"char",
        "1":"charoff",
        "valign":/^(top|middle|bottom|baseline)$/
      }
    },
    "td":
    {
      "attributes":
      {
        "0":"abbr",
        "align":/^(left|right|center|justify|char)$/,
        "1":"axis",
        "2":"char",
        "3":"charoff",
        "colspan":/^(\d)+$/,
        "4":"headers",
        "rowspan":/^(\d)+$/,
        "scope":/^(col|colgroup|row|rowgroup)$/,
        "valign":/^(top|middle|bottom|baseline)$/
      }
    },
    "textarea":
    {
      "attributes":[
      "cols",
      "rows",
      "disabled",
      "name",
      "readonly"
      ],
      "required":[
      "cols",
      "rows"
      ],
      "inside":"form"
    },
    "tfoot":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify)$/,
        "0":"char",
        "1":"charoff",
        "valign":/^(top|middle|bottom)$/,
        "2":"baseline"
      }
    },
    "th":
    {
      "attributes":
      {
        "0":"abbr",
        "align":/^(left|right|center|justify|char)$/,
        "1":"axis",
        "2":"char",
        "3":"charoff",
        "colspan":/^(\d)+$/,
        "4":"headers",
        "rowspan":/^(\d)+$/,
        "scope":/^(col|colgroup|row|rowgroup)$/,
        "valign":/^(top|middle|bottom|baseline)$/
      }
    },
    "thead":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify)$/,
        "0":"char",
        "1":"charoff",
        "valign":/^(top|middle|bottom|baseline)$/
      }
    },
    "37":"title",
    "tr":
    {
      "attributes":
      {
        "align":/^(right|left|center|justify|char)$/,
        "0":"char",
        "1":"charoff",
        "valign":/^(top|middle|bottom|baseline)$/
      }
    },
    "38":"tt",
    "39":"ul",
    "40":"var",
    "41":"section",
    "42":"article",
    "43":"aside",
    "44":"details",
    "45":"header",
    "46":"footer",
    "47":"nav",
    "48":"dialog",
    "49":"figure",
    "50":"figcaption",
    "51":"address",
    "52":"hgroup",
    "53":"mark",
    "54":"time",
    "55":"canvas",
    "56":"audio",
    "57":"video",
    "58":"source",
    "59":"output",
    "60":"progress",
    "61":"ruby",
    "62":"rt",
    "63":"rp",
    "64":"summary",
    "65":"command"
  },

  // Temporary skipped attributes
  skipped_attributes : [],
  skipped_attribute_values : [],

  getValidTagAttributes: function(tag, attributes)
  {
    var valid_attributes = {};
    var possible_attributes = this.getPossibleTagAttributes(tag);
    var regexp_attributes = [];
    $.each((possible_attributes || []), function(i, val) {
      if (val.indexOf("*") > -1) {
        regexp_attributes.push(new RegExp(val));
      }
    });
    var h = WYMeditor.Helper;
    for(var attribute in attributes) {
      var value = attributes[attribute];
      if(!h.contains(this.skipped_attributes, attribute) && !h.contains(this.skipped_attribute_values, value)){
        if (typeof value != 'function') {
          if (h.contains(possible_attributes, attribute)) {
            if (this.doesAttributeNeedsValidation(tag, attribute)) {
              if(this.validateAttribute(tag, attribute, value)){
                valid_attributes[attribute] = value;
              }
            }else{
              valid_attributes[attribute] = value;
            }
          }
          else {
            $.each(regexp_attributes, function(i, val) {
              if (attribute.match(val)) {
                valid_attributes[attribute] = value;
              }
            });
          }
        }
      }
    }
    return valid_attributes;
  },
  getUniqueAttributesAndEventsForTag: function(tag)
  {
    var result = [];

    if (this._tags[tag] && this._tags[tag]['attributes']) {
      for (k in this._tags[tag]['attributes']) {
        result.push(parseInt(k) == k ? this._tags[tag]['attributes'][k] : k);
      }
    }
    return result;
  },
  getDefaultAttributesAndEventsForTags: function()
  {
    var result = [];
    for (var key in this._events){
      result.push(this._events[key]);
    }
    for (var key in this._attributes){
      result.push(this._attributes[key]);
    }
    return result;
  },
  isValidTag: function(tag)
  {
    if(this._tags[tag]){
      return true;
    }
    for(var key in this._tags){
      if(this._tags[key] == tag){
        return true;
      }
    }
    return false;
  },
  getDefaultAttributesAndEventsForTag: function(tag)
  {
    var default_attributes = [];
    if (this.isValidTag(tag)) {
      var default_attributes_and_events = this.getDefaultAttributesAndEventsForTags();

      for(var key in default_attributes_and_events) {
        var defaults = default_attributes_and_events[key];
        if(typeof defaults == 'object'){
          var h = WYMeditor.Helper;
          if ((defaults['except'] && h.contains(defaults['except'], tag)) || (defaults['only'] && !h.contains(defaults['only'], tag))) {
            continue;
          }

          var tag_defaults = defaults['attributes'] ? defaults['attributes'] : defaults['events'];
          for(var k in tag_defaults) {
            default_attributes.push(typeof tag_defaults[k] != 'string' ? k : tag_defaults[k]);
          }
        }
      }
    }
    return default_attributes;
  },
  doesAttributeNeedsValidation: function(tag, attribute)
  {
    return this._tags[tag] && ((this._tags[tag]['attributes'] && this._tags[tag]['attributes'][attribute]) || (this._tags[tag]['required'] &&
     WYMeditor.Helper.contains(this._tags[tag]['required'], attribute)));
  },
  validateAttribute: function(tag, attribute, value)
  {
    if ( this._tags[tag] &&
      (this._tags[tag]['attributes'] && this._tags[tag]['attributes'][attribute] && value.length > 0 && !value.match(this._tags[tag]['attributes'][attribute])) || // invalid format
      (this._tags[tag] && this._tags[tag]['required'] && WYMeditor.Helper.contains(this._tags[tag]['required'], attribute) && value.length == 0) // required attribute
    ) {
      return false;
    }
    return typeof this._tags[tag] != 'undefined';
  },
  getPossibleTagAttributes: function(tag)
  {
    if (!this._possible_tag_attributes) {
      this._possible_tag_attributes = {};
    }
    if (!this._possible_tag_attributes[tag]) {
      this._possible_tag_attributes[tag] = this.getUniqueAttributesAndEventsForTag(tag).concat(this.getDefaultAttributesAndEventsForTag(tag));
    }
    return this._possible_tag_attributes[tag];
  }
};
