Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3B03DB319
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787741187; cv=none; b=aRRN81SNCgFbn4svHBMeZ7nXds6FVF+NfmYFOyTxEXu7IvOmrX32KBBDKf0tOXxotCiOqBWp63UOjA1ZY5hYD9bL2WlP1Hkq6mULKAvcsr00WXx7hvCuo8s4/goLUteJcV2dmkGwFM+b6wouUQzyBZbwqXLLgg21wrUC9XOSLFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787741187; c=relaxed/simple;
	bh=9DMgyNm2CJeujBlHdcg1IU94T2y//D81mklUv76LSYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfjviqExVIZSAbsceIsrE95+OxgjjUM441Wwyh/YpRUBxdIdOQ5jpSQaPgPruxBw+P3p5XOORIfUu8uF5KvWVD87/5+nElGDCRl+egN5U6VOt+6D3O/bnMTZRnJNKQR+raGZpE68xaoAEUdHtm+1+TlbAxiQGn6pYmpmmKNyPyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=id6q+Qws; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="id6q+Qws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DH7vMX6y60C5vp4LJnaYjc2lPpktCgzb8875n0WXDXg=; b=id6q+QwszBPf15Jn9k7WE9X+yP
	9TaSmA04mZgcrB6Bixk76kP9wq8fwYINb28YobyELiAdzz3LeNudjf40xwEX7kNR30qJldeEIsNuR
	b2+4Z/nFIZv3p3PE03k8khTxOKXy9tTeIJVNlEgwWSeEkkWpmJf5JFRPJu4ZbT9IrSZhBH8z2cK3H
	OglWJ+X40YFb0q7sRyvDJAQVa5AeNmdKujYBPfZY8pKgM7RnKK1Qi6HTfH9M/nnnp3xivljPAwCQ3
	4Aoj1BgazXN4IbS26t2Poixdi5xcOb+k/EUqIFTnbbtYm53SIEw4kzokHmvoM6+23LI2Sbmq3nOBb
	Qx8pv0XQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzB97-000000006Qd-2qqA;
	Wed, 26 Aug 2026 12:46:17 +0200
Date: Wed, 26 Aug 2026 12:46:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <ao7D-ZH3oN8qrxw9@orbyte.nwl.cc>
References: <20260824092805.4940-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824092805.4940-1-fmancera@suse.de>

On Mon, Aug 24, 2026 at 11:28:05AM +0200, Fernando Fernandez Mancera wrote:
> Currently, a netdev chain or flowtable hooked to a device prefix can be
> unintentionally deleted by a control-plane request targeting an exact
> device name or even a shorter one due to the usage of min() to calculate
> the length to match.
> 
> Fix this by making sure an exact device match never matches a prefix and
> that both the target and the candidate have the same length during
> delete operation. The add and update paths retain the existing overlap
> matching to prevent a single device from matching multiple hooks.
> 
> Reported-by: Wei Fang <void0red@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/nf_tables_api.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c112ecc4fca3..3ad9a5e88c5b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>  	return -ENOSPC;
>  }
>  
> -static bool hook_is_prefix(struct nft_hook *hook)
> +static bool hook_is_prefix(const struct nft_hook *hook)
>  {
>  	return strlen(hook->ifname) >= hook->ifnamelen;
>  }
> @@ -2457,6 +2457,27 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>  	return NULL;
>  }
>  
> +static struct nft_hook *nft_hook_list_find_strict(struct list_head *hook_list,
> +						  const struct nft_hook *this)
> +{
> +	struct nft_hook *hook;
> +
> +	list_for_each_entry(hook, hook_list, list) {
> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
> +			continue;

I don't think this is necessary: The first ifnamelen chars of both
hooks' ifname either contain the NUL-char or not. If both ifnamelen
values are identical, the following strncmp will only match if either
both are prefixes or both are not.

(I realized my initial approach using max() won't work when comparing
"eth0\0" (non-prefix) to "eth0" (prefix) as the latter is followed by
NUL-chars as well.)

> +		if (hook->ifnamelen != this->ifnamelen)
> +			continue;

Given the above, this could become 'if (strict && hook-ifnamelen !=...)'
in nft_hook_list_find with extra parameter, up to you.

Thanks, Phil
