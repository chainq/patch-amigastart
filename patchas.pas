{ Quick & Dirty patcher code }

{ So actually this is a rewrite of the original patcher, which 
  I accidentally overwrote, while trying to commit it to a git
  repo. Don't do Fridays kids, they're bad for ya. }

program patchas;

const
  orig: array of word = (
     {$include patch_orig.inc}
  );

  _new: array of word = (
     {$include patch_new.inc}
  );

var
  f: file;
  code: pword;
  size: longint;
  offset: longint;
  endoffset: longint;

const
  origname = 'amigastart';
  newname = 'amigastart.new';

function findpatchoffset(code: pword; size: longint): longint;
const
  MATCHDEPTH = 3;
var
  i: longint;
  matchlevel: longint;
  pos: longint;
begin
  size:=size div 2;
  matchlevel:=0;
  pos:=0;
  for i:=0 to size-1 do
    begin
      if BEToN(code[i]) = orig[matchlevel] then
        inc(matchlevel)
      else
        matchlevel:=0;
      pos:=i;
      if matchlevel = MATCHDEPTH then
        break;
    end;
  if matchlevel = 3 then
    findpatchoffset:=(pos-(MATCHDEPTH-1)) * 2
  else
    findpatchoffset:=-1;
end;

function applypatch(code: pword; size: longint; offset: longint): longint;
var
  i: longint;
  pos: longint;
begin
  applypatch:=-1;
  size:=size div 2;
  offset:=offset div 2;
  for i:=0 to length(orig) do
    begin
      pos:=i;
      if (offset+i) >= size then break;
      if BEToN(code[offset+i]) <> orig[i] then break;
      code[offset+i]:=NToBE(_new[i]);
    end;

  applypatch:=(offset+pos) * 2;
end;

begin
  if length(orig) <> length(_new) then
    begin
      writeln('This patcher application build is broken! Aborting.');
      halt(1);
    end;

  writeln('Reading original binary: ',origname);
  assign(f,origname);
  reset(f,1);
  size:=filesize(f);
  code:=getmem(size);
  blockread(f,code^,size);
  close(f);

  offset:=findpatchoffset(code,size);
  if offset < 0 then
    begin
      writeln('Cannot find offset to patch in ',origname,'! Aborting...');
      freemem(code);
      halt(1);
    end;
  writeln('Found code to patch at offset: ',offset);
  
  writeln('Applying patch...');
  endoffset:=applypatch(code,size,offset);
  if endoffset <> offset+(length(orig)*2) then
    begin
      writeln('Patching failed at offset ',endoffset,'! Expected patch to end at:',offset+(length(orig)*2));
      halt(1);
    end
  else
    writeln('Patching successful!');

  writeln('Writing new binary: ',newname);
  assign(f,newname);
  rewrite(f,1);
  blockwrite(f,code^,size);
  close(f);

  freemem(code);
end.
