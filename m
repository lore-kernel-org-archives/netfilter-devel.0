From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 2/14]: complain when broken ipt_owner options are used on SMP
Date: Mon, 21 Jun 2004 21:39:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621193920.GG24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DOr+hlVy7JMLa9bO"
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


--DOr+hlVy7JMLa9bO
Content-Type: multipart/mixed; boundary="MmaWY3eZhcRnoVUs"
Content-Disposition: inline


--MmaWY3eZhcRnoVUs
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 makes ipt_owner and ip6t_owner complain when options
that are broken on SMP are used. When the pid, sid or command is matched
the owner match takes files->file_lock in a BH, which deadlocks on SMP.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>


--MmaWY3eZhcRnoVUs
Content-Type: text/plain; charset=us-ascii; name="02.diff"
Content-Disposition: inline; filename="02.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:28:01+02:00 kaber@trash.net=20
#   [NETFILTER]: complain about brokeness on SMP for pid, sid and command m=
atching in ipt_owner
#=20
# net/ipv6/netfilter/ip6t_owner.c
#   2004/06/20 22:27:51+02:00 kaber@trash.net +8 -1
#   [NETFILTER]: complain about brokeness on SMP for pid, sid and command m=
atching in ipt_owner
#=20
# net/ipv4/netfilter/ipt_owner.c
#   2004/06/20 22:27:51+02:00 kaber@trash.net +9 -1
#   [NETFILTER]: complain about brokeness on SMP for pid, sid and command m=
atching in ipt_owner
#=20
diff -Nru a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
--- a/net/ipv4/netfilter/ipt_owner.c	2004-06-20 22:59:31 +02:00
+++ b/net/ipv4/netfilter/ipt_owner.c	2004-06-20 22:59:31 +02:00
@@ -184,7 +184,15 @@
 		       IPT_ALIGN(sizeof(struct ipt_owner_info)));
 		return 0;
 	}
-
+#ifdef CONFIG_SMP
+	/* files->file_lock can not be used in a BH */
+	if (((struct ipt_owner_info *)matchinfo)->match
+	    & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
+		printk("ipt_owner: pid, sid and command matching is broken "
+		       "on SMP.\n");
+		return 0;
+	}
+#endif
 	return 1;
 }
=20
diff -Nru a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner=
=2Ec
--- a/net/ipv6/netfilter/ip6t_owner.c	2004-06-20 22:59:31 +02:00
+++ b/net/ipv6/netfilter/ip6t_owner.c	2004-06-20 22:59:31 +02:00
@@ -143,7 +143,14 @@
=20
 	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_owner_info)))
 		return 0;
-
+#ifdef CONFIG_SMP
+	/* files->file_lock can not be used in a BH */
+	if (((struct ip6t_owner_info *)matchinfo)->match
+	    & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
+		printk("ip6t_owner: pid and sid matching is broken on SMP.\n");
+		return 0;
+	}
+#endif
 	return 1;
 }
=20


--MmaWY3eZhcRnoVUs--

--DOr+hlVy7JMLa9bO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zloXaXGVTD0i/8RAlxaAJ99Q2fDynfOvTQkB8b7my2fRjon+QCgl2qj
NlB5qAn4NtGKnyL8XMpv3W8=
=Y4oU
-----END PGP SIGNATURE-----

--DOr+hlVy7JMLa9bO--
