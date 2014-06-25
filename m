From: Giorgio <giorgio.nicole@arcor.de>
Subject: problems cross compiling nftables
Date: Wed, 25 Jun 2014 21:43:31 +0159
Message-ID: <53AB267C.5070403@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SA5nTjgJoIKxcwLfQaI9g8MvTBNHLhKtv"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:54774 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbaFYToH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:44:07 -0400
Received: from mail-in-02-z2.arcor-online.net (mail-in-02-z2.arcor-online.net [151.189.8.14])
	by mx.arcor.de (Postfix) with ESMTP id 961D55A55B
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2014 21:44:05 +0200 (CEST)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net [151.189.21.54])
	by mail-in-02-z2.arcor-online.net (Postfix) with ESMTP id 84E617186B0
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2014 21:44:05 +0200 (CEST)
Received: from [192.168.178.21] (p549AD71C.dip0.t-ipconnect.de [84.154.215.28])
	(Authenticated sender: giorgio.nicole@arcor.de)
	by mail-in-14.arcor-online.net (Postfix) with ESMTPA id ECB079BE1D
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2014 21:44:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SA5nTjgJoIKxcwLfQaI9g8MvTBNHLhKtv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
my name is Dal Molin Giorgio,

I'm trying to cross compile the current 'nftables' git repo. for an arm
embedded system but it's not so easy.

Looking at the configure.ac / Makefile.in's I've noticed that they are
not exactly 'state of the art'.

I think, adding a proper/modern gnu autotools support to nftables would
solve all my cross compile problems.

My question in the first place is if it's interesting for you to add
such a support to nftables.

I've already tried it myself to see how complex it is;
I've found it easy to update the configure.ac and to replace the
Makefile.in's with Makefile.am's.

The difficult part arises now from the header files: it seems there are
kinda circular dependencies between them and it's difficult for me to
solve them (ideally I should not need to modify any of the .c or .h
files).

Please let me know your position about it.

Thank you for your attention,

giorgio


--SA5nTjgJoIKxcwLfQaI9g8MvTBNHLhKtv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOrJoEACgkQYqbc2h3T5VBIoQCfYEVjM2hpm/LO+sNtKXKhG5e/
i9UAnjc14uZ+sIHQFZr1rnPtOm1csaN1
=C9Um
-----END PGP SIGNATURE-----

--SA5nTjgJoIKxcwLfQaI9g8MvTBNHLhKtv--
