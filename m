From: "Christoph A." <casmls@gmail.com>
Subject: Re: arbitrary address mask matching
Date: Mon, 10 Aug 2009 11:06:51 +0200
Message-ID: <4A7FE32B.4040409@gmail.com>
References: <4A7F5CF1.8030708@gmail.com> <4A7FDEFA.3020009@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig9BF1F91356F031E91A425F91"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	"Christoph A." <casmls@gmail.com>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:37656 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZHJJJb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:09:31 -0400
Received: by fxm28 with SMTP id 28so791119fxm.17
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 02:09:31 -0700 (PDT)
In-Reply-To: <4A7FDEFA.3020009@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9BF1F91356F031E91A425F91
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 10.08.2009 10:48, Pascal Hambourg wrote:
>> iptables -A OUTPUT -d 10.10.97.1/255.255.255.253 -m iprange --dst-rang=
e
>> 10.10.97.1-10.10.97.7 -j REJECT
>>
>> this should match on 10.10.97.1,3,5,7 but matches only 1 and 3
>=20
> 253 is binary 11111101, so this is the expected behaviour.
> BTW, what is the use of iprange in this rule ?

The rule is mainly a copy n paste from
http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf page 7 (just
changing the input to output direction)

to get the desired/described behaviour one should set this mask:
255.255.255.1

the line
-A INPUT -s 10.10.97.1/255.255.255.253

should be changed to
-A INPUT -s 10.10.97.1/255.255.255.1

Jan, would you correct this in the paper (if you agree with my
correction of the mask)

thanks
Christoph A.


--------------enig9BF1F91356F031E91A425F91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREKAAYFAkp/4ysACgkQrq+riTAIEg2oTQCeNm44clNZwVo1RU/D6ndvXqDU
f8YAni/WqxJax9BNn40r/U79rAmPHHj0
=5/4m
-----END PGP SIGNATURE-----

--------------enig9BF1F91356F031E91A425F91--
