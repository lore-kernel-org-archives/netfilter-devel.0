From: Richard Weinberger <richard@nod.at>
Subject: Re: Can't build iptables (git as of today)
Date: Sun, 18 Sep 2011 15:27:16 +0200
Message-ID: <4E75F1B4.6080307@nod.at>
References: <4E75E21D.6050000@nod.at> <alpine.LNX.2.01.1109181509580.16287@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFC95F27B3E6FB837FA9B18F4"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:43586 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab1IRN1S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:27:18 -0400
In-Reply-To: <alpine.LNX.2.01.1109181509580.16287@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFC95F27B3E6FB837FA9B18F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 18.09.2011 15:12, schrieb Jan Engelhardt:
> On Sunday 2011-09-18 14:20, Richard Weinberger wrote:
>=20
>> Hi!
>>
>> I'm trying to build the most recent iptables version but the build fai=
ls
>> with:
>>
>> make[2]: *** No rule to make target `../extensions/libext.a', needed b=
y
>> `xtables-multi'.  Stop.
>>
>> It this a known problem?
>=20
> Now it is; and this is the fix

Not really.

  CHECK    unknown symbols in .so files
/bin/sh: line 1: ../iptables/libxtables.la: No such file or directory
make[2]: *** [check] Error 1
make[2]: Leaving directory `/home/rw/src/iptables/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/rw/src/iptables'
make: *** [all] Error 2

extensions/GNUmakefile.in contains a wrong path.
Shouldn't it be ../libxtables/libxtables.la?

Thanks,
//richard



--------------enigFC95F27B3E6FB837FA9B18F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOdfG0AAoJEN9758yqZn9ev4sH/0XhCgguSr6qnOi8ekbORAjw
xDFNvO0zJdF0NQwNqIJoY+No5+4/Nb0kdWABkQpSY3KMw9joGB4Hgn6aeBfxh9aU
8qYJOVG1KgwhlIDCXiKf+XlfDJiPfFz3uDDQjVt6DKc+2wNjinsnluSCisXxQoK0
ct9ZZu4yviVNMVp9TfPnn5vhLORuMieaoDjIXU3mdU/rvqKgU25WA9cMpga2GOU4
j+pMY6LzepDOjaOqlW3G8GrZ1FvZ8tt/qILwlowdR1sqKvGJOuu09s4bt8zOjQFj
+O82mZXcYM81uXpoH5hRrmlsM1YQ8xPGdT/GoBSeaNFxkv4eK8tM6Fpy8wUrPkI=
=2T2H
-----END PGP SIGNATURE-----

--------------enigFC95F27B3E6FB837FA9B18F4--
