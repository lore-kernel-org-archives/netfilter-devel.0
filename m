From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3 -next] netfilter: nft_ct: labels get support
Date: Tue, 18 Feb 2014 09:58:47 +0000
Message-ID: <20140218095847.GA12178@macbook.localnet>
References: <1392715644-4458-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58276 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaBRJ6v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:58:51 -0500
Content-Disposition: inline
In-Reply-To: <1392715644-4458-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:27:22AM +0100, Florian Westphal wrote:
> Takes advantage of the fact that the number of labels is currently
> restricted to 2**128, ie. the extension area will always fit into
> nft register.
> 
> Patrick says the kernel registers need to be changed anyway to
> deal with concatentations so we will probably not run into issues
> when the number of labels increases in a future kernel release.
> 
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS: {
> +		struct nf_conn_labels *labels = nf_ct_labels_find(ct);
> +		unsigned int size;
> +
> +		if (!labels)
> +			goto err;

Is that really an error? I'd expect it to be equivalent with "no labels set",
which can also be matched on.

> +		size = labels->words * sizeof(long);
> +		if (size > sizeof(dest->data))
> +			goto err;

Can't we check that during ->init() if the number is limited anyway?

> +		memcpy(dest->data, labels->bits, size);
> +
> +		if (size < sizeof(dest->data))
> +			memset(((char *) dest->data) + size, 0,
> +			       sizeof(dest->data) - size);
> +		return;
> +	}
> +#endif
