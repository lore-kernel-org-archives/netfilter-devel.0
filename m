From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: Problem with IP-Pools
Date: Thu, 19 Dec 2002 16:24:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021219162444.45febd6d.markus.schaber@student.uni-ulm.de>
References: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
	<20021205201113.GD11068@naboo.club.berlin.ccc.de>
	<20021205224314.3c38afec.markus.schaber@student.uni-ulm.de>
	<1039180838.30495.104.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Thu__19_Dec_2002_16:24:44_+0100_0841c3e8"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1039180838.30495.104.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart_Thu__19_Dec_2002_16:24:44_+0100_0841c3e8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,

Martin Josefsson <gandalf@wlug.westbo.se> schrieb:

> You can find the current version (0.3.2a) here:
> 
> http://gandalf.hjorten.nu/ippool/
> 
> (I hope it compiles :)

I tried it with 2.4.20 (no patch-o-matic things applied), and the
compilation failed, outputting the attached error messages.

I didn't have time ot have a closer look yet, but if you have any idea,
or a newer verison available, it would be appreciated.

Thanks,
Markus

-- 
Markus Schaber - http://www.schabi.de/

Schabi's Flohmarkt unter http://schabi.de/flohmarkt

--Multipart_Thu__19_Dec_2002_16:24:44_+0100_0841c3e8
Content-Type: text/plain;
 name="compile.stderr"
Content-Disposition: attachment;
 filename="compile.stderr"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mail.rz.uni-ulm.de id gBJFRYmF012199

make -C  kernel CFLAGS=3D"-D__KERNEL__ -I/usr/src/pool/linux-2.4.20/inclu=
de -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno=
-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3D=
i686 -DMODULE -DMODVERSIONS -include /usr/src/pool/linux-2.4.20/include/l=
inux/modversions.h" MAKING_MODULES=3D1 modules
make[1]: Entering directory `/usr/src/pool/linux-2.4.20/kernel'
make[1]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[1]: Leaving directory `/usr/src/pool/linux-2.4.20/kernel'
make -C  drivers CFLAGS=3D"-D__KERNEL__ -I/usr/src/pool/linux-2.4.20/incl=
ude -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fn=
o-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=
=3Di686 -DMODULE -DMODVERSIONS -include /usr/src/pool/linux-2.4.20/includ=
e/linux/modversions.h" MAKING_MODULES=3D1 modules
make[1]: Entering directory `/usr/src/pool/linux-2.4.20/drivers'
make -C block modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/block'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/block'
make -C cdrom modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/cdrom'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/cdrom'
make -C char modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/char'
make -C drm modules
make[3]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/char/drm'
make[3]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[3]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/char/drm'
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/char'
make -C hotplug modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/hotplug'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/hotplug'
make -C ide modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/ide'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/ide'
make -C media modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/media'
make -C radio modules
make[3]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/media/rad=
io'
make[3]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[3]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/media/radi=
o'
make -C video modules
make[3]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/media/vid=
eo'
make[3]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[3]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/media/vide=
o'
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/media'
make -C misc modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/misc'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/misc'
make -C net modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/net'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/net'
make -C parport modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/parport'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/parport'
make -C scsi modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/scsi'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/scsi'
make -C sound modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/sound'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/sound'
make -C usb modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/usb'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/usb'
make -C video modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/drivers/video'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers/video'
make[1]: Leaving directory `/usr/src/pool/linux-2.4.20/drivers'
make -C  mm CFLAGS=3D"-D__KERNEL__ -I/usr/src/pool/linux-2.4.20/include -=
Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-com=
mon -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di6=
86 -DMODULE -DMODVERSIONS -include /usr/src/pool/linux-2.4.20/include/lin=
ux/modversions.h" MAKING_MODULES=3D1 modules
make[1]: Entering directory `/usr/src/pool/linux-2.4.20/mm'
make[1]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[1]: Leaving directory `/usr/src/pool/linux-2.4.20/mm'
make -C  fs CFLAGS=3D"-D__KERNEL__ -I/usr/src/pool/linux-2.4.20/include -=
Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-com=
mon -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di6=
86 -DMODULE -DMODVERSIONS -include /usr/src/pool/linux-2.4.20/include/lin=
ux/modversions.h" MAKING_MODULES=3D1 modules
make[1]: Entering directory `/usr/src/pool/linux-2.4.20/fs'
make[1]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[1]: Leaving directory `/usr/src/pool/linux-2.4.20/fs'
make -C  net CFLAGS=3D"-D__KERNEL__ -I/usr/src/pool/linux-2.4.20/include =
-Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-co=
mmon -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di=
686 -DMODULE -DMODVERSIONS -include /usr/src/pool/linux-2.4.20/include/li=
nux/modversions.h" MAKING_MODULES=3D1 modules
make[1]: Entering directory `/usr/src/pool/linux-2.4.20/net'
make -C core modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/net/core'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/net/core'
make -C ipv4 modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/net/ipv4'
make[2]: F=FCr das Target =BBmodules=AB gibt es nichts zu tun.
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/net/ipv4'
make -C ipv4/netfilter modules
make[2]: Entering directory `/usr/src/pool/linux-2.4.20/net/ipv4/netfilte=
r'
ld -m elf_i386 -r -o ip_conntrack.o ip_conntrack_standalone.o ip_conntrac=
k_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntra=
ck_proto_udp.o ip_conntrack_proto_icmp.o
ld -m elf_i386 -r -o iptable_nat.o ip_nat_standalone.o ip_nat_rule.o ip_n=
at_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_na=
t_proto_udp.o ip_nat_proto_icmp.o
gcc -D__KERNEL__ -I/usr/src/pool/linux-2.4.20/include -Wall -Wstrict-prot=
otypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-p=
ointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di686 -DMODULE -DMODV=
ERSIONS -include /usr/src/pool/linux-2.4.20/include/linux/modversions.h  =
-nostdinc -iwithprefix include -DKBUILD_BASENAME=3Dip_pool  -DEXPORT_SYMT=
AB -c ip_pool.c
make[2]: Leaving directory `/usr/src/pool/linux-2.4.20/net/ipv4/netfilter=
'
make[1]: Leaving directory `/usr/src/pool/linux-2.4.20/net'

--Multipart_Thu__19_Dec_2002_16:24:44_+0100_0841c3e8--
