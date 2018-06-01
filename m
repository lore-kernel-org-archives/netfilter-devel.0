From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 3/5] netfilter: nf_tables: add rule ebpf jit infrastructure
Date: Fri,  1 Jun 2018 17:32:14 +0200
Message-ID: <20180601153216.10901-4-fw@strlen.de>
References: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This adds a JIT helper infrastructure to translate nft expressions to ebpf
programs.

>From commit phase, we spawn jit module (a userspace program), and then
provide the rules that came in this transaction to that program via a pipe
(in nf_tables netlink format).

The userspace helper translates the rules if possible, and installs the
program(s) via bpf syscall.

For each rule a small response containing the corresponding file descriptor
(can be -1 on failure) and a attribute count (how many expressions were
jitted) gets sent back to kernel via pipe.

If translation fails, the rule is will be processed by nf_tables
interpreter (as before this patch).

If translation succeeded, nf_tables fetches the bpf program using the file
descriptor identifier, allocates a new rule blob containing the new 'ebpf'
expression (and possible trailing un-translated expressions).

It then replaces the original rule in the transaction log with the new
'ebpf-rule'.
The original rule is retained in a private area inside the epbf expression
to be able to present the original expressions to userspace when
'nft list ruleset' is called.

For easier review, this contains the kernel-side only.
nf_tables_jit_work() will not do anything, yet.

