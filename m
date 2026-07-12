Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CC72F532F
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783863969; cv=none; b=bqcT2RxeXHxqrFmUjb4Rh8C+38ZQCikzbP+KMXsOVb5YxpprUQLTW5zbNAOWC1m5+yxCJaX5r06FBcvR5bgyBRYjwQtiWLJIY1y/D34x51ObadO3WNnw9UxORlEdvznHIqLVfyD4npYLwguLT2UiLMqVNTKOxN9dbv77R60Cfrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783863969; c=relaxed/simple;
	bh=S7VuZp/92v5sVodcVoNUD+Zl7gy/Rf0H6PpKSjn3cqU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qxnAvQB3jTpCfojDP/+LtKABAiOSfgEayunNUSNweyxf7DSWZ4mqf3+kqgHxQtWzjcp4KkIFTOLv2GYipe1EbZxsMi0hbaaDuVt3rL+JfHXgOQP+AaAZ88iSldO/Zh6HzlZLAjE9ugjzfUCK6tne0WGXLq8TEkerFJzT6dsRwi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EvDk1Lk5; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvDk1Lk5"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso279316766b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 06:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783863965; x=1784468765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=REHu/kpx3Sz1G4n3Gv+XsXcFAXIjTW/erHmndlHfoyY=;
        b=EvDk1Lk5rFleOyiJm2tgucpYu/7fsms+ezOyYqYoE9uyfdF+ht2V7z+Fkm+XHREXap
         wgqgjM4uEDVcnHXdGRa6H1vJ+og+MELwQ4eey2aaLfoD9+nAGSBybTZUPFbvKvo/gJ3W
         q6e/iSWJwUxH1Rmq3CIjxre7zkX6LBOkA7bUhrdNhytl7IYwGBAMXmljBvI0JnpM+Cwi
         8/06nCht8BlPtrYiadH4fAK9+uytkrsmaA+coVU6t6vSEVCoowqTB/tBbq4r6G1g/arb
         9JBtBOnswdr6g7N9Jt76/sW7cKhEY+yN50t0oAu8NOEH7zN9MjvihJN/RSvE+GQQVNh8
         fc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783863965; x=1784468765;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REHu/kpx3Sz1G4n3Gv+XsXcFAXIjTW/erHmndlHfoyY=;
        b=LIQ49ebYJ0Dpow+xTEjTKtwzFDctDmYxeiT9w3hONmJStDnM7VRwx5wcu0p8OImycr
         gTwTAIe80L3fraPveHZ1hGB8vWhgLQ7wNGk2HE4aMzsnBwp0ba/N1PLfBL2UmB1viF9q
         LcBeHS8yuwhQDKF4xhy0EcNm5cjfWIfgTg9vtNSTiwAwNqoMN3bje5JO7ETaJCxbd5Oi
         Ibpy9HaoXTj3EMIr/iQ1OyRhsQaRlVH3KoAuFccfBWYiEvjq56/dE0SCYLh6fpwsOjnz
         iAXI1k6+N1m97kB6VvmXwUBaRuvHa1r2oGGF7YUAIZzsiYQE6AC1XdFwv0crPRE4z+3D
         kFvg==
X-Forwarded-Encrypted: i=1; AFNElJ/olViDorT1MGmAz+Ja6/3eBPgwu0yHveifZowaypHL8k2A0/kapYokeXzNHAMjvu1IIebcBnTy8n10LCGqQu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXS0Ve4hB62oRwLDuF1/6DVyu/Y0/p91/8XdBv4CKka69VN2pD
	MbKW9LTakPa4suAT2CwXyORSQ/Wtwm6nIwotRr3SK0xl0FrFSn0z0nPYipykWV0q
