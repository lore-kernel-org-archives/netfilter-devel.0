From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables release
Date: Thu, 29 Nov 2007 18:46:55 +0100
Message-ID: <20071129174655.GK9579@prithivi.gnumonks.org>
References: <474C4B67.3000200@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35732 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbXK2SVJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:21:09 -0500
Content-Disposition: inline
In-Reply-To: <474C4B67.3000200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2007 at 05:52:55PM +0100, Patrick McHardy wrote:
> I have a large number of pending patches for iptables for new
> matches and targets. I'm not going apply patches for new things
> unless they are at least in a -rc kernel, so we have a chance to
> fix mistakes. So my question is whether we're ready to release
> the current iptables -rc anytime soon (before/when 2.6.24 is
> released) or whether we're more likely going to need until 2.6.25,
> in which case I would apply them now.

I have a number of manpage updates pending, unfortunately I still can't
commit to the repository (and since it includes many file renames it's
hard to just submit a patch).

I'd prefer if the release is held back until the documentation is in
sync.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHTvsOXaXGVTD0i/8RArJPAJ91morI0/66ublR22XfiYacoeUEVgCghxf2
RXxS4lRQNYgw9HABNtzLnfM=
=9WF1
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
