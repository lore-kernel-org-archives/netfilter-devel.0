From: netfilter@interlinx.bc.ca
Subject: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: Wed, 2 Apr 2003 21:51:51 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030403025151.GA1702@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

There is a patch in pending that makes the tcp-window-tracking patch
fail to apply cleanly.  The patch in
pending/24_conntrack-nosysctl.patch:

--- linux-2.4.21-pre5-ac3/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15=
 12:16:55 2003
+++ linux-2.4.21-pre5-ac3-fixed/net/ipv4/netfilter/ip_conntrack_core.c	Sat =
Mar 15 12:23:34 2003
@@ -1478,8 +1478,10 @@
 	ip_ct_attach =3D ip_conntrack_attach;
 	return ret;
=20
+#ifdef CONFIG_SYSCTL
 err_free_ct_cachep:
 	kmem_cache_destroy(ip_conntrack_cachep);
+#endif /*CONFIG_SYSCTL*/
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:


is not accounted for in hunk 5 to file
net/ipv4/netfilter/ip_conntrack_core.c in
extra/tcp-window-tracking.patch.

I guess the question is, should it be expected that patches in suites
like extra should apply if all of submitted and pending are applied.

b.

--=20
Brian J. Murrell

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+i6HHl3EQlGLyuXARAgFPAJ9/BF6309RwebYYMaFzjLY5xrB3mwCfQhNY
rVtJn866NwLfIalnx1bEpWs=
=y6uV
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
