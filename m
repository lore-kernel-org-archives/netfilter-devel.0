From: Harald Welte <laforge@netfilter.org>
Subject: Re: PATCH: extra conntrack stats
Date: Thu, 1 May 2003 13:26:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501112613.GC26924@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0304301227530.3328-100000@blackhole.kfki.hu> <1051701556.8213.125.camel@tux.rsn.bth.se> <1051743903.8213.188.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051743903.8213.188.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2003 at 01:05:03AM +0200, Martin Josefsson wrote:

> > I'll write up a small list of things I think we should fix in conntrack.
>=20
> - Switch to using hlists for the hashtable
> - Rearrange struct ip_conntrack to be more cachefriendly if possible
> - Add prefetching in list-searching
> - Turn protocol_list into an array
> - Switch to a better hashfunction
> - Remove pointless timer-updating
> - Rework locking to be finer grained, start with per bucket spinlocks
>   (goal: RCU?)
> - Remove tcp_lock if using per bucket spinlocks, otherwise move it into
>   the entries
> - Remove pointless rehashing of tuples
> - Rework overload support (early_drop)
> - Avoid as many memory-writes as possible, no need to dirty cachelines if
>   we don't have to
> - Eliminate listhelp.h and lockhelp.h by request from hch
> - Try to shrink struct ip_conntrack

this list is too long for a change that is going to happen during 2.4.x
soon.

I would really like to see a simple patch changing the hash function
before.  This patch can be pushed to davem after a relatively short time
period of testing, since it shouldn't touch too much of the conntrack
core.


> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+sQRVXaXGVTD0i/8RAlS0AJ0fXLGQPuGyPjPXmIi/7engrjZwawCePAwo
6lIR4tDR5iRgpUwqp8Ymxs8=
=60yL
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
