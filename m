From: Thomas Jacob <jacob@internet24.de>
Subject: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Thu, 13 Mar 2008 13:11:18 +0100
Message-ID: <1205410278.16631.0.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YfUxnBut7/OiNhNyu04T"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:45998 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYCMMly (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:41:54 -0400
Received: from mailin03.ims-firmen.de ([192.168.1.112])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1JZmHJ-0001UD-Vm
	for netfilter-devel@vger.kernel.org; Thu, 13 Mar 2008 13:11:22 +0100
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin03.ims-firmen.de with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1JZmHJ-0000z6-TD
	for netfilter-devel@vger.kernel.org; Thu, 13 Mar 2008 13:11:21 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-YfUxnBut7/OiNhNyu04T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hiya,

I've updated the geoip patchlet a bit so that it
compiles cleanly with current versions and it
seems to work for me (see attachment). This
is based on work done here:
http://bjerkeset.com/patches/geoip-match-2.6.22.patch.gz

Emails to the authors are bouncing, so I'll try
this list instead. Feel free to include the changes anywhere you like.

     Regards
         Thomas

--=-YfUxnBut7/OiNhNyu04T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBH2RnmgF9cFv867HwRAoL8AJ9cZEIsEBQjrkSfc2d6GorMVwu5BACgwVks
hRaJMPOJ6SPtr/N9aftCfTY=
=NW/V
-----END PGP SIGNATURE-----

--=-YfUxnBut7/OiNhNyu04T--

