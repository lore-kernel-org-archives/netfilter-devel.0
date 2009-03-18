From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: ctnetlink: cleanup master conntrack assignation
Date: Wed, 18 Mar 2009 23:26:22 +0100
Message-ID: <49C1750E.7000206@netfilter.org>
References: <20090305160714.13755.83435.stgit@Decadence> <49BE6188.9020601@trash.net> <49C12489.5040500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57875 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752312AbZCRW0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:26:36 -0400
In-Reply-To: <49C12489.5040500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> This patch moves the assignation of the master conntrack to
>>> ctnetlink_create_conntrack(), which is where it really belongs.
>>> This patch is a cleanup.
>>
>> Applied, thanks.
> 
> I've added this patch on top to fix a RCU context imbalance.

Oh, stupid mistake, sorry for that.

> This seems like a good opportunity to say this again: please (everyone)
> compile your code using sparse. It catches this type and more bugs.

I'll do.

> There is a second bug introduced by this patch:
> 
>     add_timer(&ct->timeout);
>     nf_conntrack_hash_insert(ct);
>     rcu_read_unlock();
> 
>     return ct;
> 
> The conntrack lock is not held, it might crash or create double entries.

Hm, but that code is inside ctnetlink_create_conntrack() which is called
with the conntrack lock held.

       if (nlh->nlmsg_flags & NLM_F_CREATE)
                 err = ctnetlink_create_conntrack(cda,
                                                  &otuple,
                                                  &rtuple,
-                                                 master_ct,
                                                  NETLINK_CB(skb).pid,
-                                                 nlmsg_report(nlh));
+                                                 nlmsg_report(nlh),
+                                                 u3);
                spin_unlock_bh(&nf_conntrack_lock);

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
