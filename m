Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F74BE743FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 09:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjI2JLy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjI2JLx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 05:11:53 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC71180
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 02:11:50 -0700 (PDT)
Received: from [78.30.34.192] (port=36658 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qm9XG-008Fq6-KC; Fri, 29 Sep 2023 11:11:48 +0200
Date:   Fri, 29 Sep 2023 11:11:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, David Ward <david.ward@ll.mit.edu>
Subject: Re: [PATCH nf] netfilter: nft_payload: rebuild vlan header on
 h_proto access
Message-ID: <ZRaU0WT2PVRpFUoX@calendula>
References: <20230929084213.19401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230929084213.19401-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 29, 2023 at 10:42:10AM +0200, Florian Westphal wrote:
> nft can perform merging of adjacent payload requests.
> This means that:
> 
> ether saddr 00:11 ... ether type 8021ad ...
> 
> is a single payload expression, for 8 bytes, starting at the
> ethernet source offset.
> 
> Check that offset+length is fully within the source/destination mac
> addersses.
> 
> This bug prevents 'ether type' from matching the correct h_proto in case
> vlan tag got stripped.

Patch LGTM, thanks for fixing my bug.

> Fixes: de6843be3082 ("netfilter: nft_payload: rebuild vlan header when needed")
> Reported-by: David Ward <david.ward@ll.mit.edu>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_payload.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index 8cb800989947..120f6d395b98 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -154,6 +154,17 @@ int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
>  	return pkt->inneroff;
>  }
>  
> +static bool nft_payload_need_vlan_copy(const struct nft_payload *priv)
> +{
> +	unsigned int len = priv->offset + priv->len;
> +
> +	/* data past ether src/dst requested, copy needed */
> +	if (len > offsetof(struct ethhdr, h_proto))
> +		return true;
> +
> +	return false;
> +}
> +
>  void nft_payload_eval(const struct nft_expr *expr,
>  		      struct nft_regs *regs,
>  		      const struct nft_pktinfo *pkt)
> @@ -172,7 +183,7 @@ void nft_payload_eval(const struct nft_expr *expr,
>  			goto err;
>  
>  		if (skb_vlan_tag_present(skb) &&
> -		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
> +		    nft_payload_need_vlan_copy(priv)) {
>  			if (!nft_payload_copy_vlan(dest, skb,
>  						   priv->offset, priv->len))
>  				goto err;
> -- 
> 2.41.0
> 
