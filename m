From: Bradley King <bking@freesurf.fr>
Subject: Linux 2.6.12 REDIRECT bug?
Date: Wed, 22 Jun 2005 14:17:59 +0200
Message-ID: <42B956F7.8080704@freesurf.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[1.] One line summary of the problem:
the iptables REDIRECT kernel module seems to fail with kernel 2.6.12

[2.] Full description of the problem/report:
Have been running previous 2.6.x versions w/o problems A command like:
iptables -t nat -A PREROUTING -i br0  -p tcp --dport 80 -j REDIRECT 
--to-port 8080
(used to redirect intranet traffic through a NAT/MASQUERADE firewall 
short circuits traffic (port 8080 see's no activity at all)
I tried DNAT with the same results
Note that the inferface is a bridge interface with an Ethernet and Wifi 
interface bridged togeter

[3.] Keywords (i.e., modules, networking, kernel):
Iptables, Netfilter, REDIRECT, NAT, IPV4
[4.] Kernel version (from /proc/version):
cat /proc/version
Linux version 2.6.12 (root@router) (gcc version 3.3.5 (Debian 
1:3.3.5-13)) #1 Sun Jun 19 18:59:32 CEST 2005

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):
at /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 7
model name      : AMD Duron(tm) Processor
stepping        : 1
cpu MHz         : 1194.993
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips        : 2359.29

[7.3.] Module information (from /proc/modules):
cat /proc/modules
ipt_REDIRECT 2048 0 - Live 0xe9ad2000
ipt_state 1920 1 - Live 0xe9ad0000
iptable_filter 3008 1 - Live 0xe8950000
hostap_crypt_wep 6336 1 - Live 0xe9a9f000
ipt_MASQUERADE 3456 1 - Live 0xe8957000
hostap_cs 65112 3 - Live 0xe9b14000
hostap 123592 2 hostap_crypt_wep,hostap_cs, Live 0xe9af4000
serial_cs 9800 1 - Live 0xe9ab8000
ppp_deflate 6208 0 - Live 0xe9a99000
zlib_deflate 22040 1 ppp_deflate, Live 0xe9ac9000
zlib_inflate 18112 1 ppp_deflate, Live 0xe9ac3000
bsd_comp 6016 0 - Live 0xe8a61000
ppp_async 11328 1 - Live 0xe8a7a000
crc_ccitt 2048 1 ppp_async, Live 0xe89d3000
ppp_generic 25748 7 ppp_deflate,bsd_comp,ppp_async, Live 0xe9aa2000
slhc 7296 1 ppp_generic, Live 0xe8a5e000
bridge 52888 0 - Live 0xe9aaa000
parport_pc 30660 0 - Live 0xe9a88000
parport 25408 1 parport_pc, Live 0xe9a91000
8250_pnp 8512 0 - Live 0xe8a5a000
yenta_socket 23304 4 - Live 0xe9a81000
rsrc_nonstatic 11712 1 yenta_socket, Live 0xe8a51000
cx88_dvb 7876 0 - Live 0xe8a4e000
mt352 6788 1 cx88_dvb, Live 0xe8a4b000
or51132 10820 1 cx88_dvb, Live 0xe8a12000
video_buf_dvb 6532 1 cx88_dvb, Live 0xe8a16000
dvb_core 83752 1 video_buf_dvb, Live 0xe8a64000
cx22702 6532 1 cx88_dvb, Live 0xe89fb000
dvb_pll 4676 3 cx88_dvb,or51132,cx22702, Live 0xe8a08000
cx88_blackbird 15812 0 - Live 0xe8a29000
cx8802 10564 2 cx88_dvb,cx88_blackbird, Live 0xe8a25000
firmware_class 10432 2 or51132,cx88_blackbird, Live 0xe8a21000
cx8800 32076 0 - Live 0xe8a42000
cx88xx 55264 4 cx88_dvb,cx88_blackbird,cx8802,cx8800, Live 0xe8a33000
i2c_algo_bit 9864 1 cx88xx, Live 0xe89e3000
video_buf 22148 6 
cx88_dvb,video_buf_dvb,cx88_blackbird,cx8802,cx8800,cx88xx, Live 0xe8a1a000
ir_common 7620 1 cx88xx, Live 0xe89f8000
tveeprom 13208 1 cx88xx, Live 0xe8a03000
i2c_core 22160 6 mt352,or51132,cx22702,cx88xx,i2c_algo_bit,tveeprom, 
Live 0xe8a0b000
v4l1_compat 14468 1 cx8800, Live 0xe89fe000
v4l2_common 5824 1 cx8800, Live 0xe8952000
btcx_risc 4936 3 cx8802,cx8800,cx88xx, Live 0xe89e0000
videodev 9600 3 cx88_blackbird,cx8800,cx88xx, Live 0xe89f4000
ne2k_pci 9760 0 - Live 0xe89f0000
8390 10048 1 ne2k_pci, Live 0xe89ec000
sis5513 16200 0 [permanent], Live 0xe89e7000
ip_nat_ftp 3456 0 - Live 0xe8955000
iptable_nat 24028 4 ipt_REDIRECT,ipt_MASQUERADE,ip_nat_ftp, Live 0xe89ad000
ip_tables 21824 5 
ipt_REDIRECT,ipt_state,iptable_filter,ipt_MASQUERADE,iptable_nat, Live 
0xe89a6000
ip_conntrack_ftp 72848 1 ip_nat_ftp, Live 0xe89c0000
ip_conntrack 44824 5 
ipt_state,ipt_MASQUERADE,ip_nat_ftp,iptable_nat,ip_conntrack_ftp, Live 
0xe89b4000
appletalk 36276 22 - Live 0xe8960000
psnap 3972 1 appletalk, Live 0xe8802000
llc 7572 1 psnap, Live 0xe890f000
8139too 24192 0 - Live 0xe8959000
mii 5440 1 8139too, Live 0xe88f1000
snd_intel8x0 32320 0 - Live 0xe891a000
snd_ac97_codec 79232 1 snd_intel8x0, Live 0xe8991000
snd_pcm_oss 52576 0 - Live 0xe8983000
snd_mixer_oss 19520 1 snd_pcm_oss, Live 0xe8909000
snd_pcm 91528 3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 0xe896b000
snd_timer 25476 1 snd_pcm, Live 0xe8912000
snd 51940 6 
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, 
Live 0xe8942000
snd_page_alloc 9988 2 snd_intel8x0,snd_pcm, Live 0xe8905000
ohci_hcd 18372 0 - Live 0xe88ff000
usbcore 121020 2 ohci_hcd, Live 0xe8923000
8250 24196 6 serial_cs,8250_pnp, Live 0xe88b4000
serial_core 23296 1 8250, Live 0xe889b000
sg 34592 0 - Live 0xe88f5000
sr_mod 18340 0 - Live 0xe88a2000
cdrom 40800 1 sr_mod, Live 0xe88a9000
advansys 81440 0 - Live 0xe88d5000
scsi_mod 100680 3 sg,sr_mod,advansys, Live 0xe88bb000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

[7.5.] PCI information ('lspci -vvv' as root)
lspci -vvv
0000:00:00.0 Host bridge: Silicon Integrated Systems [SiS] 735 Host (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 32
        Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=8M]
        Capabilities: [c0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- 
Rate=<none>

0000:00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual 
PCI-to-PCI bridge (AGP) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: c9e00000-cbefffff
        Prefetchable memory behind bridge: c7c00000-c9cfffff
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

0000:00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS85C503/5513 
(LPC Bridge)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

0000:00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus 
Controller
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 0
        Region 4: I/O ports at 0c00 [size=32]

0000:00:02.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 
Controller (rev 07) (prog-if 10 [OHCI])
        Subsystem: Elitegroup Computer Systems K7S5A motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (20000ns max), Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin D routed to IRQ 12
        Region 0: Memory at cfffd000 (32-bit, non-prefetchable) [size=4K]

0000:00:02.3 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 
Controller (rev 07) (prog-if 10 [OHCI])
        Subsystem: Elitegroup Computer Systems K7S5A motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (20000ns max), Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at cfffe000 (32-bit, non-prefetchable) [size=4K]

0000:00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] 
(rev d0) (prog-if 80 [Master])
        Subsystem: Silicon Integrated Systems [SiS] SiS5513 EIDE 
Controller (A,B step)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128
        Region 4: I/O ports at ff00 [size=16]

0000:00:02.7 Multimedia audio controller: Silicon Integrated Systems 
[SiS] Sound Controller (rev a0)
        Subsystem: C-Media Electronics Inc: Unknown device 0300
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (13000ns min, 2750ns max)
        Interrupt: pin C routed to IRQ 11
        Region 0: I/O ports at d800 [size=256]
        Region 1: I/O ports at d400 [size=64]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8029(AS)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at d000 [size=32]

0000:00:0b.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI 
Video and Audio Decoder (rev 05)
        Subsystem: Ads Technologies Inc: Unknown device 0334
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 0x08 (32 
bytes)
        Interrupt: pin A routed to IRQ 12
        Region 0: Memory at cd000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:0b.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Ads Technologies Inc: Unknown device 0334
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 12
        Region 0: Memory at ce000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:0d.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Actiontec Electronics Inc: Unknown device 0293
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 0x10 (64 bytes)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 28001000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 28400000-287ff000 (prefetchable)
        Memory window 1: 28800000-28bff000
        I/O window 0: 00004000-000040ff
        I/O window 1: 00004400-000044ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- 
PostWrite+
        16-bit legacy interface ports at 0001

0000:00:0d.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Actiontec Electronics Inc: Unknown device 0293
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 0x10 (64 bytes)
        Interrupt: pin B routed to IRQ 12
        Region 0: Memory at 28000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
        Memory window 0: 28c00000-28fff000 (prefetchable)
        Memory window 1: 29000000-293ff000
        I/O window 0: 00004800-000048ff
        I/O window 1: 00004c00-00004cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- 
PostWrite+
        16-bit legacy interface ports at 0001

0000:00:0f.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at cc00 [size=256]
        Region 1: Memory at cffffe00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:11.0 SCSI storage controller: Advanced System Products, Inc 
ABP940-U / ABP960-U (rev 03)
        Subsystem: Advanced System Products, Inc ASC1300 SCSI Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1000ns min, 1000ns max), Cache Line Size: 0x08 (32 
bytes)
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at dc00 [size=256]
        Region 1: Memory at cfffff00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at cffe0000 [disabled] [size=64K]

