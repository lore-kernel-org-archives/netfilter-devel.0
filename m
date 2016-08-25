From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Thu, 25 Aug 2016 09:06:44 -0700
Message-ID: <1472141204.14381.137.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
         <1472132015-10264-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33359 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbcHYQUf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 12:20:35 -0400
Received: by mail-pa0-f67.google.com with SMTP id vy10so3343968pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 09:20:34 -0700 (PDT)
In-Reply-To: <1472132015-10264-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-08-25 at 15:33 +0200, Florian Westphal wrote:
> Conntrack gc worker to evict stale entries.
> 
> GC happens once every 5 seconds, but we only scan at most 1/64th of the
> table (and not more than 8k) buckets to avoid hogging cpu.
> 
> This means that a complete scan of the table will take several minutes
> of wall-clock time.
> 
> Considering that the gc run will never have to evict any entries
> during normal operation because those will happen from packet path
> this should be fine.
> 
> We only need gc to make sure userspace (conntrack event listeners)
> eventually learn of the timeout, and for resource reclaim in case the
> system becomes idle.
> 
> We do not disable BH and cond_resched for every bucket so this should
> not introduce noticeable latencies either.
> 
> A followup patch will add a small change to speed up GC for the extreme
> case where most entries are timed out on an otherwise idle system.
> 
> v2: Use cond_resched_rcu_qs & add comment wrt. missing restart on
> nulls value change in gc worker, suggested by Eric Dumazet.
> 
> v3: don't call cancel_delayed_work_sync twice (again, Eric).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c | 76 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)

Acked-by: Eric Dumazet <edumazet@google.com>


