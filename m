From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 063/103] netfilter: xtables2: initial xt1->xt2 translation for tables
Date: Tue,  4 Aug 2009 09:25:47 +0200
Message-ID: <1249370787-17583-64-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56946 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbZHDH1l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:41 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit adds enough logic to translate the initial table, as
provided by ip6table modules, to an xt2 table. The translation code
goes into a file xt1_compat.c that is planned to be shared with the
other *_tables too, hence the little #define/#include hack. I deem
this is the better evil=C2=A0-- at least when done right, and it looks
promising=C2=A0-- compared to the real code duplication that is current=
ly
in place.

The "filter2" table can be used for testing: modprobing it/rmmod, and
that packets flow through xt2_do_table(). /usr/sbin/ip6tables cannot
interact with it yet as of this commit.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |    9 +
 include/linux/netfilter_ipv6/ip6_tables.h |    3 +
 include/net/netns/x_tables.h              |    2 +-
 net/ipv6/netfilter/Kconfig                |    1 +
 net/ipv6/netfilter/ip6_tables.c           |   30 ++--
 net/ipv6/netfilter/ip6table_filter2.c     |   21 ++-
 net/netfilter/Kconfig                     |    6 +
 net/netfilter/Makefile                    |    1 +
 net/netfilter/x_tables.c                  |    3 +-
 net/netfilter/xt1_postshared.c            |   51 +++++
 net/netfilter/xt1_support.c               |   37 ++++
 net/netfilter/xt1_translat.c              |  292 +++++++++++++++++++++=
