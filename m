Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422F8EAF1;
	Sun, 20 Oct 2024 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729428654; cv=none; b=IGC25THb1Tc31xoPIMU+zxT4cUZOXiFhPut5UWT0uLJwwbguBclL08qQ2Vggblqjt3QyW5BfI746OxHcN+drIJ6vVQE3qpQdWp9L9yNSQ4ShHK5UugzO6ZyI6H2srw6WEZVNrLh1JzgVEldsdYIEsJ8yrBMkftzKmcCIJHbU7gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729428654; c=relaxed/simple;
	bh=5NoiOWSGjB70ADUGlkznvbky5DNSmBZn+X2aeN9vnpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMS+ijURT5zg/VagneZ0a5IX2mLCNTz0nBHE+ZpcrnhmBMCsmwca1sFqGtEuq6f1YrvUxQNUUvC5W4HKxXDtzaODExOKPti3A/357KpTv+g3oLT0p8t6HYkTjUET2LgghQFhdDjqR50xdHcOvb6xYXMy6SQFr1x4qHLRzFbiXhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46920 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2VOO-006uEz-8s; Sun, 20 Oct 2024 14:50:46 +0200
Date: Sun, 20 Oct 2024 14:50:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Katsnelson <me@0upti.me>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ignat@cloudflare.com, stable@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH v3] netfilter: xtables: fix a bunch of typos causing some
 targets to not load on IPv6
Message-ID: <ZxT8ow0auDTe-TDA@calendula>
References: <20241019-xtables-typos-v3-1-66dd2eaacf2f@0upti.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241019-xtables-typos-v3-1-66dd2eaacf2f@0upti.me>
X-Spam-Score: -1.9 (-)

On Sat, Oct 19, 2024 at 09:18:38PM +0300, Ilya Katsnelson wrote:
> diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
> index f3fa4f11348cd8ad796ce94f012cd48aa7a9020f..2a029b4adbcadf95e493b153f613a210624a9101 100644
> --- a/net/netfilter/xt_TRACE.c
> +++ b/net/netfilter/xt_TRACE.c
> @@ -49,6 +49,7 @@ static struct xt_target trace_tg_reg[] __read_mostly = {
>  		.target		= trace_tg,
>  		.checkentry	= trace_tg_check,
>  		.destroy	= trace_tg_destroy,
> +		.me         = THIS_MODULE,

indentation is not correct.
>  	},
>  #endif
>  };

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20241020124951.180350-1-pablo@netfilter.org/
