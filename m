From: valentina.giusti@bmw-carit.de
Subject: [PATCH 1/4] nfnetlink_acct: Traffic-based and periodic notifications
Date: Wed,  4 Sep 2013 14:05:30 +0200
Message-ID: <1378296333-19208-2-git-send-email-valentina.giusti@bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49597 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762543Ab3IDMFh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:37 -0400
In-Reply-To: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

This patch introduces notifications of accounting objects to userspace for
nfacct.
Notifications can be sent based on intervals expressed as bytes and packets
or as time periods.
When the notification request specifies both a traffic target (bytes or
packets) and a time target (period), additional parameters are available,
which allow to specify a limit for the amount of notifications based on
accounted packets or bytes to be sent during a single period.

Signed-off-by: Valentina Giusti <valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    6 +
 net/netfilter/nfnetlink_acct.c                |  280 +++++++++++++++++++++++++
 2 files changed, 286 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..8125e57 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -10,6 +10,7 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_NOTIFY,
 	NFNL_MSG_ACCT_MAX
 };
 
@@ -19,6 +20,11 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_NOTIFY_PKTS,
+	NFACCT_NOTIFY_P_RL,	/* packets notification rate limit */
+	NFACCT_NOTIFY_BYTES,
+	NFACCT_NOTIFY_B_RL,	/* bytes notification rate limit */
+	NFACCT_NOTIFY_PERIOD,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..5327c2b 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -35,9 +35,56 @@ struct nf_acct {
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
+	struct list_head	notify_list;
 	struct rcu_head		rcu_head;
 };
 
+/**
+ * struct nf_acct_notify - struct for netfilter accounting notification request
+ *
+ * @notify_rem_pkts:	packets left before the next packet-based notification
+ * @notify_rem_bytes:	bytes left before the next byte-based notification
+ * @notify_limit_pkts:	notifications limit count before the next period-based
+ *			notification
+ * @notify_limit_bytes:	notifications limit count before the next period-based
+ *			notification
+ * @head:		head of the list of notifications active on a single
+ *			nf_acct object
+ * @portid:		ID of the userspace process requesting notifications
+ * @nfnl:		netlink socket descriptor
+ * @nfacct:		pointer to the nf_acct object
+ * @pkts:		traffic target in packets
+ * @pkts_rl:		packets notification rate limit (only in combination
+ *			with period)
+ * @bytes:		traffic target in bytes
+ * @bytes_rl:		bytes notification rate limit (only in combination with
+ *			period)
+ * @period:		time notification target in seconds
+ * @work_t:		traffic-based notifications work
+ * @work_p:		period-based notifications work
+ * @lock:		lock to protect the notify list members upon deletion
+ *
+ */
+
+struct nf_acct_notify {
+	atomic_t		notify_rem_pkts;
+	atomic_t		notify_rem_bytes;
+	atomic_t		notify_limit_pkts;
+	atomic_t		notify_limit_bytes;
+	struct list_head	head;
+	u32			portid;
+	struct sock		*nfnl;
+	struct nf_acct		*nfacct;
+	u32			pkts;
+	u32			pkts_rl;
+	u32			bytes;
+	u32			bytes_rl;
+	u32			period;
+	struct work_struct	work_t;
+	struct delayed_work	work_p;
+	struct mutex		lock;
+};
+
 static int
 nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
@@ -87,6 +134,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
+	INIT_LIST_HEAD(&nfacct->notify_list);
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -219,13 +267,204 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	return ret;
 }
 
