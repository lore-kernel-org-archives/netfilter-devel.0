From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Thu, 18 Oct 2012 18:22:24 +0200
Message-ID: <1350577344-16321-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47280 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312Ab2JRQUk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:20:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When users wish to annotate connections with extra information,
(e.g. "connection came in on interface eth1"), the only way of doing so
at the moment is using connmarks.

As connmark is only 32-bit wide, this can become a problem when the
number of desired meta-information increases (especially true when also
using connmarks to label policy routing marks, and/or using dpi crap, etc).

This patch essentially adds a kernel store of (user-defined) label names.
Users can then assign these names to connections, with as many names per
connection as desired (current - arbitrarily chosen - limit is 32k
different names total).

Also includes match/target extensions to add/match based on connection names
(or "connection labels").

Notes:
- label added to a connection is "sticky", i.e. cannot be "un-set" again
- adding a new label to kernel is slow (new labels can currently
  only be added via netfilter ruleset).
- matching connection based on label is fast.

Things that might make sense, once this idea is deemed sane enough:
- ability for userspace to tag connections via nfqueue
- nfnetlink extension that can be used by userspace to dump list of labels,
  and get notifications when new labels are added/removed
- tc match

I am not sure of connlabels should interact with ctnetlink
(don't think its a good idea to also send a list of all ct-assigned labels
per ct-event); perhaps via a new nfnetlink extension?

Comments?
Feature requests?

Thanks,
Florian
---
 include/linux/netfilter/xt_connlabel.h      |   17 +
 include/net/netfilter/nf_conntrack_extend.h |    4 +
 include/net/netfilter/nf_conntrack_labels.h |   80 +++++
 include/net/netns/conntrack.h               |    9 +
 net/netfilter/Kconfig                       |   16 +
 net/netfilter/Makefile                      |    2 +
 net/netfilter/nf_conntrack_core.c           |   11 +
 net/netfilter/nf_conntrack_labels.c         |  468 +++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c        |    2 +
 net/netfilter/xt_connlabel.c                |  141 ++++++++
 10 files changed, 750 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_connlabel.h
 create mode 100644 include/net/netfilter/nf_conntrack_labels.h
 create mode 100644 net/netfilter/nf_conntrack_labels.c
 create mode 100644 net/netfilter/xt_connlabel.c

diff --git a/include/linux/netfilter/xt_connlabel.h b/include/linux/netfilter/xt_connlabel.h
new file mode 100644
index 0000000..850167d
--- /dev/null
+++ b/include/linux/netfilter/xt_connlabel.h
@@ -0,0 +1,17 @@
+#include <linux/types.h>
+
+#define XT_CONNLABEL_MAXLEN 22
+
+struct xt_connlabel_mtinfo {
+	char labelname[XT_CONNLABEL_MAXLEN-1]; /* not null terminated */
+	bool invert;
+	/* used internally by kernel: */
+	__u16 bit;
+};
+
+struct xt_connlabel_tginfo {
+	char labelname[XT_CONNLABEL_MAXLEN];
+	/* used internally by kernel: */
+	__u16 bit;
+};
+
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 8b4d1fc2..977bc8a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -23,6 +23,9 @@ enum nf_ct_ext_id {
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	NF_CT_EXT_TIMEOUT,
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	NF_CT_EXT_LABELS,
+#endif
 	NF_CT_EXT_NUM,
 };
 
@@ -33,6 +36,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
 #define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
 #define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
