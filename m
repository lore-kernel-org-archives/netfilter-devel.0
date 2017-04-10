From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove unnecessary
 nf_conntrack_expect_lock protection
Date: Mon, 10 Apr 2017 14:02:05 +0200
Message-ID: <20170410120205.GE2155@salvia>
References: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
 <20170408211615.GB5301@salvia>
 <CAML_gOdrjnSB-FxHj9oTfVFWODmNGxh5y0GZ2JPOMqjp=xa1ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753165AbdDJMCX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 08:02:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3ACC352309
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:02:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A9E3BAC34
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:02:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2A25BAC34
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:02:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOdrjnSB-FxHj9oTfVFWODmNGxh5y0GZ2JPOMqjp=xa1ng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 09, 2017 at 12:21:22PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-04-09 5:16 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Sat, Apr 01, 2017 at 10:14:24PM +0800, Liping Zhang wrote:
> >> @@ -1960,9 +1955,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
> >>       err = -EEXIST;
> >>       ct = nf_ct_tuplehash_to_ctrack(h);
> >>       if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
> >> -             spin_lock_bh(&nf_conntrack_expect_lock);
> >>               err = ctnetlink_change_conntrack(ct, cda);
> >> -             spin_unlock_bh(&nf_conntrack_expect_lock);
> >
> > We used to have a central spinlock here.
> >
> >         spin_lock_bh(&nf_conntrack_lock);
> >
> > that was removed time ago, so this go converted to use
> > nf_conntrack_expect_lock.
> 
> This patch should add:
> 
> Fixes: ca7433df3a67 ("netfilter: conntrack: seperate expect locking
> from nf_conntrack_lock")
> 
> Commit ca7433df3a67 add spin_lock_bh(&nf_conntrack_expect_lock) in
> nf_ct_remove_expectations, but we also lock the _expect_lock before calling
> ctnetlink_change_conntrack, so dead lock will happen:
> 
>  spin_lock_bh(&nf_conntrack_expect_lock):
> ->err = ctnetlink_change_conntrack(ct, cda)
> -->ctnetlink_change_helper
> --->if (!strcmp(helpname, "")) nf_ct_remove_expectations()
> ---->spin_lock_bh(&nf_conntrack_expect_lock); //lock _expect_lock
> again, dead lock!

I agree this is fixing the deadlock but see below.

> Since ctnetlink_change_conntrack is unrelated to nf_conntrack_expect_lock,
> so remove it can fix this issue.

But packets may be updating a conntrack at the same time that we're
mangling via ctnetlink, right?
