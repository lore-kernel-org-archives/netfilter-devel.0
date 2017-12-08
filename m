From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [PATCH v3 nf-next] netfilter: connlimit: split xt_connlimit into front/backend
Date: Thu, 7 Dec 2017 22:06:19 -0800
Message-ID: <CAG1aQh+TyBTXsCO0Whtfs12=tpnc8n4kBkVDMGcu0wWbfnt31g@mail.gmail.com>
References: <20171206124112.21239-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37636 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdLHGGk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 01:06:40 -0500
Received: by mail-yw0-f196.google.com with SMTP id v190so3900304ywg.4
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Dec 2017 22:06:40 -0800 (PST)
In-Reply-To: <20171206124112.21239-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 6, 2017 at 4:41 AM, Florian Westphal <fw@strlen.de> wrote:
> +static int __init nf_conncount_modinit(void)
> +{
> +       int ret, i;
> +
> +       BUILD_BUG_ON(CONNCOUNT_LOCK_SLOTS > CONNCOUNT_SLOTS);
> +       BUILD_BUG_ON((CONNCOUNT_SLOTS % CONNCOUNT_LOCK_SLOTS) != 0);
> +
> +       for (i = 0; i < CONNCOUNT_LOCK_SLOTS; ++i)
> +               spin_lock_init(&nf_conncount_locks[i]);
> +
> +       conncount_conn_cachep = kmem_cache_create("nf_conncount_tuple",
> +                                          sizeof(struct nf_conncount_tuple),
> +                                          0, 0, NULL);
> +       if (!conncount_conn_cachep)
> +               return -ENOMEM;
> +
> +       conncount_rb_cachep = kmem_cache_create("nf_conncount_rb",
> +                                          sizeof(struct nf_conncount_rb),
> +                                          0, 0, NULL);
> +       if (!conncount_rb_cachep) {
> +               kmem_cache_destroy(conncount_conn_cachep);
> +               return -ENOMEM;
> +       }
> +
> +       return ret;
I test it with iptables -m connlimit, and nf_conncount may fail to
load sometimes.

It turns out that it is because ret is not used in this function.
Shall we get rid of ret, and return 0 here?

Thanks,

-Yi-Hung
