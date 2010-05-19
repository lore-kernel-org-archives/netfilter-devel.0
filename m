From: Eric Leblond <eric@inl.fr>
Subject: Re: libnetfilter_queue question
Date: Wed, 19 May 2010 22:10:48 +0200
Message-ID: <1274299848.21477.6.camel@ice-age>
References: <4BF3BA47.7040109@inliniac.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qQ7XbT2jLOikIihhCZwB"
Cc: netfilter-devel@vger.kernel.org
To: Victor Julien <lists@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:52789 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0ESULC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 May 2010 16:11:02 -0400
In-Reply-To: <4BF3BA47.7040109@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-qQ7XbT2jLOikIihhCZwB
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Victor,

Le mercredi 19 mai 2010 =E0 12:15 +0200, Victor Julien a =E9crit :
> Hi all,
>=20
> I'm using libnetfilter_queue for inline mode in the Suricata IDS/IPS
> (www.openinfosecfoundation.org). I'm using a callback that makes the
> packet(s) available to the detection engine. In some special cases the
> call back could fail (only malloc failure atm).
>=20
> I was wondering what the proper response would be to such an event. I'm
> assuming nfq_handle_packet() would return an (non zero) error code in
> that case.
>=20
> Should I verdict the packet? (drop to be safe)

Yes, clearly ! If you don't do this the packet will get stuck inside the
kernel and nothing will released it (and free associated structures).

The only other mean to free queued packet is to unregister from the NF
queue.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-qQ7XbT2jLOikIihhCZwB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD4DBQBL9EXFnxA7CdMWjzIRAp0TAJjadlwFa9Y2v4f49HSwUdgyI696AJ4088eW
Zayrm052fb+1j+OcRShl5g==
=+4w7
-----END PGP SIGNATURE-----

--=-qQ7XbT2jLOikIihhCZwB--

