From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] libipset: Add missing ipset_parse_uint16 to map file
Date: Fri, 24 Oct 2014 16:43:54 +0700
Message-ID: <20141024094354.GA5961@nitrogen.neutroncom.local>
References: <20141017040644.GA27263@nitrogen.neutroncom.local>
 <alpine.DEB.2.10.1410222140390.8153@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48157 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaJXJn7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:43:59 -0400
Received: by mail-pa0-f43.google.com with SMTP id eu11so847644pac.16
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 02:43:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410222140390.8153@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 09:44:45PM +0200, Jozsef Kadlecsik wrote:
> On Fri, 17 Oct 2014, Neutron Soutmun wrote:
> Yes, that's missing from the map file. However, please advance the API=20
> curr and age in Make_global.am and add a new section to libipset.map=20
> instead of inserting the symbol as above. Better not change the library=
=20
> silently...

The new proposed patch is posted at
http://marc.info/?l=3Dnetfilter-devel&m=3D141414339032035&w=3D2

Please review again.

Best regards,
Neutron Soutmun

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUSh9aAAoJEJ0EcL2mzcRXIOoP/0xFd+X6LPjfYOwvzh7c+5MD
04UQXqlrYp9KvVndxuI3T5GrQpnTfNTNr3UQwXaWXwvH8yN6b0VstJw07hXo/esn
iQzSS/tFKpcOOC0GHbh106nqbSfEfG2DuvcwMfsLHjDsOwdRLWEZDbDFiaB6SaYw
tPyIo4+jDnCdKkG7NuoYe3smkLF3huVkUSfeh5GvaZKiOcgbcpHWvl035WMndzw5
2wmggZQN6WjKTF6Sv4c8NSXkyGqWpwFtQxRY6UQdqoQfbYGeODkJyStkY52wRiNO
ft+sXT5VKFrFHZB+tfexzrDUD6fMv3FW4Mf5e5+1mQyQz/ZXuyfZsQ1zYmlOQpxy
iOmYsaf31zniFpJjK4gQuTz1UGjp/mW2mw2C1XToDBzksnlQZuC2TAgWhgxITOS0
RXULpy/PYzEq9folGnwpm2WN8wgFZAOLkAz08PWKib/FCLqDkTwMhsbre3izbgH0
1X4OPlwEKrXOWS+lQEt6dnLSugqEiuf4oW6WPwklZ0PFMOqyuwwpwVuT6ZTWcHKB
4ozVyOrRq69nTp7bQCEt9CLXgyF4fHwTX3oG88fEftk/YKIwW0u5P+jqexW9zcEZ
PQL7OC3jS1fv0fIsSIU9+igLLdy5qtSTH89IgxNwNx+XuD95tmEIYev4FjtXlp5e
UYVsx7y6TgeWImNeE49P
=48aa
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
