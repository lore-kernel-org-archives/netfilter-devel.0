From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: x_tables: speed up jump target validation
Date: Wed, 13 Jul 2016 01:12:14 +0200
Message-ID: <20160712231214.GA16108@breakpoint.cc>
References: <1468341323-15047-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, wujiafu@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41560 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbcGLXMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 19:12:39 -0400
Content-Disposition: inline
In-Reply-To: <1468341323-15047-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> +	offsets = xt_alloc_entry_offsets(newinfo->number);
> +	if (!offsets)
> +		return -ENOMEM;
>  	i = 0;
>  	/* Walk through entries, checking offsets. */
>  	xt_entry_foreach(iter, entry0, newinfo->size) {
> @@ -717,15 +711,18 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
>  						 repl->underflow,
>  						 repl->valid_hooks);
>  		if (ret != 0)
> -			return ret;
> +			goto out_free;
> +		if (offsets && i < repl->num_entries)
> +			offsets[i] = (void *)iter - entry0;
>  		++i;

Ahem.  This superflous "offsets &&" hunk is a left-over of the old
version that did not -ENOMEM on xt_alloc_entry_offsets error.

I will submit a v2 tomorrow that removes this part.
