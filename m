From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pass netns to ->match or to not pass
Date: Thu, 23 Oct 2008 20:23:10 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr> <20081023233620.GA19634@x200.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56290 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYJXAXN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:23:13 -0400
In-Reply-To: <20081023233620.GA19634@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-23 19:36, Alexey Dobriyan wrote:
>> 
>> >xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
>> >haven't looked closely):
>> >
>> >	recent_mt
>> >	recent_table_lookup
>> >	[use per-netns tables list]
>> >
>> >Now, I can drag netns through struct xt_match_param, or use
>> >dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.
>> >
>> >And the latter should be better, because only xt_recent module will be
>> >affected.
>> >
>> >Comments?
>> 
>> What exactly needs netns? This?
>> 
>> 	if (par->out != NULL && skb->sk == NULL)
>> 		ttl++;
>
>Nope, something like below, and if I'm reading correctly,
>struct xt_recent_mtinfo is immutable because of ABI, hence the question.

What info would you pass thorugh xt_recent_mtinfo anyway?

>@@ -203,6 +204,7 @@ static void recent_table_flush(struct recent_table *t)
> static bool
> recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> {
>+	struct net *net = ???;

Either add a net in match_param or use dev_net.
The latter seems nicer because it does not use another 8 bytes
in match_param.
