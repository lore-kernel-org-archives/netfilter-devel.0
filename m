From: Eric Leblond <eric@inl.fr>
Subject: Re: NAT - randomize the port selection
Date: Wed, 20 Aug 2008 15:24:36 +0200
Message-ID: <20080820132435.GA6499@khasse.inl.fr>
References: <48A0497C.9060607@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Cc: netfilter-devel@vger.kernel.org
To: Pavol Rusnak <prusnak@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:37118 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYHTOC6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:02:58 -0400
Content-Disposition: inline
In-Reply-To: <48A0497C.9060607@suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday, 2008 August 11 at 16:15:24 +0200, Pavol Rusnak wrote:
> Hello!
>
> Recently there was an issue identified on DNS module about the need to =
=20
> randomize the port selection.  I'd like to know if this is already taken =
=20
> care in NAT modules in iptables? Could you please let me know if port =20
> selection is already randomized in these modules ?

Yes, an option is available since 2.6.21.

You can find some information here :
	http://software.inl.fr/trac/wiki/contribs/RandomSkype
	http://www.cipherdyne.org/blog/2008/07/mitigating-dns-cache-poisoning-atta=
cks-with-iptables.html

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkisGxMACgkQnxA7CdMWjzJ1AwCfaQ+kSzrFCjSMmhXCf9DVqAn5
95IAn3i1tjtaIWHAgKuG5iiJ/hQlh2Ap
=WbTv
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
