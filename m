From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: ctnetlink: cleanup master conntrack assignation
Date: Wed, 18 Mar 2009 23:35:43 +0100
Message-ID: <49C1773F.1070100@trash.net>
References: <20090305160714.13755.83435.stgit@Decadence> <49BE6188.9020601@trash.net> <49C12489.5040500@trash.net> <49C1750E.7000206@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52011 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZCRWfv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:35:51 -0400
In-Reply-To: <49C1750E.7000206@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>   
>> The conntrack lock is not held, it might crash or create double entries.
>>     
>
> Hm, but that code is inside ctnetlink_create_conntrack() which is called
> with the conntrack lock held.
>
>        if (nlh->nlmsg_flags & NLM_F_CREATE)
>                  err = ctnetlink_create_conntrack(cda,
>                                                   &otuple,
>                                                   &rtuple,
> -                                                 master_ct,
>                                                   NETLINK_CB(skb).pid,
> -                                                 nlmsg_report(nlh));
> +                                                 nlmsg_report(nlh),
> +                                                 u3);
>                 spin_unlock_bh(&nf_conntrack_lock);
>   

Right, I missed that, sorry.
