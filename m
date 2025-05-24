Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D005F1CEAD6
	for <netfilter-devel@vger.kernel.org>; Sat, 24 May 2025 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748092729; cv=none; b=uTv0NutWN1h2ExWhDShoFq4a3zzQ+4JQF9O55eO/Ndxk5YW+G9RSNsq/BdssicP1f4UPjzsWr6zMvODOVvFpH3gSUzsD4oK9M+V0IXyqsrWhZ49xzoaU7KYmdnGwNhTkGghAQ0TTVuZOpqHysHVRHojGax5poqinueblXL3vbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748092729; c=relaxed/simple;
	bh=hoWIPAP+7/T8An5nsfdM7ylDm1DGbtjzzferM8CpnKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4G6Enu4BQRMy3RRHW8N6TiNalkvdyyVfJ1fD0kRfFKSnqNKB3RZIVY707ZB1aeQ2Tz653mzGy/q5J58S6FsBTno50PP1Pe4xwnsEAuza4GgVy1o4gJlL3FqwgLFVMqQHaldORofSthBksNQ/tGXWzxy5tcEPFwg3o6LEbVHUws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=I63mG/wW; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="I63mG/wW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5ih/EALXV2ZZULbc47nkEbwSJfoDhUUwO/mOpc6/Ds0=; b=I63mG/wWs4cTKrLkusaMqhD5t5
	uH3L5WmdkIDcd26mAWZZkvFskL7c5gBPoNLT9COiIfETHDIAjHEE6oqGfksK326va6lf0Pe5eU+5y
	Te+rptpWAzwRI3mJGArxHBH101DTgTXfWn3OgWeXmgDNzKQeW7s8dAYzf2jizJalDf+03SaYioDAF
	JmfpECozspzVxYEPvrkHQ1gaO2ME60Bo+Pggb6wtqtuYqXpvpPP22g2bDegdTE994rWoo96XijLxH
	oT4wIMaYhdVL4rqm6M9OHy+oMJ2t95sEYxCNd155UiVtW6psFOgrMFaRC8Boi4H4e6FaS0oAHWfVe
	ZVt5HF6w==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uIoR2-004gha-0g;
	Sat, 24 May 2025 13:57:08 +0100
Date: Sat, 24 May 2025 13:57:06 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: netfilter-devel@vger.kernel.org
Cc: Mike Pagano <mpagano@gentoo.org>
Subject: Re: [PATCH] ipset: Modify pernet_operations check
Message-ID: <20250524125706.GB2764308@celephais.dreamlands>
References: <20250523172732.59179-1-mpagano@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cIHp0jFd+C+3Wg8L"
Content-Disposition: inline
In-Reply-To: <20250523172732.59179-1-mpagano@gentoo.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--cIHp0jFd+C+3Wg8L
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-05-23, at 13:26:51 -0400, Mike Pagano wrote:
>Check for 'int \*id' in the pernet_operations struct
>fails for some later versions of kernels as the declaration
>is now 'int * const id'.
>
>Kernel Commit 768e4bb6a75e3c6a034df7c67edac20bd222857e changed
>the variable declaration that ipset uses to ensure presence
>of the pernet ops id.
>
>Modify the pattern match to include both the newer change while
>still supporting the original declaration.
>
>Signed-off-by: Mike Pagano <mpagano@gentoo.org>
>---
> configure.ac | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/configure.ac b/configure.ac
>index b8e9433..faf570b 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -401,7 +401,7 @@ fi
>
> AC_MSG_CHECKING([kernel source for id in struct pernet_operations])
> if test -f $ksourcedir/include/net/net_namespace.h && \
>-   $AWK '/^struct pernet_operations /,/^}/' $ksourcedir/include/net/net_n=
amespace.h | $GREP -q 'int \*id;'; then
>+   $AWK '/^struct pernet_operations /,/^}/' $ksourcedir/include/net/net_n=
amespace.h | $GREP -qE 'int \*id;|int \* const id'; then

Or:

      $AWK '/^struct pernet_operations /,/^}/' $ksourcedir/include/net/net_=
namespace.h | $GREP -qE 'int \*( const )?id;'; then

> 	AC_MSG_RESULT(yes)
> 	AC_SUBST(HAVE_NET_OPS_ID, define)
> else
>--=20
>2.49.0
>
>

J.

--cIHp0jFd+C+3Wg8L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJoMcIbCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeFzHcq/tvfcSwTj3wnmmCj5rohi511nxhQUR1Ow/1N
IhYhBGwdtFNj70A3vVbVFymGrAq98QQNAAD12xAAhQAVGUyHmBeNHxaET7L5KAHQ
+evOBBP6vLcYrFOZUskHdxJ1cLFbFOfzXLXd+nP/8CX8CZLB1+snEtBcFE1zj2w6
P24TSAS2yIlVcwu8ZHWO9tE5cOvxo9v/mrLwu4TfiFKxoJ4+yBv31ZCZWzZ1UJLp
3w44ujOMPswTNdJ4E3+mexc/PCbCxvyZxdAJ2GqwmeA/ZKwIvTsQotZG0r89qVXr
62NVIu0ZdEkyfVpSxL64y5xDy0VMBCVt/RHP29pO8GG3eI6cUpuvVbg+kpimNW8B
p3iogwB7+Q+4I1x0xV2FfzO0cM3HK3iS5Hx7+F2JyQ9+AVPNiFl/OZLFuBYuW5uu
zYIkOgQqlnY3LVvY7gtYvqYM6fv2gAfW1mhrfEgKpVf7VR/Hwb0CIE90gOEHdR2W
mIrxePtxXz6W2IRGx0qe5Cei0VTtpkq6wNlFG4cYpo+tAKvut35g/Axg+gcjlAX8
D4rBt/AMR+dWB87DGwFtIRxzqdSrLPexjvz9qYlNVsTjb23jCf2WWT8lfuW/8/nW
YpQV3x5MbexhQpME49CU9UzLvjoh2ek9T0wtGiP6VFBqm6VJMOPNuQho1vHD7hkb
Yh4e40bYKpdV7+i9x6efSPJAhF3SGHWS2REfZgloQ24G6PsFEWtME9avbikByGQs
WovSYPb3WEMkb3aLxig=
=nszM
-----END PGP SIGNATURE-----

--cIHp0jFd+C+3Wg8L--
