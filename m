From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf V2] netfilter: nfnl_cthelper: fix a race when walk the
 nf_ct_helper_hash table
Date: Fri, 24 Mar 2017 19:56:55 +0800
Message-ID: <CAML_gOcjtCdjwUsxio7His1Bt_HN7QUv_iO9bANBdMQKRfQOPA@mail.gmail.com>
References: <1490279819-31239-1-git-send-email-zlpnobody@163.com> <20170324113749.GA2264@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:32810 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935564AbdCXL45 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 07:56:57 -0400
Received: by mail-vk0-f45.google.com with SMTP id d188so158442vka.0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 04:56:56 -0700 (PDT)
In-Reply-To: <20170324113749.GA2264@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-24 19:37 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> +struct nfnl_cthelper {
>> +     struct list_head                list;
>> +     struct nf_conntrack_helper      *helper;
>> +};
>
> I overlook this. Any reason for not using this declaration instead?
>
> struct nfnl_cthelper {
>         struct list_head                list;
>         struct nf_conntrack_helper      helper;
> };
>
> We would simplify this a bit as the helper would be embedded into the
> new nfnl_cthelper structure.

Yes, this will be better. I will send V3 later.
