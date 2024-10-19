Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26FB192B6F;
	Sat, 19 Oct 2024 21:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729372557; cv=none; b=AIPFNy5H111gH7dI4RlsXucngAmT9WSZMHlq+GwX5/jGyCctPBqyU7jH/vMVYH4xj8X6l/G69qRkRhZJrKW46aq32bqF2IZlmKx3gWn84Nwv10T98TgOyNsjYI7yho1cotdFj9fCQx/kbh06AVrRXMySpBgJmXXsg7xeqRBIAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729372557; c=relaxed/simple;
	bh=zmiWNrl9H24ydgS1osPbPNPUWz7hrrEzyQdF/MT5Adg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqBdebfz2VrgUeenDDBENlM9OVob0XpwFd28YFGIe4KaPONCU5bghDtXdSbWc3X4jkPBQXFaye+jC6DeTKoEPeJDPOK/SZoDcwmMTaOu0pg5gPgrXqVNEnaiD5PM4/AqhU+ob1x3mMDNXIH5RuGmIiio0u+z6ngtgIu4wCXA/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46886 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2Gnc-004klG-HY; Sat, 19 Oct 2024 23:15:50 +0200
Date: Sat, 19 Oct 2024 23:15:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, davem@davemloft.net,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: xtables: fix a bad copypaste in xt_nflog
 module
Message-ID: <ZxQhg-aU1cPSoVCU@calendula>
References: <20241018162517.39154-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241018162517.39154-1-ignat@cloudflare.com>
X-Spam-Score: -1.7 (-)

On Fri, Oct 18, 2024 at 05:25:17PM +0100, Ignat Korchagin wrote:
> For the nflog_tg_reg struct under the CONFIG_IP6_NF_IPTABLES switch
> family should probably be NFPROTO_IPV6

Patch is not complete.

I will post a version including mark and TRACE too

> Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> ---
>  net/netfilter/xt_NFLOG.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
> index d80abd6ccaf8..6dcf4bc7e30b 100644
> --- a/net/netfilter/xt_NFLOG.c
> +++ b/net/netfilter/xt_NFLOG.c
> @@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
>  	{
>  		.name       = "NFLOG",
>  		.revision   = 0,
> -		.family     = NFPROTO_IPV4,
> +		.family     = NFPROTO_IPV6,
>  		.checkentry = nflog_tg_check,
>  		.destroy    = nflog_tg_destroy,
>  		.target     = nflog_tg,
> -- 
> 2.39.5
> 