+#define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
new file mode 100644
index 0000000..6b5e9f3
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -0,0 +1,80 @@
+#include <linux/types.h>
+#include <net/net_namespace.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+#define NF_CONNLABEL_MAX 32768
+
+#define NF_CONNLABEL_NOT_ALLOCATED 1
+#define NF_CONNLABEL_NOT_ALLOCATED_BIT 0
+
+struct nf_conn_labels {
+	union {
+		unsigned long *label_bits_ptr;
+		unsigned long label_bits;
+	} u;
+	unsigned int bits;
+};
+
+static inline
+struct nf_conn_labels *nf_conn_labels_find(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	return nf_ct_ext_find(ct, NF_CT_EXT_LABELS);
+#else
+	return NULL;
+#endif
+}
+
+static inline
+struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	struct nf_conn_labels *cl_ext;
+	struct net *net = nf_ct_net(ct);
+	unsigned int label_count = ACCESS_ONCE(net->ct.labels.max);
+	unsigned long *label_bits = NULL;
+	unsigned int len;
+
+	if (label_count == 0) /* extension is disabled */
+		return NULL;
+
+	len = label_count / BITS_PER_LONG;
+	if (label_count > BITS_PER_LONG)
+		label_bits = kcalloc(len, sizeof(*label_bits), GFP_ATOMIC);
+
+	cl_ext = nf_ct_ext_add(ct, NF_CT_EXT_LABELS, GFP_ATOMIC);
+	if (cl_ext == NULL) {
+		kfree(label_bits);
+		return NULL;
+	}
+
+	if (label_bits) {
+		cl_ext->u.label_bits_ptr = label_bits;
+		cl_ext->bits = len * BITS_PER_LONG;
+	} else {
+		cl_ext->u.label_bits = NF_CONNLABEL_NOT_ALLOCATED;
+		cl_ext->bits = BITS_PER_LONG;
+	}
+
+	BUILD_BUG_ON(NF_CONNLABEL_MAX < BITS_PER_LONG);
+	BUILD_BUG_ON(NF_CONNLABEL_MAX / BITS_PER_LONG * sizeof(unsigned long) > 8192);
+	return cl_ext;
+#else
+	return NULL;
+#endif
+};
+
+void nf_conntrack_labels_fini(struct net *net);
+int nf_conntrack_labels_init(struct net *net);
+
+int nf_connlabel_add(struct net *net, const char *label);
+void nf_connlabel_del(struct net *net, u16 bit);
+
+bool nf_connlabel_match(const struct nf_conn *ct, u16 bit);
+void __nf_connlabel_set(const struct nf_conn *ct, u16 bit);
+
+int nf_connlabels_attach(struct nf_conn *ct, const char *label);
+
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a1d83cc..226cf18 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -50,6 +50,12 @@ struct nf_icmp_net {
 	unsigned int timeout;
 };
 
