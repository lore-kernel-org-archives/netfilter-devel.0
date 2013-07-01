From: Eric Leblond <eric@regit.org>
Subject: Re: Issue with latest nftables
Date: Mon, 01 Jul 2013 10:22:25 +0200
Message-ID: <1372666945.421.23.camel@ice-age.regit.org>
References: <1372450120.8772.5.camel@tiger2>
	 <20130629094503.GA3805@localhost> <51D1282D.1050007@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-L4QQXU7lsEdpn2kdXTxK"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48771 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3GAIWs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:22:48 -0400
In-Reply-To: <51D1282D.1050007@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-L4QQXU7lsEdpn2kdXTxK
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 01 juillet 2013 =E0 09:56 +0300, Tomasz Bursztyka a =E9crit :
> Hi Pablo,
> >> netlink: Error: unknown expression type 'match'
> >> name=3Diprange rev=3D1
> >>
> >>
> >> netlink: Error: unknown expression type 'target'
> >> name=3DLOG rev=3D0
> >>
> >> Should this problem be trivial for someone, I let him do the job. If
> >> not, I will start to work on it.
> > We don't have support for compat from nft yet. That should be
> > relatively easy to fix.
> >
>=20
> Do we want to support those totally, or just when listing the rules? I=
=20
> would rather do the later one, nft is not meant to maintain=20
> iptables-nftables rules.
> Where were could only handle then the expression itselsf and the name of=
=20
> the match/target, but nothing more. (No blob parsing etc...)

IMHO, the minimum task here is to have examples in libnftables that are
compatible with nft and don't use compat layer. Adding compat layer to
nft is another story.

BR
--
Eric

--=-L4QQXU7lsEdpn2kdXTxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBR0TxBnxA7CdMWjzIRAucvAJ9K1EdZ8n2hdwPuGH4uuByavhgXeACfW6cR
c66sVi3GCAg25bUrX9sX2yU=
=pvF1
-----END PGP SIGNATURE-----

--=-L4QQXU7lsEdpn2kdXTxK--

