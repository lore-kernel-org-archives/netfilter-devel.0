From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] NAT tuple reservation
Date: Mon, 17 Nov 2003 23:29:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031117222933.GE5075@sunbeam.de.gnumonks.org>
References: <3FB8DF90.5090505@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <3FB8DF90.5090505@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2003 at 03:47:44PM +0100, KOVACS Krisztian wrote:
>   So, some kind of tuple reservation was really needed to be able to=20
> solve these problems. The reservation facility would provide a way to=20
> reserve a "half-tuple" (manip), which wouldn't be allocated by the NAT=20
> facility when a unique tuple is searched. When the registrator of the=20
> reserved tuple would like to use it, it would use a special function,=20
> which calls ip_nat_setup_info() with a special flag, and after applying=
=20
> the mapping succeeded, removes the reservation. The reservation would be=
=20
> per-expectation, ip_conntrack_expect would store a reference to the=20
> reservation, and when the expectation is deleted all related reservations=
=20
> are deleted, too.

Yes, we all agree that we need some kind of mechanism for that.

>   The allocation routines in ip_nat_core.c should be extended to check if=
=20
> a tuple is reserved. ip_nat_used_tuple() would be extended to check if th=
e=20
> given tuple uses an already reserved manip. The reserved manips would be=
=20
> stored in a hash table, hashed based on the manip structure. The stored=
=20
> structures would look something like this:

However, I fear this would add considerable overhead.  Yet another hash
table... however, most of the time this table would be empty, or almost
empty.  So let's rather optimize on the speed of the hash function than
on the hash distribution in that case.

> struct ip_nat_reserved {
>   /* hash chain */
>   list_head prev, next;

you only need one list head for the hash table ;)

>   /* reference count */
>   atomic_t use;

do we really need to do sophisticated reference counting on those
objects?  I think it is enough to protect the whole hash table under the
already existing nat lock.  Entries are inserted/deleted under that lock, a=
nd
hash table lookups also only happen under that lock.   The only
reference would be a pointer from a single ip_conntrack_expect - thus
the refcount would always be one.

> ip_nat_setup_info_reserved(...): This is basically the same as=20
> ip_nat_setup_info, except that it calls ip_nat_setup_info() with the=20
> appropriate flag, and deletes the reservation in case of successful=20
> allocation.
>=20
>   Do you see any shortcomings/problems with this?

It doesn't cover allocation/reservation of contiguous port numbers,
which especially RTP/RTSP require.=20

>   Regards,
>     Krisztian KOVACS

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uUvNXaXGVTD0i/8RAjpYAJ9+js1BCdrSyTnk90sFk/aX509eNACgkJPn
7f+Blfpl/YiNJ5h/2q2g40g=
=QFVX
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--
