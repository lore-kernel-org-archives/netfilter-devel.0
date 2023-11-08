Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F2CC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 10:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbjKHKtt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 05:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbjKHKtN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 05:49:13 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B062685
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 02:46:14 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id A1067CC02CA;
        Wed,  8 Nov 2023 11:46:12 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  8 Nov 2023 11:46:10 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id EAA2ECC02C7;
        Wed,  8 Nov 2023 11:46:08 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9D7F93431A9; Wed,  8 Nov 2023 11:46:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 9C4383431A8;
        Wed,  8 Nov 2023 11:46:08 +0100 (CET)
Date:   Wed, 8 Nov 2023 11:46:08 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH 1/1] netfilter: ipset: fix race condition between
 swap/destroy and kernel side add/del/test, v2
In-Reply-To: <20231104103551.GA9892@breakpoint.cc>
Message-ID: <5610e82-e462-1ef-d06c-6d15853224b@netfilter.org>
References: <20231104100349.4184215-1-kadlec@netfilter.org> <20231104100349.4184215-2-kadlec@netfilter.org> <20231104103551.GA9892@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Sat, 4 Nov 2023, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Linkui Xiao reported that there's a race condition when ipset swap and destroy is
> > called, which can lead to crash in add/del/test element operations. Swap then
> > destroy are usual operations to replace a set with another one in a production
> > system. The issue can in some cases be reproduced with the script:
> 
> > iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> > while [ 1 ]
> > do
> > 	# ... Ongoing traffic...
> >         ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
> >         ipset add hash_ip2 172.20.0.0/16
> >         ipset swap hash_ip1 hash_ip2
> >         ipset destroy hash_ip2
> >         sleep 0.05
> > done
> > 
> > In the race case the possible order of the operations are
> > 
> > 	CPU0			CPU1
> > 	ip_set_test
> > 				ipset swap hash_ip1 hash_ip2
> > 				ipset destroy hash_ip2
> > 	hash_net_kadt
> > 
> > Swap replaces hash_ip1 with hash_ip2 and then destroy removes hash_ip2 which
> > is the original hash_ip1. ip_set_test was called on hash_ip1 and because destroy
> > removed it, hash_net_kadt crashes.
> > 
> > The fix is to protect both the list of the sets and the set pointers in an extended RCU
> > region and before exiting ip_set_swap(), wait to finish all started rcu_read_lock().
> > The first version of the patch was written by Linkui Xiao <xiaolinkui@kylinos.cn>.
> > 
> > v2: synchronize_rcu() is moved into ip_set_swap() in order not to burden
> > ip_set_destroy() unnecessarily when all sets are destroyed.
> 
> Hmm.  Isn't it enough to only call synchronize_rcu() in ip_set_swap?
> 
> All netfilter hooks run with rcu_read_lock() held, em_ipset.c wraps the 
> entire ip_set_test() in rcu read lock/unlock pair.

Hm, actually, you are right. Technically there's no need to extend the 
rcu_read_lock() protected area inside ipset itself.
 
> > @@ -704,13 +704,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
> >  	struct ip_set_net *inst = ip_set_pernet(net);
> >  
> >  	rcu_read_lock();
> > -	/* ip_set_list itself needs to be protected */
> > +	/* ip_set_list and the set pointer need to be protected */
> >  	set = rcu_dereference(inst->ip_set_list)[index];
> > -	rcu_read_unlock();
> >  
> >  	return set;
> >  }
> 
> ... so I don't understand why ip_set_rcu_get() has to extend
> the locked section.
> 
> AFAICS there are only two type of callers:
> 1. rcu read lock is already held (datapath)
> 2. ipset nfnl subsys mutex is held
> 
> *probably* This could be changed in a separate patch to:
> 
>   -	rcu_read_lock();
>   -	/* ip_set_list itself needs to be protected */
>   -	set = rcu_dereference(inst->ip_set_list)[index];
>   -	rcu_read_unlock();
>   +	/* ip_set_list and the set pointer need to be protected */
>   +	return rcu_dereference_check(inst->ip_set_list, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET)[index];
> 
> This is an example, probably better to add a small
> "ip_set_dereference_nfnl" helper to hide the lockdep construct...
> 
> Not saying the patch is wrong; rcu read locks nest and
> ipset locking is not simple so I might be missing something.

I'm going to rework the patch, thanks for your input!

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
