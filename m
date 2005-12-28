From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: [H.323] Compilation fixes for 2.6.14
Date: Wed, 28 Dec 2005 13:32:48 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D37@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: kadlec@blackhole.kfki.hu, max@duempel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

I am running into the same problem with 2.6.14.5 and POM-20051227.
Vinay, thank you for the patch and apologies in advance for not knowing
how to apply it.  Would you be able to point me to some instructions on
how to apply your patch to the copy of the source tree I have here? =20

thanks

- Greg Scott

******************************************************
(Original message follows)

Hi,

ip_conntrack_expect_alloc expects an argument in 2.6.14 (didn't check
2.6.13).

I got the following compilation errors while trying to compile H.323
module using patch-o-matic-ng-20051219.tar.bz2 against linux-2.6.14

net/ipv4/netfilter/ip_conntrack_h323_h225.c: In function
`h225_parse_connect_uuie':
net/ipv4/netfilter/ip_conntrack_h323_h225.c:111: error: too few
arguments to function `ip_conntrack_expect_alloc'

Patch below:
 ip_conntrack_h323_h225.c |    2 +-
 ip_conntrack_h323_h245.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


diff -urN a/net/ipv4/netfilter/ip_conntrack_h323_h225.c
b/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- a/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-12-23
14:32:53.000000000 +0530
+++ b/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-12-23
14:32:29.000000000 +0530
@@ -108,7 +108,7 @@
 		}
 		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp =3D ip_conntrack_expect_alloc();
+			exp =3D ip_conntrack_expect_alloc(ct);
 			if (exp =3D=3D NULL)
 				return NF_ACCEPT;

diff -urN a/net/ipv4/netfilter/ip_conntrack_h323_h245.c
b/net/ipv4/netfilter/ip_conntrack_h323_h245.c
--- a/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-12-23
14:32:53.000000000 +0530
+++ b/net/ipv4/netfilter/ip_conntrack_h323_h245.c	2005-12-23
14:32:29.000000000 +0530
@@ -296,7 +296,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp =3D ip_conntrack_expect_alloc();
+			exp =3D ip_conntrack_expect_alloc(ct);
 			if (exp =3D=3D NULL)
 				return NF_ACCEPT;

@@ -348,7 +348,7 @@
 			       NIPQUAD(ip), ntohs(port));
 		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp =3D ip_conntrack_expect_alloc();
+			exp =3D ip_conntrack_expect_alloc(ct);
 			if (exp =3D=3D NULL)
 				return NF_ACCEPT;

@@ -616,7 +616,7 @@
 		       ret, i, ip, port);
 		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp =3D ip_conntrack_expect_alloc();
+			exp =3D ip_conntrack_expect_alloc(ct);
 			if (exp =3D=3D NULL)
 				return NF_ACCEPT;

@@ -663,7 +663,7 @@
 		       ret, i, ip, port);
 		if (ret && ip =3D=3D ct->tuplehash[dir].tuple.src.ip) {
 			/* match found: create an expectation */
-			exp =3D ip_conntrack_expect_alloc();
+			exp =3D ip_conntrack_expect_alloc(ct);
 			if (exp =3D=3D NULL)
 				return NF_ACCEPT;
