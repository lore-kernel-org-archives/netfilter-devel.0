From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] clear nf_debug in ipsec tunnel case
Date: Fri, 5 Sep 2003 14:19:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905121955.GH665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9ZOS6odDaRI+0hI"
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


--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch (again by Patrick McHardy) clears nf_debug in
ip_local_deliver_finish so the "hook ... already set" message in
nf_hook_slow won't get triggered for decapsulated ipsec-tunnel packets
when passing them through the network stack again.

Please apply to 2.6, thanks.

=3D=3D=3D=3D=3D net/ipv4/ip_input.c 1.17 vs edited =3D=3D=3D=3D=3D
--- 1.17/net/ipv4/ip_input.c	Mon Jun 16 17:11:36 2003
+++ edited/net/ipv4/ip_input.c	Sun Aug 24 23:11:36 2003
@@ -201,6 +201,7 @@
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	nf_debug_ip_local_deliver(skb);
+	skb->nf_debug =3D 0;
 #endif /*CONFIG_NETFILTER_DEBUG*/
=20
 	__skb_pull(skb, ihl);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/9ZOS6odDaRI+0hI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WH9rXaXGVTD0i/8RAlVwAJ9WX/G3kaIQxQ4mNdVxnhC6R2dGYwCdH126
kZGQUzLsfjw+8+s2UgY0R0k=
=Mb1/
-----END PGP SIGNATURE-----

--/9ZOS6odDaRI+0hI--