+static int
+nfnl_acct_notify_send(struct nf_acct_notify *n)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	ret = nfnl_acct_fill_info(skb, n->portid, 0, NFNL_MSG_ACCT_NOTIFY,
+				  NFNL_MSG_ACCT_NEW, n->nfacct);
+	if (ret <= 0) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return netlink_unicast(n->nfnl, skb, n->portid, MSG_DONTWAIT);
+}
+
+static void
+nfnl_acct_notify_work_traffic(struct work_struct *work)
+{
+	struct nf_acct_notify *n = container_of(work, struct nf_acct_notify,
+						work_t);
+	struct nf_acct_notify *cur, *tmp;
+	int ret;
+
+	ret = nfnl_acct_notify_send(n);
+	if (ret == -ECONNREFUSED) {
+		if (n->period) {
+			ret = mutex_trylock(&n->lock);
+			if (!ret)
+				return;
+		}
+		list_for_each_entry_safe(cur, tmp, &n->nfacct->notify_list,
+					 head) {
+			if (cur->portid != n->portid)
+				continue;
+			if (n->period) {
+				cancel_delayed_work_sync(&cur->work_p);
+				mutex_unlock(&n->lock);
+			}
+			list_del(&cur->head);
+			kfree(cur);
+			return;
+		}
+	}
+}
+
+static void
+nfnl_acct_notify_work_period(struct work_struct *work)
+{
+	struct nf_acct_notify *n = container_of((struct delayed_work *)work,
+						struct nf_acct_notify, work_p);
+	struct nf_acct_notify *cur, *tmp;
+	int ret;
+
+	ret = nfnl_acct_notify_send(n);
+	if (ret == -ECONNREFUSED) {
+		if (n->bytes || n->pkts) {
+			ret = mutex_trylock(&n->lock);
+			if (!ret)
+				return;
+		}
+		list_for_each_entry_safe(cur, tmp, &n->nfacct->notify_list,
+					 head) {
+			if (cur->portid != n->portid)
+				continue;
+			if (n->bytes || n->pkts) {
+				cancel_work_sync(&cur->work_t);
+				mutex_unlock(&n->lock);
+			}
+			list_del(&cur->head);
+			kfree(cur);
+			return;
+		}
+	}
+
+	if (n->pkts_rl) {
+		atomic_set(&n->notify_limit_pkts, n->pkts_rl);
+		atomic_set(&n->notify_rem_pkts, n->pkts);
+	}
+	if (n->bytes_rl) {
+		atomic_set(&n->notify_limit_bytes, n->bytes_rl);
+		atomic_set(&n->notify_rem_pkts, n->pkts);
+	}
+
+	schedule_delayed_work(&n->work_p, n->period * HZ);
+}
+
+static int
+nfnl_acct_notify(struct sock *nfnl, struct sk_buff *skb,
+		 const struct nlmsghdr *nlh, const struct nlattr * const tb[])
+{
+	struct nf_acct *cur;
+	char *name;
+	u32 pkts = 0, pkts_rl = 0, bytes = 0, bytes_rl = 0, period = 0;
+	struct nf_acct_notify *new;
+	int ret = -ENOENT;
+
+	if (!tb[NFACCT_NAME])
+		return -EINVAL;
+	name = nla_data(tb[NFACCT_NAME]);
+
+	if (tb[NFACCT_NOTIFY_PKTS])
+		pkts = be32_to_cpu(nla_get_be32(tb[NFACCT_NOTIFY_PKTS]));
+
+	if (tb[NFACCT_NOTIFY_BYTES])
+		bytes = be32_to_cpu(nla_get_be32(tb[NFACCT_NOTIFY_BYTES]));
+
+	if (tb[NFACCT_NOTIFY_PERIOD])
+		period = be32_to_cpu(nla_get_be32(tb[NFACCT_NOTIFY_PERIOD]));
+
+	if (tb[NFACCT_NOTIFY_P_RL] && period)
+		pkts_rl = be32_to_cpu(nla_get_be32(tb[NFACCT_NOTIFY_P_RL]));
+	if (tb[NFACCT_NOTIFY_P_RL] && !period)
+		return -EINVAL;
+
+	if (tb[NFACCT_NOTIFY_B_RL] && period)
+		bytes_rl = be32_to_cpu(nla_get_be32(tb[NFACCT_NOTIFY_B_RL]));
+	if (tb[NFACCT_NOTIFY_B_RL] && !period)
+		return -EINVAL;
+
+	list_for_each_entry(cur, &nfnl_acct_list, head) {
+		if (strncmp(cur->name, name, NFACCT_NAME_MAX))
+			continue;
+
+		ret = 0;
+		new = kzalloc(sizeof(struct nf_acct_notify), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+
+		if (pkts) {
+			atomic_set(&new->notify_rem_pkts, pkts);
+			new->pkts = pkts;
+			if (pkts_rl) {
+				atomic_set(&new->notify_limit_pkts, pkts_rl);
+				new->pkts_rl = pkts_rl;
+			} else {
+				atomic_set(&new->notify_limit_pkts, -1);
+				new->pkts_rl = 0;
+			}
+		}
+
+		if (bytes) {
+			atomic_set(&new->notify_rem_bytes, bytes);
+			new->bytes = bytes;
+			if (bytes_rl) {
+				atomic_set(&new->notify_limit_bytes, bytes_rl);
+				new->bytes_rl = bytes_rl;
+			} else {
+				atomic_set(&new->notify_limit_bytes, -1);
+				new->bytes_rl = 0;
+			}
+		}
+
+		if (period)
+			new->period = period;
+
+		new->portid = NETLINK_CB(skb).portid;
+		new->nfnl = nfnl;
+		new->nfacct = cur;
+
+		list_add(&new->head, &cur->notify_list);
+
+		if ((new->bytes || new->pkts) && new->period)
+			mutex_init(&new->lock);
+
+		if (new->bytes || new->pkts)
+			INIT_WORK(&new->work_t, nfnl_acct_notify_work_traffic);
+		if (new->period) {
+			INIT_DELAYED_WORK(&new->work_p,
+					  nfnl_acct_notify_work_period);
+			schedule_delayed_work(&new->work_p, new->period * HZ);
+		}
+	}
+
+	return ret;
+}
+
 /* try to delete object, fail if it is still in use. */
 static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
+	struct nf_acct_notify *n_cur, *n_tmp;
 
 	/* we want to avoid races with nfnl_acct_find_get. */
 	if (atomic_dec_and_test(&cur->refcnt)) {
+		list_for_each_entry_safe(n_cur, n_tmp, &cur->notify_list,
+					 head) {
+			if (n_cur->pkts || n_cur->bytes)
+				cancel_work_sync(&n_cur->work_t);
+			if (n_cur->period)
+				cancel_delayed_work_sync(&n_cur->work_p);
+			list_del(&n_cur->head);
+			kfree(n_cur);
+		}
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&cur->head);
 		kfree_rcu(cur, rcu_head);
@@ -270,6 +509,11 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_NOTIFY_BYTES] = { .type = NLA_U32 },
+	[NFACCT_NOTIFY_B_RL] = { .type = NLA_U32 },
+	[NFACCT_NOTIFY_PKTS] = { .type = NLA_U32 },
+	[NFACCT_NOTIFY_P_RL] = { .type = NLA_U32 },
+	[NFACCT_NOTIFY_PERIOD] = { .type = NLA_U32 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
@@ -285,6 +529,9 @@ static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
 	[NFNL_MSG_ACCT_DEL]		= { .call = nfnl_acct_del,
 					    .attr_count = NFACCT_MAX,
 					    .policy = nfnl_acct_policy },
+	[NFNL_MSG_ACCT_NOTIFY]		= { .call = nfnl_acct_notify,
+					    .attr_count = NFACCT_MAX,
+					    .policy = nfnl_acct_policy },
 };
 
 static const struct nfnetlink_subsystem nfnl_acct_subsys = {
@@ -331,8 +578,31 @@ EXPORT_SYMBOL_GPL(nfnl_acct_put);
 
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
 {
+	int tmp, limit;
+	struct nf_acct_notify *cur;
+
 	atomic64_inc(&nfacct->pkts);
 	atomic64_add(skb->len, &nfacct->bytes);
+
+	list_for_each_entry(cur, &nfacct->notify_list, head) {
+		limit = atomic_read(&cur->notify_limit_pkts);
+		if (cur->pkts &&
+		    atomic_dec_and_test(&cur->notify_rem_pkts) && limit) {
+			schedule_work(&cur->work_t);
+			atomic_set(&cur->notify_rem_pkts, cur->pkts);
+			if (limit > 0)
+				atomic_dec(&cur->notify_limit_pkts);
+		}
+
+		tmp = atomic_sub_return(skb->len, &cur->notify_rem_bytes);
+		limit = atomic_read(&cur->notify_limit_bytes);
+		if (cur->bytes && (tmp <= 0) && limit) {
+			schedule_work(&cur->work_t);
+			atomic_set(&cur->notify_rem_bytes, cur->bytes - tmp);
+			if (limit > 0)
+				atomic_dec(&cur->notify_limit_bytes);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_update);
 
@@ -354,11 +624,21 @@ err_out:
 static void __exit nfnl_acct_exit(void)
 {
 	struct nf_acct *cur, *tmp;
+	struct nf_acct_notify *n_cur, *n_tmp;
 
 	pr_info("nfnl_acct: unregistering from nfnetlink.\n");
 	nfnetlink_subsys_unregister(&nfnl_acct_subsys);
 
 	list_for_each_entry_safe(cur, tmp, &nfnl_acct_list, head) {
+		list_for_each_entry_safe(n_cur, n_tmp, &cur->notify_list,
+					 head) {
+			if (n_cur->pkts || n_cur->bytes)
+				cancel_work_sync(&n_cur->work_t);
+			if (n_cur->period)
+				cancel_delayed_work_sync(&n_cur->work_p);
+			list_del(&n_cur->head);
+			kfree(n_cur);
+		}
 		list_del_rcu(&cur->head);
 		/* We are sure that our objects have no clients at this point,
 		 * it's safe to release them all without checking refcnt. */
-- 
1.7.10.4

