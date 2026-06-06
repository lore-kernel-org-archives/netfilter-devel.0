Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E8A313E31
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jun 2026 08:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780734100; cv=none; b=sakmgxx7kGYmr55JmyOYLP4Xs56botDohyt/3tl28+L+3X6lCE8ygHqbXYgHItWQeDPLpUSLsJW/tdJwCIYr4HZJPS92MUX5Uia6PTpp1j8tF/Rcg4q6gXumgFpqap7MyQlkccpbpOP4u46PUOCKl1Zb5RpeWBL98+zdu0iLwRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780734100; c=relaxed/simple;
	bh=KGaiIjELfsjrDD17Fw96eMzzOu6yY9SIPVjLf/e/kl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCAtKLJxbyu14vekOt1GGxaJulyCSg0le3tyUZpqYtWVsowAoJCkdkZpQFRz2H4tGeCBrBU/eNDKdCVB3Heayb6MoKJdJ/C9azGRrJGStwO4VpAuO6SghpYAQbgSxtUgghVL3x1Yhp8XixbYx678blk9MdanmT6oQAIXvqNAnbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F1E4E60337; Sat, 06 Jun 2026 10:21:28 +0200 (CEST)
Date: Sat, 6 Jun 2026 10:21:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, royenheart@gmail.com
Subject: Re: [PATCH nf v4 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
Message-ID: <aiPYhDrNiGuyRtGo@strlen.de>
References: <cbc3a29c0654e8fcee30cb021d57883fed77fafc.1780630094.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc3a29c0654e8fcee30cb021d57883fed77fafc.1780630094.git.royenheart@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  	const struct sk_buff *skb = entry->skb;
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net_device *dev = NULL;
>  
>  	if (nf_bridge_info_exists(skb)) {
>  		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
> @@ -92,6 +95,17 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
>  		entry->physin = NULL;
>  		entry->physout = NULL;
>  	}
> +
> +	if (entry->state.pf == NFPROTO_BRIDGE &&
> +	    nf_bridge_info_exists(skb) &&

Is this check redundant?

> +	    dst && (dst->flags & DST_FAKE_RTABLE))

... this should be enough.  In which cases can we have
FAKE_RTABLE and !nf_bridge_info_exists() ?

>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	dev_hold(entry->bridge_dev);

LGTM, however, in last iteration sashiko complained that dev_cmp() in
nfnetlink_queue.c should gain a bridge_dev->ifindev check so that entries
are reaped in case bridge goes down.

Could you send a v5 that adds this test? Everything else here LGTM.
