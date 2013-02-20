From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Wed, 20 Feb 2013 01:44:41 +0100
Message-ID: <20130220004441.GA4061@localhost>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
 <1359590645-4703-3-git-send-email-pablo@netfilter.org>
 <20130219220257.GF3240@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:15515 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932691Ab3BTAoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:44:46 -0500
Content-Disposition: inline
In-Reply-To: <20130219220257.GF3240@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Tue, Feb 19, 2013 at 11:02:58PM +0100, Patrick McHardy wrote:
> On Thu, Jan 31, 2013 at 01:03:59AM +0100, pablo@netfilter.org wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > This patch adds global atomic rule updates and dumps based on
> > bitmask generations. This allows to atomically commit a set of
> > rule-set updates incrementally without altering the internal
> > state of existing nf_tables expressions/matches/targets.
> > 
> > The idea consists of using a generation cursor of 1 bit and
> > a bitmask of 2 bits per rule. Assuming the gencursor is 0,
> > then the genmask (expressed as a bitmask) can be interpreted
> > as:
> > 
> > 00 active in the present, will be active in the next generation.
> > 01 inactive in the present, will be active in the next generation.
> > 10 active in the present, will be deleted in the next generation.
> >  ^
> >  gencursor
> > 
> > Once you invoke the transition to the next generation, the global
> > gencursor is updated:
> > 
> > 00 active in the present, will be active in the next generation.
> > 01 active in the present, needs to zero its future, it becomes 00.
> > 10 inactive in the present, delete now.
> > ^
> > gencursor
> > 
> > If a dump is in progress and nf_tables enters a new generation,
> > the dump will stop and return -EBUSY to let userspace know that
> > it has to retry again. In order to invalidate dumps, a global
> > genctr counter is increased everytime nf_tables enters a new
> > generation.
> > 
> > This new operation can be used from the user-space utility
> > that controls the firewall, eg.
> > 
> > nft restore < file
> > 
> > The rule updates contained in `file' will be applied atomically.
> > 
> > cat file
> > -----
> > add filter INPUT ip saddr 1.1.1.1 counter accept #1
> > del filter INPUT ip daddr 2.2.2.2 counter drop   #2
> > commit                                           #3
> > -EOF-
> > 
> > Note that the rule 1 will be inactive until the transition to the
> > next generation, the rule 2 will be evicted in the next generation.
> > 
> > There is a penalty during the rule update due to the branch
> > misprediction in the packet matching framework. But that should be
> > quickly resolved once the iteration over the dirty list that
> > contain rules that require updates is finished.
> > 
> > Event notification happens once the rule-set update has been
> > committed. So we skip notifications is case the rule-set update
> > is aborted, which can happen in case that the rule-set is tested
> > to apply correctly.
> > 
> > This patch is based on ideas extracted from discussions with
> > Patrick McHardy.
> 
> Generally, I think this has a pretty high penalty both memory-wise
> and performance-wise, so we should reconsider the idea of moving
> most of the costs to userspace by temporarily adding "skip" rules
> that skip over uncommitted rules.
>
> A couple of comments on the patch below though.
> 
> > @@ -37,6 +37,8 @@ enum nf_tables_msg_types {
> >  	NFT_MSG_NEWSETELEM,
> >  	NFT_MSG_GETSETELEM,
> >  	NFT_MSG_DELSETELEM,
> > +	NFT_MSG_COMMIT,
> > +	NFT_MSG_ABORT,
> 
> I see why you're doing this, but this is similar to the NEWCHAINNAME
> attribute, it doesn't really fit into the scheme how the netlink API
> is designed.

What would you suggest as an alternative?

> > index 3ba63b6..1131e49 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -319,15 +319,19 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
> >   *	struct nft_rule - nf_tables rule
> >   *
> >   *	@list: used internally
> > + *	@dirty_list: this rule needs an update after new generation
> >   *	@rcu_head: used internally for rcu
> >   *	@handle: rule handle
> > + *	@genmask: generation mask
> >   *	@dlen: length of expression data
> >   *	@data: expression data
> >   */
> >  struct nft_rule {
> >  	struct list_head		list;
> > +	struct list_head		dirty_list;
> 
> This is a quite heavy price. To reduce memory overhead, we could just have
> dirty chains and iterate over all rules within them.

We can save that the extra struct list_head for the dirty_list in the
rule by allocating temporary container structure, I have a follow up
patch for that.

> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index db6150b..7f08381 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> >  static int nf_tables_dump_rules(struct sk_buff *skb,
> >  				struct netlink_callback *cb)
> >  {
> > @@ -1250,6 +1288,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
> >  	unsigned int idx = 0, s_idx = cb->args[0];
> >  	struct net *net = sock_net(skb->sk);
> >  	int family = nfmsg->nfgen_family;
> > +	unsigned int genctr = net->nft.genctr, gencursor = net->nft.gencursor;
> >  
> >  	list_for_each_entry(afi, &net->nft.af_info, list) {
> >  		if (family != NFPROTO_UNSPEC && family != afi->family)
> > @@ -1258,6 +1297,8 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
> >  		list_for_each_entry(table, &afi->tables, list) {
> >  			list_for_each_entry(chain, &table->chains, list) {
> >  				list_for_each_entry(rule, &chain->rules, list) {
> > +					if (!nft_rule_is_active(net, rule))
> > +						goto cont;
> 
> Not sure whether we should really skip them during the dump. That hides
> information from userspace, we could just as well include an INACTIVE flag
> and have userspace decide whether to process them or not.

Agreed, they should be dumped.

> > +static void
> > +nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
> > +{
> > +	if (flags & NFT_RULE_F_COMMIT) {
> > +		struct nft_chain *chain = (struct nft_chain *)ctx->chain;
> > +
> > +		nft_rule_disactivate_next(ctx->net, rule);
> 
> deactivate :)

Hm, I swear I checked this in the dictionary before writing it, you
know how broken my English can be ;-)

> > +		list_add(&rule->dirty_list, &chain->dirty_rules);
> > +	} else {
> > +		list_del_rcu(&rule->list);
> > +		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
> > +				      ctx->chain, rule, NFT_MSG_DELRULE,
> > +				      0, ctx->afi->family);
> > +		nf_tables_rule_destroy(rule);
> > +	}
> > +}
> > +
> >  static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
> >  			     const struct nlmsghdr *nlh,
> >  			     const struct nlattr * const nla[])
> > +static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
> > +			    const struct nlmsghdr *nlh,
> > +			    const struct nlattr * const nla[])
> > +{
> > +	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> > +	const struct nft_af_info *afi;
> > +	struct net *net = sock_net(skb->sk);
> > +	struct nft_table *table;
> > +	struct nft_chain *chain;
> > +	struct nft_rule *rule, *tmp;
> > +	int family = nfmsg->nfgen_family;
> > +	bool create;
> > +
> > +	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> > +
> > +	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
> > +	if (IS_ERR(afi))
> > +		return PTR_ERR(afi);
> > +
> > +	/* Bump generation counter, invalidate any dump in progress */
> > +	net->nft.genctr++;
> > +
> > +	/* A new generation has just started */
> > +	net->nft.gencursor++;
> > +
> > +	/* Make sure all packets have left the previous generation before
> > +	 * purging old rules.
> > +	 */
> > +	synchronize_rcu();
> 
> This doesn't work. As soon as synchronize_rcu() is finished, new packets
> might enter nft_do_chain(). And this also seems to be the main problem
> with this approach, you can't iteratively flip the active bits without
> locking out packet processing, otherwise it will be just as non-atomic as
> it is now. For this to work you'd need a bigger generation counter in the
> rules that doesn't overflow and doesn't require changes to its values.

The gencursor is being cached at the entrace of nft_do_chain_pktinfo to
avoid that intermediate state. So AFAICS we wait until old packets
have finished iterating over the rule-set with the old gencursor and,
then, new packets will see the new rule-set using the new gencursor.

> > +	list_for_each_entry(table, &afi->tables, list) {
> > +		list_for_each_entry(chain, &table->chains, list) {
> > +			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
> > +				/* Delete this rule from the dirty list */
> > +				list_del(&rule->dirty_list);
> > +
> > +				/* This rule was inactive in the past and just
> > +				 * became active. Clear the next bit of the
> > +				 * genmask since its meaning has changed, now
> > +				 * it is the future.
> > +				 */
> > +				if (nft_rule_is_active(net, rule)) {
> > +					nft_rule_clear(net, rule);
> > +					nf_tables_rule_notify(skb, nlh, table,
> > +							      chain, rule,
> > +							      NFT_MSG_NEWRULE,
> > +							      0,
> > +							      nfmsg->nfgen_family);
> > +					continue;
> > +				}
> > +
> > +				/* This rule is in the past, get rid of it */
> > +				list_del_rcu(&rule->list);
> > +				nf_tables_rule_notify(skb, nlh, table, chain,
> > +						      rule, NFT_MSG_DELRULE, 0,
> > +						      family);
> > +				nf_tables_rule_destroy(rule);
> > +			}
