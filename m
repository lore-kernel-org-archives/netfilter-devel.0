Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E228DB45
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747927618; cv=none; b=d+A7sSQ67KmHYxhV1oEKPN/AlC1upzE8sMWZ21N2wGx6+KNu3iIkQYobvsO7om2K5xEdnMgu7KHpmQXWPl41Y6CPGDjlV9ucNAkgG0lTVBpwZ0VEqypb2lWthUW521moHnw9SYBWAXp3BniVgIp4BKF7eMet4xfozYWG3mk/qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747927618; c=relaxed/simple;
	bh=f2vb0tjCW8PctDevT/qfR7uOCgx2E8+54hy/aIA7sFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZNtqnjxfhpjMZrpXo1mfFl1CwX76LIDWkv9wE6dZzR1nr7aOZOXH1vh7WI+VxMbvSZmMjb8vgeAnALXPgAbc6vyrQk6J1xrXcyd7kPRaLXBmmvOEaHiP09+68IViwekhKoOakjc31bt6BraHBtzq0VEE1N/F5mZDubc+EOa2EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AAiyo4dy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f+2xWFWj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AAiyo4dy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f+2xWFWj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CB9E5606AE; Thu, 22 May 2025 17:26:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747927613;
	bh=guOxjV5uPTLDXHqGZqGTqWS0tR6f5qZuswP+wf8oZvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AAiyo4dy33PUmZUIxznMrLfECYKU0FcACvx8Ct2dNsz8AfHwZi/laDKeVgSEG+cec
	 IjT6sH+g5BNdvo87vYEnhNDR69dJSGg7ZVmc1Fgf3LWgc65HPYtwC5tDpjbKFATr+b
	 S7qRA1zB7E23kr/UjgKs2qyJ9FLDBnopYcBRhJZu9RRtoIKhKma5r+BWzP/UWUr3Q3
	 dieGZ4U736QAksyQLHlDQMD5faZcFMowGPFvpH2cBnd9x3eEvE7V6cvM7GQdZyW0YN
	 AbKs8o8EtqxZCaXSOpT5WhVuU5FHaBZHBJ2AcCx8lKMc0DG0kuYI+olacCk0L+UA6j
	 DFCYEt19gVwiA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7FEF5606AE;
	Thu, 22 May 2025 17:26:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747927612;
	bh=guOxjV5uPTLDXHqGZqGTqWS0tR6f5qZuswP+wf8oZvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f+2xWFWjEdQ7gqZRwa9hk6j2zTVIOdCma230p4MSQ3SMMP/rYBrc5ijiFfsztRgWW
	 rtczjwrGp18OQyZKauVLfhNTZnX1Ibm31XB90CjwE1R/3VknI8/DAOu62xsHxZ9KzO
	 PHpS5aGpHsEuITFwP5DrKro0W8SsvtPMqCDY41J1BAoGALl81oLkK6Jpp2vkL5dQHA
	 4HmUs7+Z0gC9xlEgYxbzFFQmoVvs2vPBmFa4cBbPlFn5KdzbkdvkvkViVQnRAYslDG
	 kHIlXtGBJpGnGntGU71xTX1vtGxiA+hGCg7KrxAyVbsRXcIeYH5G0ssXaM8nEJs51t
	 rkTCSjFgfIgdg==
Date: Thu, 22 May 2025 17:26:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v7 12/13] netfilter: nf_tables: Add notifications
 for hook changes
Message-ID: <aC9COQreWoVMhSEq@calendula>
References: <20250521204434.13210-1-phil@nwl.cc>
 <20250521204434.13210-13-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250521204434.13210-13-phil@nwl.cc>

On Wed, May 21, 2025 at 10:44:33PM +0200, Phil Sutter wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a7240736f98e..268bc00fe2ec 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9686,6 +9686,64 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
>  }
>  EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
>  
> +static void
> +nf_tables_device_notify(const struct nft_table *table, int attr,
> +			const char *name, const struct nft_hook *hook,
> +			const struct net_device *dev, int event)
> +{
> +	struct net *net = dev_net(dev);
> +	struct nlmsghdr *nlh;
> +	struct sk_buff *skb;
> +	u16 flags = 0;
> +
> +	if (!nfnetlink_has_listeners(net, NFNLGRP_NFT_DEV))
> +		return;
> +
> +	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		goto err;
> +
> +	event = event == NETDEV_REGISTER ? NFT_MSG_NEWDEV : NFT_MSG_DELDEV;
> +	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
> +	nlh = nfnl_msg_put(skb, 0, 0, event, flags, table->family,
> +			   NFNETLINK_V0, nft_base_seq(net));
> +	if (!nlh)
> +		goto err;
> +
> +	if (nla_put_string(skb, NFTA_DEVICE_TABLE, table->name) ||
> +	    nla_put_string(skb, attr, name) ||
> +	    nla_put(skb, NFTA_DEVICE_SPEC, hook->ifnamelen, hook->ifname) ||
> +	    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
> +		goto err;
> +
> +	nlmsg_end(skb, nlh);
> +	nfnetlink_send(skb, net, 0, NFNLGRP_NFTABLES,
                                    ^..............^
                                    NFNLGRP_NFT_DEV))


> +		       nlmsg_report(nlh), GFP_KERNEL);
> +	return;
> +err:
> +	if (skb)
> +		kfree_skb(skb);
> +	nfnetlink_set_err(net, 0, NFNLGRP_NFTABLES, -ENOBUFS);
> +}
