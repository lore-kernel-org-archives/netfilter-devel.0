From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: iptables: build fixes
Date: Wed, 6 Mar 2013 04:08:33 +0400
Message-ID: <20130306000833.GA30360@altlinux.org>
References: <1357830919-10367-1-git-send-email-jengelh@inai.de> <20130112024915.GA22315@altlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Cc: pablo@netfilter.org, Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:55516 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3CFAIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:08:35 -0500
Content-Disposition: inline
In-Reply-To: <20130112024915.GA22315@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 12, 2013 at 06:49:15AM +0400, Dmitry V. Levin wrote:
> On Thu, Jan 10, 2013 at 04:15:17PM +0100, Jan Engelhardt wrote:
> [...]
> > Jan Engelhardt (2):
> >       build: also use libtool for install stage
> >       build: do not dereference symlinks on installation
> >=20
> >  extensions/GNUmakefile.in |   21 +++++++++++++++------
> >  1 file changed, 15 insertions(+), 6 deletions(-)
>=20
> Acked-by: Dmitry V. Levin <ldv@altlinux.org>

Any idea why these fixed didn't get into 1.4.18?


--=20
ldv

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE2iQEACgkQfKvmrJ41Nh7bfQCdFexmf5NPXf9FFFEL5owv9HNI
emwAn34jsKTYpv3R92WILX1Lr1CjDw44
=G2r0
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
