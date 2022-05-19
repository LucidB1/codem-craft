

let notifications = []

function GenerateNotification(message, type, timeout) {
  let id = notifications.length + 1;
  let colors = {
      ["succes"]: "#2abdc7",
      ["error"]: "#d4423d",
      ["info"]: "#FBD33F",
  }    
  if(type == null){
      type = "succes";
  }
  if(timeout == null){
      timeout = 5000;
  }
  if(message == null){
      message = "UNKOWN";
  }
  let html = `
      <div style="transform: translateX(-165px)" class="notify" id="notify-${id}">
      <h1 class="notify-title">${type.toUpperCase()}</h1>
      <P class="notify-text">${message}</P>
      <div class="top-line"></div>
      <div class="notify-dots-${type}"></div>
    </div>
  `
  $('.notify-container').append(html)
  anime({
      targets: `#notify-${id}`,
      translateX: "0",
      duration: 550,
      easing: "spring(1, 70, 100, 10)",
    });
     notifications[id] = setTimeout(() => {
       anime({
           targets: `#notify-${id}`,
           translateX: "-165px",
           duration: 550,
           easing: "spring(1, 70, 100, 10)",
         });
       setTimeout(() => {
           $("#notify-" + id).remove();
           notifications[id] = null;
         }, 150);
   }, timeout)
}



let dataCategories
let playerxp 
let playerinv 
let servertime
let weaponName 
let weaponMinute
let gerekliitem
let weaponLabel
let claimitem 
let circlexpbar 
let playerlvl
let claimid 
let gerekliitemler
let framework 
window.addEventListener("message", function (event) {
  var item = event.data;
  switch (item.type) {
    case "SET_DATA":
      $('.container').css('display', 'block');
      RefreshCategories(item.categories)
      incomingData(item.data);

      $('.startButton').css('opacity','0.2');
      $(".startButton" ).prop( "disabled", true );
      $('#progressbar').css('display','none');
      $('.showweapons').css('display','none');
      $('.startButton').fadeIn(250);
      $('.gerekliItem').fadeIn(250);
      $('.buttontype').fadeIn(250);
      $('.cratftext').text('CRAFTING');
      $('.awaitingButton').fadeIn(250);
      $('.claimButton').fadeOut(250);
      $('.backpage').fadeOut(250);
     
      $('.text1').fadeIn(250);
      $('.text2').fadeIn(250);
      $('.text3').fadeIn(250);
      $('.yuzdeilerleme').fadeOut(250);
      $('.weaponcraftitemback').attr('src','./images/craftlinee.png');   
    
      dataCategories = item.data;
      playerxp = item.xp;
      servertime = item.sunucusaati;
     
      playerinv = item.playerinventory;
      framework = item.framework;
      console.log(playerxp)
      if (playerxp < 1000) {
        playerlvl = 0;
        $('.playerxplvl').text('0');
        circlexpbar = parseInt(playerxp) / 1000;
        bar.animate(circlexpbar);
        let xp = 1000 - playerxp
        $('.kalanxpspan').text(xp);
      }else if (playerxp >= 1000 && playerxp <= 1999) {
        $('.playerxplvl').text('1');
        circlexpbar = (parseInt(playerxp) - 1000) / 1000;
        bar.animate(circlexpbar);
        let xp = 2000 - playerxp
        $('.kalanxpspan').text(xp);
        playerlvl = 1;
      }else if (playerxp >= 2000 && playerxp <= 2999) {
        circlexpbar = (parseInt(playerxp) - 2000) / 1000;
        bar.animate(circlexpbar);
        let xp = 3000 - playerxp
        $('.kalanxpspan').text(xp);
        $('.playerxplvl').text('2');
        playerlvl = 2;
      }else if (playerxp >= 3000 && playerxp <= 3999) {
        $('.playerxplvl').text('3');
        circlexpbar = (parseInt(playerxp) - 3000) / 1000;
        bar.animate(circlexpbar);
        let xp = 4000 - playerxp;
        $('.kalanxpspan').text(xp);
        playerlvl = 3;
      }else if (playerxp >= 4000 && playerxp <= 4999) {
        $('.playerxplvl').text('4');
        circlexpbar = (parseInt(playerxp) - 4000) / 1000;
        bar.animate(circlexpbar);
        let xp = 5000 - playerxp
        $('.kalanxpspan').text(xp);
        playerlvl = 4;
      }else if (playerxp >= 5000 && playerxp <= 5999) {
        $('.playerxplvl').text('5');
        playerlvl = 5;
        circlexpbar = (parseInt(playerxp) - 5000) / 1000;
        bar.animate(circlexpbar);
        let xp = 6000 - playerxp
        $('.kalanxpspan').text(xp);
      }else if (playerxp >= 6000 && playerxp <= 6999) {
        $('.playerxplvl').text('6');
        playerlvl = 6;
        circlexpbar = (parseInt(playerxp) - 6000) / 1000;
        bar.animate(circlexpbar);
        let xp = 7000 - playerxp
        $('.kalanxpspan').text(xp);
      }else if (playerxp >= 7000 && playerxp <= 7999) {
        $('.playerxplvl').text('7');
        playerlvl = 7;
        circlexpbar = (parseInt(playerxp) - 7000) / 1000;
        bar.animate(circlexpbar);
        let xp = 8000 - playerxp
        $('.kalanxpspan').text(xp);
      }else if (playerxp >= 8000 ) {
        $('.playerxplvl').text('8');
        playerlvl = 8;
        bar.animate(1.0);
        $('.kalanxpspan').text('0');
      }

      break;
    case "AWAITING_DATA":

      sqlgelendata(item.sqldata)

    break;
    case "send_notification":
      GenerateNotification(item.message, item.notifytype, item.time)
      break
    case "CLOSE":


    break;
    default:

      break;
  }
});





