From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 17/56] netfilter: xtables2: initial xt1->xt2 translation for tables
Date: Tue, 29 Jun 2010 10:42:57 +0200
Message-ID: <1277801017-30600-18-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44268 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0F2In7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:59 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
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
 include/linux/netfilter_ipv6/ip6_tables.h |    4 +
 include/net/netns/x_tables.h              |    2 +-
 net/ipv6/netfilter/Kconfig                |    1 +
 net/ipv6/netfilter/ip6_tables.c           |   30 ++--
 net/ipv6/netfilter/ip6table_filter2.c     |   23 ++-
 net/netfilter/Kconfig                     |    6 +
 net/netfilter/Makefile                    |    1 +
 net/netfilter/x_tables.c                  |    3 +-
 net/netfilter/xt1_postshared.c            |   52 +++++
 net/netfilter/xt1_support.c               |   37 ++++
 net/netfilter/xt1_translat.c              |  290 +++++++++++++++++++++=
++++++++
 12 files changed, 433 insertions(+), 25 deletions(-)
 create mode 100644 net/netfilter/xt1_postshared.c
 create mode 100644 net/netfilter/xt1_support.c
 create mode 100644 net/netfilter/xt1_translat.c

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilt=
er/x_tables.h
index a90b758..2adbae6 100644
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
 	char name[XT_EXTENSION_MAXNAMELEN];
 	struct xt2_table *table;
 	unsigned int comefrom;
+	unsigned int xt1_offset;
 };
