From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] trivial but important iptables ipt_conntrack fix
Date: Sat, 3 May 2003 14:03:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030503120350.GT26924@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFHULmA0mO3kKGOo"
Cc: David Miller <davem@redhat.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcelo Tossati <marcelo@conectiva.com.br>
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


--GFHULmA0mO3kKGOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo & Dave!

I'm sending you this fairly trivial fix for ipt_conntrack, that should
definitely go in before 2.4.21 is released.

Please apply, Thanks!

--- linux-2.4.20-plain/net/ipv4/netfilter/ipt_conntrack.c	Fri Nov 29 00:53:=
15 2002
+++ linux-2.4.20-statefix/net/ipv4/netfilter/ipt_conntrack.c	Sat May  3 14:=
00:02 2003
@@ -27,7 +27,11 @@
=20
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
=20
-	statebit =3D ct ? IPT_CONNTRACK_STATE_INVALID : IPT_CONNTRACK_STATE_BIT(c=
tinfo);
+	if (ct)
+		statebit =3D IPT_CONNTRACK_STATE_BIT(ctinfo);
+	else
+		statebit =3D IPT_CONNTRACK_STATE_INVALID;
+
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
 			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=3D

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GFHULmA0mO3kKGOo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+s7AmXaXGVTD0i/8RAllZAJ9qOWS/iKhvozVRJNbtm3mkSrh/xwCeIKZ4
49xR0k2CHWYJ/stTbHzWo+8=
=kN3f
-----END PGP SIGNATURE-----

--GFHULmA0mO3kKGOo--
