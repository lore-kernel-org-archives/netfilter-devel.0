From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: connlimit: split xt_connlimit into front/backend
Date: Tue, 5 Dec 2017 16:55:11 -0800
Message-ID: <CAG1aQhJFE3BLkUcOx+Eb2FiCz5xH5Ui8Q5RmnRw5Q6+rePk=Uw@mail.gmail.com>
References: <20171202094914.11364-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35698 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753795AbdLFAzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Dec 2017 19:55:32 -0500
Received: by mail-yb0-f194.google.com with SMTP id k2so858032ybd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Dec 2017 16:55:32 -0800 (PST)
In-Reply-To: <20171202094914.11364-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for working on this patch.

> --- /dev/null
> +++ b/include/net/netfilter/nf_conntrack_count.h
> @@ -0,0 +1,13 @@
Should it have something like the following in the header file?

#ifdef _NF_CONNTRACK_COUNT_H
#define _NF_CONNTRACK_COUNT_H

> +struct nf_conncount_data;
> +
> +struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
> +                                           unsigned int keylen);
> +void nf_conncount_destroy(struct net *net, unsigned int family,
> +                         struct nf_conncount_data *data);
> +
> +unsigned int nf_conncount_count(struct net *net,
> +                               struct nf_conncount_data *data,
> +                               const u32 *key,
> +                               unsigned int family,
> +                               const struct nf_conntrack_tuple *tuple,
> +                               const struct nf_conntrack_zone *zone);

#endif /*_NF_CONNTRACK_COUNT_H*/


> --- /dev/null
> +++ b/net/netfilter/nf_conncount.c
> +
> +struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
> +                                           unsigned int keylen)
> +{
> +       struct nf_conncount_data *data;
> +       int ret, i;
> +
> +       if (keylen % sizeof(u32) ||
> +           keylen / sizeof(u32) > MAX_KEYLEN ||
> +           keylen == 0)
> +               return ERR_PTR(-EINVAL);
Just wanna to check the case that if users want to count only by zone,
since zone id is only 2 bytes, the user should claim 4 bytes as the
keylen right?


> +
> +       net_get_random_once(&conncount_rnd, sizeof(conncount_rnd));
> +
> +       ret = nf_ct_netns_get(net, family);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +
> +       data = kmalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return ERR_PTR(-ENOMEM);
Should we call nf_ct_netns_put() in the error case?


> +
> +       for (i = 0; i < ARRAY_SIZE(data->root); ++i)
> +               data->root[i] = RB_ROOT;
> +
> +       data->keylen = keylen / sizeof(u32);
> +
> +       return data;
> +}
> +EXPORT_SYMBOL_GPL(nf_conncount_init);

Thanks,

-Yi-Hung
