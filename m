From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] conntrack: labels: Avoid crash when labels file is not
 installed
Date: Tue, 25 Jul 2017 03:09:22 +0200
Message-ID: <20170725010922.GA28392@breakpoint.cc>
References: <20170725005508.30587-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50456 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753098AbdGYBLI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 21:11:08 -0400
Content-Disposition: inline
In-Reply-To: <20170725005508.30587-1-marcos.souza.org@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marcos Paulo de Souza <marcos.souza.org@gmail.com> wrote:
> [marcos@Icarus ~]$ conntrack -l something
> nfct_labelmap_new: No such file or directory
> Segmentation fault (core dumped)

conntrack should not pass NULL in the first place.
However I agree that lnf-conntrack should be more robust
so I applied this patch, thanks.

> This is my first patch to netfilter and conntrack-tools, so please let
> me know if I sent to the right place, or if the patch needs more work.

I changed patch title to 'labels: don't crash on NULL labelmap'.

>  int __labelmap_get_bit(struct nfct_labelmap *m, const char *name)
>  {
> -	unsigned int i = hash_name(name);
> +	unsigned int i;
> +	if (!m)
> +		return -1;
> +
> +	i = hash_name(name);
>  	struct labelmap_bucket *list = m->map_name[i];

I moved this a bit to avoid mixing declaration and code, but otherwise
it should be the same change.
