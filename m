Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DA0C4167D
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 10:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjKDKgK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 06:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjKDKgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 06:36:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BCB191
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2023 03:36:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qzE0N-0002dd-9B; Sat, 04 Nov 2023 11:35:51 +0100
Date:   Sat, 4 Nov 2023 11:35:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH 1/1] netfilter: ipset: fix race condition between
 swap/destroy and kernel side add/del/test, v2
Message-ID: <20231104103551.GA9892@breakpoint.cc>
References: <20231104100349.4184215-1-kadlec@netfilter.org>
 <20231104100349.4184215-2-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231104100349.4184215-2-kadlec@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> Linkui Xiao reported that there's a race condition when ipset swap and destroy is
> called, which can lead to crash in add/del/test element operations. Swap then
> destroy are usual operations to replace a set with another one in a production
> system. The issue can in some cases be reproduced with the script:

Hi Jozsef,

> iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> while [ 1 ]
> do
> 	# ... Ongoing traffic...
>         ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
>         ipset add hash_ip2 172.20.0.0/16
>         ipset swap hash_ip1 hash_ip2
>         ipset destroy hash_ip2
>         sleep 0.05
> done
> 
> In the race case the possible order of the operations are
> 
> 	CPU0			CPU1
> 	ip_set_test
> 				ipset swap hash_ip1 hash_ip2
> 				ipset destroy hash_ip2
> 	hash_net_kadt
> 
> Swap replaces hash_ip1 with hash_ip2 and then destroy removes hash_ip2 which
> is the original hash_ip1. ip_set_test was called on hash_ip1 and because destroy
> removed it, hash_net_kadt crashes.
> 
> The fix is to protect both the list of the sets and the set pointers in an extended RCU
> region and before exiting ip_set_swap(), wait to finish all started rcu_read_lock().
> The first version of the patch was written by Linkui Xiao <xiaolinkui@kylinos.cn>.
> 
> v2: synchronize_rcu() is moved into ip_set_swap() in order not to burden
> ip_set_destroy() unnecessarily when all sets are destroyed.

Hmm.  Isn't it enough to only call synchronize_rcu() in ip_set_swap?

All netfilter hooks run with rcu_read_lock() held,
em_ipset.c wraps the entire ip_set_test() in rcu read lock/unlock pair.

> @@ -704,13 +704,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
>  	struct ip_set_net *inst = ip_set_pernet(net);
>  
>  	rcu_read_lock();
> -	/* ip_set_list itself needs to be protected */
> +	/* ip_set_list and the set pointer need to be protected */
>  	set = rcu_dereference(inst->ip_set_list)[index];
> -	rcu_read_unlock();
>  
>  	return set;
>  }

... so I don't understand why ip_set_rcu_get() has to extend
the locked section.

AFAICS there are only two type of callers:
1. rcu read lock is already held (datapath)
2. ipset nfnl subsys mutex is held

*probably* This could be changed in a separate patch to:

  -	rcu_read_lock();
  -	/* ip_set_list itself needs to be protected */
  -	set = rcu_dereference(inst->ip_set_list)[index];
  -	rcu_read_unlock();
  +	/* ip_set_list and the set pointer need to be protected */
  +	return rcu_dereference_check(inst->ip_set_list, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET)[index];

This is an example, probably better to add a small
"ip_set_dereference_nfnl" helper to hide the lockdep construct...

Not saying the patch is wrong; rcu read locks nest and
ipset locking is not simple so I might be missing something.
