From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] __FUNCTION__ pasting fix for ip_nat_helper.c, 2.5.33
Date: Sat, 7 Sep 2002 18:36:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020907183613.L9675@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRyyN4gAPkNkeCwp"
Cc: James Morris <jmorris@intercode.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wRyyN4gAPkNkeCwp
Content-Type: multipart/mixed; boundary="PjJwPjbdn5RfZuWK"
Content-Disposition: inline


--PjJwPjbdn5RfZuWK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following patch to make our __FUNCTION__ usage compatible
with latest gcc versions.

Thanks.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--PjJwPjbdn5RfZuWK
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 #1)
	id 17lKhI-0004Un-00
	for laforge@gnumonks.org; Sun, 01 Sep 2002 04:42:44 +0200
Received: from blackbird.intercode.com.au ([203.32.101.10])
	by coruscant.gnumonks.org with esmtp (Exim 3.34 #1)
	id 17lKhF-0004Uk-00
	for laforge@gnumonks.org; Sun, 01 Sep 2002 04:42:43 +0200
Received: from localhost (jmorris@localhost)
	by blackbird.intercode.com.au (8.9.3/8.9.3) with ESMTP id MAA14025;
	Sun, 1 Sep 2002 12:42:33 +1000
Date: Sun, 1 Sep 2002 12:42:33 +1000 (EST)
From: James Morris <jmorris@intercode.com.au>
To: Harald Welte <laforge@gnumonks.org>
cc: netfilter-devel@lists.samba.org
Subject: [PATCH] __FUNCTION__ pasting fix for ip_nat_helper.c, 2.5.33
Message-ID: <Mutt.LNX.4.44.0209011240540.14016-100000@blackbird.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII

Please see the patch below.

- James
-- 
James Morris
<jmorris@intercode.com.au>

diff -urN -X dontdiff linux-2.5.33.w1/net/ipv4/netfilter/ip_nat_helper.c linux-2.5.33.w1-nathelp/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.5.33.w1/net/ipv4/netfilter/ip_nat_helper.c	Fri Aug  2 07:16:10 2002
+++ linux-2.5.33.w1-nathelp/net/ipv4/netfilter/ip_nat_helper.c	Sun Sep  1 12:25:01 2002
@@ -382,9 +382,9 @@
 			const char *tmp = me->me->name;
 			
 			if (strlen(tmp) + 6 > MODULE_MAX_NAMELEN) {
-				printk(__FUNCTION__ ": unable to "
+				printk("%s: unable to "
 				       "compute conntrack helper name "
-				       "from %s\n", tmp);
+				       "from %s\n", __FUNCTION__, tmp);
 				return -EBUSY;
 			}
 			tmp += 6;
@@ -467,7 +467,8 @@
 		    && ct_helper->me) {
 			__MOD_DEC_USE_COUNT(ct_helper->me);
 		} else 
-			printk(__FUNCTION__ ": unable to decrement usage count"
-			       " of conntrack helper %s\n", me->me->name);
+			printk("%s: unable to decrement usage count of "
+			       "conntrack helper %s\n", __FUNCTION__,
+			       me->me->name);
 	}
 }



--PjJwPjbdn5RfZuWK--

--wRyyN4gAPkNkeCwp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9eir8XaXGVTD0i/8RAklrAJ9PLba9H4wmMg4MallRoBxCxRtasACgjYM1
79dxGDLO5FdSDwXDordi3QA=
=084p
-----END PGP SIGNATURE-----

--wRyyN4gAPkNkeCwp--
