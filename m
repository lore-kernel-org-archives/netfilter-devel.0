From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] NAT tuple reservation
Date: Tue, 18 Nov 2003 17:57:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118165734.GP5075@sunbeam.de.gnumonks.org>
References: <3FB8DF90.5090505@balabit.hu> <20031117222933.GE5075@sunbeam.de.gnumonks.org> <3FB9CE8E.4000105@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oxV4ZoPwBLqAyY+a"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <3FB9CE8E.4000105@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oxV4ZoPwBLqAyY+a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2003 at 08:47:26AM +0100, KOVACS Krisztian wrote:
> >However, I fear this would add considerable overhead.  Yet another hash
> >table... however, most of the time this table would be empty, or almost
> >empty.  So let's rather optimize on the speed of the hash function than
> >on the hash distribution in that case.
>=20
>   The empty case could be made fast using a reservation-counter.

that sounds like a good plan.

> >> /* reference count */
> >> atomic_t use;
> >
> >do we really need to do sophisticated reference counting on those
> >objects?  I think it is enough to protect the whole hash table under the
> >already existing nat lock.  Entries are inserted/deleted under that lock=
,=20
> >and
> >hash table lookups also only happen under that lock.   The only
> >reference would be a pointer from a single ip_conntrack_expect - thus
> >the refcount would always be one.

you didn't comment on that.  What do you think?

> >> Do you see any shortcomings/problems with this?
> >
> >It doesn't cover allocation/reservation of contiguous port numbers,
> >which especially RTP/RTSP require.=20
>=20
>   It could be extended, however, it would make checking/allocating even=
=20
> more slow...=20

I don't care about allocation speed, as it is a rare thing to happen
(compared to the total number of packets we see).  However, checking
should be fast.

> If you could register ranges, for example, how do you define=20
> the hash function? Or, for example, you should be able to delete parts of=
=20
> that range from the reserved list, so that splitting the original range=
=20
> could be necessary...=20

I know, it's not a trivial issue.  It's ugly.  And I don't think that
you could ever put ranges in the hashtable.  However, you could provide
a high-layer function that=20

- locks the htable
- tries to allocate as many reservations as there are in the range,
  contiguously
- unlocks the htable

In normal cases, we would only have 2 or 4 (maybe 8) consecutive port
numbers to allocate.  So it is feasible to put each of them into the
hash.  This would not give a slowdown at checking / lookup time.

> Cannot problems like these solved by allowing more=20
> than one reservation per expectation to be registered?

The problem is, that then there is no atomicity.  They really need to be
consecutive. =20

So from the implementation point of view: yes, they are multiple
seperate reservations.  But from an API point of view, it should be a
single call.

> --=20
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

--oxV4ZoPwBLqAyY+a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uk9+XaXGVTD0i/8RArcLAJ9F7HA4aEcS1PbPVM3D4B4WM1Uc5wCfXQ/4
txfZDl3KEL0FLPJjqCDvQ/c=
=ekN+
-----END PGP SIGNATURE-----

--oxV4ZoPwBLqAyY+a--
