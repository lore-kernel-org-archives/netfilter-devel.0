Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE763B83E1
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740189; cv=none; b=IxC2h0rjmQpZueY1o8igsm2U6DNmaUihfy6UMgB0cNdByRDOvExydeN/Bx+/K1DzuczIlp28rC6cKOqLRit/qa0LLUkIiYcrhEAfgQ8HK2At2aG7Up2gV5LvsyIPE5ANYeqmUCN3Ce1e6N4K0DsF+Sreist4zKpm6KGKdnyT9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740189; c=relaxed/simple;
	bh=YrKRGU4pZg9DeVmLC9ZVAhJPUJmmIBNKwicn8y5MQyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rY5SyH6S+fvMIF9JpfqRFVtd2EVXKHxN16eRi87dYCfHaNEQd644HWg8cxy+p91OEfKCyRfNSU44XNq8t0nM8pyDjtriO5nA/d7xtGyVMTr7qWOYX7eJIyxjAhTFpaoZSm36u2qT01i+OB4fpTuz3Clr783czc/iHdk6YK2gAZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Mf42pLmB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Mf42pLmB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9P6nPYEZce+3A4I9qvW6jQRuTxt6iduh/Bo6BRDBUwQ=; b=Mf42pLmBf6Cx8qPQqxXJctTMHu
	7sIVw98vcxgc4QVfL8RbCxT2/eLh+bJNn8sXqDKOJaehiQkRw1Fr/Eft/eGHkbihaKwG2uBtzg+Xm
	pSYobX4tgZeoe1u6uCQSishcjIcILwLlcVSDL6VeWEuQNdQml8jwAnJQ9xKiDnlsMc4RGTAX44Qdr
	ix06jACSV9GphjCRWiuGMFvIg9pqgXiOL/zPpaj69mmo+LVLC8lM8RECSE4y9hQvBNcuyrFTUiO9a
	fKAEQQ+W63kJVyRh7/Cx2+oOV281Cm2oYAeIQ076T8q+piuZH4XERHtvruZQi/5MjVF3DtSIrLiWn
	WSFo265w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzAmQ-000000006BA-0Khi;
	Wed, 26 Aug 2026 12:22:50 +0200
Date: Wed, 26 Aug 2026 12:22:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <ao6-eoTsgfs2cyc5@orbyte.nwl.cc>
References: <20260818101825.8213-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818101825.8213-1-fmancera@suse.de>

Hi Fernando,

On Tue, Aug 18, 2026 at 12:18:25PM +0200, Fernando Fernandez Mancera wrote:
> Currently, a netdev chain or flowtable hooked to a device prefix can be
> unintentionally deleted or updated by a control-plane request targeting
> an exact device name or even a shorter one due to the usage of min() to
> calculate the length to match.
> 
> Fix this by making sure an exact device match never matches a prefix and
> that both the target and the candidate have the same length.
> 
> Reported-by: Wei Fang <void0red@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/nf_tables_api.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index af357f6c5070..e2b18c4722fc 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1973,7 +1973,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>  	return -ENOSPC;
>  }
>  
> -static bool hook_is_prefix(struct nft_hook *hook)
> +static bool hook_is_prefix(const struct nft_hook *hook)
>  {
>  	return strlen(hook->ifname) >= hook->ifnamelen;
>  }
> @@ -2440,8 +2440,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>  	struct nft_hook *hook;
>  
>  	list_for_each_entry(hook, hook_list, list) {
> -		if (!strncmp(hook->ifname, this->ifname,
> -			     min(hook->ifnamelen, this->ifnamelen))) {
> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
> +			continue;
> +		if (hook->ifnamelen != this->ifnamelen)
> +			continue;
> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
>  			if (hook->flags & NFT_HOOK_REMOVE)
>  				continue;

I think this fix introduces another issue, when adding another prefix to
a flowtable/chain which partially matches an existing prefix. E.g.,
adding "eth*" with "eth0*" present must be rejected since we otherwise
end up trying to register a new interface "eth007" to two hooks at the
same time.

Maybe we need a "bool exact" flag which turns the min() intoa a max()?
(untested ;)

Cheers, Phil
