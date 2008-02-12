From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 4/5] adds AF_BRIDGE support to IP2STR
Date: Tue, 12 Feb 2008 21:28:01 +0100
Message-ID: <20080212202801.GA13507@bayen.regit.org>
References: <20080211220753.796791654@endian.com> <20080211221056.846673328@endian.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:43838 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYBLU2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:28:09 -0500
Content-Disposition: inline
In-Reply-To: <20080211221056.846673328@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

This patchset is fine but

On Monday, 2008 February 11 at 23:07:57 +0100, Peter Warasin wrote:
> This patch make the ip address string converter AF_BRIDGE
> compatible and add ip address ARP keys in order to make
> them also convert.
> +	[KEY_ARP_SPA] =3D {
> +		.type =3D ULOGD_RET_IPADDR,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "arp.saddr",
> +	},
> +	[KEY_ARP_TPA] =3D {
> +		.type =3D ULOGD_RET_IPADDR,
> +		.flags =3D ULOGD_RETF_NONE,
> +		.name =3D "arp.daddr",
> +	},

you defined here arp.daddr as ULOGD_RET_IPADDR although you've defined it in
BASE plugin as:
	[KEY_ARP_SPA] =3D {
		.type =3D ULOGD_RET_RAW,
		.flags =3D
			ULOGD_RETF_NONE,
		.name =3D
			"arp.saddr",
	},

This should work in current state code but it is only luck.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsgFRnxA7CdMWjzIRAuN0AJkB+2TozqStZXKefiF00JKkiCkBLwCfQzw6
I/QNUzFIZsZZFephtrLga5s=
=/JOQ
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
