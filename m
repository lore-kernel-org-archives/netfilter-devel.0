From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 13 Apr 2010 18:32:29 +0200
Message-ID: <4BC49C9D.9020902@trash.net>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-4-git-send-email-jengelh@medozas.de> <4BC4756B.4090307@trash.net> <alpine.LSU.2.01.1004131801570.7914@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0DMQce (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:32:34 -0400
In-Reply-To: <alpine.LSU.2.01.1004131801570.7914@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-04-13 15:45, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> +static bool
>>> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
>>> +{
>>> +	const struct iphdr *iph = ip_hdr(skb);
>>> +	struct rtable *rt;
>>> +	struct flowi fl;
>>> +
>>> +	memset(&fl, 0, sizeof(fl));
>>> +	fl.nl_u.ip4_u.daddr = info->gw.ip;
>>> +	fl.nl_u.ip4_u.tos   = RT_TOS(iph->tos);
>>> +	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
>>> +
>>> +	if (ip_route_output_key(dev_net(skb->dev), &rt, &fl) != 0) {
>> You can't use skb->dev in modules that are valid to use in LOCAL_OUT.
>>
>>> +#ifdef WITH_CONNTRACK
>>> +	nf_conntrack_put(skb->nfct);
>>> +	skb->nfct     = &tee_track.ct_general;
>>> +	skb->nfctinfo = IP_CT_NEW;
>>> +	nf_conntrack_get(skb->nfct);
>>> +#endif
>> Why do we still need this? I thought the reentrancy-counter should take
>> care of this?
> 
> Did I really delete that commit... it's done so that conntrack
> does not count the duplicated packets towards the original
> connection.

Simply untrack it perhaps?
