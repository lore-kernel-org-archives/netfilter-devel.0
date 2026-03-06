Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6274B361DA1
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772822168; cv=none; b=JiC4dDZXmDuNEIj7O7xK5m/tWAxElTz35N8biqZUrLYTuvxsuXbcvHAx+YYEvwUzlKqYuzs57X61FKefanG8noo6qfgj0Ui6hBCvU/PuvtpOdHv9HYVAX8MWM+eP7X3xDNheSAze7H2C7p8U0ge6nEHEW8YdkCAwqIIP5v9Zv78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772822168; c=relaxed/simple;
	bh=tWuVJZRZMurqkmOYPTBTEAtbNK6WTAHPocGkA1t5qcg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeLVPyE0yfR3ybjcNPv4hvV/YmZVSI+F9pCeSt92BmosECKmZ1dPXLdWJ9L6jLYTTbdSy/jZbcxjND7sIQQLwfUzJk3tvRRgV/670fmieD2lndMBb9FbuV7s8UGNJblsbyykumoUBc4TOropOfUaV8c+Y1WAnl0b4WqBvYz6Uvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=I4u4we2A; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="I4u4we2A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pitD0mZYAzKa1HFm8FdP5te/ronu+iROjaE/V5B6o9I=; b=I4u4we2ACCSSrCbXUWKB7NnjyQ
	N2tBVSojthX8XiHtDA6TWOCgtVRsmfvmlCCh37i/f7TrPlsCgYqGiEE/rTqyh6RBM4tLRsHSwyaGP
	QG9z1kxyKJpG6O1U0vzoCx+fPdMcIhJXDlwR4JmAd3jg0kAoS9XldEfoKGyHFKRWTYz6PuKn5u2G6
	H1mD+fJubgUTod1ij0/uGAbcPwPwO820jwjKcLThehD4XJyqZVl+0Qpji56qfL1yiMDiNFlAzmPGR
	g8iy3CiSd24YwHzOru9gUAs4t927rqtZxMccpvo+DYvMLt57B15FJ/x/mClxB0pYrAo3h6u85r5mq
	6bvo3OQw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vya1k-0000000AtDN-3RZ2;
	Fri, 06 Mar 2026 18:35:56 +0000
Date: Fri, 6 Mar 2026 18:35:53 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <20260306183553.GA5468@celephais.dreamlands>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wQU8kRLLNNgO1qFh"
Content-Disposition: inline
In-Reply-To: <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--wQU8kRLLNNgO1qFh
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-03-06, at 18:41:06 +0100, Phil Sutter wrote:
>On Thu, Mar 05, 2026 at 05:53:58PM +0000, Jeremy Sowden wrote:
> > Since Python 3.12 the standard library has included an `os.unshare` fun=
ction.
> > Use it if it is available.
>=20
> This patch breaks py test suite cases involving time-related matches,
> e.g. 'meta time "1970-05-23 21:07:14"'. It expects:
>=20
> | cmp eq reg 1 0x002bd503 0x43f05400

	$ TZ=3DUTC-2 perl -MPOSIX=3Dstrftime -le 'my $ns =3D hex $ARGV[0]; print s=
trftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd50343f0=
5400
	1970-05-23 21:07:14

> but instead the rule serializes into:
>=20
> | cmp eq reg 1 0x002bd849 0x74a8f400

	$ TZ=3DUTC-2 perl -MPOSIX=3Dstrftime -le 'my $ns =3D hex $ARGV[0]; print s=
trftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd84974a8=
f400
	1970-05-23 22:07:14

> Do you see that too?

Yes, e.g.:

	6: WARNING: line 4: 'add rule netdev test-netdev egress meta time > "2022-=
07-01 11:00:00" accept': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatche=
s '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'

As with your example, the discrepancy is an hour:

	$ TZ=3DUTC-2 perl -MPOSIX=3Dstrftime -le 'my $ns =3D hex $ARGV[0]; print s=
trftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fda8f31977=
a000
2022-07-01 11:00:00

	$ TZ=3DUTC-2 perl -MPOSIX=3Dstrftime -le 'my $ns =3D hex $ARGV[0]; print s=
trftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fdac394a30=
4000
2022-07-01 12:00:00

which suggests it's time-zone related.  Didn't see anything about that
in the doc's.  Will take a closer look.  Apologies.

J.

PS UTC-2 is exotic. :)

--wQU8kRLLNNgO1qFh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpqx52CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeF1QXSd5ZTdUxcDwP3KRWW2pDlntDOLV+ZtQa5GuFN
uhYhBGwdtFNj70A3vVbVFymGrAq98QQNAAA79Q/+KqIrvciMvq63HF3d40VScSwt
jilpUSSjzU63quR1g8LOANxmjz7E0PBluYRNKxlsPo8STzznJ8Ot13gCowRkgTjb
ibI/RYAYMlxlmUqEQGBQnkohcUtZxJlZhIZFbqCKQvVO7l1zy/1xErXP2U3S+nwb
mqwpXUyGffNylpF+/QpGyt96werFbX0ptCmqKSeOYiAHyVIAjoe9xRATXPKlMLHm
ToN3SNvzD+eoovj8qZFdfsRyxg3XEdRs5joVWJiPr4Sknw3KFYRMomWyiMm6+EgA
YE2gfKU3abma2xBjoMl2iFJnETs6CMvBmQuF5oZ9peZRJ5NyWm/8Lp42ICFTDx+f
Q+/1tDTFNZjxuCmlc6V379D3E7eloW5Icc4bsGvRkyIVtFnM8dvod1+dhwwZAd6q
EQAOKjiLqh9+9w6dXj2Xxi3hDRfNOvyKth5X3ceNaO5yBMs/jDI22bmQBFFw8v3Q
yevr5OxpYA5jl8mxaRuNqet37meXza50YosYEtoiuY7e1DOKymC6FWo91mj5+J60
wBQ39LCH5xPQ4RD3QtZbz06gQeq8kfQKgZQIaYIaPq8IScfzMdOQritCS2dA7TL1
+NGw9Q0KzQKZaBd2yZl5lc2VakvFIV9nBeUWUAfx8VI9XPhl6gm4qJJjzGiNihJE
nI7PIzsqWeDd0TLwypk=
=xqJG
-----END PGP SIGNATURE-----

--wQU8kRLLNNgO1qFh--
