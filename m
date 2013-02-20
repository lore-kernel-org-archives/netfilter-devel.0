From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Wed, 20 Feb 2013 12:32:30 +0200
Message-ID: <5124A63E.3000006@linux.intel.com>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org> <1359590645-4703-3-git-send-email-pablo@netfilter.org> <20130219220257.GF3240@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab3BTKcd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:32:33 -0500
In-Reply-To: <20130219220257.GF3240@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

>
>> @@ -37,6 +37,8 @@ enum nf_tables_msg_types {
>>   	NFT_MSG_NEWSETELEM,
>>   	NFT_MSG_GETSETELEM,
>>   	NFT_MSG_DELSETELEM,
>> +	NFT_MSG_COMMIT,
>> +	NFT_MSG_ABORT,
> I see why you're doing this, but this is similar to the NEWCHAINNAME
> attribute, it doesn't really fit into the scheme how the netlink API
> is designed.

  Why doesn't it fit? Do you mean you would prefer one command leads to 
one result, so no transaction based manipulation?
I would rather see a NFT_MSG_START added actually.

>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index db6150b..7f08381 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>>   static int nf_tables_dump_rules(struct sk_buff *skb,
>>   				struct netlink_callback *cb)
>>   {
>> @@ -1250,6 +1288,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>>   	unsigned int idx = 0, s_idx = cb->args[0];
>>   	struct net *net = sock_net(skb->sk);
>>   	int family = nfmsg->nfgen_family;
>> +	unsigned int genctr = net->nft.genctr, gencursor = net->nft.gencursor;
>>   
>>   	list_for_each_entry(afi, &net->nft.af_info, list) {
>>   		if (family != NFPROTO_UNSPEC && family != afi->family)
>> @@ -1258,6 +1297,8 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>>   		list_for_each_entry(table, &afi->tables, list) {
>>   			list_for_each_entry(chain, &table->chains, list) {
>>   				list_for_each_entry(rule, &chain->rules, list) {
>> +					if (!nft_rule_is_active(net, rule))
>> +						goto cont;
> Not sure whether we should really skip them during the dump. That hides
> information from userspace, we could just as well include an INACTIVE flag
> and have userspace decide whether to process them or not.

Personally I don't see much point dumping non-active (yet to be 
committed) rules to anybody.
The current way of notifying the rule change when committed, as 
described at the end of this patch message, is I think just right.
That would be better though within the proposal I made earlier to Pablo.

Unless you don't want transaction based manipulation. What would be the 
idea then?


Tomasz
