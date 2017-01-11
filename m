From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf-next 1/1] netfilter: nf_tables: Remove one useless
 condition check in nf_tables_newobj
Date: Wed, 11 Jan 2017 09:34:57 +0800
Message-ID: <CA+6hz4rk01XR0m1pX0Lz2vaeQtg2HyU=xXfyOm7WBHv+Emn6=w@mail.gmail.com>
References: <1483667388-30814-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Feng Gao <gfree.wind@gmail.com>, Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34151 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdAKBe7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2017 20:34:59 -0500
Received: by mail-ua0-f195.google.com with SMTP id i68so54097146uad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 17:34:59 -0800 (PST)
In-Reply-To: <1483667388-30814-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 6, 2017 at 9:49 AM,  <fgao@ikuai8.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
>
> The return value of nf_tables_obj_lookup is valid pointer or one error.
> There are two cases in nf_tables_newobj totally.
> case1: return value is -ENOENT, the obj is NULL, it is unnecessary to
> perform the latter check "obj != NULL".
> case2: IS_ERR(obj) is false, the obj is one valid pointer. It is also
> unnecessary to perform that check.
>
> In summary, we could move the block of condition check "obj != NULL" in
> the else block to erase the original condition check.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_tables_api.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87..bc55086 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4154,9 +4154,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
>                         return err;
>
>                 obj = NULL;
> -       }
> -
> -       if (obj != NULL) {
> +       } else {
>                 if (nlh->nlmsg_flags & NLM_F_EXCL)
>                         return -EEXIST;
>
> --
> 1.9.1
>
>

Hi all,

Please ignore this patch.
Because I find the nf_tables_newtable and nf_tables_newset have same
logic, so I update them too, and send another patch.

The link is https://patchwork.ozlabs.org/patch/713533/.

Regards
Feng
