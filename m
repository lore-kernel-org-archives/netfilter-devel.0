From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: get rid of warnings if no PROC_FS
Date: Sun, 30 Nov 2003 21:05:12 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130153512.GF26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
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


--ZPDwMsyfds7q4mrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the fifth netfilter patch, please apply.

Author: Stephen Hemminger

Trivial -- Get rid of warnings in netfilter if /proc is not configured on.
Patch against 2.6.0-test1

diff -Nru a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent=
=2Ec
--- a/net/ipv4/netfilter/ipt_recent.c	Fri Jul 25 12:30:29 2003
+++ b/net/ipv4/netfilter/ipt_recent.c	Fri Jul 25 12:30:29 2003
@@ -91,8 +91,10 @@
  */
 static spinlock_t recent_lock =3D SPIN_LOCK_UNLOCKED;
=20
+#ifdef CONFIG_PROC_FS
 /* Our /proc/net/ipt_recent entry */
 static struct proc_dir_entry *proc_net_ipt_recent =3D NULL;
+#endif
=20
 /* Function declaration for later. */
 static int
@@ -959,8 +961,10 @@
 	int count;
=20
 	printk(version);
+#ifdef CONFIG_PROC_FS
 	proc_net_ipt_recent =3D proc_mkdir("ipt_recent",proc_net);
 	if(!proc_net_ipt_recent) return -ENOMEM;
+#endif
=20
 	if(ip_list_hash_size && ip_list_hash_size <=3D ip_list_tot) {
 	  printk(KERN_WARNING RECENT_NAME ": ip_list_hash_size too small, resetti=
ng to default.\n");

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yg5FXaXGVTD0i/8RAhvyAKCKUNV45f8slQD0Z1HoRCX37CnA5QCgjdEW
lQOot6yISiKjAkNVLdReReU=
=DoD7
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
