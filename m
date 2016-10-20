From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Thu, 20 Oct 2016 21:27:12 +0800
Message-ID: <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com> <1476966980.1161.52.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34157 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935962AbcJTN1N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 09:27:13 -0400
Received: by mail-vk0-f43.google.com with SMTP id b186so71875230vkb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 06:27:13 -0700 (PDT)
In-Reply-To: <1476966980.1161.52.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-10-20 20:36 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
[...]
> Well, the suggested userspace implementation doesn't allow a rule that
> would hit this warning. It is required to use 'ether type ip ... rt ip
> nexthop' or 'ether type ip6 ... rt ip6 nexthop', when nexthop is used
> from the inet table.
>
> So I found it reasonable to generate a warning if such a rule somehow
> got configured anyway, but if you still feel that it should be removed,
> I can do that.

I think WARN_ON was used to hint that maybe there's a bug in kernel.
It is not appropriate to warn the user's wrong configuration.

>> switch (priv->key) {
>>         case NFT_RT_NEXTHOP:
>>                 switch (pkt->pf)
>>                 ...
>>         default:
>>                 return nft_rt_get_eval(expr, regs, pkt);
>> }
>
> My thinking was that for future rt sub-expressions, it will probably
> make sense to move
>
>                 const struct rtable *rt = skb_rtable(skb);
>
>                 if (!rt)
>                         goto err;
>
> outside the inner switch statement, so it doesn't need to be duplicated
> for each sub-expression. And ditto for the IPV6 part.
>

If so, for future rt sub-expressions extension, I think the following codes
maybe better?

switch (pkt->pf)
     case IPV4:
           nft_rt_ipv4_get_eval();
           break;
     case IPV6:
           nft_rt_ipv6_get_eval();
           break;

This can reduce the duplicate codes. Just a suggestion:)
