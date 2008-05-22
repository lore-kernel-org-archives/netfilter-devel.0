From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2] missing file Rules.make.in needed by configure.in
Date: Thu, 22 May 2008 16:28:05 +0200
Message-ID: <20080522142804.GO7436@bayen.regit.org>
References: <200805211055.42278.Hugo.Mildenberger@t-online.de> <4833EE9A.3010507@trash.net> <48357F3B.90001@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t5C3/nrmPumNj5sH"
Cc: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:39564 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbYEVO0m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:26:42 -0400
Content-Disposition: inline
In-Reply-To: <48357F3B.90001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--t5C3/nrmPumNj5sH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 22 at 16:12:11 +0200, Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Hugo Mildenberger wrote:
>>> Running autogen.sh from current ulogd2.git  results in the following =
=20
>>> error:
>>>
>>> ~/git/ulogd2$ ./autogen.sh
>>> configure.in: installing `./install-sh'
>>> configure.in: installing `./missing'
>>> filter/Makefile.am: installing `./depcomp'
>>> configure.in:75: required file `Rules.make.in' not found
>>
>> Yes, the repository is broken currently. We're looking
>> into it.
>
>
> Yasuyuki fixed the tree, it should be working now.

Working fine for me.=20

My previous ulogd2 patchset and Pablo's one seems to apply cleanly.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--t5C3/nrmPumNj5sH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINYL0nxA7CdMWjzIRArmpAKCFYx+BvImFjpUa7/dpiAIWCuDkeQCfSpwV
g6pOcaHSNPxaD75YTMP0AYw=
=BWNB
-----END PGP SIGNATURE-----

--t5C3/nrmPumNj5sH--
