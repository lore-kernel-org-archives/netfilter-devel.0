From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4 3/10]: Change permissions of /proc/net/ip_conntrack to 0440
Date: Mon, 21 Jun 2004 21:51:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621195110.GW24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zyFEcxsgI11YYMbz"
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


--zyFEcxsgI11YYMbz
Content-Type: multipart/mixed; boundary="tKC5HTBlrbpnwuKu"
Content-Disposition: inline


--tKC5HTBlrbpnwuKu
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.4 changes permissions of /proc/net/ip_conntrack to
0440.

Author: Patrick McHardy <kaber@trash.net>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tKC5HTBlrbpnwuKu
Content-Type: text/plain; charset=us-ascii; name="03.diff"
Content-Disposition: inline; filename="03.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:30:15+02:00 kaber@trash.net=20
#   [NETFILTER]: Change permissions of /proc/net/ip_conntrack to 0440
#=20
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/06/20 22:30:13+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Change permissions of /proc/net/ip_conntrack to 0440
#=20
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilt=
er/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-20 23:02:40 +02:=
00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-20 23:02:40 +02:=
00
@@ -349,7 +349,7 @@
 	if (ret < 0)
 		goto cleanup_nothing;
=20
-	proc =3D proc_net_create("ip_conntrack",0,list_conntracks);
+	proc =3D proc_net_create("ip_conntrack", 0440, list_conntracks);
 	if (!proc) goto cleanup_init;
 	proc->owner =3D THIS_MODULE;
=20



--tKC5HTBlrbpnwuKu--

--zyFEcxsgI11YYMbz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zwuXaXGVTD0i/8RAvSyAKCcjq/WlFL4O91/VEZuuZL8J/lusgCeKW4e
j45LugfiFqpvk65egesdNN4=
=k155
-----END PGP SIGNATURE-----

--zyFEcxsgI11YYMbz--
