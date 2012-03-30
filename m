From: Artyom Gavrichenkov <ximaera@gmail.com>
Subject: Re: `iptables -m tcp --syn` doesn't do what the man says
Date: Sat, 31 Mar 2012 01:40:41 +0400
Message-ID: <4F762859.4080801@gmail.com>
References: <4F761E8E.9000708@gmail.com> <1333142365.2325.2579.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5A41B257D49D3CFCAB1B2324"
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51870 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966076Ab2C3VV6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:58 -0400
Received: by bkcik5 with SMTP id ik5so998878bkc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Mar 2012 14:21:56 -0700 (PDT)
In-Reply-To: <1333142365.2325.2579.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5A41B257D49D3CFCAB1B2324
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

31.03.2012 01:19, Eric Dumazet =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
> FYI current linux kernel just drops this kind of message (SYN+FIN)

OK, thanks for clarification, I should have missed this commit.

--=20
| Artyom Gavrichenkov
| gpg: fa1c670e
| mailto: ximaera@gmail.com
| xmpp: ximaera@gmail.com
| skype: xima_era
| tel. no: +7 916 515 49 58


--------------enig5A41B257D49D3CFCAB1B2324
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk92KFkACgkQ9HpYY/ocZw6jgwCg1I/iskSDEvmaG2S+oHfhUQxe
k6IAn3DdAOQ7M95uT5ajJSFOQa5zamXh
=Pv6+
-----END PGP SIGNATURE-----

--------------enig5A41B257D49D3CFCAB1B2324--
