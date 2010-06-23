From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Wed, 23 Jun 2010 14:50:36 +0200
Message-ID: <1277297436.2469.583.camel@edumazet-laptop>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
	 <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
	 <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
	 <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
	 <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com>
	 <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr>
	 <alpine.DEB.2.00.1006221057510.2237@blackhole.kfki.hu>
	 <alpine.DEB.2.00.1006221151050.2393@blackhole.kfki.hu>
	 <AANLkTimLe-21bu_kun2_H_o_QHltfrfx0QRjZHUeYaoX@mail.gmail.com>
	 <AANLkTilEoFJ54j8kCmEebatbnoRoXF-ong5Hcl4yOIPV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49245 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0FWMuk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 08:50:40 -0400
Received: by wyi11 with SMTP id 11so723456wyi.19
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2010 05:50:39 -0700 (PDT)
In-Reply-To: <AANLkTilEoFJ54j8kCmEebatbnoRoXF-ong5Hcl4yOIPV@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 23 juin 2010 =C3=A0 18:13 +0530, krunal patel a =C3=A9crit =
:
> On Wed, Jun 23, 2010 at 11:33 AM, krunal patel <krunal.raj@gmail.com>=
 wrote:
> > ---------- Forwarded message ----------
> > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Date: Tue, Jun 22, 2010 at 3:23 PM
> > Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
> > To: Jan Engelhardt <jengelh@medozas.de>
> > Cc: Nishit Shah <nsshah.82@gmail.com>, krunal patel
> > <krunal.raj@gmail.com>, netfilter-devel@vger.kernel.org
> >
> >
> > On Tue, 22 Jun 2010, Jozsef Kadlecsik wrote:
> >
> >> On Tue, 22 Jun 2010, Jan Engelhardt wrote:
> >>
> >> >
> >> > On Tuesday 2010-06-22 07:41, Nishit Shah wrote:
> >> > >> On Monday 2010-06-21 17:18, krunal patel wrote:
> >> > >>>>>        iptables -A FORWARD -m set ! --set testip src
> >> > >>>>>        iptables -A FORWARD -m set ! --set testip src
> >> > >>>>>        iptables -A FORWARD -m set --set testip src
> >> > >>
> >> > >> No question that reevaluating the same thing over and over
> >> > >> increases runtime...
> >> > >
> >> > >Well, that is not the case. With 2.6.18.8 latency is same as 6 =
msecs.
> >> >
> >> > I think what you see could be noise.
> >> >
> >> > See commit 848484c08cb4ad161074262994410387585259ff in
> >> > xtables-addons. There I needed 3000 ping packets (sent with ping=
 -f)
> >> > *and* a linear search of 10000 ranges to get above 2000 msec ove=
rhead
> >> > for a single rule.
> >>
> >> The impact of one more rule should be negligible. Something is bad=
 there,