const RefreshCategories = (data) => {
  let html = `` 
  for(i=0; i<data.length; i++){
    let item = data[i]
    html += `<h2 data-type=${item.name} class="categoryButton">${item.label}</h2>`
  } 
  $('.buttontype').html(html)
}
let categoryType
$(document).on('click', '.categoryButton', function () {
  $('.showweapons').css('display','none');
   categoryType =$(this).attr("data-type")
   categoryData(dataCategories)

});


   
// Configden gelen data
const incomingData = (configdata) => {
  let text = "";
  for (i = 0; i < configdata.length; i++) {
    text += `
        <div class="weaponlist" data-itemname = ${configdata[i].itemLabel} data-required = ${JSON.stringify(configdata[i].required)} data-weaponName = ${configdata[i].itemName} data-weaponTime = ${configdata[i].minute} data-itemlevel = ${configdata[i].level}  data-bigimage = ${configdata[i].imagesname} data-xp = ${configdata[i].xp}  >
        <h2 class="weaponame">${configdata[i].itemLabel}</h2>
        <h2 class="weapontime">${configdata[i].minute} SECONDS</h2>
        <h2 class="weaponlvl">${configdata[i].level} LVL </h2>
        <div class="weaponbackground"></div>
        <div class="weaponMargin" style="background-image:url(./itemimages/${configdata[i].imagesname}.png)"> 
       
        </div>
       
        </div>
        `;
  }
  $(".weaponWrapper").html(text);
}

const categoryData = (configdata) => {
  let text = "";
  for (i = 0; i < configdata.length; i++) {
    if (categoryType == configdata[i].category){
      text += `
      <div class="weaponlist" data-itemname = ${configdata[i].itemLabel} data-required = ${JSON.stringify(configdata[i].required)} data-weaponName = ${configdata[i].itemName} data-weaponTime = ${configdata[i].minute} data-itemlevel = ${configdata[i].level}  data-bigimage = ${configdata[i].imagesname}  data-xp = ${configdata[i].xp}  >
      <h2 class="weaponame">${configdata[i].itemLabel}</h2>
      <h2 class="weapontime">${configdata[i].minute} SECONDS</h2>
      <h2 class="weaponlvl">${configdata[i].level} LVL </h2>
      <div class="weaponbackground"></div>
   
      <div class="weaponMargin" style="background-image:url(./itemimages/${configdata[i].imagesname}.png)"> 
     
      </div>
     
      </div>
      `;
    }
    }

  $(".weaponWrapper").html(text);
}

