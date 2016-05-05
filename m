From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -nf v7] netfilter: nftables: add connlabel set support
Date: Thu, 5 May 2016 13:54:32 +0200
Message-ID: <20160505115432.GA10879@salvia>
References: <1461664793-22342-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbcEELym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 07:54:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0BC7A4B9EE
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 13:54:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EB5BE179E5D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 13:54:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EFA791B300A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 13:54:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461664793-22342-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 26, 2016 at 11:59:53AM +0200, Florian Westphal wrote:
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 25998fa..4ef41a8 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -198,9 +198,22 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
>  		}
>  		break;
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS:
> +		if (nf_connlabels_replace(ct,
> +					  &regs->data[priv->sreg],
> +					  &regs->data[priv->sreg],
> +					  NF_CT_LABELS_MAX_SIZE / sizeof(u32)))
> +			goto err;
> +		break;
> +#endif
>  	default:
>  		break;
>  	}
> +
> +	return;
> +err:
> +	regs->verdict.code = NFT_BREAK;

This will trigger a warning when CONFIG_NF_CONNTRACK_LABELS is
disabled (the err: label will be unused).

I have fixed this here with:

+#ifdef CONFIG_NF_CONNTRACK_LABELS
+       case NFT_CT_LABELS:
+               if (nf_connlabels_replace(ct,
+                                         &regs->data[priv->sreg],
+                                         &regs->data[priv->sreg],
+                                         NF_CT_LABELS_MAX_SIZE / sizeof(u32))) {
+                       regs->verdict.code = NFT_BREAK;
+                       return;
+               }
+               break;
+#endif

But still I'm unsure we should stop evaluating the rule. How can we
reach this error situation?

Let me know, I can fix this locally, no need to resend a new patch.
Thanks.
