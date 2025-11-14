Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51905359707
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156244; cv=none; b=Kfvm6dwDtQu5DEDRED0hiLUZWCQro/Ej9mvszf9Vv6GF2oBgcbI6iN9zdy5Vk7qyGGcKVUVW7pm6HI9bflBR3nCS9JKERUcR/yErEOby9vc9h8YaSU95dY1j3vtC3P60a+20a6xzISyTPgmDen8wYx/YcOERSr6KqhHVLbZzRJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156244; c=relaxed/simple;
	bh=qjE5Kyucz4c9Lqs3oKiIyF+H+4FpUiAQc0oNyQhDI/0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFN5oMtB64P8WkvhYAhyuKWkYYaW7Ctf8g/FhaLU86hO5v0Dydj0aXNhOHSJyFkXRXoQ4wuxzkrhTttSJsBml8x1pF+pU70sPL1xWfjMulFVVsUajYu1oWmZUPiCLY+Ad2MA3ERSfcdHhxGiIfB18nJ2Q9axIv1KPfm9KQ2XGvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=njovx41J; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="njovx41J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uVFTvAY8oIEt+IeESfSiWHftWk68bqjs/gXwPSk/opc=; b=njovx41JqXl7NlTtoYHaTeF1wW
	x7G5Oy/suk3zTFdjnO+udBz42SFXa8FKmPVmyl/RCzJBSe9L/6ALtxTJafLMR4b8qsnLO4CsG8LgX
	8kDC0ieTHp2olPGTr7NP8L79SCXuDKeq9+2FD/geSYgUc5f7ILKUWbuZ4/WlD48RQZ1sit+o69ZyE
	ZfJ9jWE4lEDDD8mwY5fCFseEQl29c+XfXQDr/dkpqrzxaE6bNyZsN/vjSXKZzQWUa2t8S6DWVUwvE
	XT6DDZcdMzAvdmjj/6WZ4S59i/hNDLh3sOWfbQJZz1YMj1cLTbgCVBFwHIyPKbf8TKDoH7yPyriFX
	eXm9xXlA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vK1Tr-00000001OFm-2p61
	for netfilter-devel@vger.kernel.org;
	Fri, 14 Nov 2025 21:37:19 +0000
Date: Fri, 14 Nov 2025 21:37:18 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <20251114213718.GB269079@celephais.dreamlands>
References: <20251114210109.1825562-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HH2yFX/vGB3tt5K0"
Content-Disposition: inline
In-Reply-To: <20251114210109.1825562-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--HH2yFX/vGB3tt5K0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
> multiple commands were given, options which were legal for any of the commands
> were considered legal for all of them.  This allowed one to do things like:
>
> 	# iptables -n -L Z chain

	# iptables -n -L -Z chain

> Commit 9c09d28102bb did away with this behaviour.  Restore it for the specific
> combination of `-L` and `-Z`.
>
> Fixes: 9c09d28102bb ("xshared: Simplify generic_opt_check()")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  iptables/xshared.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index fc61e0fd832b..9bda28f1c213 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -943,16 +943,16 @@ static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
>  #define CMD_IDRAC	CMD_INSERT | CMD_DELETE | CMD_REPLACE | \
>  			CMD_APPEND | CMD_CHECK | CMD_CHANGE_COUNTERS
>  static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
> -/*OPT_NUMERIC*/		CMD_LIST,
> +/*OPT_NUMERIC*/		CMD_LIST | CMD_ZERO,
>  /*OPT_SOURCE*/		CMD_IDRAC,
>  /*OPT_DESTINATION*/	CMD_IDRAC,
>  /*OPT_PROTOCOL*/	CMD_IDRAC,
>  /*OPT_JUMP*/		CMD_IDRAC,
>  /*OPT_VERBOSE*/		UINT_MAX,
> -/*OPT_EXPANDED*/	CMD_LIST,
> +/*OPT_EXPANDED*/	CMD_LIST | CMD_ZERO,
>  /*OPT_VIANAMEIN*/	CMD_IDRAC,
>  /*OPT_VIANAMEOUT*/	CMD_IDRAC,
> -/*OPT_LINENUMBERS*/	CMD_LIST,
> +/*OPT_LINENUMBERS*/	CMD_LIST | CMD_ZERO,
>  /*OPT_COUNTERS*/	CMD_INSERT | CMD_REPLACE | CMD_APPEND | CMD_SET_POLICY,
>  /*OPT_FRAGMENT*/	CMD_IDRAC,
>  /*OPT_S_MAC*/		CMD_IDRAC,
> --
> 2.51.0
>
>

--HH2yFX/vGB3tt5K0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpF6D+CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmetRTelnDJhuMpIFg9JDVAIhs5SLjbzdhM3KRvZULl9
uRYhBGwdtFNj70A3vVbVFymGrAq98QQNAACTcxAAtHuL16eyDqzh0j4Qkb6zZav9
NGIbZkgrbGqvILh4MH19fWgQwqgQA6vBsNhhGpB7b8kBTGCTIffEqug477v3N1lK
dD0kVY3TsvmqHmZIIjTTwwdZxEGaRdCuvfrrvRuU7vkW08KopJ2o9LVeosbX8cE7
GuOs9a0w8Tq1NOIUqmpajL6vAkqklqDkd8Dyt0eCvAw7c1PKe2bCX9CzHtyYq3Ze
fVP/A6aeJ0k1+X9yLLcFio9t4NP17v8av9YG9j/N+e/b2w5xD587Dqj/ZoS+ajFy
X68OaCanQ2McZ6Ju/EnZQ3d7p6mROUcGg6Izr55WGybZ58Fh18dRxmetSp2IrpPc
jFszzLo4JX7ntLiE1ko2hr0MERqU3BHROen3RFSJ8R0n4yi10sQW8Le9dMFkPXjw
WJTuRliqMk+KDf7H/eelq2gixKn164ZehR4SDf/nIxGuCpeLBoQuL+XJonskPuFm
W4IDdABYxxz0mLq/amFaSmlsqe3wiTfI8X9MizNjmnevviyGZEc1zEy8nbjtirDG
505MkNzfUI7znfrp1w2n7h+42fs3r1CvSXiz/KwK3C7JaEICepXSh1V72qBiZvba
+bupkqqhVtcB2fjKiOjYn86PXLrCmP3cisSoZN13ORNrcvIUiXNIc6MxF4x7KHqD
agRcp6WTNB54ppjbb2s=
=WoZf
-----END PGP SIGNATURE-----

--HH2yFX/vGB3tt5K0--
