From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Sun, 21 Sep 2003 16:40:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030921144013.GA22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Some people use REJECT in the OUTPUT chain (rejecting locally generated
packets).  This didn't work anymore starting with some fixes we did in 2.4.=
22.=20
A dst_entry for a local source doesn't contain pmtu information - and
thus the newly-created packet would instantly be dropped again.

I'll send you a 2.6.x merge for this later.

Please apply the following fix, thanks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="75_REJECT_localpmtu-fix.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22/net/ipv4/netfilter/ipt=
_REJECT.c linux-2.4.22-rejectfix/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.4.22/net/ipv4/netfilter/ipt_REJECT.c	2003-08-25 13:44:44.000000=
000 +0200
+++ linux-2.4.22-rejectfix/net/ipv4/netfilter/ipt_REJECT.c	2003-09-21 16:39=
:25.000000000 +0200
@@ -186,8 +186,8 @@
 	nskb->nh.iph->check =3D ip_fast_csum((unsigned char *)nskb->nh.iph,=20
 					   nskb->nh.iph->ihl);
=20
-	/* "Never happens" */
-	if (nskb->len > nskb->dst->pmtu)
+	/* dst->pmtu can be zero because it is not set for local dst's */
+	if (nskb->dst->pmtu && nskb->len > nskb->dst->pmtu)
 		goto free_nskb;
=20
 	connection_attach(nskb, oldskb->nfct);

--Qxx1br4bt0+wmkIi--

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbhNXaXGVTD0i/8RAuPuAJsGfP+lOdTF+9ICL/PwrcmDrigkOgCfZ29b
WfgGMCdz+seLGbiCJngkcfY=
=pHjS
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
