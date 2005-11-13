From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] fix leak of fragment queue at unloading
	nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 13:56:27 +0100
Message-ID: <20051113125627.GM17476@sunbeam.de.gnumonks.org>
References: <200511130850.jAD8ohfY012005@toshiba.co.jp>
	<20051113100837.GG17476@sunbeam.de.gnumonks.org>
	<200511131238.jADCcbHR017662@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511131238.jADCcbHR017662@toshiba.co.jp>
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


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 09:38:36PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> From: Harald Welte <laforge@netfilter.org>
> Date: Sun, 13 Nov 2005 11:08:37 +0100
>=20
> > On Sun, Nov 13, 2005 at 05:50:42PM +0900, Yasuyuki KOZAKAI wrote:
> > >=20
> > > This makes nf_conntrack_ipv6 free all IPv6 fragment queues at unloadi=
ng.
> > > This also check inconsistency between memory tracking and actual usage
> > > to avoid endless loop at eviction.
> >=20
> > I'm fine with this, but:
> >=20
> > >  		tmp =3D nf_ct_frag6_lru_list.next;
> > > +		if (tmp =3D=3D NULL) {
> > > +			if (net_ratelimit())
> > > +				printk(KERN_ERR
> > > +				       "nf_ct_reasm: no queue to be evicted");
> > > +			return;
> > > +		}
> >=20
> > Why is it an error if we don't have a defrag queue at unloading time?
> > Isn't it possible that we never process any fragments (or finished
> > processing of all fragments some time ago) and thus have an empty queue?
>=20
> Sorry for short explanation. This function may be called when memory usage
> exceeds threshold. And I just want to be noticed existence of bug
> in memory tracking and avoid NULL pointer access.

ok, in this case I think the error message should be more verbose.

> > Please comment.
>=20
> Is it overly cautions to avoid NULL pointer access in this case ?

I'd have to study the code in more detail.  It depends on the question:
Under which circumstances can we have a NULL pointer?

> Indeed we can notice bug early if we doesn't introduce this check.

Please explain.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdzf7XaXGVTD0i/8RAg2eAJ9TV3UnFuxFPfv3AT2PpUtfBQLQZACffPK9
pYzUGem5wpUZCN5XJ7HAxng=
=mWOd
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
