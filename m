From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD 1/4] rework NFCT to use a generic hashtable [was Re:
	[ULOGD  1/4]  improve netlink overrun handling of NFCT]
Date: Thu, 15 May 2008 22:24:59 +0200
Message-ID: <20080515202458.GA22245@bayen.regit.org>
References: <482C3E63.80006@netfilter.org> <482C3F36.4050907@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:35742 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763250AbYEOUZp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:45 -0400
Content-Disposition: inline
In-Reply-To: <482C3F36.4050907@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 15 at 15:48:38 +0200, Pablo Neira Ayuso wrote:
> Sorry, wrong description + patch. Let's start again.
>=20
> [PATCH] rework NFCT to use a generic hashtable
>=20
> This patch introduces a generic hashtable to store the nf_conntrack
> objects. The objects are identified by the original and reply tuples
> instead of the conntrack ID which is not dumped in the event message of
> linux kernel < 2.6.25. This patch also fixes the NFCT_MSG_* by NFCT_T_*
> which is the appropriate
> message type tag.

It seems two header files are missing. Here's the make output:

ulogd_inpflow_NFCT.c:39:25: error: ulogd/jhash.h: No such file or
directory
In file included from ulogd_inpflow_NFCT.c:40:
=2E./../include/ulogd/hash.h:5:19: error: slist.h: No such file or
directory
In file included from ulogd_inpflow_NFCT.c:40:

>  #include <time.h>
>  #include <ulogd/linuxlist.h>
> +#include <ulogd/jhash.h>
> +#include <ulogd/hash.h>
> =20

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILJwanxA7CdMWjzIRAl9HAJ0Rmsx41woWI2S1NC7GMn4NfvlvtgCeNo+O
nyLHigckg/wK0HRxuZoUuMo=
=rzm6
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
