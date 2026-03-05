Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7DA35DA52
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 13:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772717107; cv=none; b=Z9Y9mb9wR1krjwT8NHTl0qeKbrsq1Wg+x5jdZ3C+dp/6CuFCPVhoSPJAlaoXtU+helm/slSqBuxK/BRuJ2rBOPYjvu5DsOM4HFCVgIb4tFplJP9JIM4RRjWh4ORG0awWvvkV78PnRurHiKrheD1tbmqgZ6LuyJc/MALDLYxH2cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772717107; c=relaxed/simple;
	bh=cMaZtaRlr03JuhZgLbwqShf2V3BIn6k4exYR6whdG2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jkXZB3OUEvgHMU1YyNqmFk3isNvoEmQMN4vxxJ2HdE30AevuX/Cxgq+SCdC3KZ90Br8Zi27DvdlPus3tIcdGzCrdpLqyMEohnlCGJTg5fNY94gftCpaZLdyF/yIydDe7MvtHu23BPgsyIFEN9OowSx1B8tS5ANL7Cv3gnsNKIpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=in0Qg0Zp; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="in0Qg0Zp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VFrU45yy+yQSpc0PxoFkhecZRVdjYVKJaratpQDmFkE=; b=in0Qg0ZpM8t8H3ykI1mbJ0sxym
	fJnPzR4ZOtchIKgMtm1dA6AhM5v7ozry3tBGK7W0djb5PJyWL040rNGb//cUWfBPagyV3qtWNQiRh
	1lC7tR34ToXR2qjVWcDA03sQP8NzrHcSHTqyE6IvUr+GHVJMDopjC10Y9vLYHiL42DNzuKj6Bv+Tu
	ZZVWM3Ur8EeHNEvMD2pD6emyfkB2y+9uhlDUDFAacwmqRVsLFfZoxOeGDe7B76TUJ6pA7oAwMV3D2
	038jKFRr/HUDPHwfxZR4ZGYS1HcwYKdZOmbjWb+0AwoF7r6Llhq8cH3spLerJhJ6njfEgFYgi0+fm
	FKzYaSRQ==;
Received: from [179.221.50.217] (helo=[192.168.0.108])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vy8hG-009NP7-VR; Thu, 05 Mar 2026 14:24:59 +0100
Message-ID: <2c103e29-961c-4063-a757-c51367da8e60@igalia.com>
Date: Thu, 5 Mar 2026 10:24:54 -0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix for duplicate device in
 netdev hooks
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
 syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
References: <20260305120144.26350-1-phil@nwl.cc>
Content-Language: en-US
From: Helen Koike <koike@igalia.com>
In-Reply-To: <20260305120144.26350-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/5/26 9:01 AM, Phil Sutter wrote:
> When handling NETDEV_REGISTER notification, duplicate device
> registration must be avoided since the device may have been added by
> nft_netdev_hook_alloc() already when creating the hook.
> 
> Cc: Helen Koike <koike@igalia.com>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
> Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

I tested and validated this fixes the use-after-free as reported by syzbot.

Tested locally with Qemu using the disk image and reproducer from syzbot.

Tested-by: Helen Koike <koike@igalia.com>

Thanks,
Helen

> ---
>   net/netfilter/nf_tables_api.c    | 2 +-
>   net/netfilter/nft_chain_filter.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0c5a4855b97d..29f54998a637 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9679,7 +9679,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
>   			break;
>   		case NETDEV_REGISTER:
>   			/* NOP if not matching or already registered */
> -			if (!match || (changename && ops))
> +			if (!match || ops)
>   				continue;
>   
>   			ops = kzalloc(sizeof(struct nf_hook_ops),
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index b16185e9a6dd..041426e3bdbf 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -344,7 +344,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
>   			break;
>   		case NETDEV_REGISTER:
>   			/* NOP if not matching or already registered */
> -			if (!match || (changename && ops))
> +			if (!match || ops)
>   				continue;
>   
>   			ops = kmemdup(&basechain->ops,

