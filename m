From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Tue, 11 Oct 2005 16:38:13 +0200
Message-ID: <20051011143813.GE4756@rama.de.gnumonks.org>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<200510071227.j97CRrgx027931@toshiba.co.jp>
	<1128979368.8218.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1128979368.8218.8.camel@localhost.localdomain>
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


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 07:22:48AM +1000, Rusty Russell wrote:
> On Fri, 2005-10-07 at 21:27 +0900, Yasuyuki KOZAKAI wrote:
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > Date: Thu, 06 Oct 2005 04:23:03 +1000
> >=20
> > > +static u_int32_t
> > > +hash_conntrack(const struct ip_conntrack_tuple *tuple)
> > > +{
> > > +	return __hash_conntrack(tuple, ip_conntrack_htable_size);
> > >  }
> >=20
> > Why don't we use inline ?
>=20
> Just checking you were reading.  Well done, Yasuyuki!

I also noticed the missing inline when merging your patch, but I thought
maybe gcc will do it automatically.

> We should use "u32", too, not those types I made the mistake of using
> when I was young and foolish.

I'm still young and foolish, so all my code uses the u_intXX_t... and I
ask myself why we shouldn't use the posix types?  I'm still puzzled...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS85VXaXGVTD0i/8RAlvzAJ0ZEK8T83jhuvQ9U+W6rpQGL00uOgCfbYN8
vth/dROcR1X990876FZ1gKg=
=An7Z
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
