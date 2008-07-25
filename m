From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 25 Jul 2008 13:15:09 +0200
Message-ID: <4889B5BD.5070004@netfilter.org>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net> <1216905683.31465.10.camel@pumper.lan.luxnet.ch> <48899DBE.5080005@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fabian Hugelshofer <hugelshofer2006@gmx.ch>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57013 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706AbYGYLPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:15:43 -0400
In-Reply-To: <48899DBE.5080005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Or much simpler, just call read_rcu_unlock() before the first
> nla_nest_start() so that this results in much smaller patch:
> 
> nlmsg_failure:
> nla_put_failure:
>         read_rcu_unlock(); <---
>         nlmsg_trim(skb, b);
>         return -1;

As said, if you do this in ctnetlink_conntrack_event, I think that you
can also remove the rcu_read_lock in ctnetlink_dump_helpinfo, as then
all dump functions will be invoked under rcu_read_lock.

In ctnetlink_get_conntrack, I think that ctnetlink_fill_info needs to be
protected with rcu_read_lock.

BTW, why do we need such a big read-side critical section in
ctnetlink_create_conntrack? I think that we only need for the helper
assignation, right?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