Unresolved issues:
 - maps and sets.
   It might be possible to add a new ebpf map type that just wraps
   the nft set infrastructure for lookups.
   This would allow nft userspace to continue to work as-is while
   not requiring new ebpf helper.

 - we should eventually support translating multiple (adjacent) rules
   into single program.

   If we do this kernel will need to track mapping of rules to
   program (to re-jit when a rule is changed.  This isn't implemented
   so far, but can be added later.

   We will also need to dump the 'next' generation of the
   to-be-translated table.  The kernel has this information, so its only
   a matter of serializing it back to userspace from the commit phase.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h           |  12 ++
 net/netfilter/Kconfig                            |   7 ++
 net/netfilter/Makefile                           |   8 +-
 net/netfilter/nf_tables_api.c                    |   5 +
 net/netfilter/nf_tables_core.c                   |  31 ++++-
 net/netfilter/nf_tables_jit.c                    | 139 +++++++++++++++++++++++
 net/netfilter/nf_tables_jit/Makefile             |  18 +++
 net/netfilter/nf_tables_jit/main.c               |  21 ++++
 net/netfilter/nf_tables_jit/nf_tables_jit_kern.c |  33 ++++++
 9 files changed, 270 insertions(+), 4 deletions(-)
 create mode 100644 net/netfilter/nf_tables_jit/Makefile
 create mode 100644 net/netfilter/nf_tables_jit/main.c
 create mode 100644 net/netfilter/nf_tables_jit/nf_tables_jit_kern.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 90087a84f127..e9b5cc20ec45 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -71,6 +71,18 @@ struct nft_ebpf {
 
 extern const struct nft_expr_ops nft_ebpf_fast_ops;
 
+struct nft_jit_data_from_user {
+	int ebpf_fd;		/* fd to get program from, or < 0 if jitter error */
+	u32 expr_count;		/* number of translated expressions */
+};
+
+#if IS_ENABLED(CONFIG_NF_TABLES_JIT)
+int nft_jit_commit(struct net *net);
+#else
+static inline int nft_jit_commit(struct net *net) { return 0; }
+#endif
+int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e);
+
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3ec8886850b2..82162fe931bb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -473,6 +473,13 @@ config NF_TABLES_NETDEV
 	help
 	  This option enables support for the "netdev" table.
 
+config NF_TABLES_JIT
+	bool "Netfilter nf_tables jit infrastructure"
+	depends on BPF
+	help
+	  This option enables support for translation of nf_tables
+	  expressions to ebpf.
+
 config NFT_NUMGEN
 	tristate "Netfilter nf_tables number generator module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 49c6e0a535f9..ecb371160cf7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,8 +76,12 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
-		  nf_tables_jit.o
+		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o
+
+obj-$(CONFIG_NF_TABLES_JIT) += nf_tables_jit/
+nf_tables-$(CONFIG_NF_TABLES_JIT) += nf_tables_jit.o
+nf_tables-$(CONFIG_NF_TABLES_JIT) += nf_tables_jit/nf_tables_jit_kern.o
+nf_tables-$(CONFIG_NF_TABLES_JIT) += nf_tables_jit/nf_tables_jit_umh.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 89e61b2d048b..40c2de230400 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6092,6 +6092,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	int ret;
+
+	ret = nft_jit_commit(net);
+	if (ret < 0)
+		return ret;
 
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 038a15243508..5557b2709f98 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -93,19 +93,46 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
+/* Dirty hack: pass nft_pktinfo in skb->cb[] */
+struct nft_jit_args_inet_cb {
+	/* cb[0] */
+	u16 thoff;	 /* 0: unset */
+	u16 lloff;	 /* 0: unset */
+
+	/* cb[1] */
+	u16 l4proto;	/* thoff = 0? unset */
+	u16 reserved;
+
+	/* 12 bytes left */
+};
+
 static void nft_ebpf_fast_eval(const struct nft_expr *expr,
 			       struct nft_regs *regs,
 			       const struct nft_pktinfo *pkt)
 {
 	const struct nft_ebpf *priv = nft_expr_priv(expr);
+	struct nft_jit_args_inet_cb *jit_args;
 	struct bpf_skb_data_end cb_saved;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(struct nft_jit_args_inet_cb) > QDISC_CB_PRIV_LEN);
+
 	memcpy(&cb_saved, pkt->skb->cb, sizeof(cb_saved));
+
+	jit_args = (void *)bpf_skb_cb(pkt->skb);
+	memset(jit_args, 0, sizeof(*jit_args));
+
+	if (skb_mac_header_was_set(pkt->skb))
+		jit_args->lloff = skb_mac_header_len(pkt->skb);
+
+	if (pkt->tprot_set) {
+		jit_args->thoff = pkt->xt.thoff;
+		jit_args->l4proto = pkt->tprot;
+	}
+
 	bpf_compute_data_pointers(pkt->skb);
 
 	ret = BPF_PROG_RUN(priv->prog, pkt->skb);
-
 	memcpy(pkt->skb->cb, &cb_saved, sizeof(cb_saved));
 
 	switch (ret) {
@@ -119,9 +146,9 @@ static void nft_ebpf_fast_eval(const struct nft_expr *expr,
 	default:
 		pr_debug("Unknown verdict %d\n", ret);
 		regs->verdict.code = NF_DROP;
-		break;
 	}
 }
+
 DEFINE_STATIC_KEY_FALSE(nft_counters_enabled);
 
 static noinline void nft_update_chain_stats(const struct nft_chain *chain,
diff --git a/net/netfilter/nf_tables_jit.c b/net/netfilter/nf_tables_jit.c
index 415c2acfa471..a8f4696249bf 100644
--- a/net/netfilter/nf_tables_jit.c
+++ b/net/netfilter/nf_tables_jit.c
@@ -1,13 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf.h>
+#include <linux/filter.h>
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <linux/file.h>
+
+static int nft_jit_dump_ruleinfo(struct sk_buff *skb,
+				 const struct nft_ctx *ctx, const struct nft_rule *rule)
+{
+	const struct nft_expr *expr, *next;
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct nlattr *list;
+	int ret;
+	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWRULE);
+
+	nlh = nlmsg_put(skb, ctx->portid, ctx->seq, type, sizeof(struct nfgenmsg), 0);
+	if (nlh == NULL)
+		return -EMSGSIZE;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family = ctx->family;
+	nfmsg->version = NFNETLINK_V0;
+	nfmsg->res_id = htons(ctx->net->nft.base_seq & 0xffff);
+
+	ret = nla_put_string(skb, NFTA_RULE_TABLE, ctx->table->name);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_string(skb, NFTA_RULE_CHAIN, ctx->chain->name);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle),
+			   NFTA_RULE_PAD);
+	if (ret < 0)
+		return ret;
+
+	list = nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
+	if (list == NULL)
+		return -EMSGSIZE;
+
+	nft_rule_for_each_expr(expr, next, rule) {
+		ret = nft_expr_dump(skb, NFTA_LIST_ELEM, expr);
+		if (ret)
+			return ret;
+	}
+	nla_nest_end(skb, list);
+	nlmsg_end(skb, nlh);
+	return 0;
+}
 
 struct nft_ebpf_expression {
 	struct nft_expr e;
 	struct nft_ebpf priv;
 };
 
