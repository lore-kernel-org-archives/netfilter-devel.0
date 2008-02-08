From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 1/3] Do not set oob.family in config as it can be
	found in packet.
Date: Fri, 8 Feb 2008 19:59:39 +0100
Message-ID: <20080208185939.GH29163@bayen.regit.org>
References: <12023725412-git-send-email-eric@inl.fr> <1202372541106-git-send-email-eric@inl.fr> <47AC961A.3090204@endian.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52742 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146AbYBHS7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:59:44 -0500
Content-Disposition: inline
In-Reply-To: <47AC961A.3090204@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Friday, 2008 February  8 at 18:49:14 +0100, Peter Warasin wrote:
> Hi Eric
>=20
> Eric Leblond wrote:
>=20
> That field is necessary if NFLOG logging should also work from within
> ebtables (I sent ebtables patches recently).
> Sending from ebtables oob.family is AF_BRIDGE, since there could also
> come arp packets to be logged.

Thanks for pointing this.

> Configuring the addressfamily manually within the configuration file
> is how you then register the log handler for AF_BRIDGE. It is not
> always necessary to have that handler registered, so it's good
> practice to decide this by configuration file, i think.
>=20
> What you say?

The main motivation of this patch was to get around the problem of being
force to declare one loggers for IPv4 and one for IPv6. Adding AF_BRIDGE
into account, make me ask to forget about this patch.

I will put focus on this when documentating the issue in the configuration
file.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHrKabnxA7CdMWjzIRAgzpAJsGtetnmP9O9aiw9S5Q9SNkjjLJlQCeMBRk
vuIXanje09Qbe+8hTd2RhBY=
=vi/D
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
