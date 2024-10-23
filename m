Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6DB13C836;
	Wed, 23 Oct 2024 09:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729677394; cv=none; b=P7Fz0QpOrQP+hWXgm8h7dEDFJGzHUbMHX73y0T4A4mqgEIW9zEH91x4bbB8zRzghWV2SdI5y/Dw/S1z1SUGvU59NEM7i/qpTyxU1RsR02W8KHcGcl4yccS+7xjncJWhgHMCTQQKNOlp0QbSleRv/WIfH4/oyw+U2jItsbBwSPP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729677394; c=relaxed/simple;
	bh=TDOmQNRZS+Qs1U59yrJjSwxZlDkG7IUXbp5wL5bEbrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sts2fR+g4+LXGFxh9SjzHLmqLoqUSbzhiEnYz21J01JMSVp0J6TwgZ9ke+yGl8cxEWo89l2DRBbFIA/SmMLBhzRGNPRrn/QnFA68uNxPFVijH9cJZwowRme4mD3Zr/69Gxm8aw8+YpUg1u9rXcdQQxv86w7sElmx7RGMWuVUZ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pTbESDai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pTbESDai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7D8C4CEC6;
	Wed, 23 Oct 2024 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729677393;
	bh=TDOmQNRZS+Qs1U59yrJjSwxZlDkG7IUXbp5wL5bEbrk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pTbESDailmBr+rqmFqCE+z3hSs5LqubzYmqHcgbzPczuCHde+3H5iNBTfXtiWf7St
	 zyup/HN4MNG4hF73ANNrJEGaFCKcQdscjGt61iUw7MRfpmQ4w4LEejKWA9BO/gNJls
	 ffBXnpdf902MoeINC+RNOBIDWNjuossLfcIocyHHCG+eH3jcHiqyk2yAUP0+94zaQZ
	 YXy0fQWcG4B+KsEcU1G+en/M2x+yTBcQOAf2D1RJJDyAn4Kjgm9LPb8A0fvWJP610Q
	 jtc3kUalVoRMFk7bQ2F3nPin+EwVqRAqFP7nanq7Xco2q8pLcQTnIbDMexvFdjgMxw
	 dzPep7VW4JbLg==
Message-ID: <fde8d1b6-9812-418c-8ba4-ae2384251ee7@kernel.org>
Date: Wed, 23 Oct 2024 11:56:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] netfliter: xtables: fix typo causing some targets to not
 load on IPv6
Content-Language: en-GB
To: Ilya Katsnelson <me@0upti.me>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ilya,

On 18/10/2024 17:45, Ilya Katsnelson wrote:
> These were added with the wrong family in 4cdc55e, which seems
> to just have been a typo, but now ip6tables rules with --set-mark
> don't work anymore, which is pretty bad.

Funny, with this patch, now the v4 version doesn't work any more, which
is pretty bad as well ;-)

More seriously, it looks like your patch broke MPTCP selftests:


https://netdev-3.bots.linux.dev/vmksft-mptcp-dbg/results/826643/1-mptcp-join-sh/stdout

Two tests are now failing, because they can no longer add a mark:

> # iptables -t mangle -A OUTPUT -j MARK --set-mark 1
> Warning: Extension MARK revision 0 not supported, missing kernel module?
> iptables v1.8.10 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain OUTPUT

Please see below:

> diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
> index d80abd6ccaf8f71fa70605fef7edada827a19ceb..6dcf4bc7e30b2ae364a1cd9ac8df954a90905c52 100644
> --- a/net/netfilter/xt_NFLOG.c
> +++ b/net/netfilter/xt_NFLOG.c
> @@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
>  	{
>  		.name       = "NFLOG",
>  		.revision   = 0,
> -		.family     = NFPROTO_IPV4,
> +		.family     = NFPROTO_IPV6,

Here, by setting the family to v6 instead of v4, we now have two targets
that are exactly the same, both for v6:

>   67   │ static struct xt_target nflog_tg_reg[] __read_mostly = {
>   68   │     {
>   69   │         .name       = "NFLOG",
>   70   │         .revision   = 0,
>   71   │         .family     = NFPROTO_IPV6,  /* <== The line you modified */
>   72   │         .checkentry = nflog_tg_check,
>   73   │         .destroy    = nflog_tg_destroy,
>   74   │         .target     = nflog_tg,
>   75   │         .targetsize = sizeof(struct xt_nflog_info),
>   76   │         .me         = THIS_MODULE,
>   77   │     },
>   78   │ #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>   79   │     {
>   80   │         .name       = "NFLOG",
>   81   │         .revision   = 0,
>   82   │         .family     = NFPROTO_IPV6,  /* <== v6 was already there */
>   83   │         .checkentry = nflog_tg_check,
>   84   │         .destroy    = nflog_tg_destroy,
>   85   │         .target     = nflog_tg,
>   86   │         .targetsize = sizeof(struct xt_nflog_info),
>   87   │         .me         = THIS_MODULE,
>   88   │     },
>   89   │ #endif
>   90   │ };

Are you sure you didn't have the bug you mentioned because your kernel
config doesn't have CONFIG_IP6_NF_IPTABLES?

>  		.checkentry = nflog_tg_check,
>  		.destroy    = nflog_tg_destroy,
>  		.target     = nflog_tg,
> diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
> index f76fe04fc9a4e19f18ac323349ba6f22a00eafd7..65b965ca40ea7ea5d9feff381b433bf267a424c4 100644
> --- a/net/netfilter/xt_mark.c
> +++ b/net/netfilter/xt_mark.c
> @@ -62,7 +62,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
>  	{
>  		.name           = "MARK",
>  		.revision       = 2,
> -		.family         = NFPROTO_IPV4,
> +		.family         = NFPROTO_IPV6,

Same here.

So I think this patch is not needed, right?

>  		.target         = mark_tg,
>  		.targetsize     = sizeof(struct xt_mark_tginfo2),
>  		.me             = THIS_MODULE,
> 
> ---
> base-commit: 75aa74d52f43e75d0beb20572f98529071b700e5
> change-id: 20241018-xtables-typos-dfeadb8b122d
> 
> Best regards,

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

