From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 1/3] netfilter: convert hook list to an array
Date: Wed, 23 Aug 2017 09:17:20 -0700
Message-ID: <1503505040.2499.60.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170823152627.19865-1-fw@strlen.de>
         <20170823152627.19865-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, aconole@bytheb.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36040 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932134AbdHWQRW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 12:17:22 -0400
Received: by mail-pf0-f195.google.com with SMTP id c15so409243pfm.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:17:22 -0700 (PDT)
In-Reply-To: <20170823152627.19865-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2017-08-23 at 17:26 +0200, Florian Westphal wrote:
> From: Aaron Conole <aconole@bytheb.org>

...

> -static struct nf_hook_entry __rcu **nf_hook_entry_head(struct net *net, const struct nf_hook_ops *reg)
> +static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
> +{
> +	struct nf_hook_entries *e;
> +	size_t alloc = sizeof(*e) +
> +		       sizeof(struct nf_hook_entry) * num +
> +		       sizeof(struct nf_hook_ops *) * num;
> +
> +	if (num == 0)
> +		return NULL;
> +
> +	e = kvmalloc(alloc, GFP_KERNEL);
> +	if (e) {
> +		memset(e, 0, alloc);
> +		e->num_hook_entries = num;
> +	}


nit:

	e = kvzalloc(alloc, GFP_KERNEL);
	if (e)
		e->num_hook_entries = num;


