From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nfnetlink_acct: fix race between
 nfacct del and xt_nfacct destroy
Date: Thu, 18 Aug 2016 00:26:34 +0200
Message-ID: <20160817222634.GA2798@salvia>
References: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48718 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbcHQW0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 18:26:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 016AEE8E84
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E4F4E1B3329
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 398461B3237
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 11:13:01PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Suppose that we input the following commands at first:
>   # nfacct add test
>   # iptables -A INPUT -m nfacct --nfacct-name test
> 
> And now "test" acct's refcnt is 2, but later when we try to delete the
> "test" nfacct and the related iptables rule at the same time, race maybe
> happen:
>       CPU0                                    CPU1
>   nfnl_acct_try_del                      nfnl_acct_put
>   atomic_dec_and_test //ref=1,testfail          -
>        -                                 atomic_dec_and_test //ref=0,testok
>        -                                 kfree_rcu
>   atomic_inc //ref=1                            -
> 
> So after the rcu grace period, nf_acct will be freed but it is still linked
> in the nfnl_acct_list, and we can access it later, then oops will happen.
> 
> Convert atomic_dec_and_test and atomic_inc combinaiton to one atomic
> operation atomic_cmpxchg here to fix this problem.

Applied, thanks.
