From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.5.x iptables iptable_mangle LOCAL_IN bugfix
Date: Sun, 30 Mar 2003 21:40:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330194024.GT7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8N5nZmKALFZnI1Hj"
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


--8N5nZmKALFZnI1Hj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

The patch below fixes a bug when the MARK target is used in the INPUT
chain of the mangle table.

This one is for 2.5.x, the 2.4.x fix was in my last email.

Please apply, thanks.


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.5.66-plain/net/ipv4=
/netfilter/iptable_mangle.c linux-2.5.66-nftest/net/ipv4/netfilter/iptable_=
mangle.c
--- linux-2.5.66-plain/net/ipv4/netfilter/iptable_mangle.c	Mon Mar 24 23:01=
:24 2003
+++ linux-2.5.66-nftest/net/ipv4/netfilter/iptable_mangle.c	Sun Mar 30 21:3=
9:08 2003
@@ -179,7 +179,7 @@
 		.priority	=3D NF_IP_PRI_MANGLE,
 	},
 	{
-		.hook		=3D ipt_local_hook,
+		.hook		=3D ipt_route_hook,
 		.pf		=3D PF_INET,
 		.hooknum	=3D NF_IP_LOCAL_IN,
 		.priority	=3D NF_IP_PRI_MANGLE,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8N5nZmKALFZnI1Hj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h0goXaXGVTD0i/8RAtE6AKCyfFCM4vWaCnZO82AJt9RrNrU9PgCfTEWI
b+h/VQ6B0Uj4AF4ni9Y1Khk=
=biGl
-----END PGP SIGNATURE-----

--8N5nZmKALFZnI1Hj--