++++++++
 12 files changed, 432 insertions(+), 24 deletions(-)
 create mode 100644 net/netfilter/xt1_postshared.c
 create mode 100644 net/netfilter/xt1_support.c
 create mode 100644 net/netfilter/xt1_translat.c

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilt=
er/x_tables.h
index 0608e64..cf8e65e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -482,6 +482,8 @@ struct xt2_entry_target {
  * @table:	back link to table chain is contained in
  * @comefrom:	bitmask from which hooks the chain is entered
  * 		(currently needed for xt_check_*)
+ * @xt1_offset:	temporary field to hold the chain offset
+ * 		used during xt2->xt1 conversion (xt1_compat.c)
  */
 struct xt2_chain {
 	struct list_head anchor;
@@ -489,6 +491,7 @@ struct xt2_chain {
 	char name[31];
 	struct xt2_table *table;
 	unsigned int comefrom;
+	unsigned int xt1_offset;
 };
=20
 /**
@@ -508,6 +511,7 @@ enum {
  * @chain_list:		list of chains (struct xt2_chain)
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
+ * @valid_hooks:	hooks the table can be entered on
  * @rq_stacksize:	Size of the jumpstack. This is usually set to the
  * 			number of user chains -- since tables cannot have
  * 			loops, at most that many jumps can possibly be made --
@@ -524,6 +528,7 @@ struct xt2_table {
 	struct list_head chain_list;
 	char name[11];
 	uint8_t nfproto;
+	unsigned int valid_hooks;
=20
 	unsigned int rq_stacksize, stacksize;
 	unsigned int *stackptr;
@@ -686,11 +691,15 @@ extern struct nf_hook_ops *xt_hook_link(const str=
uct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops=
 *);
 extern void *xt_repldata_create(const struct xt_table *);
=20
+extern struct xt2_chain *xts_lookup_chain(const struct xt2_table *,
+	unsigned int);
+
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t=
,
 	const void *, unsigned int, bool);
 extern int xt2_rule_add_target(struct xt2_rule *, const char *, uint8_=
t,
 	const void *, unsigned int, bool);
+extern void xt2_rule_free(struct xt2_rule *);
=20
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char =
*);
 extern void xt2_chain_append(struct xt2_rule *);
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/=
netfilter_ipv6/ip6_tables.h
index 89e0ab1..421c2d5 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -317,6 +317,9 @@ extern unsigned int ip6t_do_table(struct sk_buff *s=
kb,
 				  const struct net_device *out,
 				  struct xt_table *table);
=20
+extern struct xt2_table *ip6t2_register_table(struct net *,
+	const struct xt_table *, const struct ip6t_replace *);
+
 /* Check for an extension */
 extern int ip6t_ext_hdr(u8 nexthdr);
 /* find specified header and get offset to it */
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.=
h
index c4abab8..a63aa04 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -16,7 +16,7 @@ struct netns_xt {
 struct netns_xt2 {
 	struct mutex table_lock;
 	struct list_head table_list[NFPROTO_NUMPROTO];
-	struct xt_table *ipv6_filter;
+	struct xt2_table_link *ipv6_filter;
 };
=20
 #endif
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 29d643b..46163b1 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -46,6 +46,7 @@ config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
 	select NETFILTER_XTABLES
+	select NETFILTER_XT1_SUPPORT
 	default m if NETFILTER_ADVANCED=3Dn
 	help
 	  ip6tables is a general, extensible packet identification framework.
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_t=
ables.c
index 7eb9a57..edb00ad 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -67,6 +67,19 @@ do {								\
 #define inline
 #endif
=20
+static int mark_source_chains(const struct xt_table_info *,
+	unsigned int, void *);
+
+#define xtsub_entry           ip6t_entry
+#define xtsub_replace         ip6t_replace
+#define xtsub_error_target    ip6t_error_target
+#define XTSUB_NFPROTO_IPV6    1
+#define XTSUB(x)              ip6t_ ## x
+#define XTSUB2(x)             ip6t2_ ## x
+
+#include "../../netfilter/xt1_translat.c"
+#include "../../netfilter/xt1_postshared.c"
+
 /*
    We keep a set of rules for each CPU, so we can avoid write-locking
    them in the softirq when updating the counters and therefore
@@ -807,21 +820,6 @@ find_check_entry(struct ip6t_entry *e, const char =
*name, unsigned int size)
 	return ret;
 }
=20
-static bool check_underflow(const struct ip6t_entry *e)
-{
-	const struct ip6t_entry_target *t;
-	unsigned int verdict;
-
-	if (!unconditional(&e->ipv6))
-		return false;
-	t =3D ip6t_get_target_c(e);
-	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) !=3D 0)
-		return false;
-	verdict =3D ((struct ip6t_standard_target *)t)->verdict;
-	verdict =3D -verdict - 1;
-	return verdict =3D=3D NF_DROP || verdict =3D=3D NF_ACCEPT;
-}
-
 static int
 check_entry_size_and_hooks(struct ip6t_entry *e,
 			   struct xt_table_info *newinfo,
@@ -853,7 +851,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 		if ((unsigned char *)e - base =3D=3D hook_entries[h])
 			newinfo->hook_entry[h] =3D hook_entries[h];
 		if ((unsigned char *)e - base =3D=3D underflows[h]) {
-			if (!check_underflow(e)) {
+			if (!ip6t2_check_underflow(e)) {
 				pr_err("Underflows must be unconditional and "
 				       "use the STANDARD target with "
 				       "ACCEPT/DROP\n");
diff --git a/net/ipv6/netfilter/ip6table_filter2.c b/net/ipv6/netfilter=
/ip6table_filter2.c
index 790552b..7456686 100644
--- a/net/ipv6/netfilter/ip6table_filter2.c
+++ b/net/ipv6/netfilter/ip6table_filter2.c
@@ -38,7 +38,14 @@ ip6table_filter_hook(unsigned int hook,
 		   int (*okfn)(struct sk_buff *))
 {
 	const struct net *net =3D dev_net((in !=3D NULL) ? in : out);
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
+	rcu_read_lock();
+	link =3D rcu_dereference(net->xt2.ipv6_filter);
+	verdict =3D xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
=20
 /* Default to forward because I got too much mail already. */
@@ -48,6 +55,7 @@ module_param(forward, bool, 0000);
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
 	struct ip6t_replace *repl =3D xt_repldata_create(&packet_filter);
+	struct xt2_table *table;
=20
 	if (repl =3D=3D NULL)
 		return -ENOMEM;
@@ -55,17 +63,18 @@ static int __net_init ip6table_filter_net_init(stru=
ct net *net)
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =3D
 		-forward - 1;
=20
-	net->xt2.ipv6_filter =3D
-		ip6t_register_table(net, &packet_filter, repl);
+	table =3D ip6t2_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->xt2.ipv6_filter))
-		return PTR_ERR(net->xt2.ipv6_filter);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv6_filter =3D xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
=20
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net->xt2.ipv6_filter);
+	xt2_table_destroy(net, net->xt2.ipv6_filter->table);
 }
