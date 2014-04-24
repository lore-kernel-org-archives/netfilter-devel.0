From: Kevin Fenzi <kevin@scrye.com>
Subject: tests/test-script.sh missing from 1.0.1 tar.bz2?
Date: Thu, 24 Apr 2014 11:23:43 -0600
Message-ID: <20140424112343.20161e0f@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/otYFgoDJ1q6lCpqH=RdR71M"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:58917
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758655AbaDXRli (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:41:38 -0400
Received: from voldemort.scrye.com (voldemort [10.99.3.2])
	by mail.scrye.com (Postfix) with ESMTP id 5D4956583FC
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2014 11:23:46 -0600 (MDT)
Received: from voldemort.scrye.com (localhost [IPv6:::1])
	by voldemort.scrye.com (Postfix) with ESMTP id 4EF8C221D0
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2014 11:23:46 -0600 (MDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/otYFgoDJ1q6lCpqH=RdR71M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Greetings.=20

Looks like somewhere along the way the tests/test-script.sh didn't get
included in the
http://ftp.netfilter.org/pub/libnftnl/libnftnl-1.0.1.tar.bz2
release.

Something in 'make dist' dropping it?
It's still in git just fine, and it's in the snapshots...=20

kevin

--Sig_/otYFgoDJ1q6lCpqH=RdR71M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJTWUiiAAoJEEs3sNgP+7teNkoP/AivCZWQ79TMemDzyPehHID5
pDII8VP240+0CCSzGR+BtOkPZQd8h2rzEl33VM/8q4A7SJ1AgbLvLsO10Rd9lyTf
90bP/mvC4MXdCMSBXp/jlytcT/58qJt54lt5uGFinEAgWHIyUYbsYnt8zEeD8vSl
vFgm0qm3FqBKUgzz2nhP0e/REdIIQJA0KYCaH10gltLUSlQWLM4OA8qYzFzWxd2C
dr5LC9E7eL+beqgyM8+hze2e/odYwT+Hk+INkphpWitn7KuFQ5t8G5jcClXR8ZaG
i48tUl36Z0nIWuAsboxyBKFHjlUY/CPMERH+tFY/jQ8RGe1tDdUSe6+3E8ijFCkh
IxgVq650GP0rBr1c7wANfzZsaUd3BCes2W3ozpO5OPYe1Kgh8m9HJxWkFTI5JsJk
VfJ2R1UqSwjVMUBc78S601ADUWAhV3KOQbd13MboM/APTZSiwVoo2wBS/zR7wpOP
+31p7DjI5dTdK4XFfea4wQooJyHA4BeYD4BNHxLv67Wme76kxTK14wnrCac+o+vr
v8OwK6qAs20fPqyTXZ0HsLaJHi0PeYIACBD3AeF22A3P3IwdjSHMtomIq54gJZOP
Me/9pPcTPvKErZhJ0Yw4/YPQr7n1PWUYVEWC+AAq+teDQPjwGMtJ1+RTxoTEGMl0
/29xulH6uHmBmcYgVNOE
=wolH
-----END PGP SIGNATURE-----

--Sig_/otYFgoDJ1q6lCpqH=RdR71M--
