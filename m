From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_hashlimit.c: avoid data corruption on checkentry
Date: Tue, 15 Feb 2005 01:52:55 +0100
Message-ID: <20050215005255.GS3829@sunbeam.de.gnumonks.org>
References: <42005218.5000401@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nG9yj4eE4W6Oba0"
Cc: netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
Content-Disposition: inline
In-Reply-To: <42005218.5000401@cookinglinux.org>
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


--+nG9yj4eE4W6Oba0
Content-Type: multipart/mixed; boundary="20XocjIeMTCm4X0r"
Content-Disposition: inline


--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 01, 2005 at 11:07:52PM -0500, Samuel Jean wrote:
=20
> While processing checkentry(), we first get a lock, search for entry
> and drop the lock. If we found the object, that's fine.
> However, in the other case, we start creating the object, get a lock,
> add the object and then release the lock. By this time, one could
> already failed to find the same object and start creating it too.
> This could lead to data corruption.

Thanks for pointing it out, I was under the (wrong) impression that
checkentry() (called via translate_table()) was already synchronized by
ipt_mutex.

Please consider / comment the following (untested) patch.

Not really sure whether nesting the rwlock inside the mutex is that much
of a good idea... but as the comment indicates, I think it's the best we
can get.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="linux-2.6.11-rc4-hashlimit_checkentry_race.patch"
Content-Transfer-Encoding: quoted-printable

--- c/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-13 13:52:06.000000000 +0100
+++ d/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-15 01:49:39.086401888 +0100
@@ -98,6 +98,7 @@
 };
=20
 static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
+static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
=20
@@ -531,10 +532,19 @@
 	if (!r->cfg.expire)
 		return 0;
=20
+	/* This is the best we've got: We cannot release and re-grab lock,
+	 * since checkentry() is called before ip_tables.c grabs ipt_mutex. =20
+	 * We also cannot grab the hashtable spinlock, since htable_create will=
=20
+	 * call vmalloc, and that can sleep.  And we cannot just re-search
+	 * the list of htable's in htable_create(), since then we would
+	 * create duplicate proc files. -HW */
+	down(&hlimit_mutex);
 	r->hinfo =3D htable_find_get(r->name);
 	if (!r->hinfo && (htable_create(r) !=3D 0)) {
+		up(&hlimit_mutex);
 		return 0;
 	}
+	up(&hlimit_mutex);
=20
 	/* Ugly hack: For SMP, we only want to use one set */
 	r->u.master =3D r;

--20XocjIeMTCm4X0r--

--+nG9yj4eE4W6Oba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCEUfnXaXGVTD0i/8RAqefAKCqcTRLCV6y9HXM6PqXqq4kslHO+ACghKiF
JgHvq4kZ1KMLhGr1e7wvPfc=
=iDeg
-----END PGP SIGNATURE-----

--+nG9yj4eE4W6Oba0--
