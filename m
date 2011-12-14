From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 14:18:02 +0100
Message-ID: <20111214131802.GB2749@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
 <4EE88729.7010507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58662 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab1LNNSK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:18:10 -0500
Content-Disposition: inline
In-Reply-To: <4EE88729.7010507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 12:23:21PM +0100, Patrick McHardy wrote:
[...]
> >+nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
> >+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
> >+{
> >+	int ret;
> >+	struct nf_acct *acct, *matching = NULL;
> >+	char *acct_name;
> >+
> >+	if (!tb[NFACCT_NAME])
> >+		return -EINVAL;
> >+
> >+	acct_name = nla_data(tb[NFACCT_NAME]);
> >+
> >+	rcu_read_lock();
> >+	list_for_each_entry(acct,&nfnl_acct_list, head) {
> 
> I don't really get the locking concept. All netlink operations happen under
> the nfnl mutex, so using RCU for the lookup shouldn't be necessary
> (applied to all netlink operations).

If you add one iptables rule with NFACCT, you have to iterate over the
list (without the mutex). Very unlikely, but we may delete one
accounting object via nfnetlink at the same time of adding the rule
that refers to it.

> >+		if (strncmp(acct->name, acct_name, NFACCT_NAME_MAX) != 0)
> >+			continue;
> >+
> >+                if (nlh->nlmsg_flags&  NLM_F_EXCL) {
> >+			rcu_read_unlock();
> >+			ret = -EEXIST;
> >+			goto err;
> >+		}
> >+		matching = acct;
> 
> break?

Indeed.

> >+        }
> >+	rcu_read_unlock();
> >+
> >+	acct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
> >+	if (acct == NULL) {
> >+		ret = -ENOMEM;
> >+		goto err;
> >+	}
> >+	spin_lock_init(&acct->lock);
> >+	strncpy(acct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
> >+	if (tb[NFACCT_BYTES])
> >+		acct->bytes = be64_to_cpu(nla_get_u64(tb[NFACCT_BYTES]));
> >+	if (tb[NFACCT_PKTS])
> >+		acct->pkts = be64_to_cpu(nla_get_u64(tb[NFACCT_PKTS]));
> >+
> >+	atomic_inc(&acct->refcnt);
> >+
> >+	/* We are protected by nfnl mutex. */
> >+	if (matching) {
> 
> This seems to be a replace operation, so I think you should
> require NLM_F_REPLACE. Also it seems you could just
> reinitialize the existing counter instead of unconditionally
> allocating a new one.

I think it's easier to return -EBUSY as you suggested.

> >+		list_del_rcu(&matching->head);
> >+		if (atomic_dec_and_test(&matching->refcnt))
> >+			call_rcu(&matching->rcu_head, nfnl_acct_free_rcu);
> >+
> >+	}
> >+	list_add_tail_rcu(&acct->head,&nfnl_acct_list);
> >+	return 0;
> >+err:
> >+	return ret;
> >+}
> >+
> >+static int
> >+nfnl_acct_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
> >+		   int event, struct nf_acct *acct)
> >+{
> >+	struct nlmsghdr *nlh;
> >+	struct nfgenmsg *nfmsg;
> >+	unsigned int flags = pid ? NLM_F_MULTI : 0;
> >+
> >+	event |= NFNL_SUBSYS_ACCT<<  8;
> >+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(*nfmsg), flags);
> >+	if (nlh == NULL)
> >+		goto nlmsg_failure;
> >+
> >+	nfmsg = nlmsg_data(nlh);
> >+	nfmsg->nfgen_family = AF_UNSPEC;
> >+	nfmsg->version = NFNETLINK_V0;
> >+	nfmsg->res_id = 0;
> >+
> >+	NLA_PUT_STRING(skb, NFACCT_NAME, acct->name);
> >+	NLA_PUT_BE64(skb, NFACCT_PKTS, cpu_to_be64(acct->pkts));
> >+	NLA_PUT_BE64(skb, NFACCT_BYTES, cpu_to_be64(acct->bytes));
> >+
> >+	nlmsg_end(skb, nlh);
> >+	return skb->len;
> >+
> >+nlmsg_failure:
> >+nla_put_failure:
> >+	nlmsg_cancel(skb, nlh);
> >+	return -1;
> >+}
> >+
> >+static int
> >+nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
> >+{
> >+	struct nf_acct *cur, *last;
> >+
> >+	if (cb->args[2])
> >+		return 0;
> >+
> >+	last = (struct nf_acct *)cb->args[1];
> >+	if (cb->args[1])
> >+		cb->args[1] = 0;
> >+
> >+	rcu_read_lock();
> >+	list_for_each_entry(cur,&nfnl_acct_list, head) {
> >+		if (last&&  cur != last)
> >+			continue;
> >+
> >+		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).pid,
> >+				       cb->nlh->nlmsg_seq,
> >+				       NFNL_MSG_ACCT_NEW, cur)<  0) {
> >+			cb->args[1] = (unsigned long)cur;
> >+			break;
> >+		}
> >+
> >+		if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) ==
> >+						NFNL_MSG_ACCT_GET_CTRZERO) {
> >+			spin_lock_bh(&cur->lock);
> >+			cur->pkts = 0;
> >+			cur->bytes = 0;
> >+			spin_unlock_bh(&cur->lock);
> >+		}
> >+	}
> >+	if (!cb->args[1])
> >+		cb->args[2] = 1;
> >+	rcu_read_unlock();
> >+	return skb->len;
> >+}
> >+
> >+static int
> >+nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
> >+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
> >+{
> >+	int ret = 0;
> >+	struct nf_acct *cur;
> >+	char *acct_name;
> >+
> >+	if (nlh->nlmsg_flags&  NLM_F_DUMP) {
> >+		return netlink_dump_start(nfnl, skb, nlh, nfnl_acct_dump,
> >+					  NULL, 0);
> >+	}
> >+
> >+	if (!tb[NFACCT_NAME])
> >+		return -EINVAL;
> >+	acct_name = nla_data(tb[NFACCT_NAME]);
> >+
> >+	rcu_read_lock();
> >+	list_for_each_entry(cur,&nfnl_acct_list, head) {
> >+		struct sk_buff *skb2;
> >+
> >+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
> >+			continue;
> >+
> >+		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> >+		if (skb2 == NULL)
> >+			break;
> >+
> >+		ret = nfnl_acct_fill_info(skb2, NETLINK_CB(skb).pid,
> >+					 nlh->nlmsg_seq,
> >+					 NFNL_MSG_ACCT_NEW, cur);
> >+		if (ret<= 0)
> >+			kfree_skb(skb2);
> >+
> >+		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
> >+						NFNL_MSG_ACCT_GET_CTRZERO) {
> >+			spin_lock_bh(&cur->lock);
> >+			cur->pkts = 0;
> >+			cur->bytes = 0;
> >+			spin_unlock_bh(&cur->lock);
> >+		}
> >+		break;
> >+	}
> >+	rcu_read_unlock();
> >+	return ret;
> >+}
> >+
> >+static int
> >+nfnl_acct_del(struct sock *nfnl, struct sk_buff *skb,
> >+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
> >+{
> >+	char *acct_name;
> >+	struct nf_acct *cur;
> >+	int ret = -ENOENT;
> >+
> >+	if (!tb[NFACCT_NAME]) {
> >+		rcu_read_lock();
> >+		list_for_each_entry(cur,&nfnl_acct_list, head) {
> >+			/* We are protected by nfnl mutex. */
> >+			list_del_rcu(&cur->head);
> >+			if (atomic_dec_and_test(&cur->refcnt))
> >+				call_rcu(&cur->rcu_head, nfnl_acct_free_rcu);
> 
> I think its strange to keep the object around after deletion if
> it is still in use. In case it is still in use, I'd return -EBUSY.

-EBUSY sounds fine to me.

> >+		}
> >+		rcu_read_lock();
> >+		return 0;
> >+	}
> >+	acct_name = nla_data(tb[NFACCT_NAME]);
> >+
> >+	rcu_read_lock();
> >+	list_for_each_entry(cur,&nfnl_acct_list, head) {
> >+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX) != 0)
> >+			continue;
> >+
> >+		/* We are protected by nfnl mutex. */
> >+		list_del_rcu(&cur->head);
> >+		if (atomic_dec_and_test(&cur->refcnt))
> >+			call_rcu(&cur->rcu_head, nfnl_acct_free_rcu);
> >+		ret = 0;
> >+		break;
> >+	}
> >+	rcu_read_lock();
> >+	return ret;
> >+}
> >+
> >+static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
> >+	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
> >+	[NFACCT_BYTES] = { .type = NLA_U64 },
> >+	[NFACCT_PKTS] = { .type = NLA_U64 },
> >+};
> >+
> >+static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
> >+	[NFNL_MSG_ACCT_NEW]		= { .call = nfnl_acct_new,
> >+					    .attr_count = NFACCT_MAX,
> >+					    .policy = nfnl_acct_policy },
> >+	[NFNL_MSG_ACCT_GET] 		= { .call = nfnl_acct_get,
> >+					    .attr_count = NFACCT_MAX,
> >+					    .policy = nfnl_acct_policy },
> >+	[NFNL_MSG_ACCT_GET_CTRZERO] 	= { .call = nfnl_acct_get,
> >+					    .attr_count = NFACCT_MAX,
> >+					    .policy = nfnl_acct_policy },
> >+	[NFNL_MSG_ACCT_DEL]		= { .call = nfnl_acct_del,
> >+					    .attr_count = NFACCT_MAX,
> >+					    .policy = nfnl_acct_policy },
> >+};
> >+
> >+static const struct nfnetlink_subsystem nfnl_acct_subsys = {
> >+	.name				= "acct",
> >+	.subsys_id			= NFNL_SUBSYS_ACCT,
> >+	.cb_count			= NFNL_MSG_ACCT_MAX,
> >+	.cb				= nfnl_acct_cb,
> >+};
> >+
> >+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
> >+
> >+struct nf_acct *nfnl_acct_find_get(const char *acct_name)
> >+{
> >+	struct nf_acct *cur, *acct = NULL;
> >+
> >+	rcu_read_lock();
> >+	list_for_each_entry(cur,&nfnl_acct_list, head) {
> >+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
> >+			continue;
> >+
> >+		acct = cur;
> >+		atomic_inc(&acct->refcnt);
> 
> This probably needs atomic_inc_not_zero() since the
> lookup might race with deletion.

I'll fix this.

> >+		break;
> >+	}
> >+	rcu_read_unlock();
> >+	return acct;
> >+}
> >+EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
> >+
> >+void nfnl_acct_put(struct nf_acct *acct)
> >+{
> >+	if (atomic_dec_and_test(&acct->refcnt))
> >+		call_rcu(&acct->rcu_head, nfnl_acct_free_rcu);
> >+}
> >+EXPORT_SYMBOL_GPL(nfnl_acct_put);
> >+
> >+void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
> >+{
> >+	spin_lock_bh(&nfacct->lock);
> >+	nfacct->pkts++;
> >+	nfacct->bytes += skb->len;
> >+	spin_unlock_bh(&nfacct->lock);
> >+}
> >+EXPORT_SYMBOL_GPL(nfnl_acct_update);
> >+
> >+static int __init nfnl_acct_init(void)
> >+{
> >+	int ret;
> >+
> >+	pr_info("nfnl_acct: registering with nfnetlink.\n");
> >+	ret = nfnetlink_subsys_register(&nfnl_acct_subsys);
> >+	if (ret<  0) {
> >+		pr_err("nfnl_acct_init: cannot register with nfnetlink.\n");
> >+		goto err_out;
> >+	}
> >+	return 0;
> >+err_out:
> >+	return ret;
> >+}
> >+
> >+static void __exit nfnl_acct_exit(void)
> >+{
> >+	struct nf_acct *cur, *tmp;
> >+
> >+	pr_info("nfnl_acct: unregistering from nfnetlink.\n");
> >+	nfnetlink_subsys_unregister(&nfnl_acct_subsys);
> >+
> >+	/* if we can remove this module, it means that it has no clients. */
> >+	list_for_each_entry_safe(cur, tmp,&nfnl_acct_list, head) {
> >+		list_del_rcu(&cur->head);
> >+		if (atomic_dec_and_test(&cur->refcnt))
> >+			kfree(cur);
> 
> What happens if it is non-zero? The iptables target should
> take a module reference as long as its using objects that
> this module is responsible for managing.

I'll fix this as well.

Thanks for the review!
