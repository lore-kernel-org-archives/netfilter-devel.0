From: Harald Welte <laforge@netfilter.org>
Subject: [RFC] h323 module unloading fix
Date: Tue, 8 Feb 2005 15:59:08 +0100
Message-ID: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1MXu+reqKPHC6GN9"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--1MXu+reqKPHC6GN9
Content-Type: multipart/mixed; boundary="vkUjpNzvt17RSo84"
Content-Disposition: inline


--vkUjpNzvt17RSo84
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

If you unload the ip_conntrack_h323 module while a h323 session is in
progress, the conntrack table is left with corrupted entries (->helper
pointer still pointing to a now no longer existing h245 helper).

This is because the h245 helper is not registered with the core, and
therefore the helper_unregister() function will only be called for h245,
but not for h245.

The proposed solution:

1) to make ip_conntrack_core:ip_conntrack_helper_unregister() work with
   a helper that was never registered (and thus has an empty list.next)
2) to have ip_conntrack_h323 unregister the h245 helper.

Any comments?

Patches for h323(pom) and 2.4.29 attached.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vkUjpNzvt17RSo84
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="patch-2.4.29-h323-h245-unregister.patch"
Content-Transfer-Encoding: quoted-printable

--- a/net/ipv4/netfilter/ip_conntrack_core.c	2005-02-08 15:26:57.000000000 =
+0100
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2005-02-08 15:27:36.000000000 =
+0100
@@ -1149,7 +1149,11 @@
=20
 	/* Need write lock here, to delete helper. */
 	WRITE_LOCK(&ip_conntrack_lock);
-	LIST_DELETE(&helpers, me);
+=09
+	/* Conditional since some helpers (h245) are not really registered
+	 * and thus don't appear in our global list*/
+	if (me->list.next)
+		LIST_DELETE(&helpers, me);
=20
 	/* Get rid of expecteds, set helpers to NULL. */
 	for (i =3D 0; i < ip_conntrack_htable_size; i++)

--vkUjpNzvt17RSo84
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=f
Content-Transfer-Encoding: quoted-printable


--- a/net/ipv4/netfilter/ip_conntrack_h323.c	2005-02-08 15:33:36.000000000 =
+0100
+++ b/net/ipv4/netfilter/ip_conntrack_h323.c	2005-02-08 15:33:51.000000000 =
+0100
@@ -300,6 +300,7 @@
 {
 	/* Unregister H.225 helper */=09
 	ip_conntrack_helper_unregister(&h225);
+	ip_conntrack_helper_unregister(&h245);
 }
=20
 EXPORT_SYMBOL(ip_h323_lock);


--vkUjpNzvt17RSo84--

--1MXu+reqKPHC6GN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCCNO8XaXGVTD0i/8RApCyAJ9OI3WVEeWvNGqk59OTLBQCN9DIWQCeKZPH
EtPl/jtgVxaA7NX+iLfkeqI=
=MI2G
-----END PGP SIGNATURE-----

--1MXu+reqKPHC6GN9--
