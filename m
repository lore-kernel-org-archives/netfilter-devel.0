From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (8/7): incremental to cosmetic changes
Date: Tue, 24 Jun 2003 18:19:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624161940.GA14880@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
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


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Sorry for bombing you with yet another patch, but this is a new bugfix
that I discovered at this moment while catching up with my email.

This patch is incremental to what I've sent you earlier today,
especially the cosmetic fixes.

Patch apples to both, 2.4.x and 2.5.x.


--- linux.old/net/ipv4/netfilter/ip_conntrack_core.c	Fri Jun 20 05:37:56 20=
03
+++ linux/net/ipv4/netfilter/ip_conntrack_core.c	Fri Jun 20 12:33:23 2003
@@ -313,9 +313,6 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) =3D=3D 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
=20
-	if (master_ct(ct))
-		ip_conntrack_put(master_ct(ct));
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -332,9 +329,12 @@
=20
 	/* Delete our master expectation */
 	if (ct->master) {
-		/* can't call __unexpect_related here,
-		 * since it would screw up expect_list */
-		list_del(&ct->master->expected_list);
+		if (ct->master->expectant) {
+			/* can't call __unexpect_related here,
+			 * since it would screw up expect_list */
+			list_del(&ct->master->expected_list);
+			ip_conntrack_put(ct->master->expectant);
+		}
 		kfree(ct->master);
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++HocXaXGVTD0i/8RAsoTAJ9nJr7FVGElsqKFzS9Opq6dUJsbOQCeNTEh
hi9zG9seydtXrqMhMUJ+aVw=
=C7O/
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
