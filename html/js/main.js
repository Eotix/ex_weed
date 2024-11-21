var progress = document.getElementById('progress-done'),
    paragraph = document.getElementById('progress-indicator'),
    picture = document.getElementById('picture'),
    p = 0
  function progressControl(precent) {
    if (precent < 0 || precent > 100) {
      return
    }
    paragraph.innerHTML = String(precent) + '%'
    progress.style.width = String(precent) + '%'
    imageSet(precent)
  }
  function imageSet(growth) {
    console.log(growth)
    if (growth < 20) {
      picture.style.backgroundImage = 'url(pics/weed7.png)'
    } else {
      if (growth >= 20 && growth < 40) {
        picture.style.backgroundImage = 'url(pics/weed6.png)'
      } else {
        if (growth >= 40 && growth < 60) {
          picture.style.backgroundImage = 'url(pics/weed5.png)'
        } else {
          if (growth >= 60 && growth < 80) {
            picture.style.backgroundImage = 'url(pics/weed4.png)'
          } else {
            if (growth >= 80 && growth < 90) {
              picture.style.backgroundImage = 'url(pics/weed3.png)'
            } else {
              if (growth >= 90 && growth < 100) {
                picture.style.backgroundImage = 'url(pics/weed2.png)'
              } else {
                if (growth == 100) {
                  picture.style.backgroundImage = 'url(pics/weed1.png)'
                }
              }
            }
          }
        }
      }
    }
  }
  function modalButtonYes() {
    $.post('http://ex_weed/DeleteSelectedWeedPot')
  }
  function giveWaterToSelectedWeedPot() {
    $.post('http://ex_weed/GiveWaterToSelectedWeedPot')
  }
  function getCannabisFromSelectedWeedPot() {
    $.post('http://ex_weed/GetCannabisFromSelectedPot')
  }
  var drugsui = document.getElementById('drugsui')
  window.addEventListener('message', function (event) {
    switch (event.data.action) {
      case 'open':
        ButtonsControl(event.data.isWaitingForWater, event.data.progress),
          progressControl(event.data.progress),
          drugsui.classList.remove('blocked')
        break
      case 'close':
        drugsui.classList.add('blocked'), progressControl(0)
        break
      case 'update':
        ButtonsControl(event.data.isWaitingForWater, event.data.progress),
          progressControl(event.data.progress)
        break
    }
  })
  $(document).on('keydown', function () {
    switch (event.keyCode) {
      case 27:
        drugsui.classList.add('blocked'), $.post('http://ex_weed/CloseUI')
        break
    }
  })
  function closeWeedPotUI() {
    drugsui.classList.add('blocked')
    $.post('http://ex_weed/CloseUI')
  }
  function ButtonsControl(Waitingforwater, progress) {
    let waterbtn_enabled = document.getElementById('giveWaterBtnEnabled')
    let waterbtn_disabled = document.getElementById('giveWaterBtnDisabled'),
      cannabisbtn_enabled = document.getElementById('getCannabisBtnEnabled')
    let cannabisbtn_disabled = document.getElementById('getCannabisBtnDisabled')
    if (Waitingforwater) {
      console.log(Waitingforwater)
      waterbtn_enabled.style.display = 'block'
      waterbtn_disabled.style.display = 'none'
    } else {
      ;(waterbtn_enabled.style.display = 'none'), (waterbtn_disabled.style.display = 'block')
    }
    if (progress >= 100) {
      ;(cannabisbtn_enabled.style.display = 'block'), (cannabisbtn_disabled.style.display = 'none')
    } else {
      cannabisbtn_enabled.style.display = 'none'
      cannabisbtn_disabled.style.display = 'block'
    }
  }
