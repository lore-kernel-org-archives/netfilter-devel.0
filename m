From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Wed, 20 Feb 2013 10:16:29 +0200
Message-ID: <5124865D.6040206@linux.intel.com>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org> <1359590645-4703-3-git-send-email-pablo@netfilter.org> <51226244.7060503@linux.intel.com> <20130220011221.GA4175@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab3BTIQp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:16:45 -0500
In-Reply-To: <20130220011221.GA4175@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>>
>>> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
>>> index 7640290..3749069 100644
>>> --- a/include/linux/netfilter/nf_tables.h
>>> +++ b/include/linux/netfilter/nf_tables.h
>>> @@ -37,6 +37,8 @@ enum nf_tables_msg_types {
>>>   	NFT_MSG_NEWSETELEM,
>>>   	NFT_MSG_GETSETELEM,
>>>   	NFT_MSG_DELSETELEM,
>>> +	NFT_MSG_COMMIT,
>>> +	NFT_MSG_ABORT,
>>>   	NFT_MSG_MAX,
>>>   };
>>> @@ -85,12 +87,18 @@ enum nft_chain_attributes {
>>>   };
>>>   #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
>>> +enum {
>>> +	NFT_RULE_F_COMMIT	= (1 << 0),
>>> +	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
>>> +};
>>> +
>> I guess you added this flags to add rules on non-transaction based
>> use-case, so it commits right away.
>> Wouldn't it be better to have no such flags in the API, but instead
>> keep track of an on going transaction in the struct nft_ctx (let's
>> have an internal flag here).
>> I.E: no on-going transaction -> we directly commit. If not, it's
>> handled as being part of the transaction.
>>
>> I just took a look at nfnetlink however, it does not seem possible
>> to keep a data pointer per connection on the subsystem.
>> Wait, there is a field in struct sock that is meant for such usage.
>> It would require to change nf_tables_api.c only then.
>> Would it make sense or am I wrong with nft_ctx usage?  (there would
>> be an issue: to free such context when the connection goes down, we
>> could abort an on-going transaction this way then)
> We can define some container structure to store rules in the dirty
> list:
>
> struct nft_rule_update {
>          struct list_head head;
>          uint32_t nl_portid;
>          struct nft_rule *rule;
>          struct nft_table *table;
>          struct nft_chain *chain;
> }
>
> That should allows us to remove the struct list_head dirty_list in
> struct nft_rule that I needed for this.
>
> The nl_portid would be the netlink portid so we know what updates
> belong to what netlink connection. Still I don't see how to get rid of
> the commit flag.
>
> Could you develop your idea?

I was exactly thinking about such external list. But it would be tighten 
to the netlink connection more deeply: as a user data to the socket, 
instead of storing the nl_portid.
I will explain below why.

To me iptables-nftables is a non-transaction based tool. There is no 
point to start a transaction for one rule.
Btw it would then require a  NFT_MSG_START or some sort, to start the 
transaction based manipulation.

Let's say now you have a software, which require to do rules 
manipulation, very often, which will be always connected through netlink 
to nftables.
starts a transaction:
     - manip 1
     - manip 2
     - ...
     - manip n
Commit or Abort.

done.

Now, for whatever reason: the software crashes in the middle of a 
transaction. When it restarts it has no idea what it was doing and why.
Here is why we should tight the transaction per netlink connection: if 
the connections breaks, we abort right away. It's transparent.
It's consistent also with the fact that you raise a notification only 
when the rule has been activated. Until it comes: no one knows about those
rules in the transaction but the one who owns the transaction.

We could do that via the struct sock { ... user_data ... }; related to 
the netlink connection, storing the transaction list.

Now, no need of a flag: if the transaction list for the current netlink 
connection is not NULL: you know you are on a transaction-based work, so
whatever manipulation comes: it will be part of the transaction. If it's 
NULL, you do as usual: activating the rule right away.


>
>>>    *	@list: used internally
>>>    *	@rcu_head: used internally
>>> + *	@net: net namespace that this chain belongs to
>> I would see that in another patch, even if it's a really tiny one.
>> (preceding this current one)
>> Moreover that we will have to full support the namespaces at some
>> point, right?
> I need that net for the code in nft_do_chain_pktinfo added in this
> patch. Probably it can be added to base chains only, would need to
> check that.

Indeed. I missed that.


Tomasz
