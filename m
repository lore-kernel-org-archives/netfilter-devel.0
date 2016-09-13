From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and _SRGE_TO
 to select the queue numbers
Date: Tue, 13 Sep 2016 20:19:46 +0800
Message-ID: <CAML_gOfTW2V=WRBjfbSqE4Tw53gQ+Ju8EitcXSYgaAY_uWwBrQ@mail.gmail.com>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com> <20160913091917.GA4051@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:32961 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbcIMMTr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 08:19:47 -0400
Received: by mail-vk0-f66.google.com with SMTP id v189so7621921vkv.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 05:19:47 -0700 (PDT)
In-Reply-To: <20160913091917.GA4051@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-09-13 17:19 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Hi Liping,
>
> A bit more comments on top of Florian's suggestion to use one single
> _SREG.
>
> On Sun, Sep 11, 2016 at 10:05:28PM +0800, Liping Zhang wrote:
>> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
>>  static void nft_queue_eval(const struct nft_expr *expr,
>> @@ -32,17 +34,30 @@ static void nft_queue_eval(const struct nft_expr *expr,
>>                          const struct nft_pktinfo *pkt)
>>  {
>>       struct nft_queue *priv = nft_expr_priv(expr);
>> -     u32 queue = priv->queuenum;
>> +     u32 queue, queues_total, queue_end;
>>       u32 ret;
>>
>> -     if (priv->queues_total > 1) {
>> +     if (priv->sreg_from) {
>> +             queue = (u16)regs->data[priv->sreg_from];
>> +             queue_end = (u16)regs->data[priv->sreg_to];
>> +
>> +             if (queue_end > queue)
>> +                     queues_total = queue_end - queue + 1;
>> +             else
>> +                     queues_total = 1;
>> +     } else {
>> +             queue = priv->queuenum;
>> +             queues_total = priv->queues_total;
>> +     }
>
> I suggest you use .select_ops to use a specific _eval function if
> _SREG is set. This would disentangle this code a bit.
>
>>
>> +     /* nftables has no idea whether the kernel supports _SREG_FROM or not,
>> +      * so for compatibility reason, it may specify the _SREG_FROM and
>> +      * _QUEUE_NUM attributes at the same time. We prefer to use _SREG_FROM,
>> +      * it is more flexible and has less restriction, for example, queue
>> +      * range 0-65535 is ok when use _SREG_FROM and _SREG_TO.
>> +      */
>
> No need for this large comment, look.
>
> From userspace, we have to modify the nft parser to take an expression
> as 'num'. Then, from the netlink_linearize path, we can check the
> expression type:
>
> * If it's a value expression, we can simply use NFTA_QUEUE_NUM.
> * If it's a range expression, we have to set up NFTA_QUEUE_NUM and
>   NFTA_QUEUE_TOTAL.
> * If it's a mapping, then we only use _SREG.
>
> Old kernels will bail out if the mapping is used, as this is not
> supported, which is what we expect. This should be fine by now, until
> I finish the patchset to provide a VM description that userspace can
> use to generate bytecode depending on the features available in the
> kernel.
>
>>
>> @@ -97,9 +142,21 @@ static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
>>  {
>>       const struct nft_queue *priv = nft_expr_priv(expr);
>>
>> -     if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
>> -         nla_put_be16(skb, NFTA_QUEUE_TOTAL, htons(priv->queues_total)) ||
>> -         nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
>> +     if (priv->sreg_from) {
>> +             if (nft_dump_register(skb, NFTA_QUEUE_SREG_FROM,
>> +                                   priv->sreg_from))
>> +                     goto nla_put_failure;
>> +             if (nft_dump_register(skb, NFTA_QUEUE_SREG_TO,
>> +                                   priv->sreg_to))
>> +                     goto nla_put_failure;
>> +     } else {
>> +             if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
>> +                 nla_put_be16(skb, NFTA_QUEUE_TOTAL,
>> +                              htons(priv->queues_total)))
>> +                     goto nla_put_failure;
>> +     }
>
> Looking at this, the code will look better if we should use
> .select_ops indeed.
>
> Thanks for resolving existing nft_queue limitations!

I will re-spin my patch based on your and Florian's suggestions.
Thanks Pablo.
