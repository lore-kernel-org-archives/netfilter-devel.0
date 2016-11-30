From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: store loopback interface to
 dreg when rt is local
Date: Wed, 30 Nov 2016 18:18:46 +0800
Message-ID: <CAML_gOca-dT-qfDVMzvAW-VLRuk5OCZB_=E6zSO=cbzuENe2vA@mail.gmail.com>
References: <1479994128-16654-1-git-send-email-zlpnobody@163.com> <20161128122507.GB28510@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34903 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbcK3KSr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 05:18:47 -0500
Received: by mail-vk0-f67.google.com with SMTP id x186so8531714vkd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 02:18:47 -0800 (PST)
In-Reply-To: <20161128122507.GB28510@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2016-11-28 20:25 GMT+08:00 Florian Westphal <fw@strlen.de>:
[...]
>> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
>> index 2581363..2107775 100644
>> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
>> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
>> @@ -130,7 +130,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>>       switch (res.type) {
>>       case RTN_UNICAST:
>>               break;
>> -     case RTN_LOCAL: /* should not appear here, see fib4_is_local() above */
>> +     case RTN_LOCAL:
>> +             nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
>
> Liping, what about doing:
>
>         case RTN_LOCAL:
>                 if (priv->flags & NFTA_FIB_F_DADDR)
>                         nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
>
>
> AFAICS this will make above rule work while the saddr test will
> still appear to not have a route at all.
>
> What do you think?

Yes, this will work both for *rpfilter* and my user case.
It seems a little ugly but I cannot find a better solution now ...