=20
 static struct pernet_operations ip6table_filter_net_ops =3D {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 773c360..0f18528 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -301,6 +301,12 @@ config NETFILTER_XTABLES
=20
 if NETFILTER_XTABLES
=20
+config NETFILTER_XT1_SUPPORT
+	tristate
+	select NETFILTER_XT_MATCH_QUOTA
+	---help---
+	Protocol-agnostic part of the xt1 <-> xt2 translation layer.
+
 # alphabetically ordered list of targets
=20
 config NETFILTER_XT_TARGET_CLASSIFY
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 49f62ee..fead6b4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
+obj-$(CONFIG_NETFILTER_XT1_SUPPORT) +=3D xt1_support.o
=20
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) +=3D xt_CLASSIFY.o
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 105039a..f8ff821 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1476,7 +1476,7 @@ int xt2_rule_add_target(struct xt2_rule *rule, co=
nst char *ext_name,
 }
 EXPORT_SYMBOL_GPL(xt2_rule_add_target);
=20
-static void xt2_rule_free(struct xt2_rule *rule)
+void xt2_rule_free(struct xt2_rule *rule)
 {
 	struct xt2_entry_target *etarget, *next_etarget;
 	struct xt2_entry_match *ematch, *next_ematch;
@@ -1515,6 +1515,7 @@ static void xt2_rule_free(struct xt2_rule *rule)
 	}
 	kfree(rule);
 }
+EXPORT_SYMBOL_GPL(xt2_rule_free);
=20
 struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *n=
