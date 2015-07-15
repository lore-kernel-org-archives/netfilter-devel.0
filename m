From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Wed, 15 Jul 2015 21:16:30 +0200
Message-ID: <55A6B18E.2070508@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net> <3a45e81237cd8248a025dc772a9dd9ef17c73b1b.1436574843.git.daniel@iogearbox.net> <20150715173558.GA7161@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:49994 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbGOTQd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 15:16:33 -0400
In-Reply-To: <20150715173558.GA7161@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/15/2015 07:35 PM, Pablo Neira Ayuso wrote:
> On Sat, Jul 11, 2015 at 03:14:05AM +0200, Daniel Borkmann wrote:
>> This patch replaces the zone id which is pushed down into functions
>> with the actual zone object. It's a bigger one-time change, but
>> needed for later on extending zones with a direction parameter, and
>> thus decoupling this additional information from all call-sites.
>>
>> It was suggested during NFWS to let the nf_ct_zone() helper store
>> the meta data on the stack as we currently do, but in a similar
>> fashion as skb_header_pointer() does, so we can avoid keeping track
>> of the object lifetime. In general, dealing directly with the object
>> also facilitates for adding other possible meta data in future.
>>
>> No functional changes in this patch.
> [...]
>> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> index 80d5554..75f7860 100644
>> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> @@ -134,9 +134,10 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>>   	struct nf_conntrack_tuple innertuple, origtuple;
>>   	const struct nf_conntrack_l4proto *innerproto;
>>   	const struct nf_conntrack_tuple_hash *h;
>> -	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
>> +	struct nf_conntrack_zone *zone, __zone;
>>
>>   	NF_CT_ASSERT(skb->nfct == NULL);
>> +	zone = nf_ct_zone_tmpl(tmpl, &__zone);
>
> This was one possible idea, but I also suggested to have a dummy:
>
> static const struct nf_ct_zone nf_ct_zone_dflt = {
>          .zone_id        = NF_CT_DEFAULT_ZONE,
> };
>
> that we return in case no zone extension is set, and use it instead of
> your nf_ct_zone_dflt() function.

There are multiple possibilities, no doubt, I liked this one better and
therefore took that path as it integrated nicely with the 3rd patch in
this series, and it also consumed less stack space, it's 4 byte after all.
