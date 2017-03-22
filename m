From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 5/5] netfilter: nfnl_cthelper: fix a race when walk the
 nf_ct_helper_hash table
Date: Wed, 22 Mar 2017 08:06:10 +0800
Message-ID: <CAML_gOfoFWSxETKo9-UR=j=y1TQC6SSNcBq9Kuek9_Wd5xeFeg@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-6-git-send-email-zlpnobody@163.com> <20170321103334.GD1940@salvia>
 <CAML_gOcmYsogb0BKRxkYh0MF9kW7KTd-HyvEbsa3uL_YTQOa7g@mail.gmail.com>
 <CAML_gOdeXTEPb2vzjR4LYOif291pto4bF8DjWzndsfh6d1+z+g@mail.gmail.com> <20170321152621.GA4069@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34278 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757788AbdCVAGM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 20:06:12 -0400
Received: by mail-vk0-f46.google.com with SMTP id z204so54184669vkd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 17:06:11 -0700 (PDT)
In-Reply-To: <20170321152621.GA4069@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-03-21 23:26 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>>
>> After I have a closer look, I find that we do not support netns for the
>> nfct_helper currently. So this possible_net_t field is not necessary for
>> the time being.
>
> Oh, I see. This is probably one of the remaining subsystems not having
> netns support.
>
>> I have a quick glance look, supporting netns for helper need a lot works
>> to do. We need to both change the nfnetlink_cthelper, nf_conntrack_help
>> and so on.
>>
>> But if you think it's worth to support netns for cthelper, I can
>> finish it in my spare time:)
>
> Let's focus on fixing up the existing issues. It would be great if you
> can add that later on, once changes in nf.git propagate to
> nf-next.git.

OK, I will keep follow up on it.

> BTW, let me also pushed out what I have here into nf.git. I'd
> appreciate if you can rebase this 5/5 patch on top of it.

No problem!
