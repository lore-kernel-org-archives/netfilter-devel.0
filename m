From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 5/5] netfilter: nfnl_cthelper: fix a race when walk the
 nf_ct_helper_hash table
Date: Tue, 21 Mar 2017 23:19:11 +0800
Message-ID: <CAML_gOdeXTEPb2vzjR4LYOif291pto4bF8DjWzndsfh6d1+z+g@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-6-git-send-email-zlpnobody@163.com> <20170321103334.GD1940@salvia>
 <CAML_gOcmYsogb0BKRxkYh0MF9kW7KTd-HyvEbsa3uL_YTQOa7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34703 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757404AbdCUPTN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 11:19:13 -0400
Received: by mail-vk0-f53.google.com with SMTP id z204so40489692vkd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 08:19:12 -0700 (PDT)
In-Reply-To: <CAML_gOcmYsogb0BKRxkYh0MF9kW7KTd-HyvEbsa3uL_YTQOa7g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-21 22:48 GMT+08:00 Liping Zhang <zlpnobody@gmail.com>:
> 2017-03-21 18:33 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>>> +struct nfnl_cthelper {
>>> +     struct list_head                list;
>>> +     struct nf_conntrack_helper      *helper;
>>> +};
>>> +
>>> +static LIST_HEAD(nfnl_cthelper_list);
>>
>> We need a field possible_net_t so we can store what netns this helper
>> belongs to, thus in case of flush command, we just remove the helpers
>> that this netns owns.

After I have a closer look, I find that we do not support netns for the
nfct_helper currently. So this possible_net_t field is not necessary for
the time being.

I have a quick glance look, supporting netns for helper need a lot works
to do. We need to both change the nfnetlink_cthelper, nf_conntrack_help
and so on.

But if you think it's worth to support netns for cthelper, I can finish it in my
spare time:)

>
> Yes, good point, I will send v2.
>
> Thanks Pablo.
