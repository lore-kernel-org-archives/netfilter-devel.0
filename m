From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf-next] netfilter: acct: add support to accounters in nftables
Date: Mon, 12 Jan 2015 11:42:31 +0000
Message-ID: <20150112114230.GB3491@acer.localdomain>
References: <cover.1421059771.git.ana@soleta.eu>
 <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ana@soleta.eu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34555 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbALLme (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:42:34 -0500
Content-Disposition: inline
In-Reply-To: <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.01, ana@soleta.eu wrote:
> From: Ana Rey <ana@soleta.eu>
> 
> This adds accounting objects support to allow us to manipulate the nftables's
> extended accounting intraestructure.
> 
> +/**
> + * struct nft_acct - nf_tables acct instance
> + *
> + * @list: table acct list node
> + * @name: name of the acct
> + * @pkts:  number of packets
> + * @bytes:  number of bytes
> + * use: number of rule references to this acct
> + */
> +struct nft_acct {
> +	struct list_head	list;
> +	char                    name[NFT_ACCT_MAXNAMELEN];
> +	atomic64_t		pkts;
> +	atomic64_t		bytes;
> +	u32			use;
> +};

Also I think it would be nice to use the same accounting structure
for regular counters and these counters regarding the accounting
part. I'm not saying we should necessarily use the nft_counter
variant with a seqlock, but whatever reasoning we use to decide
for one variant should fully apply to the other as well.

The nft_acct would then simply be a container with a list_head,
a use counter and an embedded nft counter structure.
