From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_h323: do not re-activate
 already expired timer
Date: Mon, 8 Aug 2016 13:07:20 +0200
Message-ID: <20160808110720.GA4796@salvia>
References: <1469283416-25879-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Gao Feng <fgao@ikuai8.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45006 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbcHHLH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 07:07:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 728F3186AD2
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 64AE0100A63
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:07:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A53B6FF6FB
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 13:07:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469283416-25879-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 23, 2016 at 10:16:56PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Commit 96d1327ac2e3 ("netfilter: h323: Use mod_timer instead of
> set_expect_timeout") just simplify the source codes
>     if (!del_timer(&exp->timeout))
>         return 0;
>     add_timer(&exp->timeout);
> to mod_timer(&exp->timeout, jiffies + info->timeout * HZ);
> 
> This is not correct, and introduce a race codition:
>     CPU0                     CPU1
>      -                     timer expire
>   process_rcf              expectation_timed_out
>   lock(exp_lock)              -
>   find_exp                 waiting exp_lock...
>   re-activate timer!!      waiting exp_lock...
>   unlock(exp_lock)         lock(exp_lock)
>      -                     unlink expect
>      -                     free(expect)
>      -                     unlock(exp_lock)
> So when the timer expires again, we will access the memory that
> was already freed.
> 
> Replace mod_timer with mod_timer_pending here to fix this problem.
> 
> Fixes: 96d1327ac2e3 ("netfilter: h323: Use mod_timer instead of set_expect_timeout")

Applied, thanks Zhang.
