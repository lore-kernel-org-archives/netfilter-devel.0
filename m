Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CBDCDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 19:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbjJQT0L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 15:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjJQT0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 15:26:10 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4D7F0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 12:26:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 695ADCC02BE;
        Tue, 17 Oct 2023 21:26:05 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 17 Oct 2023 21:26:03 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 4D3ACCC02B7;
        Tue, 17 Oct 2023 21:26:02 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3B3E83431A9; Tue, 17 Oct 2023 21:26:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 3A0503431A8;
        Tue, 17 Oct 2023 21:26:02 +0200 (CEST)
Date:   Tue, 17 Oct 2023 21:26:02 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     xiaolinkui <xiaolinkui@gmail.com>, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, justinstitt@google.com,
        netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: fix race condition in ipset swap,
 destroy and test/add/del
In-Reply-To: <ZS6iqG5XIEwGvDrR@calendula>
Message-ID: <ba5ac33-2cd0-658a-2094-bc37bdcdc9d@netfilter.org>
References: <20231017125256.23056-1-xiaolinkui@gmail.com> <ZS6iqG5XIEwGvDrR@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, 17 Oct 2023, Pablo Neira Ayuso wrote:

> This means then that Jozsef's patch is fixing the issue that you 
> reported, then a Tested-by: tag would be nice to have from you :)
> 
> If all is OK, then please, let Jozsef submit his own patch to 
> netfilter-devel@ so it can follow its trip to the nf.git tree.

I'll need a few days to work on the patch for possible improvements 
before the final submission.

Best regards,
Jozsef

> On Tue, Oct 17, 2023 at 08:52:56PM +0800, xiaolinkui wrote:
> > From: Linkui Xiao <xiaolinkui@kylinos.cn>
> > 
> > There is a race condition which can be demonstrated by the following
> > script:
> > 
> > ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
> > ipset add hash_ip1 172.20.0.0/16
> > ipset add hash_ip1 192.168.0.0/16
> > iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> > while [ 1 ]
> > do
> >         ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
> >         ipset add hash_ip2 172.20.0.0/16
> >         ipset swap hash_ip1 hash_ip2
> >         ipset destroy hash_ip2
> >         sleep 0.05
> > done
> > 
> > Swap will exchange the values of ref so destroy will see ref = 0 instead of
> > ref = 1. So after running this script for a period of time, the following
> > race situations may occur:
> >         CPU0:                CPU1:
> >         ipt_do_table
> >         ->set_match_v4
> >         ->ip_set_test
> >                         ipset swap hash_ip1 hash_ip2
> >                         ipset destroy hash_ip2
> >         ->hash_net4_kadt
> > 
> > CPU0 found ipset through the index, and at this time, hash_ip2 has been
> > destroyed by CPU1 through name search. So CPU0 will crash when accessing
> > set->data in the function hash_net4_kadt.
> > 
> > With this fix in place swap will wait for the ongoing operations to be
> > finished.
> > 
> > V1->V2 changes:
> > - replace ref_netlink with rcu synchonize_rcu()
> > 
> > Closes: https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org/
> > Cc: stable@vger.kernel.org
> > Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> > 
> > ---
> >  net/netfilter/ipset/ip_set_core.c | 31 ++++++++++++++++++++++++++-----
> >  1 file changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 35d2f9c9ada0..62ee4de6ffee 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -712,13 +712,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
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
> >  
> > +static inline void
> > +ip_set_rcu_put(struct ip_set *set __always_unused)
> > +{
> > +	rcu_read_unlock();
> > +}
> > +
> >  static inline void
> >  ip_set_lock(struct ip_set *set)
> >  {
> > @@ -744,8 +749,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
> >  	pr_debug("set %s, index %u\n", set->name, index);
> >  
> >  	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> > +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >  		return 0;
> > +	}
> >  
> >  	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
> >  
> > @@ -764,6 +771,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
> >  			ret = -ret;
> >  	}
> >  
> > +	ip_set_rcu_put(set);
> >  	/* Convert error codes to nomatch */
> >  	return (ret < 0 ? 0 : ret);
> >  }
> > @@ -780,12 +788,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
> >  	pr_debug("set %s, index %u\n", set->name, index);
> >  
> >  	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> > +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >  		return -IPSET_ERR_TYPE_MISMATCH;
> > +	}
> >  
> >  	ip_set_lock(set);
> >  	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
> >  	ip_set_unlock(set);
> > +	ip_set_rcu_put(set);
> >  
> >  	return ret;
> >  }
> > @@ -802,12 +813,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
> >  	pr_debug("set %s, index %u\n", set->name, index);
> >  
> >  	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> > +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >  		return -IPSET_ERR_TYPE_MISMATCH;
> > +	}
> >  
> >  	ip_set_lock(set);
> >  	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
> >  	ip_set_unlock(set);
> > +	ip_set_rcu_put(set);
> >  
> >  	return ret;
> >  }
> > @@ -882,6 +896,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name)
> >  	read_lock_bh(&ip_set_ref_lock);
> >  	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
> >  	read_unlock_bh(&ip_set_ref_lock);
> > +	ip_set_rcu_put(set);
> >  }
> >  EXPORT_SYMBOL_GPL(ip_set_name_byindex);
> >  
> > @@ -1348,6 +1363,9 @@ static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
> >   * protected by the ip_set_ref_lock. The kernel interfaces
> >   * do not hold the mutex but the pointer settings are atomic
> >   * so the ip_set_list always contains valid pointers to the sets.
> > + * However after swapping, a userspace set destroy command could
> > + * remove a set still processed by kernel side add/del/test.
> > + * Therefore we need to wait for the ongoing operations to be finished.
> >   */
> >  
> >  static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
> > @@ -1397,6 +1415,9 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
> >  	ip_set(inst, to_id) = from;
> >  	write_unlock_bh(&ip_set_ref_lock);
> >  
> > +	/* Make sure all readers of the old set pointers are completed. */
> > +	synchronize_rcu();
> > +
> >  	return 0;
> >  }
> >  
> > -- 
> > 2.17.1
> > 
> 

-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
