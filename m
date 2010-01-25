From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/09]: netfilter: nf_conntrack: add support for "conntrack
 zones"
Date: Mon, 25 Jan 2010 17:51:18 +0100
Message-ID: <4B5DCC06.3020109@trash.net>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <20100125153742.15305.79058.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001251747250.20906@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47481 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0AYQvU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:51:20 -0500
In-Reply-To: <alpine.LSU.2.01.1001251747250.20906@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-01-25 16:37, Patrick McHardy wrote:
>> diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
>> index a4c1880..fe4ee76 100644
>> --- a/include/linux/netfilter/xt_CT.h
>> +++ b/include/linux/netfilter/xt_CT.h
>> @@ -5,6 +5,7 @@ struct xt_ct_target_info {
>> 	u_int32_t	ct_events;
>> 	u_int32_t	exp_events;
>> 	char		helper[16];
>> +	u_int16_t	zone;
>>
>> 	/* Used internally by the kernel */
>> 	struct nf_conn	*ct __attribute__((aligned(8)));
> 
>> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
>> index d171b12..9c1560d 100644
>> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
>> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
>> @@ -266,7 +266,7 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
>> 		return -EINVAL;
>> 	}
>>
>> -	h = nf_conntrack_find_get(sock_net(sk), &tuple);
>> +	h = nf_conntrack_find_get(sock_net(sk), 0, &tuple);
> 
> I would prefer to avoid literal numbers where doing so meaningful;
> perhaps we can introduce a symbolic constant NF_CT_GLOBAL_ZONE
> or similar here.

Sure, I'll add that.
