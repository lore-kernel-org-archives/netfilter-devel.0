From: Samir Bellabes <samir.bellabes@wanadoo.fr>
Subject: [PATCH] Compilling error with 63_getorigdst-tuple-zero.patch
Date: Tue, 16 Sep 2003 15:34:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F671181.6030004@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
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

Hi all,

i'm running linux 2.4.22 and i apply patch-o-matic from CVS, updated=20
yesterday..
When "make modules" I got this :

first,

make[2]: D=E9pendance circulaire=20
/usr/src/linux-2.4.22/include/linux/netfilter_ipv4/ip_conntrack_helper.h=20
<- /usr/src/linux-2.4.22/include/linux/netfilter_ipv4/ip_conntrack.h=20
abandonn=E9e.

a #include recall himself.. is this a problem ?

second,

gcc -D__KERNEL__ -I/usr/src/linux-2.4.22/include -Wall=20
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common=20
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2 -march=3Di686=20
-malign-functions=3D4 -DMODULE -DMODVERSIONS -include=20
/usr/src/linux-2.4.22/include/linux/modversions.h  -nostdinc=20
-iwithprefix include -DKBUILD_BASENAME=3Dip_conntrack_core  -c -o=20
ip_conntrack_core.o ip_conntrack_core.c
ip_conntrack_core.c: In function `getorigdst':
ip_conntrack_core.c:1310: invalid type argument of `->'
ip_conntrack_core.c:1310: invalid type argument of `->'


i think the correct patch 63_getorigdst-tuple-zero.patch have to be :


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude=20
'*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej'=20
--exclude '*.cmd' --exclude '*.mod.c' --exclude '*~'=20
linux-2.4.22-plain/include/linux/netfilter_ipv4/ip_conntrack_tuple.h=20
linux-2.4.22-getorig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
---=20
linux-2.4.22-plain/include/linux/netfilter_ipv4/ip_conntrack_tuple.h     =
  =20
2002-02-25 20:38:13.000000000 +0100
+++=20
linux-2.4.22-getorig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h   =
  =20
2003-09-05 17:04:20.000000000 +0200
@@ -62,6 +62,14 @@
        } dst;
 };
=20
+/* This is optimized opposed to a memset of the whole structure. =20
Everything we
+ * really care about is the  source/destination unions */
+#define IP_CT_TUPLE_BLANK(tuple)                               \
+       do {                                                    \
+               (tuple)->src.u.all =3D 0;                           \
+               (tuple)->dst.u.all =3D 0;                           \
+       } while (0)
+
 enum ip_conntrack_dir
 {
        IP_CT_DIR_ORIGINAL,
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude=20
'*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej'=20
--exclude '*.cmd' --exclude '*.mod.c' --exclude '*~'=20
linux-2.4.22-plain/net/ipv4/netfilter/ip_conntrack_core.c=20
linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ip_conntrack_core.c  =20
2003-08-25 13:44:44.000000000 +0200
+++ linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack_core.c=20
2003-09-05 17:04:20.000000000 +0200
@@ -1303,9 +1303,14 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
        struct ip_conntrack_tuple_hash *h;
-       struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { .tcp =3D=
 {=20
sk->sport } } },
-                                           { sk->daddr, { .tcp =3D {=20
sk->dport } },
-                                             IPPROTO_TCP } };
+       struct ip_conntrack_tuple tuple;
+
+       IP_CT_TUPLE_BLANK(&tuple);
+       tuple.src.ip =3D sk->rcv_saddr;
+       tuple.src.u.tcp.port =3D sk->sport;
+       tuple.dst.ip =3D sk->daddr;
+       tuple.dst.u.tcp.port =3D sk->dport;
+       tuple.dst.protonum =3D IPPROTO_TCP;
=20
        /* We only do TCP at the moment: is there a better way? */
        if (strcmp(sk->prot->name, "TCP") !=3D 0) {


thanks to correct, as far as i'm a newbie, i could be incorrect..

thanks for your work !

Samir Bellabes
samir.bellabes@wanadoo.fr
