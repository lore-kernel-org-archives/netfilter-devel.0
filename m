From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH] set_expr: Allow passing the parent set to set_expr_alloc()
Date: Wed, 12 Jul 2017 08:43:10 +0200
Message-ID: <CAOkSjBi0c2RJMtSw1KADjEkH-djevs=ZYVHkfzCfKJyej-SDTQ@mail.gmail.com>
References: <20170711215952.11056-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35662 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdGLGnc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 02:43:32 -0400
Received: by mail-it0-f66.google.com with SMTP id v193so1346337itc.2
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jul 2017 23:43:32 -0700 (PDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id v65sm1100007iod.28.2017.07.11.23.43.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jul 2017 23:43:31 -0700 (PDT)
Received: by mail-it0-f45.google.com with SMTP id m68so7027040ith.1
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jul 2017 23:43:31 -0700 (PDT)
In-Reply-To: <20170711215952.11056-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 July 2017 at 23:59, Phil Sutter <phil@nwl.cc> wrote:
> Usually one wants to at least initialize set_flags from the parent, so
> make allocation of a set's set expression more convenient.
>
> The idea to do this came when fixing an issue with output formatting of
> larger anonymous sets in nft monitor: Since
> netlink_events_cache_addset() didn't initialize set_flags,
> calculate_delim() didn't detect it's an anonymous set and therefore
> added newlines to the output.
>
> Reported-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> Fixes: a9dc3ceabc10f ("expression: print sets and maps in pretty format")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---

Thanks for working on this Phil :-)

some comments below

> diff --git a/src/expression.c b/src/expression.c
> index f90ca6035bd3a..f51fbae281b95 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -824,9 +824,16 @@ static const struct expr_ops set_expr_ops = {
>         .destroy        = compound_expr_destroy,
>  };
>
> -struct expr *set_expr_alloc(const struct location *loc)
> +struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
>  {
> -       return compound_expr_alloc(loc, &set_expr_ops);
> +       struct expr *set_expr = compound_expr_alloc(loc, &set_expr_ops);
> +
> +       if (set) {
> +               set_expr->set_flags = set->flags;
> +               set_expr->dtype = set->keytype;
> +       }
> +
> +       return set_expr;
>  }

What about:

if (!set)
     return set_expr;

set_expr->set_flags = set->flags;
[..]
return set_expr;


> diff --git a/src/segtree.c b/src/segtree.c
> index a2316a7b98041..f53536210018d 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -602,10 +602,12 @@ static int expr_value_cmp(const void *p1, const void *p2)
>         int ret;
>
>         ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
> -       if (ret == 0 && (e1->flags & EXPR_F_INTERVAL_END))
> -               return -1;
> -       else
> -               return 1;
> +       if (ret == 0) {
> +               if (e1->flags & EXPR_F_INTERVAL_END)
> +                       return -1;
> +               else if (e2->flags & EXPR_F_INTERVAL_END)
> +                       return 1;
> +       }
>
>         return ret;
>  }
> --

^^^
this last chunk belongs to another patch?
