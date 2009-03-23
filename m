From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Mon, 23 Mar 2009 23:05:53 +0100
Message-ID: <1237845953.4786.47.camel@ice-age>
References: <1691181420.20090323214823@yandex.ru>
	 <49C7E095.9020002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ykE1oORQTQ0qDJUhUzii"
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:58124 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZCWWGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:06:11 -0400
In-Reply-To: <49C7E095.9020002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ykE1oORQTQ0qDJUhUzii
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 23 mars 2009 =E0 20:18 +0100, Patrick McHardy a =E9crit :
> Kuzin Andrey wrote:
> > This is patch for problem with stucked packets in nf_queue if
> > something going wrong in userspace program. Automatically drop packets
> > without any verdict after timeout defined by NFQNL_TIMEOUT_ENTRY_DROP.
>=20
> There's a very easy and cheap way to handle this. The packets have
> sequence numbers and userspace should issues verdicts in ascending
> order anyways to avoid reordering. Just add something that will drop
> everything in the queue up to the sequence number contained in the
> netlink message.

I don't think the described mechanism is generic enough to be a default
behaviour. It should be useful for projects like snort-inline but it
will really a problem for software like NuFW which are asynchronous by
design.

In NuFW, packet authentication is triggered by a user message (signing
of packet is done is userspace). Thus the ordering of the answer depends
of the ordering of user messages. As NuFW authenticate packet at network
scale (there is thus plenty of users), it is not possible to assume that
the answer will be ordered.

Thus, even if it could be useful, this mechanism should only be
activated by an explicit userspace query.=20

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-ykE1oORQTQ0qDJUhUzii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJyAe9nxA7CdMWjzIRAnraAJ40571UpZm14GfFZmXnVHVt1hWEzwCff4oS
Djci/EOIC1gX8R7ipk8i8rU=
=P6JJ
-----END PGP SIGNATURE-----

--=-ykE1oORQTQ0qDJUhUzii--

