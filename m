From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4+2.6] NAT range calculation fix
Date: Thu, 4 Sep 2003 12:04:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030904100403.GD2616@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n2Pv11Ogg/Ox8ay5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--n2Pv11Ogg/Ox8ay5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following fix to your 2.4 and 2.6 tree:

Author: Karlis Peisenieks

D: This patch fixes a logic bug in NAT range calculations, which also
D: causes a large slowdown when ICMP floods go through NAT.

--- linux/net/ipv4/netfilter/ip_nat_core.c	26 Aug 2003 11:13:19 -0000	1.6
+++ linux/net/ipv4/netfilter/ip_nat_core.c	28 Aug 2003 08:25:45 -0000
@@ -159,8 +159,8 @@
 				continue;
 		}
=20
-		if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+		    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--n2Pv11Ogg/Ox8ay5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/Vw4TXaXGVTD0i/8RAlMhAJ9cr3ZqP/DX1SXKzXCUD45faubt+gCcChL7
/bBieh86JVKPh3WokFyTncI=
=E855
-----END PGP SIGNATURE-----

--n2Pv11Ogg/Ox8ay5--
