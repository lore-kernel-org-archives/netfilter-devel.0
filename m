From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Sun, 7 Jan 2007 15:26:07 +0100
Message-ID: <20070107142607.GC13543@prithivi.gnumonks.org>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Cc: Vincent Deffontaines <vincent@inl.fr>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1167349247.15420.13.camel@localhost>
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


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2006 at 12:40:47AM +0100, Eric Leblond wrote:
> It will add 4*IFNAMSIZ =3D 64 octets to each nfnetlink_queue message but
> this is not impressive as a part of the packet payload is usually sent.

No, please don't do that. =20

In your application, it might not be a lot, since you always send the
packet payload.  other applications might only need a smal bit of that.

Also, I _really_ want to get rid of interface names throughout
netfilter/iptables at some point in the future.  all 'next generation'
subsystems (such as all nfnetlink based services) should just deal with
ifindexes.

all of iproute2 also uses ifindexes, and IIRC their netlink messages
also only have ifindexes.=20

Please put some functions into libnfnetlink, even if it doesn't natively
belong there.   If there's more netlink unification, we can always make
those just wrappers for the 'real new unified' ifindex/name resolving
functions.

[yes, I'm back, more or less]

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFoQL/XaXGVTD0i/8RAno9AJ40DRHDe4RRVhE90D9R62mBWJHLcACgnwzq
YMRBZe2YsKFn6cxqeAyO/DU=
=7Jsq
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
