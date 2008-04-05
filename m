From: Eric Leblond <eric@inl.fr>
Subject: Re: [Resend ULOGD PATCH] Add event output and make event mask
	configurable  in NFCT.
Date: Sat, 5 Apr 2008 12:21:37 +0200
Message-ID: <20080405102137.GC5333@bayen.regit.org>
References: <47E99B88.9090200@netfilter.org> <12064930002868-git-send-email-eric@inl.fr> <47EA188B.4090807@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:48402 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbYDEKV4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 06:21:56 -0400
Content-Disposition: inline
In-Reply-To: <47EA188B.4090807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wednesday, 2008 March 26 at 10:34:03 +0100, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> >=20
> > Here's the modification following your recommandation. That's better li=
ke that :)
>=20
> Applied. Thanks. Eric, please refresh your tree against SVN to make sure
> that patches apply cleanly. I'll keep iterating over the remaining
> patches along today.

I've tested and applied all my not applied ulogd2 patches other current
subversion tree. They apply cleanly. I've published a git tree which
contains this patches.

Git tree: http://home.regit.org/~regit/git/ulogd2.git
Gitweb: http://home.regit.org/cgi-bin/gitweb.cgi?p=3Dulogd2.git;a=3Dshortlo=
g;h=3DML

The ML branch is the one containing all the patches.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH91KxnxA7CdMWjzIRAuKBAJ964uNI3JD38+ARao2+d2+W1rmDQQCfSw4E
XSSVqz7a0oUXLvjG41n7Zlk=
=jU13
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
