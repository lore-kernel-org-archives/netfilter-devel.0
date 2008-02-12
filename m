From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 4/5] adds AF_BRIDGE support to IP2STR
Date: Tue, 12 Feb 2008 22:15:40 +0100
Message-ID: <20080212211538.GB13507@bayen.regit.org>
References: <20080211220753.796791654@endian.com> <20080211221056.846673328@endian.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:56403 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763706AbYBLVPm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:15:42 -0500
Content-Disposition: inline
In-Reply-To: <20080211221056.846673328@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday, 2008 February 11 at 23:07:57 +0100, Peter Warasin wrote:
> This patch make the ip address string converter AF_BRIDGE
> compatible and add ip address ARP keys in order to make
> them also convert.

There is a problem with this patch. It uses oob_protocol to find which
output has to be done. Thus, oob_protocol has to be defined and this is
not the case for OUTPUT packet.

So, this patch breaks IP display for OUTPUT packet. It could be fixed by
using a combination of oob_family and oob_protocol.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsgx6nxA7CdMWjzIRAvhLAKCG89iC3GcT/kpD9EdD4hpyQII/SwCbBBH0
syyFLDJwDPz3Y4cTJu5UW3g=
=mjGs
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