X-Gm-Gg: AfdE7cmXfZ/C3LtRw0XlURcljJzbY1kFGj8q3QWlGnzH3r1nDlo98KGrvL01i5Wd9/m
	CBeaFr96rI75YQmoqxWiZcQF/AvFG7oHdMBodhTNAGrlxfVLeYddNX9k9WmmNwoMQhq8FO/wdFm
	tNdAOLDlTTrA6oJmfZKzbki0zzDjyybpNCUiIaij2XVgVw6m5XYXXoH+Vw0fTkgUek7Bhy/I02O
	i7aiCFIPrQCSIvEq+NiKqwsztGBa3VEx4P6N428xBv0xNBXDlXlwNGd0ZwNmeLhVlGb/+h8e1Cf
	daCVnoSFVOP1BEgVT6aLJCjt5CHfS0jDXs0irKxoRsWcFFkQ3Sc0nrLumExr1Au41Hl+vdwkYOv
	M8tlC5/wt3KQX2NnE/MENfqNHzRF/xUoQcOM3UNTsZE7rtGHlzHp/hxrIyVVtsBZh42apfc6Bzt
	qg3JlDSQ2A8ZZctSk/y/XiBOxpN9EnI8qfyAY3QJySSC/Jgu/5J0yNAZsmGOOWfunvvd2tuab2w
	U9e3xgu/Xsg5z56LjVuOZ0qGVt6o7z9o6bhqgMfjp6Iz6tlv2rBozflUxuV+/lmGRYsngwftjxw
	BxJ2ttrtmOpttyjTeXJ57dQ=
X-Received: by 2002:a17:907:c084:b0:c0e:883e:93fd with SMTP id a640c23a62f3a-c161ea934b9mr271693866b.48.1783863965199;
        Sun, 12 Jul 2026 06:46:05 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15bb51af39sm766255966b.29.2026.07.12.06.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 06:46:03 -0700 (PDT)
Message-ID: <f332d077-bd3b-454f-a14d-73f7701e0644@gmail.com>
Date: Sun, 12 Jul 2026 15:46:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next,v2 3/3] netfilter: flowtable: initial bridge
 support
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: razor@blackwall.org, fw@strlen.de
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-4-pablo@netfilter.org>
 <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>
