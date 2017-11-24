From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH nft] src: deprecate "flow table" syntax, replace it by "meter"
Date: Fri, 24 Nov 2017 13:13:10 +0100
Message-ID: <CAOkSjBgPMs=xWGYWizam9ttPRKJQyj9Frj1dmB2fcu7J47yp+g@mail.gmail.com>
References: <20171123142322.6444-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, rwhite@pobox.com,
        neal.p.murphy@alum.wpi.edu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36984 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbdKXMNd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 07:13:33 -0500
Received: by mail-wm0-f47.google.com with SMTP id v186so22153324wma.2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 04:13:33 -0800 (PST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com. [74.125.82.48])
        by smtp.gmail.com with ESMTPSA id x17sm13877909edx.9.2017.11.24.04.13.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Nov 2017 04:13:31 -0800 (PST)
Received: by mail-wm0-f48.google.com with SMTP id 128so22142383wmo.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 04:13:31 -0800 (PST)
In-Reply-To: <20171123142322.6444-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 November 2017 at 15:23, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> According to bugzilla 1137: "flow tables" should not be syntactically
> unique.
>
> "Flow tables are always named, but they don't conform to the way sets,
> maps, and dictionaries work in terms of "add" and "delete" and all that.
>
> They are also "flow tables" instead of one word like "flows" or
> "throttle" or something.
>
> It seems weird to just have these break the syntactic expectations."
>
> Personally, I never liked the reference to "table" since we have very
> specific semantics in terms of what a "table" is netfilter for long
> time.
>
> This patch promotes "meter" as the new keyword. The former syntax is
> still accepted for a while, just to reduce chances of breaking things.
> At some point the former syntax will just be removed.
>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1137
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>

I agree.

What about adding a warning in case of using the old syntax?
Something like:

WARNING: this syntax is deprecated and will be deleted in the future,
use 'meter' instead.

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

> diff --git a/src/evaluate.c b/src/evaluate.c
> index fd61e7530d2e..3d4824ff80d6 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2021,37 +2021,37 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>         return expr_evaluate(ctx, &stmt->payload.val);
>  }
>
> -static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
> +static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>         struct expr *key, *set, *setref;
>
>         expr_set_context(&ctx->ectx, NULL, 0);
> -       if (expr_evaluate(ctx, &stmt->flow.key) < 0)
> +       if (expr_evaluate(ctx, &stmt->meter.key) < 0)
>                 return -1;
> -       if (expr_is_constant(stmt->flow.key))
> -               return expr_error(ctx->msgs, stmt->flow.key,
> +       if (expr_is_constant(stmt->meter.key))
> +               return expr_error(ctx->msgs, stmt->meter.key,
>                                   "Flow key expression can not be constant");

^
line below contains flow instead of meter

> -       if (stmt->flow.key->comment)
> -               return expr_error(ctx->msgs, stmt->flow.key,
> +       if (stmt->meter.key->comment)
> +               return expr_error(ctx->msgs, stmt->meter.key,
>                                   "Flow key expression can not contain comments");

^
same here
