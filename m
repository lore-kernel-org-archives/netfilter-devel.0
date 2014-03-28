From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Fri, 28 Mar 2014 12:15:27 +0000
Message-ID: <20140328121527.GA7610@macbook.localnet>
References: <20140328114622.8896.14752.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55063 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaC1MPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:15:31 -0400
Content-Disposition: inline
In-Reply-To: <20140328114622.8896.14752.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 12:46:22PM +0100, Arturo Borrero Gonzalez wrote:
> +static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
> +				    const struct nft_set *set,
> +				    const struct nft_set_elem *elem,
> +				    int event, u16 flags)
> +{
> ...
> +	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
> +			     GFP_KERNEL);
> +err_free:
> +	kfree_skb(skb);

There's the reason of your crash. You must not free the skb after sending it.
