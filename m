From: "Sebastian Aberle" <aberle@infotech.de>
Subject: RSH helper concurrent sessions fix
Date: Wed, 22 Jun 2005 17:22:00 +0200
Message-ID: <JBEOIOMFMBOPMPLFDIALKENHCJAA.aberle@infotech.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

here is a fix for a small error I discovered in the RSH conntrack helper =
when trying to establish multiple concurrent sessions to a host (working =
for me, at least).


diff -dpru =
patch-o-matic-ng-20050621/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c=
 =
patch-o-matic-ng-20050621_RSHFIXED/rsh/linux/net/ipv4/netfilter/ip_conntr=
ack_rsh.c
--- =
patch-o-matic-ng-20050620/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c=
	Thu Nov 11 22:33:11 2004
+++ =
patch-o-matic-ng-20050621_RSHFIXED/rsh/linux/net/ipv4/netfilter/ip_conntr=
ack_rsh.c	Wed Jun 22 17:05:18 2005
@@ -230,7 +230,7 @@ static int help(const struct iphdr *iph,
 	exp->mask.dst.ip =3D 0xffffffff;
=20
 	exp->mask.src.u.tcp.port =3D htons(0xfc00);
-	exp->mask.dst.u.tcp.port =3D htons(0xfc00);
+	exp->mask.dst.u.tcp.port =3D htons(0xffff);
 	exp->mask.dst.protonum =3D 0xffff;
=20
 	exp->expectfn =3D NULL;
diff -dpru =
patch-o-matic-ng-20050621/rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrac=
k_rsh.c =
patch-o-matic-ng-20050621_RSHFIXED/rsh/linux-2.6.11/net/ipv4/netfilter/ip=
_conntrack_rsh.c
--- =
patch-o-matic-ng-20050621/rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrac=
k_rsh.c	Sun Apr 10 14:36:36 2005
+++ =
patch-o-matic-ng-20050621_RSHFIXED/rsh/linux-2.6.11/net/ipv4/netfilter/ip=
_conntrack_rsh.c	Wed Jun 22 17:05:54 2005
@@ -231,7 +231,7 @@ static int help(struct sk_buff **pskb,
 	exp->mask.dst.ip =3D 0xffffffff;
=20
 	exp->mask.src.u.tcp.port =3D htons(0xfc00);
-	exp->mask.dst.u.tcp.port =3D htons(0xfc00);
+	exp->mask.dst.u.tcp.port =3D htons(0xffff);
 	exp->mask.dst.protonum =3D 0xff;
=20
 	exp->expectfn =3D NULL;


Greetings,

Sebastian Aberle
--
InfoTech GmbH
Holthoffstrasse 126
45659 Recklinghausen, GERMANY
www.infotech.de
