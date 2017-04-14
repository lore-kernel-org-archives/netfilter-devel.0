From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf V2] netfilter: ctnetlink: make it safer when updating ct->status
Date: Fri, 14 Apr 2017 10:43:25 +0800
Message-ID: <CAML_gOdzp1411GPG3xJVSfWovqnuiLQzbE0H_kn9BeYh738-dw@mail.gmail.com>
References: <1492088027-10389-1-git-send-email-zlpnobody@163.com> <20170413232555.GA7517@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, cernekee@chromium.org,
        Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35139 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752850AbdDNCn1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 22:43:27 -0400
Received: by mail-vk0-f66.google.com with SMTP id z204so4832136vkd.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 19:43:27 -0700 (PDT)
In-Reply-To: <20170413232555.GA7517@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-14 7:25 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Thu, Apr 13, 2017 at 08:53:47PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> User can update the ct->status via nfnetlink, but using a non-atomic
>> operation "ct->status |= status;". This is unsafe, and may clear
>> IPS_DYING_BIT bit set by another CPU unexpectedly. For example:
>>          CPU0                            CPU1
>>   ctnetlink_change_status        __nf_conntrack_find_get
>>       old = ct->status              nf_ct_gc_expired
>>           -                         nf_ct_kill
>>           -                      test_and_set_bit(IPS_DYING_BIT
>>       new = old | status;                 -
>>   ct->status = new; <-- oops, _DYING_ is cleared!
>
> This is fixing an issue that was introduced in ca7433df3a67.

Actually, even holding the global nf_conntrack_lock, this won't help anything.
Because data processing path is protected by rcu, so they can manipulate
the same _ct_ at the same time.

After having a close investigation, I found the above issue was
introduced by commit 76507f69c44e ("[NETFILTER]: nf_conntrack: use RCU
for conntrack hash"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=76507f69c44ed199a1a68086145398459e55835d

The commit ca7433df3a67 ("netfilter: conntrack: seperate expect
locking from nf_conntrack_lock")
only introduced the dead lock indeed.

> So I would like this comes in a patch batch including the several
> patches that we need to fix the conntrack update path from ctnetlink.

OK, I will try to send a patch set.
