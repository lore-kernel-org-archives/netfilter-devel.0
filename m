From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: add optional user data area to
 rules
Date: Wed, 26 Feb 2014 12:05:06 +0000
Message-ID: <20140226120506.GC24874@macbook.localnet>
References: <1393379592-16312-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaBZMFK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:05:10 -0500
Content-Disposition: inline
In-Reply-To: <1393379592-16312-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 02:53:12AM +0100, Pablo Neira Ayuso wrote:
> This allows us to store user comment strings, but it could be also
> used to store any kind of information that the user application needs
> to link to the rule.
> 
>  struct nft_rule {
>  	struct list_head		list;
> -	u64				handle:46,
> -					genmask:2,
> -					dlen:16;
> +	u64				handle;
> +	u32				dlen;
> +	u32				genmask:2,
> +					ulen:30;

This increases the size of the rule by 8 bytes. I'd suggest to scrape
that off elsewhere. First of all, we probably don't need 16 bytes for
the rule length, 12 == 4k should be enough. The other 4 bits could
be taken from the handle I suppose, 2^42 should still be enough. Assuming
1000 new rules per second it would still last for 139 years :)
