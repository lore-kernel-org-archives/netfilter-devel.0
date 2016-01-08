From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] nftables: ct: add byte/packet counter support
Date: Fri, 8 Jan 2016 13:38:18 +0100
Message-ID: <20160108123818.GB4816@salvia>
References: <1452198864-10134-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35100 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbcAHMi1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 07:38:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9940CB5A623
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:38:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B664DA809
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:38:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A39CDDA809
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:38:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452198864-10134-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 07, 2016 at 09:34:24PM +0100, Florian Westphal wrote:
> @@ -366,6 +398,13 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  		goto nla_put_failure;
>  
>  	switch (priv->key) {
> +	case NFT_CT_BYTES:
> +	case NFT_CT_PKTS:
> +		if ((priv->dir == IP_CT_DIR_ORIGINAL ||
> +		     priv->dir == IP_CT_DIR_REPLY) &&
> +		     nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
> +			goto nla_put_failure;
> +		break;
>  	case NFT_CT_PROTOCOL:

Any concern if I fold this change into your patch? It just simplifies
this check, see below:

        switch (priv->key) {
        case NFT_CT_BYTES:
        case NFT_CT_PKTS:
-               if ((priv->dir == IP_CT_DIR_ORIGINAL ||
-                    priv->dir == IP_CT_DIR_REPLY) &&
-                    nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
+               if (priv->dir < IP_CT_DIR_MAX &&
+                   nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
                        goto nla_put_failure;
                break;
        case NFT_CT_PROTOCOL:

Thanks.
