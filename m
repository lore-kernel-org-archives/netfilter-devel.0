From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Wed, 20 Feb 2013 02:12:21 +0100
Message-ID: <20130220011221.GA4175@localhost>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
 <1359590645-4703-3-git-send-email-pablo@netfilter.org>
 <51226244.7060503@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:15436 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932307Ab3BTBM0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:12:26 -0500
Content-Disposition: inline
In-Reply-To: <51226244.7060503@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Mon, Feb 18, 2013 at 07:17:56PM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> Hopefully you mentioned such patchset, went far away in my mail box.
> I am fine with most of them but this particular one.
> Some small parts should be reworked a bit.
> 
> The overall idea is nice, especially the bit field so it does not
> make the nft_rule bigger.
> 
> >diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> >index 7640290..3749069 100644
> >--- a/include/linux/netfilter/nf_tables.h
> >+++ b/include/linux/netfilter/nf_tables.h
> >@@ -37,6 +37,8 @@ enum nf_tables_msg_types {
> >  	NFT_MSG_NEWSETELEM,
> >  	NFT_MSG_GETSETELEM,
> >  	NFT_MSG_DELSETELEM,
> >+	NFT_MSG_COMMIT,
> >+	NFT_MSG_ABORT,
> >  	NFT_MSG_MAX,
> >  };
> >@@ -85,12 +87,18 @@ enum nft_chain_attributes {
> >  };
> >  #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
> >+enum {
> >+	NFT_RULE_F_COMMIT	= (1 << 0),
> >+	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
> >+};
> >+
> 
> I guess you added this flags to add rules on non-transaction based
> use-case, so it commits right away.
> Wouldn't it be better to have no such flags in the API, but instead
> keep track of an on going transaction in the struct nft_ctx (let's
> have an internal flag here).
> I.E: no on-going transaction -> we directly commit. If not, it's
> handled as being part of the transaction.
> 
> I just took a look at nfnetlink however, it does not seem possible
> to keep a data pointer per connection on the subsystem.
> Wait, there is a field in struct sock that is meant for such usage.
> It would require to change nf_tables_api.c only then.
> Would it make sense or am I wrong with nft_ctx usage?  (there would
> be an issue: to free such context when the connection goes down, we
> could abort an on-going transaction this way then)

We can define some container structure to store rules in the dirty
list:

struct nft_rule_update {
        struct list_head head;
        uint32_t nl_portid;
        struct nft_rule *rule;
        struct nft_table *table;
        struct nft_chain *chain;
}

That should allows us to remove the struct list_head dirty_list in
struct nft_rule that I needed for this.

The nl_portid would be the netlink portid so we know what updates
belong to what netlink connection. Still I don't see how to get rid of
the commit flag.

Could you develop your idea?

> >  enum nft_rule_attributes {
> >  	NFTA_RULE_UNSPEC,
> >  	NFTA_RULE_TABLE,
> >  	NFTA_RULE_CHAIN,
> >  	NFTA_RULE_HANDLE,
> >  	NFTA_RULE_EXPRESSIONS,
> >+	NFTA_RULE_FLAGS,
> >  	__NFTA_RULE_MAX
> >  };
> 
> ... then it would not require such extra arguments, we would keep a
> simple api.
> 
> >   *	@rcu_head: used internally for rcu
> >   *	@handle: rule handle
> >+ *	@genmask: generation mask
> >   *	@dlen: length of expression data
> >   *	@data: expression data
> >   */
> >  struct nft_rule {
> >  	struct list_head		list;
> >+	struct list_head		dirty_list;
> >  	struct rcu_head			rcu_head;
> >-	u64				handle:48,
> >+	u64				handle:46,
> >+					genmask:2,
> >  					dlen:16;
> >  	unsigned char			data[]
> >  		__attribute__((aligned(__alignof__(struct nft_expr))));
> >@@ -366,8 +370,10 @@ enum nft_chain_flags {
> >   *	struct nft_chain - nf_tables chain
> >   *
> >   *	@rules: list of rules in the chain
> >+ *	@dirty_rules: rules that need an update after next generation
> 
> See the end of the patch, on abort or commit function. I think we
> should try to do something better (performance wise)
> 
> >   *	@list: used internally
> >   *	@rcu_head: used internally
> >+ *	@net: net namespace that this chain belongs to
> 
> I would see that in another patch, even if it's a really tiny one.
> (preceding this current one)
> Moreover that we will have to full support the namespaces at some
> point, right?

I need that net for the code in nft_do_chain_pktinfo added in this
patch. Probably it can be added to base chains only, would need to
check that.

> >+static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
> >+			    const struct nlmsghdr *nlh,
> >+			    const struct nlattr * const nla[])
> >+{
> >+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> >+	const struct nft_af_info *afi;
> >+	struct net *net = sock_net(skb->sk);
> >+	struct nft_table *table;
> >+	struct nft_chain *chain;
> >+	struct nft_rule *rule, *tmp;
> >+	int family = nfmsg->nfgen_family;
> >+	bool create;
> >+
> >+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> >+
> >+	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
> >+	if (IS_ERR(afi))
> >+		return PTR_ERR(afi);
> >+
> >+	/* Bump generation counter, invalidate any dump in progress */
> >+	net->nft.genctr++;
> >+
> >+	/* A new generation has just started */
> >+	net->nft.gencursor++;
> >+
> >+	/* Make sure all packets have left the previous generation before
> >+	 * purging old rules.
> >+	 */
> >+	synchronize_rcu();
> >+
> >+	list_for_each_entry(table, &afi->tables, list) {
> >+		list_for_each_entry(chain, &table->chains, list) {
> >+			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
> >+				/* Delete this rule from the dirty list */
> >+				list_del(&rule->dirty_list);
> 
> Ok here it sounds we could do better. Instead of storing the dirty
> list inside each chain, we may try an external one so we won't have
> to go through the whole table/chain/rule base like we do in a dump.
> If such dirty list is external (keeping a pointer on targeted table
> and chain too for each rule), it will be possible to loop only on
> it.

Yes, that's doable. We can store a pointer to the table and the chain
in the nft_rule_update container structure that I proposed above.

> And having this list_for_each_entry() make the line out of 80 chars
> anyway. (there is the same issue for nft_dump_rules and some other)
> 
> >+static int nf_tables_abort(struct sock *nlsk, struct sk_buff *skb,
> >+			   const struct nlmsghdr *nlh,
> >+			   const struct nlattr * const nla[])
> >+{
> >+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> >+	const struct nft_af_info *afi;
> >+	struct net *net = sock_net(skb->sk);
> >+	struct nft_table *table;
> >+	struct nft_chain *chain;
> >+	struct nft_rule *rule, *tmp;
> >+	bool create;
> >+
> >+	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> >+
> >+	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
> >+	if (IS_ERR(afi))
> >+		return PTR_ERR(afi);
> >+
> >+	list_for_each_entry(table, &afi->tables, list) {
> >+		list_for_each_entry(chain, &table->chains, list) {
> >+			list_for_each_entry_safe(rule, tmp, &chain->dirty_rules, dirty_list) {
> 
> Same here.
> 
> 
> Br,
> 
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
