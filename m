From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH] src: add import operation
Date: Wed, 12 Nov 2014 14:17:33 +0100
Message-ID: <20141112131733.GA1846@salvia>
References: <20141021112420.11406.7309.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54227 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaKLNPj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:15:39 -0500
Content-Disposition: inline
In-Reply-To: <20141021112420.11406.7309.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 01:25:47PM +0200, Arturo Borrero Gonzalez wrote:
> The import operation reads a XML or JSON file, with syntax:
>  % nft import {xml|json}
> 
> A basic way to test this new functionality is:
>  % nft export xml | nft import xml
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> 
> NOTE: This patchs requires:
> 	* [nft] mnl: delete useless parameter nf_sock in batch functions
> 	* [libnftnl] ruleset: deconstify _get interface
> 
> Please comment :-)

The existing approach doesn't support incremental updates. I think
it's important to provide a way to say: 'add this and delete that'
when importing something too, so this interface becomes equivalent to
nft -f.

I think we need a new _parse_file() function to takes a callback as
argument. This callback is invoked per object parsed from the file, so
we can reuse the existing "struct cmd" in nft. I think it's important
to consolidate code, the existing approach where we have different
code to do basically the same is not desirable.

> +int mnl_nft_ruleset_batch_add(const struct nft_ruleset *rs,
> +			      uint32_t table_flags, uint32_t chain_flags,
> +			      uint32_t set_flags, uint32_t rule_flags)

[...]

> +	ret = mnl_nft_ruleset_batch_add(rs, 0, 0, 0, 0);

So we don't make any global assumption on the flags and so on.

Thanks.