> >> but we know too little on the setup, the configuration: what kind =
of
> >> architecture, hardware you run the testing? What do you get when y=
ou
> >> replace the rules with similar ones but with pure "-s src" matchin=
g, i.e.
> >> without calling ipset? And it'd be good if you'd test a recent ker=
nel as
> >> well. 2.6.27 is almost two years old.
> >
> > I meant by "you" the OP, that is Krunal. :-)
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : KFKI Research Institute for Particle and Nuclear Physics
> >          H-1525 Budapest 114, POB. 49, Hungary
> >
>=20
> Sir,
>=20
> I checked using "-s src"
> iptables -F PREROUTING -t raw
> iptables -F PREROUTING -t mangle
> iptables -F PREROUTING -t nat
> iptables -F FORWARD -t mangle
> iptables -F FORWARD -t filter
> iptables -F POSTROUTING -t mangle
> iptables -F POSTROUTING -t nat
>=20
>=20
> iptables -A FORWARD -s 1.2.3.4
> iptables -A FORWARD -s 1.2.3.4
> iptables -A FORWARD -s ! 1.2.3.4
> iptables -A FORWARD -s 1.2.3.4
> iptables -A FORWARD -s 1.2.3.4
> iptables -A FORWARD -s ! 1.2.3.4
>=20
> Now response time is constant to 5msec. :).
> Next I will try to test using Oprofile and ipset.
>=20
> Some of the information about hardware.
>=20
> # lspci
> 00:00.0 Class 0600: Device 8086:25d8 (rev b1)
> 00:02.0 Class 0604: Device 8086:25f7 (rev b1)
> 00:03.0 Class 0604: Device 8086:25e3 (rev b1)
> 00:04.0 Class 0604: Device 8086:25e4 (rev b1)
> 00:05.0 Class 0604: Device 8086:25e5 (rev b1)
> 00:06.0 Class 0604: Device 8086:25e6 (rev b1)
> 00:07.0 Class 0604: Device 8086:25e7 (rev b1)
> 00:10.0 Class 0600: Device 8086:25f0 (rev b1)
> 00:10.1 Class 0600: Device 8086:25f0 (rev b1)
> 00:10.2 Class 0600: Device 8086:25f0 (rev b1)
> 00:11.0 Class 0600: Device 8086:25f1 (rev b1)
> 00:13.0 Class 0600: Device 8086:25f3 (rev b1)
> 00:15.0 Class 0600: Device 8086:25f5 (rev b1)
> 00:16.0 Class 0600: Device 8086:25f6 (rev b1)
> 00:1c.0 Class 0604: Device 8086:2690 (rev 09)
> 00:1d.0 Class 0c03: Device 8086:2688 (rev 09)
> 00:1d.1 Class 0c03: Device 8086:2689 (rev 09)
> 00:1e.0 Class 0604: Device 8086:244e (rev d9)
> 00:1f.0 Class 0601: Device 8086:2670 (rev 09)
> 00:1f.1 Class 0101: Device 8086:269e (rev 09)
> 00:1f.2 Class 0101: Device 8086:2680 (rev 09)
> 00:1f.3 Class 0c05: Device 8086:269b (rev 09)
> 02:00.0 Class 0604: Device 8086:0329 (rev 09)
> 02:00.2 Class 0604: Device 8086:032a (rev 09)
> 05:00.0 Class 0200: Device 8086:105e (rev 06)
> 05:00.1 Class 0200: Device 8086:105e (rev 06)
> 06:00.0 Class 0200: Device 8086:105e (rev 06)
> 06:00.1 Class 0200: Device 8086:105e (rev 06)
> 07:00.0 Class 0200: Device 8086:105e (rev 06)
> 07:00.1 Class 0200: Device 8086:105e (rev 06)
> 08:00.0 Class 0200: Device 8086:105e (rev 06)
> 08:00.1 Class 0200: Device 8086:105e (rev 06)
> 0a:00.0 Class 0604: Device 8086:3500 (rev 01)
> 0a:00.3 Class 0604: Device 8086:350c (rev 01)
> 0c:00.0 Class 0604: Device 8086:3510 (rev 01)
> 0c:01.0 Class 0604: Device 8086:3514 (rev 01)
> 0c:02.0 Class 0604: Device 8086:3518 (rev 01)
> 0d:00.0 Class 0200: Device 8086:1096 (rev 01)
> 0d:00.1 Class 0200: Device 8086:1096 (rev 01)
> 0f:00.0 Class 0200: Device 8086:105f (rev 06)
> 0f:00.1 Class 0200: Device 8086:105f (rev 06)
>=20
>=20
> # cat /proc/interrupts
>        CPU0   CPU1 CPU2  CPU3 CPU4 CPU5  CPU6  CPU7
>  0:      69       0        0        0        0        0        0
>  0   IO-APIC-edge     timer
>  1:       0        1        0        1        0        0        0
>   0   IO-APIC-edge     i8042
>  2:       0        0        0        0        0        0        0
>   0    XT-PIC-XT       cascade
>  4:    6616    3980   3588   9144   4476   7268   8221  12631
> IO-APIC-edge   serial
>  8:       0        0        1        0        0        0        0
>   0   IO-APIC-edge     rtc
> 12:      0        1        2        0        0        0        0
>  0   IO-APIC-edge     i8042
> 14:      0        0        0        0        0        0        0
>  0   IO-APIC-edge     ata_piix
> 15:      0        0        0        0        0        0        0
>  0   IO-APIC-edge     ata_piix
> 19:   1998    1914   1926   2150   1963   2130  2161   2276
> IO-APIC-fasteoi ata_piix
> 202:     1   326209   2        1   549016   570250  0       0
> PCI-MSI-edge     PortH
> 203:     0   325939   418403  1   651746   1       1        1
> PCI-MSI-edge     PortG
> 204:     1        1       0  1524352    1        0        1        2
> PCI-MSI-edge     PortF
> 205:     1        0  1490540   1        0        2        1        1
> PCI-MSI-edge     PortE
> 206:     2  2025716   1        1        2        1        1        2
> PCI-MSI-edge     PortD
> 207: 1881962 1        2        2        1        0        2        1
> PCI-MSI-edge     PortC
> 208:     1    19336    18600   1    26054        1        1        0
> PCI-MSI-edge     PortB
> 209:     3    23297    27551   2    31698        1        3        0
> PCI-MSI-edge     PortA
> 210: 133213  48582  41595 179080  77845  86064  240070  556444
> PCI-MSI-edge     PortL
> 211:     0       1   199112      1       2   520968   692707     1
> PCI-MSI-edge     PortK
> NMI:    0        0        0        0        0        0        0
> 0   Non-maskable interrupts
> LOC: 591051  591001  590979  590957  590933  590912  590891  590869
> Local timer interrupts
> RES:    50       61      161      124      148      218       57
> 162   Rescheduling interrupts
> CAL:   2281     2328     1789   2318    2154     1912     2355
> 1789   function call interrupts
> TLB:    149      162      915      164      797      830      108
> 1094   TLB shootdowns
> TRM:     0        0        0        0        0        0        0
>  0   Thermal event interrupts
> SPU:     0        0        0        0        0        0        0
>  0   Spurious interrupts
> ERR:     0
> MIS:      0
>=20
>=20
>=20
> # cat /proc/irq/202/smp_affinity
> 32

