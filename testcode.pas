{* This is very messy... *}

program testcode;

{.$define test}

function orig_inttostr(buf: pointer; value: longint): pchar; assembler; nostackframe;
asm
  // buf = a0, value = d0
{ 362:	41ed 100a      }	//lea 4106(a5),a0
{ 366:	20bc 204b 0000 }	move.l #541786112,(a0) ; <space>K #0 #0 in buffer
{ 36c:	e088           }	lsr.l #8,d0
{ 36e:	e488           }	lsr.l #2,d0            ; div by 1024 
{ 370:	80fc 000a      }	divu.w #10,d0          ; word division by 10 -> if result is bigger than 65536 -> havoc
{ 374:	4840           }	swap d0
{ 376:	1100           }	move.b d0,-(a0)
{ 378:	0610 0030      }	addi.b #48,(a0)
{ 37c:	e088           }	lsr.l #8,d0
{ 37e:	e088           }	lsr.l #8,d0
{ 380:	80fc 000a      }	divu.w #10,d0
{ 384:	4840           }	swap d0
{ 386:	1100           }	move.b d0,-(a0)
{ 388:	0610 0030      }	addi.b #48,(a0)
{ 38c:	e088           }	lsr.l #8,d0
{ 38e:	e088           }	lsr.l #8,d0
{ 390:	80fc 000a      }	divu.w #10,d0
{ 394:	4840           }	swap d0
{ 396:	1100           }	move.b d0,-(a0)
{ 398:	0610 0030      }	addi.b #48,(a0)
{ 39c:	e088           }	lsr.l #8,d0
{ 39e:	e088           }	lsr.l #8,d0
{$ifdef test}
{ 3a0:	112d 00a6      }	move.b #44{','}{166(a5)},-(a0) ; <- separator
{$else}
{ 3a0:	112d 00a6      }	move.b 166(a5),-(a0) ; <- separator
{$endif}
{ 3a4:	80fc 000a      }	divu.w #10,d0
{ 3a8:	4840           }	swap d0
{ 3aa:	1100           }	move.b d0,-(a0)
{ 3ac:	0610 0030      }	addi.b #48,(a0)
{ 3b0:	e088           }	lsr.l #8,d0
{ 3b2:	e088           }	lsr.l #8,d0
{ 3b4:	80fc 000a      }	divu.w #10,d0
{ 3b8:	4840           }	swap d0
{ 3ba:	1100           }	move.b d0,-(a0)
{ 3bc:	0610 0030      }	addi.b #48,(a0)
{ 3c0:	4840           }	swap d0
{ 3c2:	1100           }	move.b d0,-(a0)
{ 3c4:	0610 0030      }	addi.b #48,(a0)
{ 3c8:	0c10 0030      }	cmpi.b #48,(a0)
{ 3cc:	6622           }	bne.s {0x3f0} @quit
{ 3ce:	5288           }	addq.l #1,a0
{ 3d0:	0c10 0030      }	cmpi.b #48,(a0)
{ 3d4:	661a           }	bne.s {0x3f0} @quit
{ 3d6:	5288           }	addq.l #1,a0
{ 3d8:	0c10 0030      }	cmpi.b #48,(a0)
{ 3dc:	6612           }	bne.s {0x3f0} @quit
{ 3de:	5488           }	addq.l #2,a0
{ 3e0:	0c10 0030      }	cmpi.b #48,(a0)
{ 3e4:	660a           }	bne.s {0x3f0} @quit
{ 3e6:	5288           }	addq.l #1,a0
{ 3e8:	0c10 0030      }	cmpi.b #48,(a0)
{ 3ec:	6602           }	bne.s {0x3f0} @quit
{ 3ee:	5288           }	addq.l #1,a0
{ 3f0:	4e75           }	{rts}
@quit:
			        move.l a0,d0
end;

function new_inttostr(buf: pointer; value: longint): pchar; assembler; nostackframe;
asm
  // buf = a0, value = d0
{ 362:	41ed 100a      }	//lea 4106(a5),a0
{ 366:	20bc 204b 0000 }	move.l #541786112,(a0) ; <space>K #0 #0 in buffer
{ 36c:	e088           }	lsr.l #8,d0
{ 36e:	e488           }	lsr.l #2,d0            ; div by 1024  -> KiB
@loop:
{ 370:	80fc 000a      }	divu.w #1000,d0        ; divide by thousand
                                move.w d0,-(sp)        ; store result for later
{ 37c:	e088           }	lsr.l #8,d0
{ 37e:	e088           }	lsr.l #8,d0            ; get the remainder
                                divu.w #10,d0
                                swap d0
{ 376:	1100           }	move.b d0,-(a0)
{ 378:	0610 0030      }	addi.b #48,(a0)
{ 37c:	e088           }	lsr.l #8,d0
{ 37e:	e088           }	lsr.l #8,d0
{ 380:	80fc 000a      }	divu.w #10,d0
{ 384:	4840           }	swap d0
{ 386:	1100           }	move.b d0,-(a0)
{ 388:	0610 0030      }	addi.b #48,(a0)
{ 38c:	e088           }	lsr.l #8,d0
{ 38e:	e088           }	lsr.l #8,d0
{ 390:	80fc 000a      }	divu.w #10,d0
{ 394:	4840           }	swap d0
{ 396:	1100           }	move.b d0,-(a0)
{ 398:	0610 0030      }	addi.b #48,(a0)
{ 39c:	e088           }	lsr.l #8,d0
{ 39e:	e088           }	lsr.l #8,d0
                                moveq.l #0,d0
                                move.w (sp)+,d0
                                beq.s @test
{$ifdef test}
{ 3a0:	112d 00a6      }	move.b #44{','}{166(a5)},-(a0) ; <- separator
{$else}
{ 3a0:	112d 00a6      }	move.b 166(a5),-(a0) ; <- separator
{$endif}
                                bra.s @loop
@test:
{ 3c8:	0c10 0030      }	cmpi.b #48,(a0)
{ 3cc:	6622           }	bne.s {0x3f0} @quit
{ 3ce:	5288           }	addq.l #1,a0
				bra.s @test
{ 3f0:	4e75           }	{rts}
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
                                nop
@quit:
			        move.l a0,d0
end;

procedure test(mem: dword);
var
  test: array[0..255] of char;
  ptest: pchar;
begin
  writeln('Correct: ',mem div 1024);

  fillchar(test,sizeof(test),#0);
  ptest:=orig_inttostr(@test[255-4],mem);
  writeln(' Original: ',ptest);

  fillchar(test,sizeof(test),#0);
  ptest:=new_inttostr(@test[255-4],mem);
  writeln('      New: ',ptest);
end;

begin
  test(524288);  // some chip mem
  test(2097152); // maximum chip mem
  test(955252746);
  test(1610612736); // maximum z3 range
end.
