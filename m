From: Harald Welte <laforge@gnumonks.org>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Sat, 12 Oct 2002 16:34:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012163410.B13233@sunbeam.de.gnumonks.org>
References: <1034286048.25146.40.camel@tux> <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu> <20021012141737.X13233@sunbeam.de.gnumonks.org> <1034428150.7595.36.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="saqwZB8dd8xoGD4q"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1034428150.7595.36.camel@tux>; from gandalf@wlug.westbo.se on Sat, Oct 12, 2002 at 03:09:10PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--saqwZB8dd8xoGD4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2002 at 03:09:10PM +0200, Martin Josefsson wrote:

> > > > ip_conntrack_change_expect
> > > > 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> > > > 	LIST_FIND
> > > >
> > > > 	FAILS!! called from nat-helpers which only hold their own locks
> > > > 	if any at all.
> >=20
> > No.  The helper's help functions are called from do_bindings, which grab
> > a readlock on ip_conntrack_lock before traversing the list of expectati=
ons
> > matching this packet.  See also my comment above.
>=20
> Ahh I missed this, the helper is called after exp_for_packet which has
> already screwed up the lock-debug.
>=20
> But we'll need to hold at least a read-lock on the tuple_lock during
> that LIST_FIND since we only have a read-lock on ip_conntrack_lock.
> and we modify tupe/mask inside this read-locked ip_conntrack_lock but
> within a write-lock'd tuple_lock. And since we'll probably need to take
> that write-lock anyway we might just as well take it from the beginning.

this is correct, we should grab a write-tuple-lock around the whole block,
just as your patch did.  Could you prepare (and test) a patch which does
only this (and the ip_ct_find_proto() change?).

> So the lockingrules comes down to this if I've understood things
> correctly:
>=20
> 1. All accesses to the expect-list are to be performed with
> ip_conntrack_lock held.
>=20
> 2. All list-structure changes are done under a write-locked
> ip_conntrack_lock and tuple_lock is not needed.
>=20
> 3. All other accesses are performed under at least a read-locked
> ip_conntrack_lock.
>=20
> 4. All read-accesses to tuple/mask data inside the list are performed
> under at least a read-locked tuple_lock.
>=20
> 5. All write-accesses to tuple/mask data inside the list are performed
> under a write-locked tuple_lock.
>=20
> Does that sound ok to you?

sounds correct.

> /Martin

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--saqwZB8dd8xoGD4q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qDLiXaXGVTD0i/8RAhy6AJ9DyvtXwBfn8qLu2tdqCEAsOJ+nZQCfW13S
Kx9vB0lLEgEoVRdjb+nRUYU=
=IegV
-----END PGP SIGNATURE-----

--saqwZB8dd8xoGD4q--
