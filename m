From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH 2.4] [TRIVIAL] kill ip_conntrack_tftp compile warning
Date: 29 Jun 2003 21:11:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056913873.632.68.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-61brsOYAtMibM2LyPLL5"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-61brsOYAtMibM2LyPLL5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Attached trivial patch kills the following compiler warning on
2.4.22-pre (probably 2.4.21 too). 2.5 already has the fix.

gcc -D__KERNEL__ -I/home/sneppef/kernel/linux-2.4.22-pre2-orig/include
-Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2
-march=k6 -DMODULE -DMODVERSIONS -include
/home/sneppef/kernel/linux-2.4.22-pre2-orig/include/linux/modversions.h 
-nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_nat_tftp  -c -o
ip_nat_tftp.o ip_nat_tftp.c
ip_nat_tftp.c: In function `init':
ip_nat_tftp.c:156: warning: `ret' might be used uninitialized in this
function

Regards,
Filip




--=-61brsOYAtMibM2LyPLL5
Content-Disposition: attachment; filename=diff.netfilter.trivial-tftp.20030629-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.trivial-tftp.20030629-1;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_nat_tftp=
.c linux-2.4.22-pre2/net/ipv4/netfilter/ip_nat_tftp.c
--- linux-2.4.22-pre2-orig/net/ipv4/netfilter/ip_nat_tftp.c     2003-06-13 =
16:51:39.000000000 +0200
+++ linux-2.4.22-pre2/net/ipv4/netfilter/ip_nat_tftp.c  2003-06-29 05:16:35=
.000000000 +0200
@@ -153,7 +153,7 @@

 static int __init init(void)
 {
-	int i, ret;
+	int i, ret =3D 0;
 	char *tmpname;

 	if (!ports[0])

--=-61brsOYAtMibM2LyPLL5--
