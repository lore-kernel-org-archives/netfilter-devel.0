From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 4
Date: Sat, 12 Nov 2005 11:12:53 +0100
Message-ID: <20051112101253.GB10584@sunbeam.de.gnumonks.org>
References: <20051103191110.GO905@sunbeam.de.gnumonks.org>
	<200511071710.56991.mbellion@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jEihaNHb65WmIJG"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Bellion <mbellion@hipac.org>
Content-Disposition: inline
In-Reply-To: <200511071710.56991.mbellion@hipac.org>
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


--8jEihaNHb65WmIJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2005 at 05:10:56PM +0100, Michael Bellion wrote:
> Hi
>=20
> > This is the fourth incarnation of the x_tables patch.  It is now
> > compiling clean, and at least those parts that I use in my systems seem
> > to work fine.
> >
> > I want to run this trough nfsim before submitting it mainline.
> >
> > I dislike the 'void *' pointers we cast for match/targetinfo, but I
> > think the advantage of code unification is bigger than some typecasts.
> >
> > Also, we should think about putting all those match/checkentry/target
> > parameters into a structure (which could contain unions to avoid the
> > typeasting).  But I think this can happen in a next patch, x_tables
> > changes are already large enough.
> >
> > Please review and comment,
>=20
> Nice work!

Thanks ;)

> But could you rename it to something without "tables"?
> It is not related to tables in any way. It is about function based matche=
s and=20
> targets, that's why the name "x_tables" is IMHO a bit irritating.

Well, there are pieces of the patch that are related to 'tables' (like
the xt_register_table(), etc. functions).

So as this first step, I really only wanted to unify
{ip,ip6,arp}_tables.  This is not yet the generalized match/target
support.

As a second step, I want to cleanup the API for matches/targets, and
also introduce the tlv-to-matchinfo and matchinfo-to-tlv members of
xt_match / xt_target.  Also, the 'verdict' that is returned by targets
needs to be removed [for multiple targets], but in a way they=20

Maybe ew could just call them 'XTended match' and 'XTended target' at
that point, this way we could keep with the xt_ prefix.  What do you
think?

> What about the name "x_functions" or something similar?

Good question.  If we can come up with a good (intuitive) name over the
next two weeks, I can still change it.=20

To be honest, I don't think 'x_functions' is more intuitive.   Whatever
name we  will find, it won't be ideal.  the 'x' was just to replace
'ip/ip6/arp'. =20

If we say 'nf match' and 'nf action', then we end up with nfm and nfa
prefixes in structure and functio names, both of which are already used
by nfnetlink (NFM_, NFA_), which could be confusing.

packet matches and packet actions would be another option, but 'packet
actions' are already used by TC/iproute, if i'm not mistaken.

Comments/Suggestions?
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8jEihaNHb65WmIJG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdcAlXaXGVTD0i/8RAuwCAKCkEiwtVTtAyhR6CotoliWvRubn5wCgrQq9
xpMZKAbhGiCvkCWHTGSS03s=
=uJi+
-----END PGP SIGNATURE-----

--8jEihaNHb65WmIJG--
