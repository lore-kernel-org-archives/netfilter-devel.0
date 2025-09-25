Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556FD1F03DE
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 20:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830452; cv=none; b=Ytjr6Yd2F7gTdneATdzl+QwzS4RYzb7EZenFphq9d/oV2fKm8qshygQ4kz9dMGc/FU4tXWo2QsuTgA33oui+gzrZvJBGkIhO8gu5Exa0/Fqguid1PXQLbPaIqIMlDaosS/8yUsmUnZW0j8X0C7dCvYCvwhgxSwo1ZJmBYWTI6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830452; c=relaxed/simple;
	bh=eWOjustwCsfhOHG9sLaNbJDfaqGxn5ROZCkuiTJd8J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xs9fLqsVjfjMwVyiabmKNUxm/R/7RkXIBsSGG5t/posM6HgLEmRIsMmiDuj44lnG6+OhZyxixnagrcWc/IKsVMiuvUVcDTXFT2KnENWrXzUaOmUHxcz9oJNe25YDeGXXdvPD+vsHK/WhpIgx7Ao8eM7BvUzOq+mvdPA4w+xvtog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=afDaXQd5; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="afDaXQd5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2rdbNDLI5IG2Jg6Bu68Hi5LFvbDgIMeCdV+nFKB/Luc=; b=afDaXQd5pdJ+7rp1kB4qlszX0v
	JL651P31OvECsauvPmFHowZmlFa1uPDMT+purDM8Mni6VqqFNOKuz2mYlbW6N6XlbW7B2SfMLKyq4
	2l+o2EZnloLDkwpI8ZtoKcXkTSBLO9yudhIAN7hsvn36cTrlEu1IszJ4IKzQMIzhx0jxevxuzcvFW
	LRouagX9sf9BPWon/x+FRKNmV4fkX90iXfW8E24pWxLeCIpI71cxYwLoW2NKCn2tMfgMJSiB91XEF
	0QifWxncDOdLON/cu+i/SyvQ0gonitnMYqelZBiYj5VIwO6yj8dZ8UAZpQu6LWPEiWD7+BXu8dbjm
	VJRTvpng==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1v1s8s-00000001QWY-0vUn;
	Thu, 25 Sep 2025 21:00:38 +0100
Date: Thu, 25 Sep 2025 21:00:36 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] libnftables: do not re-add default include directory
 in include search
Message-ID: <20250925200036.GC6365@celephais.dreamlands>
References: <20250924222119.191657-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EHUcF3O8cfrpuyr0"
Content-Disposition: inline
In-Reply-To: <20250924222119.191657-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--EHUcF3O8cfrpuyr0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-09-25, at 00:21:19 +0200, Pablo Neira Ayuso wrote:
>Otherwise globbing might duplicate included files because
>include_path_glob() is called twice.
>
>Fixes: 7eb950a8e8fa ("libnftables: include canonical path to avoid duplica=
tes")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Jeremy Sowden <jeremy@azazel.net>

LGTM.  Will get this into Debian.

Thanks, Pablo.

J.

>---
> src/libnftables.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/src/libnftables.c b/src/libnftables.c
>index c8293f77677f..9f6a1bc33539 100644
>--- a/src/libnftables.c
>+++ b/src/libnftables.c
>@@ -176,6 +176,9 @@ static bool nft_ctx_find_include_path(struct nft_ctx *=
ctx, const char *path)
> 			return true;
> 	}
>
>+	if (!strcmp(path, DEFAULT_INCLUDE_PATH))
>+		return true;
>+
> 	return false;
> }
>
>--=20
>2.30.2
>
>

--EHUcF3O8cfrpuyr0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJo1Z9jCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcEsdmIHyP4xIQtQawslm0UBC8vfZtFzzKDHiftM0eg
2hYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAqwBAAjz47KlRILkrRT3IWWSa0IWNI
oNdu4uJuqzQ2soK/jyjPz1cAaXJSu6oPs2TrJqkNyQghbtW4LhcWPp8IIELqlTeL
Lna6dhNCcJvCNXXR+GeDCX78IKP7sBBoWY2WhXeOOCoSbXtn1glzzWam7jlSRyC3
0QRd13lTkzHKpkFJ3NAuiHwvsd+sKmD2/Wb1XSd6FOUZpZZ+6k42ZJQCnP2YoJ2I
eF+8LhvefuIQy6I3nBYWiDHbDp2p+67wvghdnQBC98aLkZkek+uwsyLkBzptpeBC
kqu7dcs+piQikpKezmLIm7C/nBKhiPt1MJGZT3Q6Re1ar5wdq5fOzS423mkGXN8y
0334tST4P4ObEY7SNODLpTWanrY5OzcZqrwa4C/8GS8f/lflTS83Yg7+X5HJsgkn
KTa5PYpFv53hDyYkCN7dTsl7ObaG1yz5lK/0B8cFYqgjzmzfFA4XGE9JTCxpIXLO
5P0Mcy5x69xU5CIiWWodrIepfsKTcEmuUhfeC8F114iADoTZjTQdEqT9YJrhuF93
Fd7o1B1rJWALKK6a3N8juoD0I0PPfftA9Y5rulPEA1HTfpp+3AZRgSQp0lDNSGJD
Cfnq511kISdQS/L6ngp/nJwyiK5Iv/xG68+2EefXhc4bGREm3bDkU3etgfwlyJS+
u0yWaCOyk57EPYnpMH8=
=8Gu9
-----END PGP SIGNATURE-----

--EHUcF3O8cfrpuyr0--
