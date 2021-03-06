React = require 'react'
_ = require 'lodash'

Slide = React.createClass
  render: ->
    {caption, url, active, baseDir, width, id, key} = @props
    className = if active then 'slide active' else 'slide'
    if caption
      CaptionEl = <p className="slide-caption">{caption}</p>
    unless width
      width = 500
    if url
      unless url.slice(0, 4) is 'http'
        unless url[0] is '/'
          url = '/'+url
        url = "//ezle.imgix.net/#{baseDir}#{url}?w=#{width}"
    else if id
      url = "//ezle.imgix.net/#{id}?w=#{width}"
    else
      msg = "Missing image."
      return <span className="missing-image">{msg}</span>

    <li className={className}>
      <img src={url} alt={key} />
      {CaptionEl}
    </li>

module.exports = React.createClass
  getInitialState: ->
    currentIndex: 0
    auto: true

  tick: ->
    {images} = @props
    {currentIndex, auto} = @state
    maxIndex = images.length-1
    nextIndex = currentIndex + 1
    nextIndex = if nextIndex is maxIndex then 0 else nextIndex
    @setState currentIndex: nextIndex

  componentDidMount: ->
    {slideDuration} = @props
    slideDuration = slideDuration or 4000
    @interval = setInterval @tick, slideDuration

  componentWillUnmount: ->
    clearInterval @interval

  toggleAuto: ->
    {auto} = @state
    @setState auto: !auto
    if auto
      console.log 'hold auto-advance'
      @componentWillUnmount()
    else
      console.log 'activate auto-advance'
      @componentDidMount()

  render: ->
    {currentIndex} = @state
    {images, baseDir, width} = @props
    SlideEl = (props, i) ->
      if _.isString props
        key = i
        url = props
      else
        {id, key, alt, filename, caption, url, rev} = props
        key = key or rev or id or i
      active = currentIndex is i
      if caption?.text
        caption = caption.text
      <Slide
        url={url}
        key={key}
        id={id}
        caption={caption}
        active={active}
        baseDir={baseDir}
        width={width}
      />

    <ul className="slideshow" onDoubleClick={@toggleAuto} onClick={@tick} >
      { _.map images, SlideEl }
    </ul>
