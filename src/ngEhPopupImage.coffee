
app = angular.module 'eHanlin', []

app.directive 'ngEhPopupImage', [ '$compile',  ( $compile )->

  POPUP_IMAGE_SCALE = "ngEhPopupImageScale"

  popupWindow = do ->

    scale = localStorage.getItem( POPUP_IMAGE_SCALE ) or 1
    scale = Number scale
    $body = $ document.body

    div = document.createElement 'div'
    div.className = "ng-eh-popup-image"
    div.innerHTML = """
      <div class="text-left" style="position:absolute;left:10px;top:10px;">
        <button class="increase btn btn-default">
         <i class="glyphicon glyphicon-plus"></i>
        </button>
        <button class="decrease btn btn-default">
         <i class="glyphicon glyphicon-minus"></i>
        </button>
      </div>
      <div class="content text-center" style="height:100%;overflow:auto;"></div>
    """
    $div = $ div
    $div.css
      background: "white"
      padding: "10px 10px 10px 10px"
      position: "fixed"
      top: "10px"
      left: "10px"
      right: "10px"
      bottom: "10px"
      "z-index": "10"
      "box-shadow": "0 0 5px #a9a9a9"
      "display":"none"

    $content = $div.find '.content:first'
    document.body.appendChild div

    createHiddenEffect = ( effect )->

      $div.addClass "animated #{effect}"
      $div.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
        $div.removeClass "animated #{effect}"
        $div.hide()
      )
      $body.css 'overflow', ''

    createShowEffect = ( effect )->

      $div.show()
      $div.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
       $div.removeClass "animated #{effect}"
      )
      $div.addClass "animated #{effect}"
      $body.css 'overflow', 'hidden'

    refreshScale = ( s )->
      $img = $div.find '.content > img'
      scale = s
      $img.height "#{100 * s }%"
      localStorage.setItem( POPUP_IMAGE_SCALE, s )

    $div.on 'click', ".increase", ->

      refreshScale scale + 0.1

    $div.on 'click', ".decrease", ->

      refreshScale scale - 0.1

    $div.on 'mousewheel DOMMouseScroll', ( event )->
      event.stopPropagation()
      #event.preventDefault()

    $div.on 'contextmenu', ( event )->

      event.preventDefault()
      createHiddenEffect 'bounceOut'


    show:( opts )->
      img = new Image
      img.src = opts.img
      $(img).css
        'transition': '.3s'
        height:"#{100 * scale}%"
      $content.empty().append img
      createShowEffect 'bounceIn'

  link:( scope, element, attrs, ctrl )->

    scope.$watch 'ready', ->

      element.on 'contextmenu', ( event )->
        event.preventDefault()
        #src = event.target.src
        src = attrs.ngEhPopupImage
        popupWindow.show
          img:src


]