=20
 /**
@@ -512,6 +515,7 @@ enum {
  * @chain_list:		list of chains (struct xt2_chain)
  * @name:		name of this table
  * @nfproto:		nfproto the table is used exclusively with
+ * @valid_hooks:	hooks the table can be entered on
  * @rq_stacksize:	Size of the jumpstack. This is usually set to the
  * 			number of user chains -- since tables cannot have
  * 			loops, at most that many jumps can possibly be made --
@@ -529,6 +533,7 @@ struct xt2_table {
 	struct list_head chain_list;
 	char name[11];
 	uint8_t nfproto;
+	unsigned int valid_hooks;
=20
 	unsigned int rq_stacksize, stacksize;
 	unsigned int __percpu *stackptr;
@@ -692,11 +697,15 @@ static inline unsigned long ifname_compare_aligne=
d(const char *_a,
 extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_ho=
okfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops=
 *);
=20
+extern struct xt2_chain *xts_lookup_chain(const struct xt2_table *,
+					  unsigned int);
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
index 18442ff..d1d5d3a 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -310,6 +310,10 @@ extern unsigned int ip6t_do_table(struct sk_buff *=
skb,
 				  const struct net_device *out,
 				  struct xt_table *table);
=20
+extern struct xt2_table *ip6t2_register_table(struct net *,
+					      const struct xt_table *,
+					      const struct ip6t_replace *);
+
 /* Check for an extension */
 extern int ip6t_ext_hdr(u8 nexthdr);
 /* find specified header and get offset to it */
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.=
h
index 1e96a54..9365569 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -19,7 +19,7 @@ struct netns_xt {
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
index 3b91f0a..d23f22a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -63,6 +63,19 @@ MODULE_DESCRIPTION("IPv6 packet filter");
 #define inline
 #endif
=20
+static int mark_source_chains(const struct xt_table_info *,
+			      unsigned int, void *);
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
 void *ip6t_alloc_initial_table(const struct xt_table *info)
 {
 	return xt_alloc_initial_table(ip6t, IP6T);
@@ -828,21 +841,6 @@ find_check_entry(struct ip6t_entry *e, struct net =
*net, const char *name,
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
@@ -874,7 +872,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
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
index 55750e4..f81f98b 100644
--- a/net/ipv6/netfilter/ip6table_filter2.c
+++ b/net/ipv6/netfilter/ip6table_filter2.c
@@ -37,8 +37,14 @@ ip6table_filter_hook(unsigned int hook, struct sk_bu=
ff *skb,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct net *net =3D dev_net((in !=3D NULL) ? in : out);
-
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
 static struct nf_hook_ops *filter_ops __read_mostly;
@@ -50,6 +56,7 @@ module_param(forward, bool, 0000);
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	struct xt2_table *table;
=20
 	repl =3D ip6t_alloc_initial_table(&packet_filter);
 	if (repl =3D=3D NULL)
@@ -58,17 +65,19 @@ static int __net_init ip6table_filter_net_init(stru=
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
+						table->nfproto,
+						XT2_STD_RCULOCK);
 	return 0;
 }
=20
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->xt2.ipv6_filter);
+	xt2_table_destroy(net, net->xt2.ipv6_filter->table);
 }
=20
 static struct pernet_operations ip6table_filter_net_ops =3D {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21be535..4146464 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -314,6 +314,12 @@ config NETFILTER_XTABLES
=20
 if NETFILTER_XTABLES
=20
+config NETFILTER_XT1_SUPPORT
+	tristate
+	select NETFILTER_XT_MATCH_QUOTA
+	---help---
+	Protocol-agnostic part of the xt1 <-> xt2 translation layer.
+
 comment "Xtables combined modules"
=20
 config NETFILTER_XT_MARK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e28420a..2449f3b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
+obj-$(CONFIG_NETFILTER_XT1_SUPPORT) +=3D xt1_support.o
=20
 # combos
 obj-$(CONFIG_NETFILTER_XT_MARK) +=3D xt_mark.o
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f63587a..fcfa04e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1424,7 +1424,7 @@ int xt2_rule_add_target(struct xt2_rule *rule, co=
nst char *ext_name,
 }
 EXPORT_SYMBOL_GPL(xt2_rule_add_target);
=20
-static void xt2_rule_free(struct xt2_rule *rule)
+void xt2_rule_free(struct xt2_rule *rule)
 {
 	struct xt2_entry_target *etarget, *next_etarget;
 	struct xt2_entry_match *ematch, *next_ematch;
@@ -1465,6 +1465,7 @@ static void xt2_rule_free(struct xt2_rule *rule)
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
index 0000000..9fd5852
--- /dev/null
+++ b/net/netfilter/xt1_postshared.c
@@ -0,0 +1,52 @@
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
+		       const struct xtsub_replace *repl)
+{
+	struct xt2_table *table;
+	void *blob;
+	int ret;
+
+	table =3D xt2_table_new();
+	if (table =3D=3D NULL)
+		return ERR_PTR(-ENOMEM);
+	table->net =3D net;
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
index 0000000..3d6892a
--- /dev/null
+++ b/net/netfilter/xt1_translat.c
@@ -0,0 +1,290 @@
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
+		   const void *base, const struct xtsub_replace *repl)
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
+		if (delta =3D=3D repl->underflow[hook] &&
+		    !XTSUB2(check_underflow)(e)) {
+			pr_err("Underflows must be unconditional and use the "
+			       "STANDARD target with ACCEPT/DROP\n");
+			return -EINVAL;
+		}
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
+		      unsigned int entry_offset)
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
+						    st->verdict);
+		/* debug: (we already checked loopfreeness before) */
+		if (ntarget->r_goto =3D=3D rule->chain)
+			return -ELOOP;
+#endif
+	} else {
+		ntarget->ext     =3D XT2_ACTION_JUMP;
+		ntarget->r_jump  =3D xts_lookup_chain(rule->chain->table,
+						    st->verdict);
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
+		    unsigned int entry_offset)
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
+				 sizeof(entry->ipv6), false);
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
+				 sizeof(byte_counter), false);
+	if (ret < 0)
+		goto out;
+	ret =3D xt2_rule_add_match(rule, "quota", 3, &packet_counter,
+				 sizeof(packet_counter), false);
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
+				const struct xtsub_replace *repl)
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
