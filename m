From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink unique id size?
Date: Sun, 20 Feb 2005 13:28:06 +0100
Message-ID: <20050220122805.GU29256@sunbeam.de.gnumonks.org>
References: <4214D75D.5070005@ingate.com> <4218165E.1060300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaPAUYI/0vT2YKpA"
Cc: netfilter-devel@lists.netfilter.org, Marcus Sundberg <marcus@ingate.com>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4218165E.1060300@trash.net>
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


--yaPAUYI/0vT2YKpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 20, 2005 at 05:47:26AM +0100, Patrick McHardy wrote:
> Marcus Sundberg wrote:
> >Hi,
> >
> >isn't an unsigned int a bit (or rather about 32 bits) small for
> >keeping the id field of the ip_conntrack struct? It's bound to wrap
> >around, and with things like long-lived ssh sessions it's even
> >possible for two connections to be assigned the same id after a
> >wrap-around.
> >
> >Am I missing something obvious when I think ctnetlink_dump_table()
> >will break down when the wrap-around occurs?
> >
> >Using an uint64_t would on the other hand guarantee that each
> >connection really get a unique id.
>=20
> We had a long discussion about this an the result was that it has to
> be 64 bit. Search the archives if you are interested, the subject
> is "ctnetlink questions". I'm surprised too that it now is 32 bit.
> Maybe Harald knows the reason.

my guess is that nobody has ever increased it's size since that
discussion was over.

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yaPAUYI/0vT2YKpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGIJVXaXGVTD0i/8RAuVtAKCGZdzzWn7Ovysguy1MWsH7LUrgRQCdF3KT
wcn0vFZSfzhiRb1hsoowXz8=
=nezM
-----END PGP SIGNATURE-----

--yaPAUYI/0vT2YKpA--
