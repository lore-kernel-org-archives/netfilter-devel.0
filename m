From: Yi-Hung Wei <yihung.wei@gmail.com>
Subject: Re: [PATCH v4 nf-next] netfilter: connlimit: split xt_connlimit into
 front and backend
Date: Fri, 8 Dec 2017 16:55:05 -0800
Message-ID: <CAG1aQhJfr_eovVkdYqtvASVCfUeS5CbfF6y8E+H+Te8sDEkLzA@mail.gmail.com>
References: <20171208111516.32541-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46635 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdLIAzt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 19:55:49 -0500
Received: by mail-oi0-f67.google.com with SMTP id t81so8288311oih.13
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Dec 2017 16:55:49 -0800 (PST)
In-Reply-To: <20171208111516.32541-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 8, 2017 at 3:15 AM, Florian Westphal <fw@strlen.de> wrote:
> --- /dev/null
> +++ b/include/net/netfilter/nf_conntrack_count.h
> @@ -0,0 +1,17 @@
> +#ifdef _NF_CONNTRACK_COUNT_H
^^^^^^^^
#ifndef? Looks like a typo in v4.


> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> index a6214f235333..d69e2f41aaa6 100644
> --- a/net/netfilter/xt_connlimit.c
> +++ b/net/netfilter/xt_connlimit.c
>  static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
>  {
>         const struct xt_connlimit_info *info = par->matchinfo;
> -       unsigned int i;
>
>         nf_ct_netns_put(par->net, par->family);
I run into some issues when load and unload xt_connlimit a couple of
times. It turns out that we do nf_ct_netns_put() twice, where the
other one is in nf_conncount_destroy(). Maybe get rid of this line?

Thanks,

-Yi-Hung
