From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 3/14]: Change permissions of /proc/net/ip_conntrack to 0440
Date: Mon, 21 Jun 2004 21:39:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621193959.GH24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G1IH56i3DES2a+WZ"
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


--G1IH56i3DES2a+WZ
Content-Type: multipart/mixed; boundary="/8Xxy37xq6kDVsli"
Content-Disposition: inline


--/8Xxy37xq6kDVsli
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 changes permissions of /proc/net/ip_conntrack to
0440.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/8Xxy37xq6kDVsli
Content-Type: text/plain; charset=us-ascii; name="03.diff"
Content-Disposition: inline; filename="03.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:29:39+02:00 kaber@trash.net=20
#   [NETFILTER]: Change permissions of /proc/net/ip_conntrack to 0440
#=20
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/06/20 22:29:30+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Change permissions of /proc/net/ip_conntrack to 0440
#=20
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilt=
er/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-20 22:59:41 +02:=
00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-20 22:59:41 +02:=
00
@@ -502,7 +502,7 @@
 	if (ret < 0)
 		goto cleanup_nothing;
=20
-	proc =3D proc_net_create("ip_conntrack",0,list_conntracks);
+	proc =3D proc_net_create("ip_conntrack", 0440, list_conntracks);
 	if (!proc) goto cleanup_init;
 	proc->owner =3D THIS_MODULE;
=20


--/8Xxy37xq6kDVsli--

--G1IH56i3DES2a+WZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zmPXaXGVTD0i/8RAkFQAJsGtFpqJ/FHmE5nIVRcaqusGDFcNQCgoh6Y
TTRt1q2NsxP1x4k0cxFKFRA=
=R8aN
-----END PGP SIGNATURE-----

--G1IH56i3DES2a+WZ--