let imagesbig
let xpweapon
$(document).on('click', '.weaponlist', function () {
  $('.showweapons').css('display','block');
  imagesbig = $(this).attr('data-bigimage');
  let itemlevel = $(this).attr('data-itemlevel');
  if (playerlvl >= parseInt(itemlevel)  ){
    $('.startButton').css('opacity','1.0');
    $(".startButton" ).prop( "disabled", false );
  }else{
    $('.startButton').css('opacity','0.2');
    $(".startButton" ).prop( "disabled", true );
  }
  weaponName = $(this).attr('data-weaponName');
  weaponMinute = $(this).attr('data-weaponTime');
  weaponLabel = $(this).attr('data-itemname');
  xpweapon = $(this).attr('data-xp');
  let required = $(this).attr('data-required');
  let required2 = JSON.parse(required);
  $('.weaponbackground').removeClass('weaponbackgroundhover');
  $(this).find('.weaponbackground').addClass('weaponbackgroundhover');
  $('.showweapons').attr("src","./itemimages/"+imagesbig+".png");   
  let text2 = "";
$('.weaponname').text(weaponLabel);
$('.weaponspanname').text(weaponLabel);
$('.weaponspanminute').text(weaponMinute);
  gerekliitemler = required;
  for (i = 0; i < required2.length; i++) {     

    if (GetAmountDataByName(required2[i].name)){
    text2 += `
        <div class="items">
        <img class="gerekliItempng" src="./itemimages/${required2[i].name}.png" alt="">
        <h2>${required2[i].label}</h2>
        <h3>${required2[i].amount}/ <span>${GetAmountDataByName2(required2[i].name)} </span> </h3>
         </div>
        `;

  }else{
    text2 += `
    <div class="items">
    <img class="gerekliItempng" src="./images/water.png" alt="">
    <h2>${required2[i].label}</h2>
    <h3>${required2[i].amount}/0</h3>
     </div>
    `;
  }
  }
   
   $(".gerekliliste").html(text2);
});
$(document).on('click', '.startButton', function () {
  console.log(xpweapon)
   $.post("https://codem-craft/sendItem", JSON.stringify({
  weaponName :weaponName, weaponMinute:weaponMinute , weaponLabel:weaponLabel,itemName : gerekliitemler,imagesbig:imagesbig ,xpweapon:xpweapon
  }));
});
$(document).on('click', '.awaitingButton', function () {
  $('.showweapons').css('display','none');
  $('.startButton').fadeOut(250);
  $('.gerekliItem').fadeOut(250);
  $('.buttontype').fadeOut(250);
  $('.cratftext').text('AWAITING LIST');
  $('.awaitingButton').fadeOut(250);
  $('.claimButton').fadeIn(250);
  $('.backpage').fadeIn(250);
  $('.text1').fadeOut(250);
  $('.text2').fadeOut(250);
  $('.text3').fadeOut(250);
  $('.yuzdeilerleme').fadeIn(250);
  $('#progressbar').css('display','block');
  $.post("https://codem-craft/getAwating", JSON.stringify({}), {})
  $('.weaponcraftitemback').attr('src','./images/craftline.png');   
});
$(document).on('click', '.backpage', function () {
  $('.startButton').fadeIn(250);
  $('.gerekliItem').fadeIn(250);
  $('.buttontype').fadeIn(250);
  $('.cratftext').text('CRAFTING');
  $('.awaitingButton').fadeIn(250);
  $('.claimButton').fadeOut(250);
  $('.backpage').fadeOut(250);
  incomingData(dataCategories)
  $('#progressbar').css('display','none');
  $('.text1').fadeIn(250);
  $('.text2').fadeIn(250);
  $('.text3').fadeIn(250);
  $('.yuzdeilerleme').fadeOut(250);
  $('.weaponcraftitemback').attr('src','./images/craftlinee.png');   
  $('.showweapons').css('display','none');
});
const sqlgelendata = (configdata) => {
  let text = "";
  if (configdata){
  for (i = 0; i < configdata.length; i++) {
      text += `
      <div class="weaponlist2" data-itemname = ${configdata[i].weaponlabel} data-claimitem = ${configdata[i].weaponname} data-id =${configdata[i].id}  data-sqlzaman =${configdata[i].itemtime} data-itemzaman = ${configdata[i].weapontime}  data-weaponimage =${configdata[i].images} >
      <h2 class="weaponame2">${configdata[i].weaponlabel}</h2>
      <div class="weaponbackground2"></div>
      <div class="weaponMargin2" style="background-image:url(./itemimages/${configdata[i].images}.png)"> 
     
      </div>
    
      </div>
      `;
  }
  }
  $(".weaponWrapper").html(text);
}
 setInterval(function() {
   servertime = servertime + 1;
 },1000)