0000:01:00.0 VGA compatible controller: nVidia Corporation NV6 
[Vanta/Vanta LT] (rev 11) (prog-if 00 [VGA])
        Subsystem: Guillemot Corporation Maxi Gamer Phoenix 2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at ca000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at c8000000 (32-bit, prefetchable) [size=16M]
        Expansion ROM at cbef0000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64- 
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- 
Rate=<none>


[7.6.] SCSI information (from /proc/scsi/scsi)
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

No problems through 2.6.11.... I normally use iptables 1.2.11 I tried 
1.3.1 with the same results....

[X.] Other notes, patches, fixes, workarounds:


Thank you

Output of sh scripts/ver_linux:

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux router 2.6.12 #1 Sun Jun 19 18:59:32 CEST 2005 i686 GNU/Linux

Gnu C                  3.3.5
Gnu make               3.80
binutils               2.15
util-linux             2.12p
mount                  2.12p
module-init-tools      3.2-pre1
e2fsprogs              1.37
reiserfsprogs          line
reiser4progs           line
xfsprogs               2.6.20
pcmcia-cs              3.2.5
quota-tools            3.12.
PPP                    2.4.3
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         ipt_REDIRECT ipt_state iptable_filter 
hostap_crypt_wep ipt_MASQUERADE hostap_cs
hostap serial_cs ppp_deflate zlib_deflate zlib_inflate bsd_comp 
ppp_async crc_ccitt ppp_generic
slhc bridge parport_pc parport 8250_pnp yenta_socket rsrc_nonstatic 
cx88_dvb mt352 or51132 video_buf_dvb
dvb_core cx22702 dvb_pll cx88_blackbird cx8802 firmware_class cx8800 
cx88xx i2c_algo_bit video_buf ir_common
tveeprom i2c_core v4l1_compat v4l2_common btcx_risc videodev ne2k_pci 
8390 sis5513 ip_nat_ftp iptable_nat
ip_tables ip_conntrack_ftp ip_conntrack appletalk psnap llc 8139too mii 
snd_intel8x0 snd_ac97_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd snd_page_alloc ohci_hcd 
usbcore 8250 serial_core sg sr_mod
cdrom advansys scsi_mo



Thanks
B King
