From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: i think this i a kernel bug
Date: Sat, 25 Oct 2003 18:17:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1067098665.18990.1.camel@tux.rsn.bth.se>
References: <9990587768.20031025185624@delfi.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TLkLFUGUQr/8ZMULty06"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kaspars Zeme <Kaspars.Zeme@delfi.lv>
In-Reply-To: <9990587768.20031025185624@delfi.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-TLkLFUGUQr/8ZMULty06
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm forwarding this to the correct list.

We've had reports of this before but no developer has been able to
reproduce it :(

/Martin

On Sat, 2003-10-25 at 17:56, Kaspars Zeme wrote:
> root@cs:/var/swaret# cat /proc/version
> Linux version 2.4.22 (root@cs) (gcc version 3.2.3) #3 Sat Oct 25 13:58:37=
 EEST 2003
>=20
> syslog msg:
> Oct 25 17:10:06 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de7be444) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:10:53 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de7bebc4) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:25:00 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de7bee44) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:25:00 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de8230a4) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:25:00 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de8231e4) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:25:00 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de823324) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> Oct 25 17:25:00 cs kernel: LIST_DELETE: ip_conntrack_core.c:301 `&ct->tup=
lehash[IP_CT_DIR_REPLY]'(de823464) not in &ip_conntrack_hash [hash_conntrac=
k(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
>=20
> notes:
>=20
> i  can  not show you /proc/modules because the box just hangs up after
> some  time  and  i  can't  get  that information.
>=20
> root@cs:/var/swaret# iptables -V
> iptables v1.2.6a
>=20
>=20
> root@cs:/var/swaret# cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 8
> model name      : Pentium III (Coppermine)
> stepping        : 10
> cpu MHz         : 996.783
> cache size      : 256 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmo=
v pat pse36 mmx fxsr sse
> bogomips        : 1985.74
>=20
> root@cs:/var/swaret# cat /proc/ioports
> 0000-001f : dma1
> 0020-003f : pic1
> 0040-005f : timer
> 0060-006f : keyboard
> 0080-008f : dma page reg
> 00a0-00bf : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 0170-0177 : ide1
> 01f0-01f7 : ide0
> 0376-0376 : ide1
> 03c0-03df : vga+
> 03f6-03f6 : ide0
> 0cf8-0cff : PCI conf1
> d400-d4ff : Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
>   d400-d4ff : 8139too
> d800-d8ff : Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (#2)
>   d800-d8ff : 8139too
> ef40-ef5f : Intel Corp. 82801BA/BAM USB (Hub #1)
> ef80-ef9f : Intel Corp. 82801BA/BAM USB (Hub #2)
> efa0-efaf : Intel Corp. 82801BA/BAM SMBus
> ffa0-ffaf : Intel Corp. 82801BA IDE U100
>   ffa0-ffa7 : ide0
>   ffa8-ffaf : ide1
>=20
> root@cs:/var/swaret# cat /proc/iomem
> 00000000-0009fbff : System RAM
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000f0000-000fffff : System ROM
> 00100000-1febffff : System RAM
>   00100000-0024e081 : Kernel code
>   0024e082-002c75a3 : Kernel data
> 1fec0000-1fef7fff : ACPI Tables
> 1fef8000-1fefffff : ACPI Non-volatile Storage
> f8000000-fbffffff : Intel Corp. 82810E DC-133 CGC [Chipset Graphics Contr=
oller]
> ff8ff800-ff8ff8ff : Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
>   ff8ff800-ff8ff8ff : 8139too
> ff8ffc00-ff8ffcff : Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+=
 (#2)
>   ff8ffc00-ff8ffcff : 8139too
> ffa80000-ffafffff : Intel Corp. 82810E DC-133 CGC [Chipset Graphics Contr=
oller]
> ffb80000-ffbfffff : reserved
> fff00000-ffffffff : reserved
>=20
> root@cs:/var/swaret# lspci -vv
> 00:00.0 Host bridge: Intel Corp. 82810E DC-133 GMCH [Graphics Memory Cont=
roller Hub] (rev 03)
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 0
>=20
> 00:01.0 VGA compatible controller: Intel Corp. 82810E DC-133 CGC [Chipset=
 Graphics Controller] (rev 03) (prog-if 00 [VGA])
>         Subsystem: Intel Corp.: Unknown device 4333
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at f8000000 (32-bit, prefetchable) [size=3D64M]
>         Region 1: Memory at ffa80000 (32-bit, non-prefetchable) [size=3D5=
12K]
>         Capabilities: [dc] Power Management version 1
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,=
D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>=20
> 00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB PCI Bridge (rev 02) (prog-i=
f 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR+ FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=
=3D64
>         I/O behind bridge: 0000d000-0000dfff
>         Memory behind bridge: ff800000-ff8fffff
>         Prefetchable memory behind bridge: f6a00000-f6afffff
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>=20
> 00:1f.0 ISA bridge: Intel Corp. 82801BA ISA Bridge (LPC) (rev 02)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParEr=
r- Stepping- SERR+ FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>=20
> 00:1f.1 IDE interface: Intel Corp. 82801BA IDE U100 (rev 02) (prog-if 80 =
[Master])
>         Subsystem: Intel Corp.: Unknown device 4333
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Region 4: I/O ports at ffa0 [size=3D16]
>=20
> 00:1f.2 USB Controller: Intel Corp. 82801BA/BAM USB (Hub #1) (rev 02) (pr=
og-if 00 [UHCI])
>         Subsystem: Intel Corp.: Unknown device 4333
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin D routed to IRQ 5
>         Region 4: I/O ports at ef40 [size=3D32]
>=20
> 00:1f.3 SMBus: Intel Corp. 82801BA/BAM SMBus (rev 02)
>         Subsystem: Intel Corp.: Unknown device 4333
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin B routed to IRQ 10
>         Region 4: I/O ports at efa0 [size=3D16]
>=20
> 00:1f.4 USB Controller: Intel Corp. 82801BA/BAM USB (Hub #2) (rev 02) (pr=
og-if 00 [UHCI])
>         Subsystem: Intel Corp.: Unknown device 4333
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B-
>         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 9
>         Region 4: I/O ports at ef80 [size=3D32]
>=20
> 01:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/813=
9C/8139C+ (rev 10)
>         Subsystem: Compex FN22-3(A) LinxPRO Ethernet Adapter
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (8000ns min, 16000ns max)
>         Interrupt: pin A routed to IRQ 3
>         Region 0: I/O ports at d400 [size=3D256]
>         Region 1: Memory at ff8ff800 (32-bit, non-prefetchable) [size=3D2=
56]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1+,=
D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>=20
> 01:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/813=
9C/8139C+ (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. RT8139
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (8000ns min, 16000ns max)
>         Interrupt: pin A routed to IRQ 10
>         Region 0: I/O ports at d800 [size=3D256]
>         Region 1: Memory at ff8ffc00 (32-bit, non-prefetchable) [size=3D2=
56]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1+,=
D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--=-TLkLFUGUQr/8ZMULty06
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/mqIpWm2vlfa207ERAtgoAKCBz5xvO2jK0RlVqOt8YsCJuffC+gCcCIIG
ka8o4KDYg0qz2uQHvkm4QN4=
=YTIJ
-----END PGP SIGNATURE-----

--=-TLkLFUGUQr/8ZMULty06--
