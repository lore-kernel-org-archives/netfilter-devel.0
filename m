From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4.x] Fix ipchains MASQUEARDE oops
Date: Thu, 4 Dec 2003 15:07:57 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204093757.GA7680@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
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


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following patch (on top of 2.4.23).  It fixes an oops
that was introduced during  2.4.23 when we did a change in the NAT core
but forgot to update the compatibility layer.  2.6.x already contains
that fix.

Please apply, thanks.

Which raises another issue... do you think it would still be possible to
rip out the ipfwadm and ipchains compatibility layer from 2.6.x?  I'm
just _asking_, if it was still possible - not asking you to do it.
This would certainly not affect stability, since we just delete a couple
of whole files...
I think the time has come to remove that kludge, especially since with
2.7.x we will get yet another generation of the linux packet filter.

--- linux.old/net/ipv4/netfilter/ip_fw_compat_masq.c	2002-11-29 05:22:53.00=
0000000 +0530
+++ linux/net/ipv4/netfilter/ip_fw_compat_masq.c	2003-12-04 14:54:06.000000=
000 +0530
@@ -91,9 +91,6 @@
 			WRITE_UNLOCK(&ip_nat_lock);
 			return ret;
 		}
-
-		place_in_hashes(ct, info);
-		info->initialized =3D 1;
 	} else
 		DEBUGP("Masquerading already done on this conn.\n");
 	WRITE_UNLOCK(&ip_nat_lock);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/zwCLXaXGVTD0i/8RAqOAAKCgJb2vtW/6lgC1tEOFXDOAcD5KFACfTgwR
k68DrGN0j7ZyPvykrhCu9Oc=
=kv17
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
