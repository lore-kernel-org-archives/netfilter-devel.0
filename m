From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 4/14]: skip internal targets in iptables proc listing
Date: Mon, 21 Jun 2004 21:40:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194020.GI24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v4FgCkd4vT7RadTR"
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


--v4FgCkd4vT7RadTR
Content-Type: multipart/mixed; boundary="+dJ5Ea9E9bxtHwvD"
Content-Disposition: inline


--+dJ5Ea9E9bxtHwvD
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 changes iptables to skip the standard and error
target in /proc/net/ip_tables_targets. Before they would show up
as an empty line, followed by "ERROR".

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+dJ5Ea9E9bxtHwvD
Content-Type: text/plain; charset=us-ascii; name="04.diff"
Content-Disposition: inline; filename="04.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:31:11+02:00 kaber@trash.net=20
#   [NETFILTER]: skip internal targets in iptables proc listing
#=20
# net/ipv6/netfilter/ip6_tables.c
#   2004/06/20 22:31:01+02:00 kaber@trash.net +10 -1
#   [NETFILTER]: skip internal targets in iptables proc listing
#=20
# net/ipv4/netfilter/ip_tables.c
#   2004/06/20 22:31:01+02:00 kaber@trash.net +10 -1
#   [NETFILTER]: skip internal targets in iptables proc listing
#=20
diff -Nru a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c	2004-06-20 22:59:51 +02:00
+++ b/net/ipv4/netfilter/ip_tables.c	2004-06-20 22:59:51 +02:00
@@ -1731,6 +1731,15 @@
 	return 0;
 }
=20
+static inline int print_target(const struct ipt_target *t,
+                               off_t start_offset, char *buffer, int lengt=
h,
+                               off_t *pos, unsigned int *count)
+{
+	if (t =3D=3D &ipt_standard_target || t =3D=3D &ipt_error_target)
+		return 0;
+	return print_name((char *)t, start_offset, buffer, length, pos, count);
+}
+
 static int ipt_get_tables(char *buffer, char **start, off_t offset, int le=
ngth)
 {
 	off_t pos =3D 0;
@@ -1757,7 +1766,7 @@
 	if (down_interruptible(&ipt_mutex) !=3D 0)
 		return 0;
=20
-	LIST_FIND(&ipt_target, print_name, void *,
+	LIST_FIND(&ipt_target, print_target, struct ipt_target *,
 		  offset, buffer, length, &pos, &count);
 =09
 	up(&ipt_mutex);
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables=
=2Ec
--- a/net/ipv6/netfilter/ip6_tables.c	2004-06-20 22:59:51 +02:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2004-06-20 22:59:51 +02:00
@@ -1845,6 +1845,15 @@
 	return 0;
 }
=20
+static inline int print_target(const struct ip6t_target *t,
+                               off_t start_offset, char *buffer, int lengt=
h,
+                               off_t *pos, unsigned int *count)
+{
+	if (t =3D=3D &ip6t_standard_target || t =3D=3D &ip6t_error_target)
+		return 0;
+	return print_name((char *)t, start_offset, buffer, length, pos, count);
+}
+
 static int ip6t_get_tables(char *buffer, char **start, off_t offset, int l=
ength)
 {
 	off_t pos =3D 0;
@@ -1871,7 +1880,7 @@
 	if (down_interruptible(&ip6t_mutex) !=3D 0)
 		return 0;
=20
-	LIST_FIND(&ip6t_target, print_name, char *,
+	LIST_FIND(&ip6t_target, print_target, struct ip6t_target *,
 		  offset, buffer, length, &pos, &count);
=20
 	up(&ip6t_mutex);


--+dJ5Ea9E9bxtHwvD--

--v4FgCkd4vT7RadTR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zmkXaXGVTD0i/8RAuW7AJ9a2A5CjcqurBLyWWP73HUkMbrttACfVMW6
xNNfLIK/SLlv3vGeXbip2kg=
=k0dj
-----END PGP SIGNATURE-----

--v4FgCkd4vT7RadTR--
