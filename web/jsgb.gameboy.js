
var gbRunInterval;
var gbFpsInterval;

function gb_Frame() {
  gbEndFrame=false;
  while (!(gbEndFrame||gbPause)) {
    if (!gbHalt) OP[MEMR(PC++)](); else gbCPUTicks=4;
    if (gbIME) gbInterrupts[gbRegIE & gbRegIF]();
    gb_TIMER_Control();
  }
}

function gb_Step(){
  if (!gbHalt) OP[MEMR(PC++)](); else gbCPUTicks=4;
  if (gbIME) gbInterrupts[gbRegIE & gbRegIF]();
  gb_TIMER_Control();
  gb_Dump_All();
}

function gb_Run() {
  if (!gbPause) return;
  gbPause=false;
  gbFpsInterval=setInterval(gb_Show_Fps,1000);
  gbRunInterval=setInterval(gb_Frame,16);
}

function gb_Pause() {
  if (gbPause) return;
  gbPause=true;
  $('BR').disabled=0;
  $('BP').disabled=1;
  $('BS').disabled=0;
  clearInterval(gbRunInterval);
  clearInterval(gbFpsInterval);
  $('STATUS').innerHTML='Pause';
  gb_Dump_All();        
}

function gb_Insert_Cartridge(fileName, Start) {
  gb_Pause();
  gbSeconds = 0;
  gbFrames  = 0;
  gb_Init_Memory();
  gb_Init_LCD();
  gb_Init_Interrupts();
  gb_Init_CPU();
  gb_Init_Input();
  gb_ROM_Load('roms/'+fileName);
}

