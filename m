From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: conntrack: account packets drop by tcp_packet()
Date: Mon, 23 Feb 2009 11:49:51 +0100
Message-ID: <49A27F4F.7050702@trash.net>
References: <20090223101551.7309.61740.stgit@Decadence> <alpine.LSU.2.00.0902231147390.29210@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62715 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZBWKtx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:49:53 -0500
In-Reply-To: <alpine.LSU.2.00.0902231147390.29210@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-23 11:15, Pablo Neira Ayuso wrote:
>> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
>> index 8b9dbb7..4503727 100644
>> --- a/net/netfilter/nf_conntrack_core.c
>> +++ b/net/netfilter/nf_conntrack_core.c
>> @@ -733,6 +733,8 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
>> 		nf_conntrack_put(skb->nfct);
>> 		skb->nfct = NULL;
>> 		NF_CT_STAT_INC_ATOMIC(net, invalid);
>> +		if (-ret == NF_DROP)
>> +			NF_CT_STAT_INC_ATOMIC(net, drop);
>> 		return -ret;
>> 	}
>>
> 
> *boggle* Why not just "ret == -NF_DROP"?
> The assumption would be near that "-NF_DROP" is a constant just
> as "NF_DROP" would be, but "-ret" involves an extra instruction
> for negating ret.

Indeed. No need to resend though, I'll fix it up.