+static int nft_jit_rule(struct nft_trans *trans, struct sk_buff *skb)
+{
+	const struct nft_rule *r = nft_trans_rule(trans);
+	const struct nft_expr *e, *last;
+	struct nft_ebpf_expression ebpf = { 0 };
+	struct nft_rule *rule;
+	struct nft_expr *new;
+	unsigned int size = sizeof(ebpf);
+	int err, expr_count;
+
+	err = nft_jit_dump_ruleinfo(skb, &trans->ctx, nft_trans_rule(trans));
+	if (err < 0)
+		return err;
+
+	err = nf_tables_jit_work(skb, &ebpf.priv);
+	if (err < 0)
+		return err;
+
+	if (!ebpf.priv.prog)
+		return 0;
+
+	ebpf.priv.original = r;
+
+	if (r->udata) {
+		struct nft_userdata *udata = nft_userdata(r);
+
+		size += udata->len + 1;
+	}
+
+	rule = kmalloc(sizeof(*rule) + r->dlen + size, GFP_KERNEL);
+	if (!rule) {
+		bpf_prog_put(ebpf.priv.prog);
+		return -ENOMEM;
+	}
+
+	memcpy(rule, r, sizeof(*r));
+	rule->dlen = r->dlen + sizeof(ebpf);
+
+	new = nft_expr_first(rule);
+	memcpy(new, &ebpf, sizeof(ebpf));
+	new->ops = &nft_ebpf_fast_ops;
+	size = sizeof(ebpf);
+
+	expr_count = 0;
+	nft_rule_for_each_expr(e, last, r) {
+		++expr_count;
+		if (expr_count <= ebpf.priv.expressions)
+			continue; /* expression was jitted */
+
+		new = nft_expr_next(new);
+		memcpy(new, e, e->ops->size);
+		size += e->ops->size;
+	}
+
+	rule->dlen = size;
+	if (r->udata) {
+		const struct nft_userdata *udata = nft_userdata(r);
+
+		memcpy(nft_userdata(rule), udata, udata->len + 1);
+	}
+
+	list_replace_rcu(&nft_trans_rule(trans)->list, &rule->list);
+	nft_trans_rule(trans) = rule;
+
+	return 0;
+}
+
+int nft_jit_commit(struct net *net)
+{
+	struct nft_trans *trans;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->msg_type != NFT_MSG_NEWRULE)
+			continue;
+
+		ret = nft_jit_rule(trans, skb);
+		if (ret < 0)
+			break;
+		skb->head = skb->data;
+		skb_reset_tail_pointer(skb);
+	}
+
+	kfree_skb(skb);
+	return ret;
+}
+
 static const struct nla_policy nft_ebpf_policy[NFTA_EBPF_MAX + 1] = {
 	[NFTA_EBPF_FD]			= { .type = NLA_S32 },
 	[NFTA_EBPF_ID]			= { .type = NLA_U32 },
diff --git a/net/netfilter/nf_tables_jit/Makefile b/net/netfilter/nf_tables_jit/Makefile
new file mode 100644
index 000000000000..aa7509e49589
--- /dev/null
+++ b/net/netfilter/nf_tables_jit/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+
+hostprogs-y := nf_tables_jit_umh
+nf_tables_jit_umh-objs := main.o
+HOSTCFLAGS += -I. -Itools/include/
+
+quiet_cmd_copy_umh = GEN $@
+      cmd_copy_umh = echo ':' > $(obj)/.nf_tables_jit_umh.o.cmd; \
+      $(OBJCOPY) -I binary -O $(CONFIG_OUTPUT_FORMAT) \
+      -B `$(OBJDUMP) -f $<|grep architecture|cut -d, -f1|cut -d' ' -f2` \
+      --rename-section .data=.rodata $< $@
+
+$(obj)/nf_tables_jit_umh.o: $(obj)/nf_tables_jit_umh
+	$(call cmd,copy_umh)
+
+obj-$(CONFIG_NF_TABLES_JIT) += nf_tables_jit.o
+nf_tables_jit-objs += nf_tables_jit_kern.o nf_tables_jit_umh.o
diff --git a/net/netfilter/nf_tables_jit/main.c b/net/netfilter/nf_tables_jit/main.c
new file mode 100644
index 000000000000..6f6a4423c2e4
--- /dev/null
+++ b/net/netfilter/nf_tables_jit/main.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <unistd.h>
+
+int main(void)
+{
+	static struct {
+		int fd, count;
+	} response;
+
+	response.fd = -1;
+	for (;;) {
+		char buf[8192];
+
+		if (read(0, buf, sizeof(buf)) < 0)
+			return 1;
+		if (write(1, &response, sizeof(response)) != sizeof(response))
+			return 2;
+	}
+
+	return 0;
+}
diff --git a/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c b/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c
new file mode 100644
index 000000000000..4778f53b2683
--- /dev/null
+++ b/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/umh.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+
+#define UMH_start _binary_net_netfilter_nf_tables_jit_nf_tables_jit_umh_start
+#define UMH_end _binary_net_netfilter_nf_tables_jit_nf_tables_jit_umh_end
+
+extern char UMH_start;
+extern char UMH_end;
+
+static struct umh_info info;
+
+static int nft_jit_load_umh(void)
+{
+	return fork_usermode_blob(&UMH_start, &UMH_end - &UMH_start, &info);
+}
+
+int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e)
+{
+	if (!info.pipe_to_umh) {
+		int ret = nft_jit_load_umh();
+		if (ret)
+			return ret;
+
+		if (WARN_ON(!info.pipe_to_umh))
+			return -EINVAL;
+	}
+
+	return 0;
+}
-- 
2.16.4