let kalanzaman
$(document).on('click', '.weaponlist2', function () {
  $('.showweapons').css('display','block');
  claimitem = $(this).attr("data-claimitem");
  claimid = $(this).attr("data-id");
  let images = $(this).attr("data-weaponimage");
  $('.weaponbackground2').removeClass('weaponbackgroundhover2');
  $(this).find('.weaponbackground2').addClass('weaponbackgroundhover2');
  let sqldengelenzaman = $(this).attr('data-sqlzaman');
  let itemzaman = $(this).attr('data-itemzaman');
  $('.showweapons').attr("src","./itemimages/"+images+".png");   
  if(servertime - sqldengelenzaman >= itemzaman) {
    $(".ply-weight-prog").css("width",100+"%");
    $(".yuzdeilerleme").text("%"+100);
    $(".claimButton" ).prop( "disabled", false );
    $('.claimButton').css('opacity','1.0');
   }else if(servertime - sqldengelenzaman <= itemzaman) {
   
    let zaman = servertime - sqldengelenzaman
    let yuzde = (zaman/itemzaman)* 100;
    let yuzde2 = yuzde.toFixed(0);
    $(".claimButton" ).prop( "disabled", true );
    $('.claimButton').css('opacity','0.2');
    $(".ply-weight-prog").css("width",yuzde2+"%");
    $(".yuzdeilerleme").text("%"+yuzde2);
    }   
});
$(document).on('click', '.claimButton', function () {
    $.post("https://codem-craft/claimitem", JSON.stringify({
      claimitem :claimitem , claimid:claimid
   }));
});
$(document).keydown(function (e) {
  if (e.keyCode == 27) {
    $('.container').css('display', 'none');
    $.post('https://codem-craft/escape');
  }
});

var bar = new ProgressBar.Circle(progressbarcircle, {
  strokeWidth: 6,
  easing: 'easeInOut',
  duration: 1400,
  color: '#008dff',
  trailColor: '#eee',
  trailWidth: 1,
  svgStyle: null
});



const GetAmountDataByName = (name) => {

  let data = playerinv.filter((item) => { 
    if (item){
      return item.name == name
    }
  });
   
  return data[0] ? data[0] : false;
};

const GetAmountDataByName2 = (name) => {
  if (framework == 'esx'){
    let count = 0
    let data = playerinv.filter((item) =>{
      if (item){
        return item.name == name
      }
    });
    
    data.forEach(element => {
     
        count = count+element.count;
        
    });
  
    return count;
  }else{
    let count = 0
    let data = playerinv.filter((item) =>{
      if (item){
        return item.name == name
      }
    });
    
    data.forEach(element => {
     
        count = count+element.amount;
        
    });
  
    return count;
  }

};