Content-Language: en-US
In-Reply-To: <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/12/26 11:27 AM, Eric Woudstra wrote:
> 
> 
> On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
>> This patch adds bridge flowtable support, this allows to define a
>> shortcut between two bridge ports. This is complementary to the
>> existing inet family flowtable support.
>>
>> Set up does not require userspace updates, an example ruleset to
>> enable the flowtable in the bridge family is provided here below:
>>
>>  table bridge x {
>>         flowtable y {
>>                 hook ingress priority 0
>>                 devices = { veth0, veth1 }
>>         }
>>         chain forward {
>>                 type filter hook forward priority 0
>>                 ip protocol tcp flow add @y counter
>>                 counter
>>         }
>>  }
>>
>> I decided to add an explicit nft_flow_offload_bridge_eval() instead of
>> recycling the existing inet function by adding branches to skip the
>> routing part which is obviously not needed in the bridge path. I
>> consider this mostly boiler plate for feature extensibility and better
>> maintability is better to keep it separated. Similarly, the bridge hook
>> that represents the flowtable bridge datapath is implemented in a
>> separated function.
>>
>> Although connection tracking in the bridge does not support the tracking
>> of IP flows encapsulated in PPPoE and VLAN tracking yet, there are
>> scenarios that involved PPPoE and VLAN that can be supported already,
>> such as those where packets flows through the bridge with no tagging,
>> eg. a VLAN device is used as a bridge port which decapsulates the
>> packets at the ingress path.
>>
>> Tested with:
>> - Plain forwarding between bridge ports with no VLAN tagging.
>> - VLAN device used in bridged ports, as long as packets that are
>>   untagged when circulating within the bridge.
>>
>> This initial bridge flowtable support does support VLAN tagged packets
>> circulating within the bridge yet, because nf_conntrack_bridge still
>> does not support PPPoE/VLAN natively.
>>
>> Hardware offload is disabled until there is a driver in the tree
>> supporting this.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>> v2: remove bridge vlan support, currently not exercised.
>>
>>  include/net/netfilter/nf_flow_table.h |   7 ++
>>  net/netfilter/nf_flow_table_inet.c    |  12 +++
>>  net/netfilter/nf_flow_table_ip.c      | 134 ++++++++++++++++++++++++++
>>  net/netfilter/nf_flow_table_path.c    |  65 +++++++++++++
>>  net/netfilter/nft_flow_offload.c      |  88 ++++++++++++++++-
>>  5 files changed, 305 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index 7b23b245a5a8..d65914198ec9 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -247,6 +247,8 @@ struct nft_pktinfo;
>>  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>>  		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
>>  		   struct nft_flowtable *ft);
>> +int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
>> +		    enum ip_conntrack_dir dir, struct nft_flowtable *ft);
>>  
>>  static inline int
>>  nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
>> @@ -341,6 +343,8 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>>  				     const struct nf_hook_state *state);
>>  unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  				       const struct nf_hook_state *state);
>> +unsigned int nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
>> +					 const struct nf_hook_state *state);
>>  
>>  #if (IS_BUILTIN(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
>>      (IS_MODULE(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
>> @@ -374,6 +378,9 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>>  int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
>>  			    enum flow_offload_tuple_dir dir,
>>  			    struct nf_flow_rule *flow_rule);
>> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
>> +			enum flow_offload_tuple_dir dir,
>> +			struct nf_flow_rule *flow_rule);
>>  
>>  int nf_flow_table_offload_init(void);
>>  void nf_flow_table_offload_exit(void);
>> diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
>> index b0f199171932..44790a0d3012 100644
>> --- a/net/netfilter/nf_flow_table_inet.c
>> +++ b/net/netfilter/nf_flow_table_inet.c
>> @@ -65,6 +65,15 @@ static int nf_flow_rule_route_inet(struct net *net,
>>  	return err;
>>  }
>>  
>> +static struct nf_flowtable_type flowtable_bridge = {
>> +	.family		= NFPROTO_BRIDGE,
>> +	.init		= nf_flow_table_init,
>> +	.setup		= nf_flow_table_offload_setup,

After fixing the problems in the patch-set mentioned earlier, when the sotware
fastpath is setup correctly:

Setting up a hardware offloaded flow, because the hardware supports it,
this crashes:

[  283.380108] Unable to handle kernel execute from non-executable memory at virtual address 0000000000000000
[  283.389925] Mem abort info:
[  283.393178]   ESR = 0x0000000086000004
[  283.396940]   EC = 0x21: IABT (current EL), IL = 32 bits
[  283.402299]   SET = 0, FnV = 0
[  283.405358]   EA = 0, S1PTW = 0
[  283.408498]   FSC = 0x04: level 0 translation fault
[  283.413473] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000419d9000
[  283.419918] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  283.426766] Internal error: Oops: 0000000086000004 [#1]  SMP
[  283.432432] Modules linked in: nft_flow_offload nf_flow_table_inet nf_flow_table nft_masq nft_chain_nat nf_nat nf_conntrack_bridge nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables cdc_mbim cdc_wdm cdc_ncm r8153_ecm cdc_ether usbnet r8152 mii mt7915e mt76_connac_lib mt76 mac80211 cfg80211 rfkill libarc4
[  283.460181] CPU: 1 UID: 0 PID: 2420 Comm: kworker/u16:6 Not tainted 7.2.0-rc1-bpirnn #12 PREEMPT 
[  283.469040] Hardware name: Bananapi BPI-R3 (DT)
[  283.473558] Workqueue: nf_ft_offload_add flow_offload_work_handler [nf_flow_table]
[  283.481128] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  283.488084] pc : 0x0
[  283.490269] lr : nf_flow_offload_rule_alloc+0x45c/0x4b0 [nf_flow_table]
[  283.496875] sp : ffff8000830b3c90
[  283.500176] x29: ffff8000830b3c90 x28: ffff00000afc06b8 x27: ffff000007a8a180
[  283.507298] x26: ffff000006704000 x25: ffff000006704000 x24: ffff0000029598c8
[  283.514420] x23: ffff00000af7ac50 x22: 0000000000000000 x21: ffff000006704000
[  283.521541] x20: ffff000002959850 x19: ffff000002959800 x18: 0000000000000000
[  283.528662] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  283.535785] x14: 0000000000000000 x13: 0000000000000008 x12: 0101010101010101
[  283.542914] x11: 7f7f7f7f7f7f7f7f x10: fefefefefefeff63 x9 : 0000000000000000
[  283.550038] x8 : ffff000001f25000 x7 : 0000000000000000 x6 : 000000000000003f
[  283.557159] x5 : 00000000ffffffff x4 : 0000000000000000 x3 : ffff000002959800
[  283.564280] x2 : 0000000000000000 x1 : ffff000006704000 x0 : ffff000007a8a180
[  283.571405] Call trace:
[  283.573841]  0x0 (P)
[  283.576022]  flow_offload_work_handler+0x60/0x358 [nf_flow_table]
[  283.582111]  process_scheduled_works+0x210/0x30c
[  283.586731]  worker_thread+0x140/0x1d4
[  283.590478]  kthread+0xf8/0x108
[  283.593617]  ret_from_fork+0x10/0x20

