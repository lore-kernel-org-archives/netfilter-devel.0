From: Varsha Rao <rvarsha016@gmail.com>
Subject: Re: [PATCH nft] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Thu, 15 Jun 2017 16:58:26 +0530
Message-ID: <CAAFX7JQk7A-T=fex8byZk0LRanAooZaTBrSGX5BjXmXEYPynVw@mail.gmail.com>
References: <59418f32.1623620a.a2188.374c@mx.google.com> <20170615094606.GA8817@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36559 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdFOL3N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 07:29:13 -0400
Received: by mail-it0-f67.google.com with SMTP id 185so1633328itv.3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 04:29:07 -0700 (PDT)
In-Reply-To: <20170615094606.GA8817@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 15, 2017 at 3:16 PM, Pablo Neira Ayuso wrote:
> On Thu, Jun 15, 2017 at 01:01:57AM +0530, Varsha Rao wrote:
>> diff --git a/include/datatype.h b/include/datatype.h
>> index 04b7d88..748688e 100644
>> --- a/include/datatype.h
>> +++ b/include/datatype.h
>> @@ -145,7 +145,8 @@ struct datatype {
>>       const char                      *desc;
>>       const struct datatype           *basetype;
>>       const char                      *basefmt;
>> -     void                            (*print)(const struct expr *expr);
>> +     void                            (*print)(const struct expr *expr,
>> +                                              struct print_ctx *ct);
>
> Could you use:
>
>         struct print_ctx *pctx
>
> instead?
>
> 'ct' usually refers to the connection tracking system (ct) in our
> codebase, so I would prefer we have a different variable name.
>
> This applies everywhere in this patch.

Okay, I will change it.
>
>> --- a/include/expression.h
>> +++ b/include/expression.h
>> @@ -157,7 +157,8 @@ struct expr_ops {
>>       void                    (*set_type)(const struct expr *expr,
>>                                           const struct datatype *dtype,
>>                                           enum byteorder byteorder);
>> -     void                    (*print)(const struct expr *expr);
>> +     void                    (*print)(const struct expr *expr,
>> +                                      struct print_ctx *ct);
>>       bool                    (*cmp)(const struct expr *e1,
>>                                      const struct expr *e2);
>>       void                    (*pctx_update)(struct proto_ctx *ctx,
>> @@ -330,7 +331,7 @@ extern struct expr *expr_alloc(const struct location *loc,
>>  extern struct expr *expr_clone(const struct expr *expr);
>>  extern struct expr *expr_get(struct expr *expr);
>>  extern void expr_free(struct expr *expr);
>> -extern void expr_print(const struct expr *expr);
>> +extern void expr_print(const struct expr *expr, struct print_ctx *ct);
>>  extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
>>  extern void expr_describe(const struct expr *expr);
>>
>> @@ -410,7 +411,7 @@ extern struct expr *list_expr_alloc(const struct location *loc);
>>
>>  extern struct expr *set_expr_alloc(const struct location *loc);
>>  extern int set_to_intervals(struct list_head *msgs, struct set *set,
>> -                         struct expr *init, bool add);
>> +                         struct expr *init, bool add, struct print_ctx *ct);
>
> Why do we need this? I think we only need print_ctx for *_print()
> functions.

In src/segtree.c, set_to_intervals calls expr_print() if segtree_debug()
is true and it would cause problem if NULL is passed to expr_print().

Thanks,
varsha
