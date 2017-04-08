From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove unnecessary
 nf_conntrack_expect_lock protection
Date: Sat, 8 Apr 2017 23:16:15 +0200
Message-ID: <20170408211615.GB5301@salvia>
References: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752545AbdDHVQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:16:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 022252493A
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:16:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ABEFDA793
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:16:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DE0ADA725
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:16:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 01, 2017 at 10:14:24PM +0800, Liping Zhang wrote:
> @@ -1960,9 +1955,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
>  	err = -EEXIST;
>  	ct = nf_ct_tuplehash_to_ctrack(h);
>  	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
> -		spin_lock_bh(&nf_conntrack_expect_lock);
>  		err = ctnetlink_change_conntrack(ct, cda);
> -		spin_unlock_bh(&nf_conntrack_expect_lock);

We used to have a central spinlock here.

        spin_lock_bh(&nf_conntrack_lock);

that was removed time ago, so this go converted to use
nf_conntrack_expect_lock.
