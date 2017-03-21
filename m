From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 3/5] netfilter: drop const qualifier from struct nf_conntrack_expect_policy
Date: Tue, 21 Mar 2017 23:00:02 +0800
Message-ID: <CAML_gOfKb9NKJVK0mPCNR1sK1Tt=6RWnzsD7WZEyS7_YNY43hw@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-4-git-send-email-zlpnobody@163.com> <20170321103404.GE1940@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34359 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756347AbdCUPAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 11:00:50 -0400
Received: by mail-vk0-f65.google.com with SMTP id y16so6478806vky.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 08:00:03 -0700 (PDT)
In-Reply-To: <20170321103404.GE1940@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-21 18:34 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Mar 19, 2017 at 10:36:00PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> So we can modify the nf_conntrack_expect_policy directly, the next patch
>> will need this.
>
> I'm missing why you need this.

Because I want to modify the nf_conntrack_expect_policy directly when
do update expect policy in nfct_helper.

I saw you make a cast type to do this:
  policy = (struct nf_conntrack_expect_policy *) &helper->expect_policy[i];
(refer to http://patchwork.ozlabs.org/patch/741528/)

But when I'm working on this, I'm not sure "cast type" is proper or not.
So I just remove the const qualifier.
