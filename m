From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Thu, 25 Aug 2005 19:19:15 +0200
Message-ID: <1124990355.28166.31.camel@localhost.localdomain>
References: <43075517.3070405@eurodev.net> <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
	<20050825104258.GU4442@rama.de.gnumonks.org>
	<1124988859.28166.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-g2oHGgHrmZnbv8q0Ww6n"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <1124988859.28166.28.camel@localhost.localdomain>
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


--=-g2oHGgHrmZnbv8q0Ww6n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-08-25 at 18:54 +0200, Martin Josefsson wrote:

I wonder why davem got lost on the CC, he's there in my Sent folder but
not in the mail I got from netfilter-devel... I hope he makes it this
time.

> On Thu, 2005-08-25 at 12:42 +0200, Harald Welte wrote:
>=20
> > > One thing that can help is to not put pointers into these rules,
> > > that is actually the most difficult case to handle.  Without
> > > pointers, the entire struct can be defined using portable types
> > > that require no translation.  Once you introduce a pointer, using
> > > the user's struct as-is becomes impossible.  (as an added bonus
> > > such rules could thus be sent over the wire as well, if we ever
> > > wanted to do that)
> >=20
> > The only reason why a pointer is needed at all, is the "dump whole tabl=
e
> > to userspace, do some modifications and read it back" approach.  I
> > seriously doubt that we would be able to change that assumption.  If we
> > did, it wouldn't be iptables anymore, but half-way into pkttables.
> >=20
> > As an intermediate solution we could do some form of indirect
> > resolval/mapping.  The core could provide an allocation wrapper API
> > which matches/targets could use for malloc'ing their private data
> > structures.  In addition to a pointer, it would return an (32bit) ID.
> > That ID can then be embedded in kernel/userspace data structures.  When
> > userspace rules come in, the ID gets translated to the real pointer by
> > some call to that API of the core.
>=20
> Now that we have support for diffrent revisions of matches/targets we
> can easily add new revisions that uses diffrent structs and later
> deprecate the older revisions.
>=20
> Matches and targets have two sizes defined for their datastructures,
> size and userspacesize. size is the total size of the datastructure, the
> amount that is allocated for the rule private data. And userspacesize is
> the amount transferred to/from userspace when rules are modified.
>=20
> So we could put all portable members at the top of the structure and all
> pointers at the end and set userspacesize to the offset of the first
> pointer in the structure. There's no need to transfer that data back and
> forth to userspace, it just introduces races in the cases where there's
> members used for refcounting in the structure.
> So the remaining problem is that the total size of the structure is
> diffrent on 32/64 bit.
> The userspacesize stays the same on both but not the part of the
> structure that holds the "kernelprivate data", iow the last part of the
> structure, that changes on 32/64bit and I don't think we can assume that
> the size on 64bit is 2 * size on 32bit, that only holds for non portable
> types, what if someone wants a portable size in this section...
>=20
> Any ideas?
>=20
--=20
/Martin

--=-g2oHGgHrmZnbv8q0Ww6n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDDf2TWm2vlfa207ERAkHJAJwIUIkf9PBxOvU1i4VGBrKdKh5EjwCgsCDJ
kcMCHMSglRyIu0VKH+mQKJU=
=D8vJ
-----END PGP SIGNATURE-----

--=-g2oHGgHrmZnbv8q0Ww6n--
