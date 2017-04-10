From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove unnecessary
 nf_conntrack_expect_lock protection
Date: Mon, 10 Apr 2017 21:53:17 +0800
Message-ID: <CAML_gOeGnhrVxvW-ZzRZFQqYSZ9j+GFgFOEXmomXP2X0xSYCJg@mail.gmail.com>
References: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
 <20170408211615.GB5301@salvia> <CAML_gOdrjnSB-FxHj9oTfVFWODmNGxh5y0GZ2JPOMqjp=xa1ng@mail.gmail.com>
 <20170410120205.GE2155@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33264 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753379AbdDJNxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 09:53:24 -0400
Received: by mail-ua0-f179.google.com with SMTP id q26so35180574uaa.0
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 06:53:24 -0700 (PDT)
In-Reply-To: <20170410120205.GE2155@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-10 20:02 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> Since ctnetlink_change_conntrack is unrelated to nf_conntrack_expect_lock,
>> so remove it can fix this issue.
>
> But packets may be updating a conntrack at the same time that we're
> mangling via ctnetlink, right?

Yes, but in packets processing path, we use rcu_read_lock(), so using
spin_lock_bh(&nf_conntrack_expect_lock) here won't help anything.

As a quick summary(just a reference):
1. For CTA_TIMEOUT, there's no problem
2. For CTA_MARK, no problem too
3. For CTA_PROTOINFO, spin_lock_bh(&ct->lock) will be held, so no problem too
4. For CTA_LABELS, it may race with packets path, but it seems not a big problem
5. For CTA_SEQ_ADJ_ORIG... we should hold &ct->lock when do updating seqadj
    (this one should require a new patch)
6. For CTA_HELP, updating helpinfo may be a problem(I am not sure
about this part)
7. For CTA_STATUS, I think it may cause a big problem, the bit set operation via
ctnetlink_change_status is not atomic, so it may clear the
IPS_DYING_BIT, for example:
    CPU0(update CTA_STATUS)        CPU1(packet path, set _DYING_)
    ctnetlink_change_status                 --
    olds = ct->status                             --
    --                                               set_bit(IPS_DYING_BIT...
    ct->status = olds | new status --> Here DYING_BIT will be cleared!

But I think we can convert "ct->status |= status & ~(IPS_NAT_DONE_MASK
| IPS_NAT_MASK);"
to a series of atomic bit set operations to solve the 7th issue.

And the issues listed above won't be solved by holding _expect_lock,
so I think we should get rid of the _expect_lock at first.
