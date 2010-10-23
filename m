From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2] UNIXSOCK plugin (v5b)
Date: Sat, 23 Oct 2010 11:54:29 +0200
Message-ID: <1287827669.4463.0.camel@ice-age>
References: <1287575092-454-1-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a1qXQbXwhkzlpKxwmoal"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:59833 "EHLO sd-6807"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755360Ab0JZOue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:50:34 -0400
Received: from fydelkass.inl.fr ([88.171.131.12] helo=fydelkass.edenwall.com)
	by sd-6807 with esmtp (Exim 4.69)
	(envelope-from <eric@inl.fr>)
	id 1PAjBI-0005fh-BN
	for netfilter-devel@vger.kernel.org; Tue, 26 Oct 2010 15:03:12 +0200
In-Reply-To: <1287575092-454-1-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-a1qXQbXwhkzlpKxwmoal
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 20 octobre 2010 =E0 13:44 +0200, Pierre Chifflier a =E9crit :
> Hi,
>=20
> First of all, sorry for the long time with no updates on this patch.
> This is a resend of the patches for the UNIXSOCK input plugin for ulogd2.
>=20
> Please let me know if there are any issues.

Patches pushed to the git tree.

BR,

>=20
> PS: hope you enjoyed the oowall presentation :)
>=20
>=20
>=20
> Changes for v5:
> - align all structures on 64 bits instead of 32
>   This has been tested on a sparc64 (thanks to Jan)
> - update pcap2ulog to handle different pcap formats
>=20
> Changes for v4:
> - use structures instead of reading integers directly
> - all structures and fields are now aligned (4 bytes)
> - update pcap2ulog script to use aligned data as well
>=20
> Changes for v3:
> - if the bufsize value (from conf) is 0, try to guess the buffer size
>   using getsockopt(SOL_SOCKET, SO_RCVBUF ..)
> - set default path to /var/run/ulogd/ulogd2.sock with mode 0600
> - add new configuration options perms, owner and group to be able
>   to set these parameters on the created socket
> - change the input algorithm to make it more robust against junk data (wh=
ich
>   can happen if the client is desynchronized)
> - fixed a few bugs
>=20
> Description:
>=20
> [1] add new input plugin UNISOCK, using a unix socket. This allows usersp=
ace
> applications to send packets to ulogd, for example to send packets offlin=
e.
> It uses a key-length-value protocol to handle optional fields or extensio=
ns.
>=20
> [2] is a Perl script to load a PCAP file and send it to ulogd using the
> UNIXSOCK plugin.
>=20
> Pierre

--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-a1qXQbXwhkzlpKxwmoal
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMwrDRnxA7CdMWjzIRAhx4AKCHhQTmukqXWtht8FTGe8SNsLzMKwCfUC3+
J/uKfC3M92nNyCtoCY9x4wU=
=1ZeH
-----END PGP SIGNATURE-----

--=-a1qXQbXwhkzlpKxwmoal--

