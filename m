From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Mon, 18 Feb 2013 19:17:56 +0200
Message-ID: <51226244.7060503@linux.intel.com>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org> <1359590645-4703-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3BRRSA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:18:00 -0500
In-Reply-To: <1359590645-4703-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Hopefully you mentioned such patchset, went far away in my mail box.
I am fine with most of them but this particular one.
Some small parts should be reworked a bit.

The overall idea is nice, especially the bit field so it does not make 
the nft_rule bigger.

> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 7640290..3749069 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -37,6 +37,8 @@ enum nf_tables_msg_types {
>   	NFT_MSG_NEWSETELEM,
>   	NFT_MSG_GETSETELEM,
>   	NFT_MSG_DELSETELEM,
> +	NFT_MSG_COMMIT,
> +	NFT_MSG_ABORT,
>   	NFT_MSG_MAX,
>   };
>   
> @@ -85,12 +87,18 @@ enum nft_chain_attributes {
>   };
>   #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
>   
> +enum {
> +	NFT_RULE_F_COMMIT	= (1 << 0),
> +	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
> +};
> +

I guess you added this flags to add rules on non-transaction based 
use-case, so it commits right away.
Wouldn't it be better to have no such flags in the API, but instead keep 
track of an on going transaction in the struct nft_ctx (let's have an 
internal flag here).
I.E: no on-going transaction -> we directly commit. If not, it's handled 
as being part of the transaction.

I just took a look at nfnetlink however, it does not seem possible to 
keep a data pointer per connection on the subsystem.
Wait, there is a field in struct sock that is meant for such usage. It 
would require to change nf_tables_api.c only then.
Would it make sense or am I wrong with nft_ctx usage?  (there would be 
an issue: to free such context when the connection goes down, we could 
abort an on-going transaction this way then)

>   enum nft_rule_attributes {
>   	NFTA_RULE_UNSPEC,
>   	NFTA_RULE_TABLE,
>   	NFTA_RULE_CHAIN,
>   	NFTA_RULE_HANDLE,
>   	NFTA_RULE_EXPRESSIONS,
> +	NFTA_RULE_FLAGS,
>   	__NFTA_RULE_MAX
>   };

... then it would not require such extra arguments, we would keep a 
simple api.

>    *	@rcu_head: used internally for rcu
>    *	@handle: rule handle
> + *	@genmask: generation mask
>    *	@dlen: length of expression data
>    *	@data: expression data
>    */
>   struct nft_rule {
>   	struct list_head		list;
> +	struct list_head		dirty_list;
>   	struct rcu_head			rcu_head;
> -	u64				handle:48,
> +	u64				handle:46,
> +					genmask:2,
>   					dlen:16;
>   	unsigned char			data[]
>   		__attribute__((aligned(__alignof__(struct nft_expr))));
> @@ -366,8 +370,10 @@ enum nft_chain_flags {
>    *	struct nft_chain - nf_tables chain
>    *
>    *	@rules: list of rules in the chain
> + *	@dirty_rules: rules that need an update after next generation

See the end of the patch, on abort or commit function. I think we should 
try to do something better (performance wise)

>    *	@list: used internally
>    *	@rcu_head: used internally
> + *	@net: net namespace that this chain belongs to

I would see that in another patch, even if it's a really tiny one. 
(preceding this current one)
Moreover that we will have to full support the namespaces at some point, 
right?

> +static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
> +			    const struct nlmsghdr *nlh,
> +			    const struct nlattr * const nla[])
> +{
> +	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	const struct nft_af_info *afi;
> +	struct net *net = sock_net(skb->sk);
> +	struct nft_table *table;
> +	struct nft_chain *chain;
> +	struct nft_rule *rule, *tmp;
> +	int family = nfmsg->nfgen_family;
> +	bool create;
> +
> +	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> +
> +	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
> +	if (IS_ERR(afi))
> +		return PTR_ERR(afi);
> +
> +	/* Bump generation counter, invalidate any dump in progress */
> +	net->nft.genctr++;
> +
> +	/* A new generation has just started */
> +	net->nft.gencursor++;
> +
> +	/* Make sure all packets have left the previous generation before
> +	 * purging old rules.
> +	 */
> +	synchronize_rcu();
> +
> +	list_for_each_entry(table, &afi->tables, list) {
> +		list_for_each_entry(chain, &table->chains, list) {
> +			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
> +				/* Delete this rule from the dirty list */
> +				list_del(&rule->dirty_list);

Ok here it sounds we could do better. Instead of storing the dirty list 
inside each chain, we may try an external one so we won't have to go 
through the whole table/chain/rule base like we do in a dump. If such 
dirty list is external (keeping a pointer on targeted table and chain 
too for each rule), it will be possible to loop only on it.

And having this list_for_each_entry() make the line out of 80 chars 
anyway. (there is the same issue for nft_dump_rules and some other)

> +static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
> +			   const struct nlmsghdr *nlh,
> +			   const struct nlattr * const nla[])
> +{
> +	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	const struct nft_af_info *afi;
> +	struct net *net = sock_net(skb->sk);
> +	struct nft_table *table;
> +	struct nft_chain *chain;
> +	struct nft_rule *rule, *tmp;
> +	bool create;
> +
> +	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> +
> +	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
> +	if (IS_ERR(afi))
> +		return PTR_ERR(afi);
> +
> +	list_for_each_entry(table, &afi->tables, list) {
> +		list_for_each_entry(chain, &table->chains, list) {
> +			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {

Same here.


Br,

Tomasz
