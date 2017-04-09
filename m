From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove unnecessary
 nf_conntrack_expect_lock protection
Date: Sun, 9 Apr 2017 12:21:22 +0800
Message-ID: <CAML_gOdrjnSB-FxHj9oTfVFWODmNGxh5y0GZ2JPOMqjp=xa1ng@mail.gmail.com>
References: <1491056064-19687-1-git-send-email-zlpnobody@163.com> <20170408211615.GB5301@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33940 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdDIEVY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Apr 2017 00:21:24 -0400
Received: by mail-ua0-f193.google.com with SMTP id u59so2038520uau.1
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Apr 2017 21:21:23 -0700 (PDT)
In-Reply-To: <20170408211615.GB5301@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-09 5:16 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sat, Apr 01, 2017 at 10:14:24PM +0800, Liping Zhang wrote:
>> @@ -1960,9 +1955,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
>>       err = -EEXIST;
>>       ct = nf_ct_tuplehash_to_ctrack(h);
>>       if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
>> -             spin_lock_bh(&nf_conntrack_expect_lock);
>>               err = ctnetlink_change_conntrack(ct, cda);
>> -             spin_unlock_bh(&nf_conntrack_expect_lock);
>
> We used to have a central spinlock here.
>
>         spin_lock_bh(&nf_conntrack_lock);
>
> that was removed time ago, so this go converted to use
> nf_conntrack_expect_lock.

This patch should add:

Fixes: ca7433df3a67 ("netfilter: conntrack: seperate expect locking
from nf_conntrack_lock")

Commit ca7433df3a67 add spin_lock_bh(&nf_conntrack_expect_lock) in
nf_ct_remove_expectations, but we also lock the _expect_lock before calling
ctnetlink_change_conntrack, so dead lock will happen:

 spin_lock_bh(&nf_conntrack_expect_lock):
->err = ctnetlink_change_conntrack(ct, cda)
-->ctnetlink_change_helper
--->if (!strcmp(helpname, "")) nf_ct_remove_expectations()
---->spin_lock_bh(&nf_conntrack_expect_lock); //lock _expect_lock
again, dead lock!

Since ctnetlink_change_conntrack is unrelated to nf_conntrack_expect_lock,
so remove it can fix this issue.