Adding .action = nf_flow_rule_bridge, with the function as it is in my latest
patch named "netfilter: nf_flow_table_offload: Add nf_flow_rule_bridge()",
it does not crash and the hardware offloaded path functions like a charm.

>> +	.free		= nf_flow_table_free,
>> +	.hook		= nf_flow_offload_bridge_hook,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>>  static struct nf_flowtable_type flowtable_inet = {
>>  	.family		= NFPROTO_INET,
>>  	.init		= nf_flow_table_init,
>> @@ -97,6 +106,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
>>  
>>  static int __init nf_flow_inet_module_init(void)
>>  {
>> +	nft_register_flowtable_type(&flowtable_bridge);
>>  	nft_register_flowtable_type(&flowtable_ipv4);
>>  	nft_register_flowtable_type(&flowtable_ipv6);
>>  	nft_register_flowtable_type(&flowtable_inet);
>> @@ -109,6 +119,7 @@ static void __exit nf_flow_inet_module_exit(void)
>>  	nft_unregister_flowtable_type(&flowtable_inet);
>>  	nft_unregister_flowtable_type(&flowtable_ipv6);
>>  	nft_unregister_flowtable_type(&flowtable_ipv4);
>> +	nft_unregister_flowtable_type(&flowtable_bridge);
>>  }
>>  
>>  module_init(nf_flow_inet_module_init);
>> @@ -118,5 +129,6 @@ MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>>  MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
>>  MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
>> +MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
>>  MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
>>  MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 29e93ac1e2e4..17ae49f62aa5 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -1196,3 +1196,137 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  	return nf_flow_queue_xmit(state->net, skb, &xmit);
>>  }
>>  EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
>> +
>> +static int nf_flow_bridge_xmit(struct net *net,
>> +			       struct nf_flowtable *flow_table,
>> +			       struct flow_offload *flow,
>> +			       enum flow_offload_tuple_dir dir,
>> +			       struct sk_buff *skb)
>> +{
>> +	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
>> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
>> +	struct nf_flow_xmit xmit = {};
>> +
>> +	xmit.outdev = dev_get_by_index_rcu(net, this_tuple->out.ifidx);
>> +	if (!xmit.outdev) {
>> +		flow_offload_teardown(flow);
>> +		return NF_DROP;
>> +	}
>> +
>> +	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
>> +		nf_ct_acct_update(flow->ct, dir, skb->len);
>> +
>> +	xmit.dest = this_tuple->out.h_dest;
>> +	xmit.source = this_tuple->out.h_source;
>> +	xmit.tuple = other_tuple;
>> +	xmit.needs_gso_segment = this_tuple->needs_gso_segment;
>> +
>> +	return nf_flow_queue_xmit(net, skb, &xmit);
>> +}
>> +
>> +static unsigned int
>> +nf_flow_offload_ip_bridge(void *priv, struct sk_buff *skb,
>> +			  const struct nf_hook_state *state)
>> +{
>> +	struct flow_offload_tuple_rhash *tuplehash;
>> +	struct nf_flowtable *flow_table = priv;
>> +	enum flow_offload_tuple_dir dir;
>> +	struct nf_flowtable_ctx ctx = {
>> +		.in	= state->in,
>> +	};
>> +	struct flow_offload *flow;
>> +	unsigned int thoff;
>> +	struct iphdr *iph;
>> +
>> +	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
>> +	if (!tuplehash)
>> +		return NF_ACCEPT;
>> +
>> +	dir = tuplehash->tuple.dir;
>> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>> +
>> +	iph = (struct iphdr *)(skb_network_header(skb) + ctx.offset);
>> +	thoff = (iph->ihl * 4) + ctx.offset;
>> +	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
>> +		return NF_ACCEPT;
>> +
>> +	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
>> +		return NF_DROP;
>> +
>> +	flow_offload_refresh(flow_table, flow, false);
>> +	nf_flow_encap_pop(&ctx, skb, tuplehash);
>> +	skb_clear_tstamp(skb);
>> +
>> +	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
>> +}
>> +
>> +static unsigned int
>> +nf_flow_offload_ipv6_bridge(void *priv, struct sk_buff *skb,
>> +			    const struct nf_hook_state *state)
>> +{
>> +	struct flow_offload_tuple_rhash *tuplehash;
>> +	struct nf_flowtable *flow_table = priv;
>> +	enum flow_offload_tuple_dir dir;
>> +	struct nf_flowtable_ctx ctx = {
>> +		.in	= state->in,
>> +	};
>> +	struct flow_offload *flow;
>> +	struct ipv6hdr *ip6h;
>> +	unsigned int thoff;
>> +
>> +	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
>> +	if (!tuplehash)
>> +		return NF_ACCEPT;
>> +
>> +	dir = tuplehash->tuple.dir;
>> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>> +
>> +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx.offset);
>> +	thoff = sizeof(*ip6h) + ctx.offset;
>> +	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
>> +		return NF_ACCEPT;
>> +
>> +	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
>> +		return NF_DROP;
>> +
>> +	flow_offload_refresh(flow_table, flow, false);
>> +	nf_flow_encap_pop(&ctx, skb, tuplehash);
>> +	skb_clear_tstamp(skb);
>> +
>> +	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
>> +}
>> +
>> +unsigned int
>> +nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
>> +			    const struct nf_hook_state *state)
>> +{
>> +	struct vlan_ethhdr *veth;
>> +	__be16 proto;
>> +
>> +	switch (skb->protocol) {
>> +	case htons(ETH_P_8021Q):
>> +		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
>> +			return NF_ACCEPT;
>> +
>> +		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
>> +		proto = veth->h_vlan_encapsulated_proto;
>> +		break;
>> +	case htons(ETH_P_PPP_SES):
>> +		if (!nf_flow_pppoe_proto(skb, &proto))
>> +			return NF_ACCEPT;
>> +		break;
>> +	default:
>> +		proto = skb->protocol;
>> +		break;
>> +	}
>> +
>> +	switch (proto) {
>> +	case htons(ETH_P_IP):
>> +		return nf_flow_offload_ip_bridge(priv, skb, state);
>> +	case htons(ETH_P_IPV6):
>> +		return nf_flow_offload_ipv6_bridge(priv, skb, state);
>> +	}
>> +
>> +	return NF_ACCEPT;
>> +}
>> +EXPORT_SYMBOL_GPL(nf_flow_offload_bridge_hook);
>> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
>> index 5455149e5d9a..a3aa9a9ce673 100644
>> --- a/net/netfilter/nf_flow_table_path.c
>> +++ b/net/netfilter/nf_flow_table_path.c
>> @@ -8,6 +8,7 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/netfilter/nf_conntrack_common.h>
>>  #include <linux/netfilter/nf_tables.h>
>> +#include <linux/if_vlan.h>
>>  #include <net/ip.h>
>>  #include <net/inet_dscp.h>
>>  #include <net/netfilter/nf_tables.h>
>> @@ -360,3 +361,67 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>>  	return -ENOENT;
>>  }
>>  EXPORT_SYMBOL_GPL(nft_flow_route);
>> +
>> +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
>> +				    struct nft_flowtable *ft,
>> +				    enum ip_conntrack_dir dir,
>> +				    const struct net_device *dev,
>> +				    unsigned char *src_ha,
>> +				    unsigned char *dst_ha)
>> +{
>> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> 
> Add:
> 
> struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
> 
> See below.
> 
>> +	struct net_device_path_stack stack;
>> +	struct nft_forward_info info = {};
>> +	struct net_device_path_ctx ctx;
>> +	int i, j = 0;
>> +
>> +	nft_dev_fill_forward_path_init(&ctx, dev, dst_ha);
>> +
> 
> Here you could add the following to handle the encaps on this_tuple.
> 
> for (i = this_tuple->encap_num - 1; i >= 0 ; i--) {
> 	if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
> 		return -1;
> 
> 	if (this_tuple->in_vlan_ingress & BIT(i))
> 		continue;
> 
> 	info.encap[info.num_encaps].id = this_tuple->encap[i].id;
> 	info.encap[info.num_encaps].proto = this_tuple->encap[i].proto;
> 	info.num_encaps++;
> 
> 	if (this_tuple->encap[i].proto == htons(ETH_P_PPP_SES))
> 		continue;
> 
> 	if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
> 		return -1;
> 	ctx.vlan[ctx.num_vlans].id = this_tuple->encap[i].id;
> 	ctx.vlan[ctx.num_vlans].proto = this_tuple->encap[i].proto;
> 	ctx.num_vlans++;
> }
> 
>> +	if (dev_fill_forward_path(&ctx, &stack) < 0 ||
>> +	    nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
>> +		return -1;
>> +
>> +	if (!nft_flowtable_find_dev(info.indev, ft))
>> +		return -1;
>> +
> 
> After replacing dev_fill_forward_path() with dev_fill_bridge_path(),
> from here...
> 
>> +	this_tuple->iifidx = info.indev->ifindex;
>> +	for (i = info.num_encaps - 1; i >= 0; i--) {
>> +		this_tuple->encap[j].id = info.encap[i].id;
>> +		this_tuple->encap[j].proto = info.encap[i].proto;
>> +		j++;
>> +	}
>> +	this_tuple->encap_num = info.num_encaps;
> 
> Until here, this_tuple needs to be the other_tuple.
> dev_fill_forward_path() does not traverse the bridge.
> See other comment in other patch. Also, need to copy
> the in_vlan_ingress bit.
> 
> So it becomes:
> 
> other_tuple->iifidx = info.indev->ifindex;
> for (i = info.num_encaps - 1; i >= 0; i--) {
> 	other_tuple->encap[j].id = info.encap[i].id;
> 	other_tuple->encap[j].proto = info.encap[i].proto;
> 	if (info.ingress_vlans & BIT(i))
> 		other_tuple->in_vlan_ingress |= BIT(j);
> 	j++;
> }
> other_tuple->encap_num = info.num_encaps;
> 
>> +
>> +	ether_addr_copy(this_tuple->out.h_source, src_ha);
>> +	ether_addr_copy(this_tuple->out.h_dest, dst_ha);
>> +	this_tuple->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>> +
>> +	return 0;
>> +}
>> +
>> +int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
>> +		    enum ip_conntrack_dir dir, struct nft_flowtable *ft)
>> +{
>> +	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
>> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
>> +	const struct net_device *outdev = nft_out(pkt);
>> +	const struct net_device *indev = nft_in(pkt);
>> +	struct ethhdr *eth = eth_hdr(pkt->skb);
>> +	int err;
>> +
> 
> Here I use the skb to fill other_tuple->encaps. I understand you want to
> do this differently.
> Then I call nft_dev_fill_bridge_path() with !dir first, then dir.
> 
>> +	err = nft_dev_fill_bridge_path(flow, ft, dir, indev,
>> +				       eth->h_source, eth->h_dest);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	err = nft_dev_fill_bridge_path(flow, ft, !dir, outdev,
>> +				       eth->h_dest, eth->h_source);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	this_tuple->out.ifidx = other_tuple->iifidx;
>> +	other_tuple->out.ifidx = this_tuple->iifidx;
> 
> This could move to nft_dev_fill_bridge_path() (only 1 line) as both
> tuples are also known there.
> 
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nft_flow_bridge);
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
>> index 32b4281038dd..d1f145a401d1 100644
>> --- a/net/netfilter/nft_flow_offload.c
>> +++ b/net/netfilter/nft_flow_offload.c
>> @@ -135,6 +135,64 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>>  	regs->verdict.code = NFT_BREAK;
>>  }
>>  
>> +static void nft_flow_offload_bridge_eval(const struct nft_expr *expr,
>> +					 struct nft_regs *regs,
>> +					 const struct nft_pktinfo *pkt)
>> +{
>> +	struct nft_flow_offload *priv = nft_expr_priv(expr);
>> +	struct nf_flowtable *flowtable = &priv->flowtable->data;
>> +	struct tcphdr _tcph, *tcph = NULL;
>> +	enum ip_conntrack_info ctinfo;
>> +	struct flow_offload *flow;
>> +	enum ip_conntrack_dir dir;
>> +	struct nf_conn *ct;
>> +	int ret;
>> +
>> +	/* Is this an IP packet? If not, skip. */
>> +	if (!pkt->flags)
>> +		goto out;
>> +
>> +	ct = nf_ct_get(pkt->skb, &ctinfo);
>> +	if (!ct || !nf_ct_is_confirmed(ct))
>> +		goto out;
>> +
>> +	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>> +	case IPPROTO_TCP:
>> +		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
>> +					  sizeof(_tcph), &_tcph);
>> +		if (unlikely(!tcph || tcph->fin || tcph->rst ||
>> +			     !nf_conntrack_tcp_established(ct)))
>> +			goto out;
>> +		break;
>> +	case IPPROTO_UDP:
>> +		break;
>> +	}
>> +
>> +	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
>> +		goto out;
>> +
>> +	flow = flow_offload_alloc(ct);
>> +	if (!flow)
>> +		goto err_flow_forward;
>> +
>> +	dir = CTINFO2DIR(ctinfo);
>> +	if (nft_flow_bridge(flow, pkt, dir, priv->flowtable) < 0)
>> +		goto err_flow_add;
>> +
>> +	ret = flow_offload_add(flowtable, flow);
>> +	if (ret < 0)
>> +		goto err_flow_add;
>> +
>> +	return;
>> +
>> +err_flow_add:
>> +	flow_offload_free(flow);
>> +err_flow_forward:
>> +	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
>> +out:
>> +	regs->verdict.code = NFT_BREAK;
>> +}
>> +
>>  static int nft_flow_offload_validate(const struct nft_ctx *ctx,
>>  				     const struct nft_expr *expr)
>>  {
>> @@ -142,7 +200,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
>>  
>>  	if (ctx->family != NFPROTO_IPV4 &&
>>  	    ctx->family != NFPROTO_IPV6 &&
>> -	    ctx->family != NFPROTO_INET)
>> +	    ctx->family != NFPROTO_INET &&
>> +	    ctx->family != NFPROTO_BRIDGE)
>>  		return -EOPNOTSUPP;
>>  
>>  	return nft_chain_validate_hooks(ctx->chain, hook_mask);
>> @@ -235,6 +294,27 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
>>  	.owner		= THIS_MODULE,
>>  };
>>  
>> +static const struct nft_expr_ops nft_flow_offload_bridge_ops = {
>> +	.type		= &nft_flow_offload_type,
>> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
>> +	.eval		= nft_flow_offload_bridge_eval,
>> +	.init		= nft_flow_offload_init,
>> +	.activate	= nft_flow_offload_activate,
>> +	.deactivate	= nft_flow_offload_deactivate,
>> +	.destroy	= nft_flow_offload_destroy,
>> +	.validate	= nft_flow_offload_validate,
>> +	.dump		= nft_flow_offload_dump,
>> +};
>> +
>> +static struct nft_expr_type nft_flow_offload_bridge_type __read_mostly = {
>> +	.name		= "flow_offload",
>> +	.family		= NFPROTO_BRIDGE,
>> +	.ops		= &nft_flow_offload_bridge_ops,
>> +	.policy		= nft_flow_offload_policy,
>> +	.maxattr	= NFTA_FLOW_MAX,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>>  static int flow_offload_netdev_event(struct notifier_block *this,
>>  				     unsigned long event, void *ptr)
>>  {
>> @@ -264,8 +344,14 @@ static int __init nft_flow_offload_module_init(void)
>>  	if (err < 0)
>>  		goto register_expr;
>>  
>> +	err = nft_register_expr(&nft_flow_offload_bridge_type);
>> +	if (err < 0)
>> +		goto register_bridge_expr;
>> +
>>  	return 0;
>>  
>> +register_bridge_expr:
>> +	nft_unregister_expr(&nft_flow_offload_type);
>>  register_expr:
>>  	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
>>  err:
> 

