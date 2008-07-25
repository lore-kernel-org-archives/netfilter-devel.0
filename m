From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 25 Jul 2008 11:32:46 +0200
Message-ID: <48899DBE.5080005@netfilter.org>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net> <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56136 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706AbYGYJcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:32:52 -0400
In-Reply-To: <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> @@ -384,8 +378,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
>  	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
>  	if (!nest_parms)
>  		goto nla_put_failure;
> -	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
> +	rcu_read_lock();
> +	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0) {
> +		rcu_read_unlock();
>  		goto nla_put_failure;
                        ^^^
Would it look nicer if you add a new label 'nla_put_failure_unlock'?

nla_put_failure_unlock:
        read_rcu_unlock();
nlmsg_failure:
nla_put_failure:
        nlmsg_trim(skb, b);
        return -1;

Or much simpler, just call read_rcu_unlock() before the first
nla_nest_start() so that this results in much smaller patch:

nlmsg_failure:
nla_put_failure:
        read_rcu_unlock(); <---
        nlmsg_trim(skb, b);
        return -1;

BTW, please, add a short description to your patches and the
'Signed-off-by' field.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