+struct nf_connlabels_net {
+	struct hlist_head *ct_htable;
+	struct hlist_head *ct_htable_bits;
+	unsigned int max;
+};
+
 struct nf_ip_net {
 	struct nf_generic_net   generic;
 	struct nf_tcp_net	tcp;
@@ -83,6 +89,9 @@ struct netns_ct {
 	int			sysctl_auto_assign_helper;
 	bool			auto_assign_helper_warned;
 	struct nf_ip_net	nf_ct_proto;
+#if defined(CONFIG_NF_CONNTRACK_LABELS)
+	struct nf_connlabels_net labels;
+#endif
 #ifdef CONFIG_NF_NAT_NEEDED
 	struct hlist_head	*nat_bysource;
 	unsigned int		nat_htable_size;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fefa514..80a0fdd 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -124,6 +124,15 @@ config NF_CONNTRACK_TIMESTAMP
 
 	  If unsure, say `N'.
 
+config NF_CONNTRACK_LABELS
+	bool  'Connection tracking labels'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option enables support for assigning user-defined text strings
+	  to connection tracking entries.
+
+	  If unsure, say `N'.
+
 config NF_CT_PROTO_DCCP
 	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL
@@ -472,6 +481,13 @@ config NETFILTER_XT_SET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_CONNLABELS
+	tristate '"connlimit" target and match support"'
+	depends on NF_CONNTRACK_LABELS
+	---help---
+	  This match allows you to match against connlabels assigned to the
+	  connection.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3259697..0e7139c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -4,6 +4,7 @@ nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_exp
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
+nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
@@ -70,6 +71,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
+obj-$(CONFIG_NETFILTER_XT_CONNLABELS) += xt_connlabel.o
 obj-$(CONFIG_NF_NAT) += xt_nat.o
 
 # targets
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0f241be..fb2ef9c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -45,6 +45,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
+#include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 
@@ -816,6 +817,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
+	nf_ct_labels_ext_add(ct);
 
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
 	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
@@ -1359,6 +1361,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 	}
 
 	nf_ct_free_hashtable(net->ct.hash, net->ct.htable_size);
+	nf_conntrack_labels_fini(net);
 	nf_conntrack_helper_fini(net);
 	nf_conntrack_timeout_fini(net);
 	nf_conntrack_ecache_fini(net);
@@ -1585,7 +1588,15 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_helper_init(net);
 	if (ret < 0)
 		goto err_helper;
+
+	ret = nf_conntrack_labels_init(net);
+	if (ret < 0)
+		goto err_labels;
+
 	return 0;
+
+err_labels:
+	nf_conntrack_helper_fini(net);
 err_helper:
 	nf_conntrack_timeout_fini(net);
 err_timeout:
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
new file mode 100644
index 0000000..7c70301
--- /dev/null
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -0,0 +1,468 @@
+#define DEBUG
+#include <linux/ctype.h>
+#include <linux/export.h>
+#include <linux/jhash.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+
+#include <linux/netfilter/xt_connlabel.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+
+#define HT_SIZE	(NF_CONNLABEL_MAX / 32u)
+#define HT_MASK (HT_SIZE - 1)
+
+static DEFINE_SPINLOCK(connlabels_lock);
+
+struct nf_connlabel_entry {
+	struct rcu_head rcu;
+	struct hlist_node node;
+	struct hlist_node node_bit;
+	atomic_t refcnt;
+	int bit;
+	unsigned int added;
+	char name[1];
+};
+
+static u32 hash_rnd __read_mostly;
+
+static bool __nf_connlabel_entry_get(struct nf_connlabel_entry *e)
+{
+	return atomic_inc_not_zero(&e->refcnt);
+}
+
+static void __nf_connlabel_entry_free(struct nf_connlabel_entry *ent)
+{
+	hlist_del_rcu(&ent->node_bit);
+	pr_debug("%s: free label %s, bit %d\n", __func__, ent->name, ent->bit);
+	kfree_rcu(ent, rcu);
+}
+
+static void nf_connlabel_entry_free(struct nf_connlabel_entry *ent)
+{
+	spin_lock_bh(&connlabels_lock);
+	__nf_connlabel_entry_free(ent);
+	spin_unlock_bh(&connlabels_lock);
+}
+
+static void __nf_connlabel_entry_put(struct nf_connlabel_entry *ent)
+{
+	if (atomic_dec_and_test(&ent->refcnt))
+		 __nf_connlabel_entry_free(ent);
+}
+
+static void nf_connlabel_entry_put(struct nf_connlabel_entry *ent)
+{
+	if (atomic_dec_and_test(&ent->refcnt))
+		nf_connlabel_entry_free(ent);
+}
+
+static u32 label_hash(const char *str)
+{
+	return jhash(str, strlen(str), hash_rnd) & HT_MASK;
+}
+
+static u32 label_bit_hash(unsigned int bit)
+{
+	return bit & HT_MASK;
+}
+
+static struct nf_connlabels_net *net_connlabels(struct net *net)
+{
+	return &net->ct.labels;
+}
+
+static struct hlist_head *
+__nf_connlabels_hlist(struct nf_connlabels_net *cl_net, const char *label)
+{
+	return &cl_net->ct_htable[label_hash(label)];
+}
+
+static bool labels_equal(struct nf_connlabel_entry *ent, const char *label)
+{
+	return strcmp(ent->name, label) == 0;
+}
+
+static struct hlist_head *cl_alloc_hlist_table(void)
+{
+	struct hlist_head *h = vmalloc(sizeof(struct hlist_head) * HT_SIZE);
+	if (h) {
+		unsigned int i;
+		for (i = 0; i < HT_SIZE; i++)
+			INIT_HLIST_HEAD(&h[i]);
+	}
+	return h;
+}
+
+/*
+ * slow path; only called when a new label is added to the store.
+ */
+static int __find_free_bit(struct nf_connlabels_net *cl_net)
+{
+	/* protected by connlabels_lock */
+	static unsigned long label_bits_used[NF_CONNLABEL_MAX / BITS_PER_LONG];
+	unsigned long bit;
+	struct hlist_head *list;
+	struct hlist_node *pos;
+	struct nf_connlabel_entry *ent;
+	int i;
+
+	memset(label_bits_used, 0, sizeof(label_bits_used));
+
+	/* bit 0 cannot be used.  It is reserved to indicate if
+	 * labels->u is kmalloc'd or not.
+	 */
+	__set_bit(NF_CONNLABEL_NOT_ALLOCATED_BIT, label_bits_used);
+
+	for (i = 0; i < HT_SIZE ; i++) {
+		list = &cl_net->ct_htable_bits[i];
+		if (i && hlist_empty(list))
+			break;
+		hlist_for_each_entry(ent, pos, list, node_bit) {
+			if (WARN_ON(ent->bit >= NF_CONNLABEL_MAX))
+				return -ENOSPC;
+			__set_bit(ent->bit, label_bits_used);
+		}
+	}
+	bit = find_first_zero_bit(label_bits_used, NF_CONNLABEL_MAX);
+	if (bit >= NF_CONNLABEL_MAX)
+		return -ENOSPC;
+
+	if (bit >= cl_net->max) {
+		cl_net->max = roundup(bit, BITS_PER_LONG);
+		pr_debug("cl_net->max increased to %u\n", cl_net->max);
+	}
+	return bit;
+}
+
+static int __nf_connlabels_add(struct nf_connlabels_net *cl_net,
+                               struct hlist_head *list,
+			       struct nf_connlabel_entry *ent)
+{
+	ent->bit = __find_free_bit(cl_net);
+	if (ent->bit < 0)
+		return -ENOSPC;
+
+	atomic_set(&ent->refcnt, 1);
+	ent->added = 0;
+
+	hlist_add_head_rcu(&ent->node, list);
+	hlist_add_head_rcu(&ent->node_bit,
+		&cl_net->ct_htable_bits[label_bit_hash(ent->bit)]);
+
+	pr_debug("%s: created label %s with bit %d\n",
+					__func__, ent->name, ent->bit);
+	return ent->bit;
+}
+
+static int label_valid_name(const char *name)
+{
+	if (*name == '\0')
+		return -EINVAL;
+
+	if (strnlen(name, XT_CONNLABEL_MAXLEN) >= XT_CONNLABEL_MAXLEN)
+		return -ENAMETOOLONG;
+
+	while (*name) {
+		if (*name == '/' || isspace(*name))
+			return -EINVAL;
+		name++;
+	}
+
+	return 0;
+}
+
+static int __nf_connlabel_find_get(const char *label,
+                                   const struct hlist_head *list)
+{
+	struct hlist_node *pos;
+	struct nf_connlabel_entry *ent;
+
+	hlist_for_each_entry(ent, pos, list, node) {
+		if (!labels_equal(ent, label))
+			continue;
+		ent->added++;
+		return ent->bit;
+	}
+	return -ENOENT;
+}
+
+int nf_connlabel_add(struct net *net, const char *label)
+{
+	struct nf_connlabels_net *cl_net = net_connlabels(net);
+	struct hlist_head *list;
+	struct nf_connlabel_entry *ent;
+	int ret = label_valid_name(label);
+
+	if (ret)
+		return ret;
+
+	list = __nf_connlabels_hlist(cl_net, label);
+
+	spin_lock_bh(&connlabels_lock);
+	ret = __nf_connlabel_find_get(label, list);
+	spin_unlock_bh(&connlabels_lock);
+	if (ret >= 0)
+		return ret;
+
+	ent = kmalloc(sizeof(*ent) + strlen(label), GFP_KERNEL);
+	if (!ent)
+                return -ENOMEM;
+
+	strcpy(ent->name, label);
+
+	/* check if label was added while lock was dropped */
+	spin_lock_bh(&connlabels_lock);
+	ret = __nf_connlabel_find_get(label, list);
+	if (ret >= 0) /* yes: we raced, free duplicate */
+		goto out_free;
+
+	ret = __nf_connlabels_add(cl_net, list, ent);
+	if (ret >= 0)
+		goto out;
+ out_free:
+	kfree(ent);
+ out:
+	spin_unlock_bh(&connlabels_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_connlabel_add);
+
+
+/*
+ * remove label from name_to_bit table if user count drops to zero.
+ * memory will not be released (yet) if there are conntracks that
+ * reference the label.
+ */
+void nf_connlabel_del(struct net *net, u16 bit)
+{
+	struct nf_connlabels_net *cl_net = net_connlabels(net);
+	struct nf_connlabel_entry *ent;
+	struct hlist_node *pos;
+	struct hlist_node *tmp;
+	struct hlist_head *listb;
+
+	spin_lock_bh(&connlabels_lock);
+
+	listb = &cl_net->ct_htable_bits[label_bit_hash(bit)];
+
+	hlist_for_each_entry_safe(ent, pos, tmp, listb, node_bit) {
+		if (ent->bit != bit)
+			continue;
+		if (ent->added == 0) {
+			hlist_del_rcu(&ent->node);
+			__nf_connlabel_entry_put(ent);
+		} else
+			ent->added--;
+	}
+	spin_unlock_bh(&connlabels_lock);
+}
+EXPORT_SYMBOL_GPL(nf_connlabel_del);
+
+static int labels_test_bit(unsigned int b, const struct nf_conn_labels *labels)
+{
+	if (b >= labels->bits)
+		return 0;
+
+	if (labels->u.label_bits & NF_CONNLABEL_NOT_ALLOCATED)
+		return test_bit(b, &labels->u.label_bits);
+
+	return test_bit(b, labels->u.label_bits_ptr);
+}
+
+static unsigned long *labels_get_bits(struct nf_conn_labels *labels)
+{
+	if (labels->u.label_bits & NF_CONNLABEL_NOT_ALLOCATED)
+		return &labels->u.label_bits;
+	return labels->u.label_bits_ptr;
+}
+
+static int __nf_connlabel_entry_get_cond(int b, struct nf_conn_labels *labels,
+					  struct nf_connlabel_entry *e)
+{
+	unsigned long *bitv;
+
+	if (b >= labels->bits)
+		return -ENOSPC;
+
+	bitv = labels_get_bits(labels);
+
+	if (test_and_set_bit(b, bitv) == 0) {
+		if (__nf_connlabel_entry_get(e))
+			return 0;
+		clear_bit(b, bitv);
+		return -ENOENT;
+	}
+	return -EINVAL;
+}
+
+static void labels_free_bits(struct nf_conn_labels *labels)
+{
+	if (labels->u.label_bits & NF_CONNLABEL_NOT_ALLOCATED)
+		kfree(labels->u.label_bits_ptr);
+}
+
+/* look up label in internal store and attach its identifier to ct */
+int nf_connlabels_attach(struct nf_conn *ct, const char *label)
+{
+	struct nf_conn_labels *labels;
+	struct nf_connlabels_net *cl_net;
+	struct hlist_head *list;
+	struct nf_connlabel_entry *ent;
+	struct hlist_node *pos;
+	int ret = -ENOENT;
+
+	labels = nf_conn_labels_find(ct);
+	if (!labels)
+		return -ENOSPC;
+
+	cl_net = net_connlabels(nf_ct_net(ct));
+
+	rcu_read_lock();
+
+	list = __nf_connlabels_hlist(cl_net, label);
+	hlist_for_each_entry_rcu(ent, pos, list, node) {
+		if (labels_equal(ent, label)) {
+			ret = __nf_connlabel_entry_get_cond(ent->bit,
+							labels, ent);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_connlabels_attach);
+
+/* must hold rcu_read_lock */
+void __nf_connlabel_set(const struct nf_conn *ct, u16 bit)
+{
+	struct nf_connlabel_entry *ent;
+	struct nf_connlabels_net *cl_net;
+	struct nf_conn_labels *labels;
+	struct hlist_head *list;
+	struct hlist_node *pos;
+
+	labels = nf_conn_labels_find(ct);
+	if (!labels)
+		return;
+	cl_net = net_connlabels(nf_ct_net(ct));
+
+	if (WARN_ON_ONCE(labels->bits <= bit))
+		return;
+
+	if (labels_test_bit(bit, labels))
+		return;
+
+	list = &cl_net->ct_htable_bits[label_bit_hash(bit)];
+
+	hlist_for_each_entry_rcu(ent, pos, list, node_bit) {
+		if (ent->bit == (int)bit) {
+			__nf_connlabel_entry_get_cond(bit, labels, ent);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(__nf_connlabel_set);
+
+/* rcu_read_locked via __nf_ct_ext_destroy() */
+static void nf_ct_ext_label_destroy(struct nf_conn *ct)
+{
+	struct nf_conn_labels *labels;
+	struct nf_connlabels_net *cl_net;
+	unsigned long b, *bits;
+
+	labels = nf_conn_labels_find(ct);
+	if (!labels)
+		return;
+
+	cl_net = net_connlabels(nf_ct_net(ct));
+
+	bits = labels_get_bits(labels);
+	for_each_set_bit(b, bits, labels->bits) {
+		struct nf_connlabel_entry *ent;
+		struct hlist_head *list;
+		struct hlist_node *pos;
+
+		list = &cl_net->ct_htable_bits[label_bit_hash(b)];
+
+		hlist_for_each_entry_rcu(ent, pos, list, node_bit) {
+			if ((unsigned long) ent->bit == b) {
+				nf_connlabel_entry_put(ent);
+				break;
+			}
+		}
+	}
+	labels_free_bits(labels);
+}
+
+bool nf_connlabel_match(const struct nf_conn *ct, u16 bit)
+{
+	struct nf_conn_labels *labels;
+	struct nf_connlabels_net *cl_net;
+
+	labels = nf_conn_labels_find(ct);
+	if (!labels)
+		return false;
+
+	cl_net = net_connlabels(nf_ct_net(ct));
+	return labels_test_bit(bit, labels);
+}
+EXPORT_SYMBOL_GPL(nf_connlabel_match);
+
+static struct nf_ct_ext_type labels_extend __read_mostly = {
+	.len    = sizeof(struct nf_conn_labels),
+	.align  = __alignof__(struct nf_conn_labels),
+	.destroy = nf_ct_ext_label_destroy,
+	.id     = NF_CT_EXT_LABELS,
+};
+
+int nf_conntrack_labels_init(struct net *net)
+{
+	struct nf_connlabels_net *connlabels_net;
+	int ret = -ENOMEM;
+
+	BUILD_BUG_ON(sizeof(struct nf_conn_labels) > 255);
+
+	connlabels_net = net_connlabels(net);
+        connlabels_net->ct_htable = cl_alloc_hlist_table();
+        if (!connlabels_net->ct_htable)
+                goto err;
+	connlabels_net->ct_htable_bits = cl_alloc_hlist_table();
+	if (!connlabels_net->ct_htable_bits) {
+		vfree(connlabels_net->ct_htable);
+		goto err;
+	}
+
+	if (net_eq(net, &init_net)) {
+		hash_rnd = net_random();
+
+		ret = nf_ct_extend_register(&labels_extend);
+		if (ret < 0)
+			goto err_free;
+	}
+	return 0;
+ err_free:
+	vfree(connlabels_net->ct_htable);
+	vfree(connlabels_net->ct_htable_bits);
+ err:
+	pr_err("nf_ct_connlabels: Unable to register extension\n");
+	return ret;
+}
+
+void nf_conntrack_labels_fini(struct net *net)
+{
+	unsigned int i;
+	struct nf_connlabels_net *connlabels_net = net_connlabels(net);
+
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&labels_extend);
+
+	for (i = 0; i < HT_SIZE; i++) {
+		BUG_ON(!hlist_empty(&connlabels_net->ct_htable[i]));
+		BUG_ON(!hlist_empty(&connlabels_net->ct_htable_bits[i]));
+	}
+	vfree(connlabels_net->ct_htable);
+	vfree(connlabels_net->ct_htable_bits);
+}
+
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7bbfb3d..70365bf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -43,6 +43,7 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
+#include <net/netfilter/nf_conntrack_labels.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l4proto.h>
@@ -1488,6 +1489,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
+	nf_ct_labels_ext_add(ct);
 	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
new file mode 100644
index 0000000..5e08a86
--- /dev/null
+++ b/net/netfilter/xt_connlabel.c
@@ -0,0 +1,141 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_connlabel.h>
+
+static bool
+connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+        const struct xt_connlabel_mtinfo *info = par->matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL || nf_ct_is_untracked(ct))
+		return false;
+
+	return nf_connlabel_match(ct, info->bit) ^ info->invert;
+}
+
+static unsigned int
+connlabel_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_connlabel_tginfo *info = par->targinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL || nf_ct_is_untracked(ct))
+		return XT_CONTINUE;
+
+	__nf_connlabel_set(ct, info->bit);
+	return XT_CONTINUE;
+}
+
+static int connlabels_common_checks(struct net *net, unsigned int family, const char *label)
+{
+	int ret;
+
+	if (strnlen(label, XT_CONNLABEL_MAXLEN) >= XT_CONNLABEL_MAXLEN)
+		return -ENAMETOOLONG;
+
+	ret = nf_ct_l3proto_try_module_get(family);
+	if (ret < 0) {
+		pr_info("cannot load conntrack support for proto=%u\n", family);
+		return ret;
+	}
+
+	ret = nf_connlabel_add(net, label);
+	if (ret < 0)
+	        nf_ct_l3proto_module_put(family);
+	return ret;
+}
+
+static int connlabel_tg_check(const struct xt_tgchk_param *par)
+{
+	struct xt_connlabel_tginfo *info = par->targinfo;
+	int ret;
+
+	ret = connlabels_common_checks(par->net, par->family, info->labelname);
+	if (ret < 0)
+		return ret;
+	info->bit = ret;
+	return 0;
+}
+
+static void connlabel_tg_destroy(const struct xt_tgdtor_param *par)
+{
+        struct xt_connlabel_tginfo *info = par->targinfo;
+
+	nf_connlabel_del(par->net, info->bit);
+	nf_ct_l3proto_module_put(par->family);
+}
+
+static int connlabel_mt_check(const struct xt_mtchk_param *par)
+{
+	struct xt_connlabel_mtinfo *info = par->matchinfo;
+	char name[XT_CONNLABEL_MAXLEN];
+	int ret;
+
+	strlcpy(name, info->labelname, sizeof(name));
+
+	ret = connlabels_common_checks(par->net, par->family, name);
+	if (ret < 0)
+		return ret;
+	info->bit = ret;
+	return 0;
+}
+
+static void connlabel_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	struct xt_connlabel_mtinfo *info = par->matchinfo;
+
+	nf_connlabel_del(par->net, info->bit);
+	nf_ct_l3proto_module_put(par->family);
+}
+
+static struct xt_target connlabels_tg_reg __read_mostly = {
+        .name           = "CONNLABEL",
+        .family         = NFPROTO_UNSPEC,
+        .checkentry     = connlabel_tg_check,
+        .target         = connlabel_tg,
+        .targetsize     = sizeof(struct xt_connlabel_tginfo),
+        .destroy        = connlabel_tg_destroy,
+        .me             = THIS_MODULE,
+};
+
+static struct xt_match connlabels_mt_reg __read_mostly = {
+        .name           = "connlabel",
+        .family         = NFPROTO_UNSPEC,
+        .checkentry     = connlabel_mt_check,
+        .match          = connlabel_mt,
+        .matchsize      = sizeof(struct xt_connlabel_mtinfo),
+        .destroy        = connlabel_mt_destroy,
+        .me             = THIS_MODULE,
+};
+
+static int __init connlabel_mt_init(void)
+{
+	int ret;
+
+	ret = xt_register_target(&connlabels_tg_reg);
+	if (ret < 0)
+		return ret;
+	ret = xt_register_match(&connlabels_mt_reg);
+	if (ret < 0) {
+		xt_unregister_target(&connlabels_tg_reg);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit connlabel_mt_exit(void)
+{
+	xt_unregister_target(&connlabels_tg_reg);
+	xt_unregister_match(&connlabels_mt_reg);
+}
+
+module_init(connlabel_mt_init);
+module_exit(connlabel_mt_exit);
-- 
1.7.8.6

