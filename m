From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] 2.4.x iptables iptable_mangle LOCAL_IN bugfix
Date: Sun, 30 Mar 2003 21:36:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330193641.GS7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U5J2I87mWnf1KeOw"
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


--U5J2I87mWnf1KeOw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

The patch below fixes a bug when the MARK target is used in the INPUT
chain of the mangle table.

This one is for 2.4.x, expect the 2.5.x fix in my next email.

Please apply, thanks.


diff -Nru --exclude .depend --exclude *.o --exclude *.ver --exclude .*.flag=
s --exclude *.orig --exclude *.rej --exclude *~ linux-2.4.20-plain/net/ipv4=
/netfilter/iptable_mangle.c linux-2.4.20-mangleinput/net/ipv4/netfilter/ipt=
able_mangle.c
--- linux-2.4.20-plain/net/ipv4/netfilter/iptable_mangle.c	Mon Feb 25 20:38=
:14 2002
+++ linux-2.4.20-mangleinput/net/ipv4/netfilter/iptable_mangle.c	Wed Jan  8=
 18:09:36 2003
@@ -170,7 +170,7 @@
 static struct nf_hook_ops ipt_ops[]
 =3D { { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_PRE_ROUTING,=20
 	NF_IP_PRI_MANGLE },
-    { { NULL, NULL }, ipt_local_hook, PF_INET, NF_IP_LOCAL_IN,
+    { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_LOCAL_IN,
 	NF_IP_PRI_MANGLE },
     { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_FORWARD,
 	NF_IP_PRI_MANGLE },

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U5J2I87mWnf1KeOw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+h0dJXaXGVTD0i/8RAmAYAJ46CrZwMRAksCZXmF4uVBgRlnenqwCfSBrX
bmXXV1taDhF5RF9vhjGmoPI=
=2fHR
-----END PGP SIGNATURE-----

--U5J2I87mWnf1KeOw--
