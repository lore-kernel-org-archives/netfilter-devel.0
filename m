Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16DC3431F5
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776251899; cv=none; b=o95xE0JIbTLZMMJftAiWvX8c3CksqA3bEANNY1nJarFyyELlAsr1GRJqW1TrivBVw3PtMTP+Mj4F2dMs7pILlD8Wb4pl+DgidAB4IRXQAXrMprR+T8nhXb+ctgK31yT/wXthgQc6D2Lu0ZUNDlkCek2JlFZNcLH/S7RltlRRD+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776251899; c=relaxed/simple;
	bh=P+Jw8/E+tS9DngxbFW2iGbGLNvi6zHb2/8k+y+rVxuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWlh2zV+ajF0f0Iwy5BON9JNn+qdNjKl+WdkcitpAhWDRvhFWwFmyfvMwF/f/RTZCu0Tqt25cy50sB/ahapt8R10ib+E4LTinmPvlMKMoNvdrPPno1rRa3zOjVSBpwCnlFTPEpcerjEZVfou1Z2aWMapBCInCT+GyrefXD4/dX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4370760301; Wed, 15 Apr 2026 13:18:09 +0200 (CEST)
Date: Wed, 15 Apr 2026 13:18:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: xtables: restrict several matches to ipv4
 and ipv6
Message-ID: <ad9z8Bv9-BvL-cPd@strlen.de>
References: <20260415104707.55946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415104707.55946-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
> index 6df485f4403d..130ebe5d1c43 100644
> --- a/net/netfilter/xt_realm.c
> +++ b/net/netfilter/xt_realm.c
> @@ -27,24 +27,35 @@ realm_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
>  }
>  
> -static struct xt_match realm_mt_reg __read_mostly = {
> -	.name		= "realm",
> -	.match		= realm_mt,
> -	.matchsize	= sizeof(struct xt_realm_info),
> -	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> -			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> -	.family		= NFPROTO_UNSPEC,
> -	.me		= THIS_MODULE
> +static struct xt_match realm_mt_reg[] __read_mostly = {
> +	{
> +		.name		= "realm",
> +		.match		= realm_mt,
> +		.matchsize	= sizeof(struct xt_realm_info),
> +		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> +				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> +		.family		= NFPROTO_IPV4,
> +		.me		= THIS_MODULE
> +	},
> +	{
> +		.name		= "realm",
> +		.match		= realm_mt,
> +		.matchsize	= sizeof(struct xt_realm_info),
> +		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
> +				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
> +		.family		= NFPROTO_IPV6,
> +		.me		= THIS_MODULE
> +	}
>  };

Is this for possible users of ip6tables ... -t realm?
AFAICS dst->tclassid is never populated for ipv6, so while its possible
to use it from ip6tables I don't think it can match.

I don't object to this change of course.  I just wonder why this was
ever changed from ipt_realm to xt in the first place.

It was done as part of 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables").

