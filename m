From: Harald Welte <laforge@netfilter.org>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Thu, 19 Aug 2004 13:35:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819113532.GO3921@sunbeam.de.gnumonks.org>
References: <1092170081.9955.12.camel@dana.go-nix.ca> <411A1F1D.7080804@trash.net> <1092436283.4792.34.camel@dana.go-nix.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6pllAmZw5nNZD8Lv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nix N. Nix" <nix@go-nix.ca>
Content-Disposition: inline
In-Reply-To: <1092436283.4792.34.camel@dana.go-nix.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6pllAmZw5nNZD8Lv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 13, 2004 at 06:31:23PM -0400, Nix N. Nix wrote:
> On Wed, 2004-08-11 at 09:29, Patrick McHardy wrote:
> > >\1DCC <command> <param> <ip> <port> [<size>]\1\n
> > >
> > >...is the format of a DCC command (where <size> is optional).
> > >
> > >dcc_parse is responsible for finding the ip and port in this string.  =
It
> > >gets the string starting at <param>.  Unfortunately, so far, dcc_parse
> > >assumed that <param> does not contain any spaces.  Thus, the module
> > >failed to track connections implied by a string of the form
> > >
> > >\1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n
> > >
> > How do filenames which contain a quotation mark look ? I assume the=20
> > quotation
> > marks is escaped ? We should also handle this case.
>=20
> It turns out that quotes are sent unescaped or otherwise encoded.  Thus,
> the transfer of a file named |The Big" Movie.avi| results in a DCC
> string of the form

Which IRC clients did you test this with?  If we put a change in
ip_conntrack_irc, we should make sure that it suports all major clients
in both linux and windows world.

> As a result, my previously proposed patch fails.  However, I have found
> what I think is another useable rationale:

Mh. I don't like this heuristics and I'd rather rewrite that portion of
the IRC parser in order to be more intelligent.  We have parsed the
command just before, so we know whether it is a SEND or CHAT or watever.

So we should make this whole quotation handlign conditional to the SEND
operation.

btw: Your patch didn't declare 'Nix'.  Did you actually try to run this?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6pllAmZw5nNZD8Lv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJCEXaXGVTD0i/8RAt5bAJ4+26U07wVWA5zXtrTFYCHUmqwFjACeJ4Ro
TlDlR8hkU+/Kj3yukpd8kFM=
=/Gvd
-----END PGP SIGNATURE-----

--6pllAmZw5nNZD8Lv--
