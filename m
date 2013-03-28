From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] nf_tables: Transaction API proposal
Date: Thu, 28 Mar 2013 10:01:42 +0200
Message-ID: <5153F8E6.5080900@linux.intel.com>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org> <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1364293144-4147-2-git-send-email-tomasz.bursztyka@linux.intel.com> <20130327163550.GA5136@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab3C1IBp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:01:45 -0400
In-Reply-To: <20130327163550.GA5136@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -37,8 +37,9 @@ enum nf_tables_msg_types {
>>   	NFT_MSG_NEWSETELEM,
>>   	NFT_MSG_GETSETELEM,
>>   	NFT_MSG_DELSETELEM,
>> -	NFT_MSG_COMMIT,
>> -	NFT_MSG_ABORT,
>> +	NFT_MSG_START_TRANSACTION,
>> +	NFT_MSG_COMMIT_TRANSACTION,
>> +	NFT_MSG_ABORT_TRANSACTION,
> No need to rename this and use long names, I would leave them as:
>
> NFT_MSG_BEGIN
> NFT_MSG_COMMIT
> NFT_MSG_ABORT

I did that change to get a fully explicit message name, as all the other 
ones are actually.
Why not shortening to NFT_MSG_BEGIN_TRANS then? or something like that.

>
>>   	NFT_MSG_MAX,
>>   };
>>   
>> @@ -88,18 +89,12 @@ enum nft_chain_attributes {
>>   };
>>   #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
>>   
>> -enum {
>> -	NFT_RULE_F_COMMIT	= (1 << 0),
>> -	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
>> -};
> I like the idea of removing the COMMIT flag by the explicit
> NFT_MSG_BEGIN.
>
>> -static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
>> +static int nf_tables_transaction_add(const struct nft_ctx *ctx,
>> +				     struct nft_transaction *transaction,
>> +				     struct nft_rule *rule)
>>   {
>>   	struct nft_rule_update *rupd;
>>   
>> -	/* Another socket owns the dirty list? */
>> -	if (!ctx->net->nft.pid_owner)
>> -		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
>> -	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
>> -		return -EBUSY;
> We still need that there is a single owner at time. Otherwise two
> ongoing transactions may overlap.

One of the point of this RFC is to propose a way to enable transaction 
per-client.
It's actually not nice to enable only one transaction at a time, what do 
we do if the owner never commits?
That's why I thought I could store client's transaction somewhere.

But my proposal is bogus anyway as you noticed below, about sk_user_data.

>
>> +static int nf_tables_start_transaction(struct sock *nlsk, struct sk_buff *skb,
>> +				       const struct nlmsghdr *nlh,
>> +				       const struct nlattr * const nla[])
>> +{
>> +	struct nft_transaction *transaction;
>> +
>> +	if (nlsk->sk_user_data != NULL)
>> +		return -EALREADY;
>> +
>> +	transaction = kmalloc(sizeof(struct nft_transaction), GFP_KERNEL);
>> +	if (transaction == NULL)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&transaction->updates);
>> +	nlsk->sk_user_data = transaction;
> This is global to all other subsystems sharing the nfnetlink bus. This
> patch will be smaller if you reuse the existing per-net list that is
> used for rule updates.

Ok I was suspecting something like that about this socket. I first 
thought it was tight to the client.
We have to figure out something else then, having a list of pid_owner + 
transaction list.
We could also limit this list to very few amount of owners, let's say 5?

Of course this would lead to lookup in this list every time a request is 
made, to know whether or not the pid_owner has started a transaction or not.

I will prepare another RFC

Tomasz