ame)
 {
diff --git a/net/netfilter/xt1_postshared.c b/net/netfilter/xt1_postsha=
red.c
new file mode 100644
index 0000000..9dcbac1
--- /dev/null
+++ b/net/netfilter/xt1_postshared.c
@@ -0,0 +1,51 @@
+/*
+ *	xt1 <-> xt2 translation layer, per-nfproto specific part
+ *	Copyright =C2=A9 Jan Engelhardt, 2009
+ *
+ *	This program is free software: you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
+ *	the Free Software Foundation, either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+struct xt2_table *
+XTSUB2(register_table)(struct net *net, const struct xt_table *classic=
_table,
+                       const struct xtsub_replace *repl)
+{
+	struct xt2_table *table;
+	void *blob;
+	int ret;
+
+	table =3D xt2_table_new();
+	if (table =3D=3D NULL)
+		return ERR_PTR(-ENOMEM);
+	/* Need a writable copy for check_entry_and_size_hooks. */
+	ret  =3D -ENOMEM;
+	blob =3D vmalloc(repl->size);
+	if (blob =3D=3D NULL)
+		goto out;
+	memcpy(blob, repl->entries, repl->size);
+	strncpy(table->name, classic_table->name, sizeof(table->name));
+	table->name[sizeof(table->name)-1] =3D '\0';
+	table->valid_hooks =3D classic_table->valid_hooks;
+	table->nfproto     =3D classic_table->af;
+
+	ret =3D XTSUB2(table_to_xt2)(table, blob, repl);
+	vfree(blob);
+	if (ret < 0)
+		goto out;
+	ret =3D xt2_table_register(net, table);
+	if (ret < 0)
+		goto out;
+	return table;
+
+ out:
+	xt2_table_destroy(NULL, table);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(XTSUB2(register_table));
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
new file mode 100644
index 0000000..d15bfb7
--- /dev/null
+++ b/net/netfilter/xt1_support.c
@@ -0,0 +1,37 @@
+/*
+ *	xt1 <-> xt2 translation layer, protocol independent parts
+ *	Copyright =C2=A9 Jan Engelhardt, 2009
+ *
+ *	This program is free software: you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
+ *	the Free Software Foundation, either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+
+/**
+ * @table:	table to search in
+ * @needle:	rule offset in the xt1 blob
+ *
+ * Find the xt2 chain for a given xt1 offset. This assumes the chains =
are
+ * sorted by xt1_offset, which they should be given our linear transla=
tion
+ * mechanism in xt1_compat.c.
+ */
+struct xt2_chain *
+xts_lookup_chain(const struct xt2_table *table, unsigned int needle)
+{
+	struct xt2_chain *chain, *ret =3D NULL;
+
+	list_for_each_entry(chain, &table->chain_list, anchor) {
+		if (chain->xt1_offset <=3D needle)
+			ret =3D chain;
+		else
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xts_lookup_chain);
+
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.=
c
new file mode 100644
index 0000000..a1663ba
--- /dev/null
+++ b/net/netfilter/xt1_translat.c
@@ -0,0 +1,292 @@
+/*
+ *	xt1 <-> xt2 translation layer, proto-format specific part
+ *	Copyright =C2=A9 Jan Engelhardt, 2009
+ *
+ *	This program is free software: you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
+ *	the Free Software Foundation, either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/slab.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_quota.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#if !defined(XTSUB_NFPROTO_IPV6)
+#	error Need to define XTSUB_NFPROTO_xxx.
+#endif
+
+#ifdef XTSUB_NFPROTO_IPV6
+static const struct ip6t_ip6 xtsub_uncond;
+
+static inline bool XTSUB2(unconditional)(const struct xtsub_entry *e)
+{
+	return memcmp(&e->ipv6, &xtsub_uncond, sizeof(xtsub_uncond)) =3D=3D 0=
;
+}
+#endif
+
+static inline struct xt_entry_target *
+XTSUB2(get_target)(const struct xtsub_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+static bool XTSUB2(check_underflow)(const struct xtsub_entry *e)
+{
+	const struct xt_entry_target *t;
+	unsigned int verdict;
+
+	if (!XTSUB2(unconditional)(e))
+		return false;
+	t =3D XTSUB2(get_target)(e);
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) !=3D 0)
+		return false;
+	verdict =3D ((struct xt_standard_target *)t)->verdict;
+	verdict =3D -verdict - 1;
+	return verdict =3D=3D NF_DROP || verdict =3D=3D NF_ACCEPT;
+}
+
+/**
+ * Check an xt1 entry for sanity and create chains as we find them.
+ */
+static int
+XTSUB2(rule_check)(struct xtsub_entry *e, struct xt2_table *table,
+                   const void *base, const struct xtsub_replace *repl)
+{
+	const void *limit =3D (void *)base + repl->size;
+	unsigned int delta =3D (void *)e - base;
+	struct xtsub_error_target *t;
+	struct xt2_chain *chain;
+	unsigned int hook;
+
+	if ((unsigned long)e % __alignof__(struct xtsub_entry) !=3D 0 ||
+	    (void *)e + sizeof(struct xtsub_entry) >=3D limit ||
+	    e->next_offset < sizeof(struct xtsub_entry) +
+	    sizeof(struct xt_entry_target))
+		return -EINVAL;
+
+	/* Check hooks & underflows */
+	for (hook =3D 0; hook < ARRAY_SIZE(repl->hook_entry); ++hook) {
+		if (!(repl->valid_hooks & (1 << hook)))
+			continue;
+		if (delta =3D=3D repl->hook_entry[hook]) {
+			chain =3D xt2_chain_new(table, NULL);
+			if (chain =3D=3D NULL)
+				return -ENOMEM;
+
+			table->entrypoint[hook] =3D chain;
+			chain->comefrom =3D e->comefrom;
+			/* Aid for finding chains for a given delta. */
+			chain->xt1_offset =3D delta;
+		}
+		if (delta =3D=3D repl->underflow[hook])
+			if (!XTSUB2(check_underflow)(e)) {
+				pr_err("Underflows must be unconditional and "
+				       "use the STANDARD target with "
+				       "ACCEPT/DROP\n");
+				return -EINVAL;
+			}
+	}
+
+	/* Clear counters and comefrom */
+	memset(&e->counters, 0, sizeof(e->counters));
+	e->comefrom =3D 0;
+
+	t =3D (void *)XTSUB2(get_target)(e);
+	if (strcmp(t->target.u.user.name, XT_ERROR_TARGET) =3D=3D 0) {
+		t->errorname[sizeof(t->errorname)-1] =3D '\0';
+		if (strcmp(t->errorname, XT_ERROR_TARGET) =3D=3D 0)
+			/* End of ruleset */
+			return 0;
+		chain =3D xt2_chain_new(table, t->errorname);
+		if (chain =3D=3D NULL)
+			return -ENOMEM;
+		chain->xt1_offset =3D delta;
+		/* Chain marker translated. */
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+XTSUB2(target_to_xt2)(struct xt2_rule *rule, const struct xtsub_entry =
*entry,
+                      unsigned int entry_offset)
+{
+	const struct xt_entry_target *etarget =3D XTSUB2(get_target)(entry);
+	const struct xt_standard_target *st;
+	struct xt2_entry_target *ntarget;
+
+	if (strcmp(etarget->u.user.name, XT_STANDARD_TARGET) !=3D 0)
+		return xt2_rule_add_oldtarget(rule, etarget);
+
+	ntarget =3D kmalloc(sizeof(*ntarget), GFP_KERNEL);
+	if (ntarget =3D=3D NULL)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&ntarget->anchor);
+
+	st =3D (void *)etarget;
+	if (st->verdict =3D=3D XT_RETURN) {
+		ntarget->ext     =3D XT2_FINAL_VERDICT;
+		ntarget->verdict =3D XT_RETURN;
+	} else if (st->verdict < 0) {
+		ntarget->ext     =3D XT2_FINAL_VERDICT;
+		ntarget->verdict =3D -st->verdict - 1;
+	} else if (st->verdict =3D=3D entry_offset + entry->next_offset) {
+		ntarget->ext     =3D XT2_FINAL_VERDICT;
+		ntarget->verdict =3D XT_CONTINUE;
+#ifdef XTSUB_NFPROTO_IPV6
+	} else if (entry->ipv6.flags & IP6T_F_GOTO) {
+		ntarget->ext     =3D XT2_ACTION_GOTO;
+		ntarget->r_goto  =3D xts_lookup_chain(rule->chain->table,
+		                   st->verdict);
+		/* debug: (we already checked loopfreeness before) */
+		if (ntarget->r_goto =3D=3D rule->chain)
+			return -ELOOP;
+#endif
+	} else {
+		ntarget->ext     =3D XT2_ACTION_JUMP;
+		ntarget->r_jump  =3D xts_lookup_chain(rule->chain->table,
+		                   st->verdict);
+		if (ntarget->r_jump =3D=3D rule->chain)
+			return -ELOOP;
+	}
+
+	list_add_tail(&ntarget->anchor, &rule->target_list);
+	return 0;
+}
+
+/**
+ * Translate a single ip6t_entry into a xt2 rule.
+ */
+static struct xt2_rule *
+XTSUB2(rule_to_xt2)(struct xt2_chain *chain, const struct xtsub_entry =
*entry,
+                    unsigned int entry_offset)
+{
+	const struct xt_entry_match *ematch;
+	struct xt_quota_mtinfo3 byte_counter =3D {.flags =3D XT_QUOTA_GROW};
+	struct xt_quota_mtinfo3 packet_counter =3D
+		{.flags =3D XT_QUOTA_GROW | XT_QUOTA_PACKET};
+	struct xt2_rule *rule;
+	int ret;
+
+	rule =3D xt2_rule_new(chain);
+	if (rule =3D=3D NULL)
+		return ERR_PTR(-ENOMEM);
+
+	rule->chain->comefrom =3D entry->comefrom;
+#ifdef XTSUB_NFPROTO_IPV6
+	rule->l4proto =3D entry->ipv6.proto;
+	if (entry->ipv6.flags & IP6T_INV_PROTO)
+		rule->flags |=3D XT2_INV_L4PROTO;
+	ret =3D xt2_rule_add_match(rule, "ipv6", 0, &entry->ipv6,
+	      sizeof(entry->ipv6), false);
+#endif
+	if (ret < 0)
+		goto out;
+
+	xt_ematch_foreach(ematch, entry) {
+		ret =3D xt2_rule_add_oldmatch(rule, ematch);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret =3D xt2_rule_add_match(rule, "quota", 3, &byte_counter,
+	      sizeof(byte_counter), false);
+	if (ret < 0)
+		goto out;
+	ret =3D xt2_rule_add_match(rule, "quota", 3, &packet_counter,
+	      sizeof(packet_counter), false);
+	if (ret < 0)
+		goto out;
+	ret =3D XTSUB2(target_to_xt2)(rule, entry, entry_offset);
+	if (ret < 0)
+		goto out;
+	return rule;
+
+ out:
+	xt2_rule_free(rule);
+	return ERR_PTR(ret);
+}
+
+/**
+ * @table:	new table
+ * @entry0:	blob of <struct ip6t_entry>s
+ * @repl:	blob metadata
+ *
+ * Convert a blob table into a xt2 table.
+ */
+static int XTSUB2(table_to_xt2)(struct xt2_table *table, void *entry0,
+                                const struct xtsub_replace *repl)
+{
+	struct xt_table_info mark_param;
+	struct xtsub_entry *iter;
+	unsigned int i;
+	int ret =3D 0;
+
+	i =3D 0;
+	/* Walk through entries, checking offsets, creating chains. */
+	xt_entry_foreach(iter, entry0, repl->size) {
+		ret =3D XTSUB2(rule_check)(iter, table, entry0, repl);
+		++i;
+		if (ret < 0)
+			return ret;
+		else if (ret =3D=3D 0)
+			continue;
+	}
+
+	if (i !=3D repl->num_entries)
+		return -EINVAL;
+
+	/* Check hooks all assigned */
+	for (i =3D 0; i < ARRAY_SIZE(repl->hook_entry); ++i) {
+		/* Only hooks which are valid */
+		if (!(repl->valid_hooks & (1 << i)))
+			continue;
+		if (table->entrypoint[i] =3D=3D NULL)
+			return -EINVAL;
+	}
+
+	memcpy(mark_param.hook_entry, repl->hook_entry,
+	       sizeof(repl->hook_entry));
+	mark_param.size =3D repl->size;
+	if (!mark_source_chains(&mark_param, repl->valid_hooks, entry0))
+		return -ELOOP;
+
+	/* Now process rules. */
+	xt_entry_foreach(iter, entry0, repl->size) {
+		unsigned int hook, delta =3D (void *)iter - (void *)entry0;
+		const struct xt_entry_target *t;
+		struct xt2_chain *chain;
+		struct xt2_rule *rule;
+
+		t =3D XTSUB2(get_target)(iter);
+		if (strcmp(t->u.user.name, XT_ERROR_TARGET) =3D=3D 0)
+			/* already translated */
+			continue;
+
+		/*
+		 * Do not ignore base chain policies (which are rules), though.
+		 * We need these for the counters.
+		 */
+		chain =3D xts_lookup_chain(table, delta);
+		if (chain =3D=3D NULL)
+			return -EINVAL;
+		rule =3D XTSUB2(rule_to_xt2)(chain, iter, delta);
+		if (IS_ERR(rule))
+			return PTR_ERR(rule);
+		xt2_chain_append(rule);
+
+		for (hook =3D 0; hook < ARRAY_SIZE(repl->underflow); ++hook) {
+			if (!(table->valid_hooks & (1 << hook)))
+				continue;
+			if (delta =3D=3D repl->underflow[hook]) {
+				table->underflow[hook] =3D rule;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
--=20
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
