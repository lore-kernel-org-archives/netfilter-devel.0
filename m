From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Sun, 11 Sep 2016 23:12:26 +0200
Message-ID: <20160911211226.GB6572@breakpoint.cc>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53836 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753839AbcIKVMg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 17:12:36 -0400
Content-Disposition: inline
In-Reply-To: <1473602728-33502-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Currently, the user can specify the queue numbers by _QUEUE_NUM and
> _QUEUE_TOTAL attributes, this is enough in most situations.
> 
> But acctually, it is not very flexible, for example:
>   tcp dport 80 mapped to queue0
>   tcp dport 81 mapped to queue1
>   tcp dport 82 mapped to queue2
> In order to do this thing, we must add 3 nft rules, and more
> mapping means more rules ...
> 
> So similer to nft_nat, take two registers to select the queue numbers,
> then we can add one simple rule to mapping queues, maybe like this:
>   queue num tcp dport map { 80:0, 81:1, 82:2 ... }

I like this.

My first thought was that it would be better to just support one single
sreg (the queue number) and eventually externalize the hashing/queue
selection:

queue num jhash ip saddr . ip daddr mod ...

Problem is that with plain jhash we won't get a symmetric hash
for origin and reply, so for this we would need a new expression/hash
mode.

We would also need another expression to allow distribution
starting with a queue other than 0.
