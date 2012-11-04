From: Eric Leblond <eric@regit.org>
Subject: [PATCH 0/2] Add include for nflog and nfacct
Date: Sun, 04 Nov 2012 10:51:51 +0100
Message-ID: <1352022711.11805.8.camel@tourtet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ibna1pCJ+G6QyEEnv8eQ"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56937 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2KDJwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:52:14 -0500
Received: from ip-37-24-162-232.unitymediagroup.de ([37.24.162.232] helo=[192.168.0.107])
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1TUwsF-0008VI-IW
	for netfilter-devel@vger.kernel.org; Sun, 04 Nov 2012 10:52:11 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ibna1pCJ+G6QyEEnv8eQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

The libnetfilter_log and libnetfilter_acct include can't be put directly
on top of a source file because some integer types are not defined.
Following this mail are two patches to fix this problem.

BR,
--
Eric

--=-ibna1pCJ+G6QyEEnv8eQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBQljq3nxA7CdMWjzIRAkQjAJ4nkyrXoUfkmoisdnFXXo31KufwqACfczkW
BvZGmPDJifLf9gjp5P8rMkQ=
=Os/K
-----END PGP SIGNATURE-----

--=-ibna1pCJ+G6QyEEnv8eQ--