These affinities are buggy.

You put decimal values but kernel expect hexadecimal values.

You should use following power of two values :=20

01, 02, 04, 08, 10, 20, 40, 80

> # cat /proc/irq/202/smp_affinity
> 32
> # cat /proc/irq/203/smp_affinity
> 16
> # cat /proc/irq/204/smp_affinity
> 08
> # cat /proc/irq/205/smp_affinity
> 04
> # cat /proc/irq/206/smp_affinity
> 02
> # cat /proc/irq/207/smp_affinity
> 01
> # cat /proc/irq/208/smp_affinity
> 16
> # cat /proc/irq/209/smp_affinity
> 16
> # cat /proc/irq/210/smp_affinity
> ff
> # cat /proc/irq/211/smp_affinity
> 64
>=20
>=20
>=20
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.00
> clflush size    : 64
> power management:
>=20
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 1
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 4
> initial apicid  : 4
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.30
> clflush size    : 64
> power management:
>=20
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 1
> initial apicid  : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.31
> clflush size    : 64
> power management:
>=20
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 1
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 5
> initial apicid  : 5
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.30
> clflush size    : 64
> power management:
>=20
> processor       : 4
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> apicid          : 2
> initial apicid  : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.28
> clflush size    : 64
> power management:
>=20
> processor       : 5
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 1
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> apicid          : 6
> initial apicid  : 6
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.31
> clflush size    : 64
> power management:
>=20
> processor       : 6
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> apicid          : 3
> initial apicid  : 3
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.29
> clflush size    : 64
> power management:
>=20
> processor       : 7
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
> stepping        : 11
> cpu MHz         : 1995.004
> cache size      : 4096 KB
> physical id     : 1
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> apicid          : 7
> initial apicid  : 7
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pg=
e
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx tm2 ssse=
3
> cx16 xtpr dca lahf_lm
> bogomips        : 3990.31
> clflush size    : 64
> power management:
>=20
>=20
> Regards,
> Krunal


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
