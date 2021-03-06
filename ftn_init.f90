! Fortran logical units used in WSJT6
!
!   10  wave files read from disk
!   11  decoded.txt
!   12  decoded.ave
!   13  tsky.dat
!   14  azel.dat
!   15  debug.txt
!   16  c:/wsjt.reg 
!   17  wave files written to disk
!   18  test file to be transmitted (wsjtgen.f90)
!   19  dmet_* files
!   20  prefixes.txt
!   21  ALL.TXT
!   22  kvasd.dat
!   23  CALL3.TXT
!   24  FFT_plans.txt
!   25  *.eco

!------------------------------------------------ ftn_init
subroutine ftn_init
!f2py threadsafe

  character*1 fname*80
  include 'gcom1.f90'
  include 'gcom2.f90'
  include 'gcom3.f90'
  include 'gcom4.f90'
  character*12 csub0
  integer*8 mtx
  integer*2 nsky
  common/sky/ nsky(360,180)
  common/mtxcom/mtx,ltrace,mtxstate,csub0
  save /mtxcom/

  call cs_init
  call cs_lock('ftn_init')
  iflag=1
  i=ptt(nport,pttport,0,iflag,iptt)                       !Clear DTR line
  iflag=0
  i=ptt(nport,pttport,0,iflag,iptt)                       !Clear RTS line
  addpfx='    '

  do i=80,1,-1
     if(AppDir(i:i).ne.' ') goto 1
  enddo
1 iz=i
  lenappdir=iz
  call pfxdump(appdir(:iz)//'/prefixes.txt')

  open(11,file=appdir(:iz)//'/decoded.txt',status='unknown',               &
       err=910)
  endfile 11

  open(12,file=appdir(:iz)//'/decoded.ave',status='unknown',               &
       err=920)
  endfile 12

  open(15,file=appdir(:iz)//'/debug.txt',status='unknown',                 &
       err=940)

  open(21,file=appdir(:iz)//'/ALL.TXT',status='unknown',                   &
       position='append',err=950)

  open(22,file=appdir(:iz)//'/kvasd.dat',access='direct',recl=1024,        &
       status='unknown')

  call zero(nsky,180*180)
  fname=appdir(:iz)//'/TSKY.DAT'

  call rfile2(fname,nsky,129600,nr)
  if(nr.ne.129600) go to 10
  nsky4=nsky(1,1)
  if (iabs(nsky4).gt.500) then
     write(*,1000)
1000 format('Converting TSKY.DAT')
     do i=1,360
        do j=1,180
           nsky(i,j) = iswap_short(nsky(i,j))
        enddo
     enddo
  endif

10 call cs_unlock
  return

910 print*,'Error opening DECODED.TXT'
  stop
920 print*,'Error opening DECODED.AVE'
  stop
940 print*,'Error opening DEBUG.TXT'
  stop
950 print*,'Error opening ALL.TXT'
  stop

end subroutine ftn_init
