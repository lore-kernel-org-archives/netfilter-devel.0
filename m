From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: add support for listing the entire ruleset
Date: Sat, 4 Jan 2014 02:30:51 +0100
Message-ID: <20140104013051.GA5504@localhost>
References: <20131231184002.25829.99216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbaADBa5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:30:57 -0500
Content-Disposition: inline
In-Reply-To: <20131231184002.25829.99216.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Tue, Dec 31, 2013 at 07:40:02PM +0100, Arturo Borrero Gonzalez wrote:
> This patch add the following operation:
> 
>  :~# nft list ruleset [xml|json]
> 
> With this, you can backup your current ruleset in 3 formats:
>  * nft standar/default
>  * xml
>  * json

This feature is nice, I prefer if we use the following syntax:

nft export <xml|json>

So you can implement:

nft import <xml|json> filename

with the new nft_*_parse_file() function that you posted.

> The XML/JSON output is provided raw by libnftables, thus without format.
> In case of XML, you can give format with the `xmllint' tool from libxml2-tools:
>  :~# nft list ruleset xml | xmllint --format -
> In case of JSON, you can use `json_pp' from perl standar package:
>  :~# nft list ruleset json | json_pp
> 
> Exporting your ruleset gives the possibility of a later import. In default
> nft format, the workflow is as follow:
> 
>  :~# nft list ruleset > ruleset.nft
>  :~# nft -f ruleset.nft
> 
> In XML/JSON format, the import operation is currently under development.
> 
> About this implementation:
> 
> By now, `struct netlink_ctx' can't handle a complete ruleset, so the ruleset
> listing operation is done as follow.
> 
> if XML/JSON:
>  * Obtain the ruleset from the kernel, 4 queries (one per object type),
>    using NFPROTO_UNSPEC. Note that this requires sets to be fetched with
>    NFPROTO_UNSPECT. This is an incoming kernel patch.
>  * Call libnftables's nft_ruleset_fprintf() directly.
> 
> if default nft format:
>  * Obtain tables from kernel, using NFPROTO_UNSPEC (one netlink query).
>  * Iterate these obtained tables calling recursively do_command_list(). This is
>    done by filling a temporal netlink_ctx, and using it as an index.
>  * Proceed normally as when listing one single table (several netlink queries).
> 
> I would prefer to have just one path to print the ruleset, but I can't avoid
> modifying netlink_ctx, and seems a major change to me.

This patch looks relatively small and non-intrusive to the nft
internal structure, I think this is the way to go.
