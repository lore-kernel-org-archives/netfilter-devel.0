From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ip_queue memory leaks
Date: Sun, 27 Apr 2003 11:49:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427094949.GF990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TeJTyD9hb8KJN2Jy"
Cc: Muli Ben-Yehuda <mulix@mulix.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--TeJTyD9hb8KJN2Jy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following patch (courtesy of Muli Ben-Yehuda).
It fixes memory leaks in the ip_queue code for ipv4 and ipv6.

Patch applies cleanly (-p0) to 2.4.21-rc1 and 2.5.68.

Thanks,

Index: net/ipv4/netfilter/ip_queue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /home/cvs/linux-2.5/net/ipv4/netfilter/ip_queue.c,v
retrieving revision 1.13
diff -u -r1.13 ip_queue.c
--- net/ipv4/netfilter/ip_queue.c	3 Apr 2003 16:59:51 -0000	1.13
+++ net/ipv4/netfilter/ip_queue.c	19 Apr 2003 11:35:11 -0000
@@ -300,8 +300,9 @@
 	write_lock_bh(&queue_lock);
 =09
 	if (!peer_pid)
-		goto err_out_unlock;
+		goto err_out_free_nskb;=20
=20
+ 	/* netlink_unicast will either free the nskb or attach it to a socket */=
=20
 	status =3D netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
 	if (status < 0)
 		goto err_out_unlock;
@@ -312,6 +313,9 @@
=20
 	write_unlock_bh(&queue_lock);
 	return status;
+
+err_out_free_nskb:
+	kfree_skb(nskb);=20
 =09
 err_out_unlock:
 	write_unlock_bh(&queue_lock);
Index: net/ipv6/netfilter/ip6_queue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /home/cvs/linux-2.5/net/ipv6/netfilter/ip6_queue.c,v
retrieving revision 1.10
diff -u -r1.10 ip6_queue.c
--- net/ipv6/netfilter/ip6_queue.c	5 Apr 2003 01:30:47 -0000	1.10
+++ net/ipv6/netfilter/ip6_queue.c	19 Apr 2003 11:35:12 -0000
@@ -304,8 +304,9 @@
 	write_lock_bh(&queue_lock);
 =09
 	if (!peer_pid)
-		goto err_out_unlock;
+		goto err_out_free_nskb;=20
=20
+ 	/* netlink_unicast will either free the nskb or attach it to a socket */=
=20
 	status =3D netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
 	if (status < 0)
 		goto err_out_unlock;
@@ -316,6 +317,9 @@
=20
 	write_unlock_bh(&queue_lock);
 	return status;
+=09
+err_out_free_nskb:
+	kfree_skb(nskb);=20
 =09
 err_out_unlock:
 	write_unlock_bh(&queue_lock);

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TeJTyD9hb8KJN2Jy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q6e9XaXGVTD0i/8RAqC6AKCcMO7iz7IF7z1E0BoEx8HfEcTlFQCglGUT
N18ry0WYJar5nZWMmk7DezU=
=ZCOV
-----END PGP SIGNATURE-----

--TeJTyD9hb8KJN2Jy--
