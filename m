From: Harald Welte <laforge@netfilter.org>
Subject: Re: Rule optimization scheme openbsd-like
Date: Tue, 14 Oct 2003 13:23:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031014112305.GD3752@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2003 at 10:25:00AM +0200, Maciej Soltysiak wrote:
> Hi,
>=20
> someone on LKML writing in 'thoughts for 2.7' about netfilter development,
> handed me a fistful of links related to openbsd's pf.
>=20
> Out of them I only read one document so far:
> http://www.benzedrine.cx/pf-paper.html
>=20
> This document explains some pf's features, one of them is:

Please read the proceedings of the netfilter workshop (can be found in
the documentation directory of the CVS tree).

> 2.8. Transparent rule set evaluation optimization

Iptables (or pkttables as its successor) will stay a linked list with no
optimizations.  If you need an optimized ruleset, you will use nf-hipac
- which will be most likely using the same userspace configuration tool.

> What do you think? Is anyone working on this

no, I think it is just a waste of time.  If you are interested in high
performance, especially with medium to large sized rulesets, nf-hipac is
the way to go.

> It might be a good rule writing technique to add to the HOWTO or to write
> a HOWTO on rule writing technique.

yes, that was something I always wanted to do but never got around
doing.  Actually I started it once, but didn't get very far.

When I'm back home next weekend, I'll see if I can find that old piece
of document and send it to you.

> Regards,
> Maciej

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/i9yZXaXGVTD0i/8RAoXYAJwNmmpibyMHUdKFeyeavfr81MyHCQCgk68j
wJJDTwkhFlowi7V0ttOda74=
=I22C
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
