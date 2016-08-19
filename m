From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 4/6] netfilter: conntrack: add gc worker to
 remove timed-out entries
Date: Fri, 19 Aug 2016 07:41:13 -0700
Message-ID: <1471617673.29842.105.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
         <1471606575-2197-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34181 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbcHSOlw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 10:41:52 -0400
Received: by mail-pa0-f67.google.com with SMTP id hh10so3552367pac.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Aug 2016 07:41:14 -0700 (PDT)
In-Reply-To: <1471606575-2197-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-08-19 at 13:36 +0200, Florian Westphal wrote:
> Conntrack gc worker to evict stale entries.

...

> +
> +		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
> +			tmp = nf_ct_tuplehash_to_ctrack(h);
> +
> +			if (nf_ct_is_expired(tmp)) {
> +				nf_ct_gc_expired(tmp);
> +				expired_count++;
> +				continue;

Same remark about hlist_nulls_for_each_entry_rcu() not 'safe' here

> +			}
> +		}
> +
> +		rcu_read_unlock();
> +		cond_resched();

This could use cond_resched_rcu_qs() 

> +	} while (++buckets < goal &&
> +		 expired_count < GC_MAX_EVICTS);
> +
> +	if (gc_work->exiting)
> +		return;
> +

