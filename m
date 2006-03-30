From: Massimiliano Hofer <max@nucleus.it>
Subject: Fix the condition extension for 2.6.16 kernels
Date: Thu, 30 Mar 2006 23:51:18 +0200
Message-ID: <200603302351.27713.max@nucleus.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1456199.evNvLxGOTU";
	protocol="application/pgp-signature"; micalg=pgp-sha1
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

--nextPart1456199.evNvLxGOTU
Content-Type: multipart/mixed;
  boundary="Boundary-01=_XLFLEtQTD04NB0E"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_XLFLEtQTD04NB0E
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
this is my first contribution to this project, so I suggest you to test it=
=20
before accepting my code.
Anyway I did a really simple fix for the condition extension for 2.6.16=20
kernels.


diff -Nur=20
patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv4/netfilter=
/ipt_condition.c=20
patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv4/netfilter/ipt_=
condition.c
=2D--=20
patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv4/netfilter=
/ipt_condition.c=20
2003-12-18 19:47:52.000000000 +0100
+++=20
patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv4/netfilter/ipt_=
condition.c     =20
2006-03-30 23:41:13.000000000 +0200
@@ -92,7 +92,7 @@
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
       const struct net_device *out, const void *matchinfo, int offset,
=2D      const void *hdr, u_int16_t datalen, int *hotdrop)
+      unsigned int protoff, int *hotdrop)
 {
        const struct condition_info *info =3D
            (const struct condition_info *) matchinfo;
@@ -116,7 +116,7 @@


 static int
=2Dcheckentry(const char *tablename, const struct ipt_ip *ip,
+checkentry(const char *tablename, const void *ip,
           void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
        struct condition_info *info =3D (struct condition_info *) matchinfo;
diff -Nur=20
patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv6/netfilter=
/ip6t_condition.c=20
patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv6/netfilter/ip6t=
_condition.c
=2D--=20
patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv6/netfilter=
/ip6t_condition.c       =20
2003-12-20 17:38:19.000000000 +0100
+++=20
patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv6/netfilter/ip6t=
_condition.c    =20
2006-03-30 23:41:01.000000000 +0200
@@ -88,7 +88,7 @@
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
       const struct net_device *out, const void *matchinfo, int offset,
=2D      const void *hdr, u_int16_t datalen, int *hotdrop)
+      unsigned int protoff, int *hotdrop)
 {
        const struct condition6_info *info =3D
            (const struct condition6_info *) matchinfo;
@@ -112,7 +112,7 @@


 static int
=2Dcheckentry(const char *tablename, const struct ip6t_ip6 *ip,
+checkentry(const char *tablename, const void *ip,
           void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
        struct condition6_info *info =3D
@@ -232,7 +232,7 @@
        proc_net_condition =3D proc_mkdir("ip6t_condition", proc_net);

        if (proc_net_condition) {
=2D               errorcode =3D ipt_register_match(&condition_match);
+               errorcode =3D ip6t_register_match(&condition_match);

                if (errorcode)
                        remove_proc_entry("ip6t_condition", proc_net);
@@ -246,7 +246,7 @@
 static void __exit
 fini(void)
 {
=2D       ipt_unregister_match(&condition_match);
+       ip6t_unregister_match(&condition_match);
        remove_proc_entry("ip6t_condition", proc_net);
 }



=2D-=20
Bye,
   Massimiliano Hofer
        Nucleus

--Boundary-01=_XLFLEtQTD04NB0E
Content-Type: text/x-diff;
  charset="us-ascii";
  name="condition.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="condition.patch"

diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv4=
/netfilter/ipt_condition.c patch-o-matic-ng-20060329/patchlets/condition/li=
nux/net/ipv4/netfilter/ipt_condition.c
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv4/net=
filter/ipt_condition.c	2003-12-18 19:47:52.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv4/netfilter/=
ipt_condition.c	2006-03-30 23:41:13.000000000 +0200
@@ -92,7 +92,7 @@
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
       const struct net_device *out, const void *matchinfo, int offset,
=2D      const void *hdr, u_int16_t datalen, int *hotdrop)
+      unsigned int protoff, int *hotdrop)
 {
 	const struct condition_info *info =3D
 	    (const struct condition_info *) matchinfo;
@@ -116,7 +116,7 @@
=20
=20
 static int
=2Dcheckentry(const char *tablename, const struct ipt_ip *ip,
+checkentry(const char *tablename, const void *ip,
 	   void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
 	struct condition_info *info =3D (struct condition_info *) matchinfo;
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv6=
/netfilter/ip6t_condition.c patch-o-matic-ng-20060329/patchlets/condition/l=
inux/net/ipv6/netfilter/ip6t_condition.c
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux/net/ipv6/net=
filter/ip6t_condition.c	2003-12-20 17:38:19.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux/net/ipv6/netfilter/=
ip6t_condition.c	2006-03-30 23:41:01.000000000 +0200
@@ -88,7 +88,7 @@
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
       const struct net_device *out, const void *matchinfo, int offset,
=2D      const void *hdr, u_int16_t datalen, int *hotdrop)
+      unsigned int protoff, int *hotdrop)
 {
 	const struct condition6_info *info =3D
 	    (const struct condition6_info *) matchinfo;
@@ -112,7 +112,7 @@
=20
=20
 static int
=2Dcheckentry(const char *tablename, const struct ip6t_ip6 *ip,
+checkentry(const char *tablename, const void *ip,
 	   void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
 {
 	struct condition6_info *info =3D
@@ -232,7 +232,7 @@
 	proc_net_condition =3D proc_mkdir("ip6t_condition", proc_net);
=20
 	if (proc_net_condition) {
=2D	        errorcode =3D ipt_register_match(&condition_match);
+	        errorcode =3D ip6t_register_match(&condition_match);
=20
 		if (errorcode)
 			remove_proc_entry("ip6t_condition", proc_net);
@@ -246,7 +246,7 @@
 static void __exit
 fini(void)
 {
=2D	ipt_unregister_match(&condition_match);
+	ip6t_unregister_match(&condition_match);
 	remove_proc_entry("ip6t_condition", proc_net);
 }
=20

--Boundary-01=_XLFLEtQTD04NB0E--

--nextPart1456199.evNvLxGOTU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBELFLfh3gWNw6JlW4RAn1SAJ9JvgeosQ+TcA9gmdaaCmFoeTRCmACfT/oN
jFCt3MZhdP1b+GUEWW94W9k=
=jY6c
-----END PGP SIGNATURE-----

--nextPart1456199.evNvLxGOTU--
