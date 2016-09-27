From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf-next] netfilter: xt_nfacct: Use not operation instead
 of condition check
Date: Tue, 27 Sep 2016 09:04:27 +0800
Message-ID: <CA+6hz4qeVkZ2u-0yxdG0WJi5sgrDKF3dUXH-pX5kuY8YbAxYpw@mail.gmail.com>
References: <1474899184-30187-1-git-send-email-fgao@ikuai8.com>
 <20160926151756.GA17426@breakpoint.cc> <CA+6hz4qxwzV7YME8Nzo-uTJH9n7jz8cO8GWd4P-5GV90Httyqg@mail.gmail.com>
 <20160927003924.GC17426@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:34648 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755456AbcI0BEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2016 21:04:53 -0400
Received: from mail-vk0-f49.google.com (unknown [209.85.213.49])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2016 09:04:29 +0800 (CST)
Received: by mail-vk0-f49.google.com with SMTP id 192so79754358vkl.2
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 18:04:29 -0700 (PDT)
In-Reply-To: <20160927003924.GC17426@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 27, 2016 at 8:39 AM, Florian Westphal <fw@strlen.de> wrote:
> Gao Feng <fgao@ikuai8.com> wrote:
>> >> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
>> >> index cf32759..7abb5b5 100644
>> >> --- a/net/netfilter/xt_nfacct.c
>> >> +++ b/net/netfilter/xt_nfacct.c
>> >> @@ -28,7 +28,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
>> >>
>> >>       overquota = nfnl_acct_overquota(par->net, skb, info->nfacct);
>> >>
>> >> -     return overquota == NFACCT_UNDERQUOTA ? false : true;
>> >> +     return !(overquota == NFACCT_UNDERQUOTA);
>> >
>> > I don't find one better than the other.  If you need to change
>> > it for some reason consider
>> >
>> > "return overquota != NFACCT_UNDERQUOTA"
>> >
>> > instead of this strange negation.
>>
>> Thanks, it is more simple use "!=".
>> >
>> > But really, I think its fine as-is.
>>
>> It could decrease one condition check and jump.
>
> gcc should emit same instructions for all these variants.

Thanks Florian.
It is unnecessary to simplify it now.

Regards
Feng

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


