From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Sat, 11 Jan 2003 20:23:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030111192315.GE24488@naboo.de.gnumonks.org>
References: <3E1D7419.1060502@fugmann.dhs.org> <20030110140024.GU1353@sunbeam.de.gnumonks.org> <3E1EE68C.7030004@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1EE68C.7030004@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2003 at 04:28:12PM +0100, Anders Fugmann wrote:

> >Apart from that, everything in patch-o-matic are new features or
> >extensions, which are either not fully stable or we strongly doubt that
> >they are useful for the big public.  And if somebody wants to test one
> >of those non-standard extensions, we can ask people to use patch-o-matic.
>
> Yes. I'm aware of that. My question is "How can a patch be proven stable=
=20
> enough to be included, and is the functionality provided 'importent'=20
> enough for the general public?

Well, It's hard to give a set of rules for this.  Mainly it reduces to
the case that I (or somebody else of the coreteam) has the personal
feeling that the code is OK and the functionality is important enough.

This sounds a bit like dictatorship, but our impression of what is
'important' is not a fixed one.  We judge by the practical cases we know
of, and by what users tell us.  So if there is a discussion about a
particular patch [or feature] on the list, and we see there is a big
demand by the users, we are likely to be inclined that this feature is
'needed'.  This has just happeed with the 'string' match, which I
personally dislike, but I am now convinced that there is a reasonable
demand for that particular function [and which will now be submitted to
the kernel anytime soon].

It's not different than in other subsystems of the kernel.  If you want
a feature to get into the core network stack, you need to write good
code and convince Alexey, DaveM and/or Andi Kleen that it is needed ;)

btw: having a bit-wise mark match and MARK target has always been one of
my favourites.  So if we can solve the compatibility issue, the patch
will certainly make it ;)

> Regards
> Anders Fugmann

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+IG8jXaXGVTD0i/8RArBLAJ4j7SlWmbSaURYKCoL2GVApQv7k6QCdHzxa
8T1U5UtRf3yaI/WNV2FfBdI=
=rGeC
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
