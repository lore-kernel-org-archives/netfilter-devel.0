Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC153FE7;
	Fri, 29 Aug 2025 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477012; cv=none; b=fi6AEoOiY1lI5468FbyViLX/kNZ3YnIJ2jZNT5KcC3X9a6V/qCwQ7kydKhRbq3PGcgWiHkCQPdBQQid4NNeN1FylwVyUQp2VteuXQIsGBEM00eNYyt3lG+bo8kzVaBqunJr40tyzQzo9mFAdZyByepwkfBmJgUYui6HCIAkkNuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477012; c=relaxed/simple;
	bh=Hru83g9HCeNPbRe6vzLuhSyMyzuUR95nJiEHkne/63Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahRu/llKt1QZZ2BnW1JUq0XGIuvc/cGfzwL7tQoO1vPPHVnuKsj3xd0w43WtWO/8Z2HxtYVhI0n+nhMSuZJnbZVokMm3xOFuvPBBXmZVN5UnsqgTzGDsfCOykBxpTv5KFi0vKb47p3H/4zA1gfkvAZhP3keUkREXC6MDJE4PeLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AE20E60298; Fri, 29 Aug 2025 16:16:46 +0200 (CEST)
Date: Fri, 29 Aug 2025 16:16:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Miaoqian Lin <linmq006@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Joshua Hunt <johunt@akamai.com>,
	Vishwanath Pai <vpai@akamai.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_hashlimit: fix inconsistent return type in
 hashlimit_mt_*
Message-ID: <aLG2TumWk_kgK6zN@strlen.de>
References: <20250829125132.2026448-1-linmq006@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829125132.2026448-1-linmq006@gmail.com>

Miaoqian Lin <linmq006@gmail.com> wrote:
> The hashlimit_mt_v1() and hashlimit_mt_v2() functions return the
> cfg_copy() error code (-EINVAL) instead of false when configuration
> copying fails. Since these functions are declared to return bool,
> -EINVAL is interpreted as true, which is misleading.

Could you please check if its possible to rework cfg_copy() to not
return anything?

> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -806,7 +806,7 @@ hashlimit_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
>  
>  	ret = cfg_copy(&cfg, (void *)&info->cfg, 1);
>  	if (ret)
> -		return ret;
> +		return false;

AFAICS cfg_copy cannot return an error.

You could try adding an enum for the version field to xt_hashlimit.c,
then use switch/case to let compiler complain for other values.

Or try to replace the else branch error return with BUILD_BUG(),
compiler should be able to figure this out.

You might have to add __always_inline hint.
