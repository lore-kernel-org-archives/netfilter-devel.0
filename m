From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] nft: xtables: add the infrastructure to translate from iptables to nft
Date: Mon, 14 Apr 2014 12:41:04 +0200
Message-ID: <1397472066-13011-4-git-send-email-pablo@netfilter.org>
References: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45236 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbaDNKlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:18 -0400
In-Reply-To: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch provides the infrastructure and two new utilities to
translate iptables commands to nft, they are:

1) iptables-restore-translate which basically takes a file that contains
   the ruleset in iptables-restore format and converts it to the nft
   syntax, eg.

 % iptables-restore-translate -f ipt-ruleset > nft-ruleset
 % cat nft-ruleset
 # Translated by iptables-restore-translate v1.4.21 on Mon Apr 14 12:18:14 2014
 add table ip filter
 add chain ip filter INPUT { type filter hook input priority 0; }
 add chain ip filter FORWARD { type filter hook forward priority 0; }
 add chain ip filter OUTPUT { type filter hook output priority 0; }
 add rule ip filter INPUT iifname lo counter accept
 # -t filter -A INPUT -m state --state INVALID -j LOG --log-prefix invalid:
 ...

The rules that cannot be translated are left commented. Users should be able
to run this to track down the nft progress to see at what point it can fully
replace iptables and their filtering policy.

2) iptables-translate which suggests a translation for an iptables
   command:

 $ iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
 nft add rule filter OUTPUT ip protocol udp ip dst 8.8.8.8 counter accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/xtables.h               |   14 ++
 iptables/Makefile.am            |    3 +
 iptables/nft-ipv4.c             |   64 +++++-
 iptables/nft-ipv6.c             |   65 +++++-
 iptables/nft-shared.h           |    2 +
 iptables/nft.h                  |   10 +
 iptables/xtables-compat-multi.c |    4 +
 iptables/xtables-multi.h        |    4 +
 iptables/xtables-translate.c    |  459 +++++++++++++++++++++++++++++++++++++++
 libxtables/xtables.c            |   51 +++++
 10 files changed, 674 insertions(+), 2 deletions(-)
 create mode 100644 iptables/xtables-translate.c

diff --git a/include/xtables.h b/include/xtables.h
index bad11a8..2d78cbf 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -205,6 +205,8 @@ enum xtables_ext_flags {
 	XTABLES_EXT_ALIAS = 1 << 0,
 };
 
+struct xt_buf;
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -269,6 +271,9 @@ struct xtables_match
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* Translate iptables to nft */
+	int (*xlate)(const struct xt_entry_match *match, struct xt_buf *buf);
+
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
 
@@ -346,6 +351,9 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* Translate iptables to nft */
+	int (*xlate)(const struct xt_entry_target *target, struct xt_buf *buf);
+
 	size_t udata_size;
 
 	/* Ignore these men behind the curtain: */
@@ -548,6 +556,12 @@ extern void xtables_lmap_free(struct xtables_lmap *);
 extern int xtables_lmap_name2id(const struct xtables_lmap *, const char *);
 extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 
+/* generic buffer */
+struct xt_buf *xt_buf_alloc(int size);
+void xt_buf_free(struct xt_buf *buf);
+void xt_buf_add(struct xt_buf *buf, const char *fmt, ...);
+const char *xt_buf_get(struct xt_buf *buf);
+
 #ifdef XTABLES_INTERNAL
 
 /* Shipped modules rely on this... */
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 41bca7c..5ede3fc 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,6 +38,7 @@ xtables_compat_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
+				xtables-translate.c \
 				xtables-config.c xtables-events.c \
 				xtables-arp-standalone.c xtables-arp.c
 xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS}
@@ -67,6 +68,8 @@ endif
 if ENABLE_NFTABLES
 x_sbin_links  = iptables-compat iptables-compat-restore iptables-compat-save \
 		ip6tables-compat ip6tables-compat-restore ip6tables-compat-save \
+		iptables-translate ip6tables-translate \
+		iptables-restore-translate ip6tables-restore-translate \
 		arptables-compat xtables-config xtables-events
 endif
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index d05e80e..f59f630 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -17,6 +17,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <netinet/ip.h>
+#include <netdb.h>
 
 #include <xtables.h>
 
@@ -409,6 +410,66 @@ static bool nft_ipv4_rule_find(struct nft_family_ops *ops,
 	return nft_ipv46_rule_find(ops, r, cs);
 }
 
+static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
+{
+	const struct iptables_command_state *cs = data;
+	int ret;
+
+	if (cs->fw.ip.iniface[0] != '\0') {
+		xt_buf_add(buf, "iifname %s%s ",
+			   cs->fw.ip.invflags & IPT_INV_VIA_IN ? "!= " : "",
+			   cs->fw.ip.iniface);
+	}
+	if (cs->fw.ip.outiface[0] != '\0') {
+		xt_buf_add(buf, "oifname %s%s ",
+			   cs->fw.ip.invflags & IPT_INV_VIA_OUT? "!= " : "",
+			   cs->fw.ip.outiface);
+	}
+
+	if (cs->fw.ip.flags & IPT_F_FRAG) {
+		xt_buf_add(buf, "ip frag-off %s%x ",
+			   cs->fw.ip.invflags & IPT_INV_FRAG? "" : "!= ", 0);
+	}
+
+	if (cs->fw.ip.proto != 0) {
+		const struct protoent *pent =
+			getprotobynumber(cs->fw.ip.proto);
+		char protonum[strlen("255") + 1];
+
+		if (!xlate_find_match(cs, pent->p_name)) {
+			snprintf(protonum, sizeof(protonum), "%u",
+				 cs->fw.ip.proto);
+			protonum[sizeof(protonum) - 1] = '\0';
+			xt_buf_add(buf, "ip protocol %s%s ",
+				   cs->fw.ip.invflags & IPT_INV_PROTO ?
+					"!= " : "",
+				   pent ? pent->p_name : protonum);
+		}
+	}
+
+	if (cs->fw.ip.src.s_addr != 0) {
+		xt_buf_add(buf, "ip saddr %s%s ",
+			   cs->fw.ip.invflags & IPT_INV_SRCIP ? "!= " : "",
+			   inet_ntoa(cs->fw.ip.src));
+	}
+	if (cs->fw.ip.dst.s_addr != 0) {
+		xt_buf_add(buf, "ip daddr %s%s ",
+			   cs->fw.ip.invflags & IPT_INV_DSTIP ? "!= " : "",
+			   inet_ntoa(cs->fw.ip.dst));
+	}
+
+	ret = xlate_matches(cs, buf);
+	if (!ret)
+		return ret;
+
+	/* Always add counters per rule, as in iptables */
+	xt_buf_add(buf, "counter ");
+
+	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), buf);
+
+	return ret;
+}
+
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
@@ -421,4 +482,5 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.post_parse		= nft_ipv4_post_parse,
 	.parse_target		= nft_ipv4_parse_target,
 	.rule_find		= nft_ipv4_rule_find,
+	.xlate			= nft_ipv4_xlate,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index f08598a..3890848 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -17,6 +17,7 @@
 #include <sys/socket.h>
 #include <arpa/inet.h>
 #include <netinet/ip6.h>
+#include <netdb.h>
 
 #include <xtables.h>
 
@@ -330,6 +331,67 @@ static bool nft_ipv6_rule_find(struct nft_family_ops *ops,
 	return nft_ipv46_rule_find(ops, r, cs);
 }
 
+static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
+			    int invert, struct xt_buf *buf)
+{
+	char addr_str[INET6_ADDRSTRLEN];
+
+	if (!invert && IN6_IS_ADDR_UNSPECIFIED(addr))
+		return;
+
+	inet_ntop(AF_INET6, addr, addr_str, INET6_ADDRSTRLEN);
+	xt_buf_add(buf, "%s %s%s ", selector, invert ? "!= " : "", addr_str);
+}
+
+static int nft_ipv6_xlate(const void *data, struct xt_buf *buf)
+{
+	const struct iptables_command_state *cs = data;
+	int ret;
+
+	if (cs->fw6.ipv6.iniface[0] != '\0') {
+		xt_buf_add(buf, "iifname %s%s ",
+			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_IN ?
+				"!= " : "",
+			   cs->fw6.ipv6.iniface);
+	}
+	if (cs->fw6.ipv6.outiface[0] != '\0') {
+		xt_buf_add(buf, "oifname %s%s ",
+			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT ?
+				"!= " : "",
+			   cs->fw6.ipv6.outiface);
+	}
+
+	if (cs->fw6.ipv6.proto != 0) {
+		const struct protoent *pent =
+			getprotobynumber(cs->fw6.ipv6.proto);
+		char protonum[strlen("255") + 1];
+
+		if (!xlate_find_match(cs, pent->p_name)) {
+			snprintf(protonum, sizeof(protonum), "%u",
+				 cs->fw6.ipv6.proto);
+			protonum[sizeof(protonum) - 1] = '\0';
+			xt_buf_add(buf, "ip protocol %s%s ",
+				   cs->fw6.ipv6.invflags & IP6T_INV_PROTO ?
+					"!= " : "",
+				   pent ? pent->p_name : protonum);
+		}
+	}
+
+	xlate_ipv6_addr("saddr", &cs->fw6.ipv6.src, IP6T_INV_SRCIP, buf);
+	xlate_ipv6_addr("daddr", &cs->fw6.ipv6.dst, IP6T_INV_DSTIP, buf);
+
+	ret = xlate_matches(cs, buf);
+	if (!ret)
+		return ret;
+
+	/* Always add counters per rule, as in iptables */
+	xt_buf_add(buf, "counter ");
+
+	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), buf);
+
+	return ret;
+}
+
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
@@ -342,4 +404,5 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.post_parse		= nft_ipv6_post_parse,
 	.parse_target		= nft_ipv6_parse_target,
 	.rule_find		= nft_ipv6_rule_find,
+	.xlate			= nft_ipv6_xlate,
 };
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 584cd5f..8d2faf2 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -35,6 +35,7 @@
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
 struct xtables_args;
+struct xt_buf;
 
 struct nft_family_ops {
 	int (*add)(struct nft_rule *r, void *data);
@@ -57,6 +58,7 @@ struct nft_family_ops {
 	void (*parse_target)(struct xtables_target *t, void *data);
 	bool (*rule_find)(struct nft_family_ops *ops, struct nft_rule *r,
 			  void *data);
+	int (*xlate)(const void *data, struct xt_buf *buf);
 };
 
 void add_meta(struct nft_rule *r, uint32_t key);
diff --git a/iptables/nft.h b/iptables/nft.h
index c31371c..31c04f3 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -158,6 +158,16 @@ enum {
 int nft_xtables_config_load(struct nft_handle *h, const char *filename, uint32_t flags);
 
 /*
+ * Translation from iptables to nft
+ */
+struct xt_buf;
+
+bool xlate_find_match(const struct iptables_command_state *cs, const char *p_name);
+int xlate_matches(const struct iptables_command_state *cs, struct xt_buf *buf);
+int xlate_action(const struct iptables_command_state *cs, bool goto_set,
+		 struct xt_buf *buf);
+
+/*
  * ARP
  */
 
diff --git a/iptables/xtables-compat-multi.c b/iptables/xtables-compat-multi.c
index 4781052..bb21e69 100644
--- a/iptables/xtables-compat-multi.c
+++ b/iptables/xtables-compat-multi.c
@@ -26,6 +26,10 @@ static const struct subcommand multi_subcommands[] = {
 	{"ip6tables-restore",		xtables_ip6_restore_main},
 	{"ip6tables-compat-save",	xtables_ip6_save_main},
 	{"ip6tables-compat-restore",	xtables_ip6_restore_main},
+	{"iptables-translate",		xtables_ip4_xlate_main},
+	{"ip6tables-translate",		xtables_ip6_xlate_main},
+	{"iptables-restore-translate",	xtables_ip4_xlate_restore_main},
+	{"ip6tables-restore-translate",	xtables_ip6_xlate_restore_main},
 	{"arptables",			xtables_arp_main},
 	{"arptables-compat",		xtables_arp_main},
 	{"xtables-config",		xtables_config_main},
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index e706894..022b2ad 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -9,6 +9,10 @@ extern int xtables_ip4_restore_main(int, char **);
 extern int xtables_ip6_main(int, char **);
 extern int xtables_ip6_save_main(int, char **);
 extern int xtables_ip6_restore_main(int, char **);
+extern int xtables_ip4_xlate_main(int, char **);
+extern int xtables_ip6_xlate_main(int, char **);
+extern int xtables_ip4_xlate_restore_main(int, char **);
+extern int xtables_ip6_xlate_restore_main(int, char **);
 extern int xtables_arp_main(int, char **);
 extern int xtables_config_main(int, char **);
 extern int xtables_events_main(int, char **);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
new file mode 100644
index 0000000..c7fb2df
--- /dev/null
+++ b/iptables/xtables-translate.c
@@ -0,0 +1,459 @@
+/*
+ * (C) 2014 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <iptables.h>
+#include <time.h>
+#include "xtables-multi.h"
+#include "nft.h"
+
+#include <string.h>
+#include <netdb.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <stdarg.h>
+#include <limits.h>
+#include <unistd.h>
+#include <iptables.h>
+#include <xtables.h>
+#include <libiptc/libxtc.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include "xshared.h"
+#include "nft-shared.h"
+
+int xlate_action(const struct iptables_command_state *cs, bool goto_set,
+		 struct xt_buf *buf)
+{
+	int ret = 1;
+
+	/* If no target at all, add nothing (default to continue) */
+	if (cs->target != NULL) {
+		/* Standard target? */
+		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
+			xt_buf_add(buf, "accept");
+		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
+			xt_buf_add(buf, "drop");
+		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
+			xt_buf_add(buf, "return");
+		else if (cs->target->xlate)
+			ret = cs->target->xlate(cs->target->t, buf);
+		else
+			return 0;
+	} else if (strlen(cs->jumpto) > 0) {
+		/* Not standard, then it's a go / jump to chain */
+		if (goto_set)
+			xt_buf_add(buf, "goto %s", cs->jumpto);
+		else
+			xt_buf_add(buf, "jump %s", cs->jumpto);
+	}
+
+	return ret;
+}
+
+int xlate_matches(const struct iptables_command_state *cs, struct xt_buf *buf)
+{
+	struct xtables_rule_match *matchp;
+	int ret = 1;
+
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (!matchp->match->xlate)
+			return 0;
+
+		ret = matchp->match->xlate(matchp->match->m, buf);
+		if (!ret)
+			break;
+	}
+	return ret;
+}
+
+bool xlate_find_match(const struct iptables_command_state *cs, const char *p_name)
+{
+	struct xtables_rule_match *matchp;
+
+	/* Skip redundant protocol, eg. ip protocol tcp tcp dport */
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (strcmp(matchp->match->name, p_name) == 0)
+			return true;
+	}
+	return false;
+}
+
+const char *family2str[] = {
+	[NFPROTO_IPV4]	= "ip",
+	[NFPROTO_IPV6]	= "ip6",
+};
+
+static int nft_rule_xlate_add(struct nft_handle *h,
+			      const struct nft_xt_cmd_parse *p,
+			      const struct iptables_command_state *cs,
+			      bool append)
+{
+	struct xt_buf *buf = xt_buf_alloc(10240);
+	int ret;
+
+	if (append) {
+		xt_buf_add(buf, "add rule %s %s %s ",
+			   family2str[h->family], p->table, p->chain);
+	} else {
+		xt_buf_add(buf, "insert rule %s %s %s ",
+			   family2str[h->family], p->table, p->chain);
+	}
+
+	ret = h->ops->xlate(cs, buf);
+	if (ret)
+		printf("%s\n", xt_buf_get(buf));
+
+	xt_buf_free(buf);
+	return ret;
+}
+
+static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
+		 struct iptables_command_state *cs,
+		 struct xtables_args *args, bool append,
+		 int (*cb)(struct nft_handle *h,
+			   const struct nft_xt_cmd_parse *p,
+			   const struct iptables_command_state *cs,
+			   bool append))
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		switch (h->family) {
+		case AF_INET:
+			cs->fw.ip.src.s_addr = args->s.addr.v4[i].s_addr;
+			cs->fw.ip.smsk.s_addr = args->s.mask.v4[i].s_addr;
+			for (j = 0; j < args->d.naddrs; j++) {
+				cs->fw.ip.dst.s_addr =
+					args->d.addr.v4[j].s_addr;
+				cs->fw.ip.dmsk.s_addr =
+					args->d.mask.v4[j].s_addr;
+				ret = cb(h, p, cs, append);
+			}
+			break;
+		case AF_INET6:
+			memcpy(&cs->fw6.ipv6.src,
+			       &args->s.addr.v6[i], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.smsk,
+			       &args->s.mask.v6[i], sizeof(struct in6_addr));
+			for (j = 0; j < args->d.naddrs; j++) {
+				memcpy(&cs->fw6.ipv6.dst,
+				       &args->d.addr.v6[j],
+				       sizeof(struct in6_addr));
+				memcpy(&cs->fw6.ipv6.dmsk,
+				       &args->d.mask.v6[j],
+				       sizeof(struct in6_addr));
+				ret = cb(h, p, cs, append);
+			}
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void print_ipt_cmd(int argc, char *argv[])
+{
+	int i;
+
+	printf("# ");
+	for (i = 1; i < argc; i++)
+		printf("%s ", argv[i]);
+
+	printf("\n");
+}
+
+static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
+			    char **table, bool restore)
+{
+	int ret = 0;
+	struct nft_xt_cmd_parse p = {
+		.table		= *table,
+		.restore	= restore,
+	};
+	struct iptables_command_state cs;
+	struct xtables_args args = {
+		.family = h->family,
+	};
+
+	do_parse(h, argc, argv, &p, &cs, &args);
+
+	switch (p.command) {
+	case CMD_APPEND:
+		ret = 1;
+		if (!xlate(h, &p, &cs, &args, true, nft_rule_xlate_add))
+			print_ipt_cmd(argc, argv);
+		break;
+	case CMD_DELETE:
+		break;
+	case CMD_DELETE_NUM:
+		break;
+	case CMD_CHECK:
+		break;
+	case CMD_REPLACE:
+		break;
+	case CMD_INSERT:
+		ret = 1;
+		if (!xlate(h, &p, &cs, &args, false, nft_rule_xlate_add))
+			print_ipt_cmd(argc, argv);
+		break;
+	case CMD_FLUSH:
+		break;
+	case CMD_ZERO:
+		break;
+	case CMD_ZERO_NUM:
+		break;
+	case CMD_LIST:
+	case CMD_LIST|CMD_ZERO:
+	case CMD_LIST|CMD_ZERO_NUM:
+		printf("list table %s %s\n",
+		       family2str[h->family], p.table);
+		ret = 1;
+		break;
+	case CMD_LIST_RULES:
+	case CMD_LIST_RULES|CMD_ZERO:
+	case CMD_LIST_RULES|CMD_ZERO_NUM:
+		break;
+	case CMD_NEW_CHAIN:
+		printf("add chain %s %s %s\n",
+		       family2str[h->family], p.table, p.chain);
+		ret = 1;
+		break;
+	case CMD_DELETE_CHAIN:
+		printf("delete chain %s %s %s\n",
+		       family2str[h->family], p.table, p.chain);
+		ret = 1;
+		break;
+	case CMD_RENAME_CHAIN:
+		break;
+	case CMD_SET_POLICY:
+		break;
+	default:
+		/* We should never reach this... */
+		printf("Unsupported command?\n");
+		exit(1);
+	}
+
+	xtables_rule_matches_free(&cs.matches);
+
+	if (h->family == AF_INET) {
+		free(args.s.addr.v4);
+		free(args.s.mask.v4);
+		free(args.d.addr.v4);
+		free(args.d.mask.v4);
+	} else if (h->family == AF_INET6) {
+		free(args.s.addr.v6);
+		free(args.s.mask.v6);
+		free(args.d.addr.v6);
+		free(args.d.mask.v6);
+	}
+	xtables_free_opts(1);
+
+	return ret;
+}
+
+static void print_usage(const char *name, const char *version)
+{
+	fprintf(stderr, "%s %s "
+			"(c) 2014 by Pablo Neira Ayuso <pablo@netfilter.org>\n"
+			"Usage: %s [-h] [-f]\n"
+                        "	[ --help ]\n"
+                        "	[ --file=<FILE> ]\n", name, version, name);
+        exit(1);
+}
+
+static const struct option options[] = {
+	{ .name = "help",	.has_arg = false,	.val = 'h' },
+	{ .name = "file",	.has_arg = true,	.val = 'f' },
+	{ NULL },
+};
+
+static int xlate_chain_user_add(struct nft_handle *h, const char *chain,
+				const char *table)
+{
+	printf("add chain %s %s %s\n", family2str[h->family], chain, table);
+	return 0;
+}
+
+static int commit(struct nft_handle *h)
+{
+	return 1;
+}
+
+static void xlate_table_new(struct nft_handle *h, const char *table)
+{
+	printf("add table %s %s\n", family2str[h->family], table);
+}
+
+static int xlate_chain_set(struct nft_handle *h, const char *table,
+			   const char *chain, const char *policy,
+			   const struct xt_counters *counters)
+{
+	printf("add chain %s %s %s ", family2str[h->family], table, chain);
+	if (strcmp(chain, "PREROUTING") == 0)
+		printf("{ type filter hook prerouting priority 0; }\n");
+	else if (strcmp(chain, "INPUT") == 0)
+		printf("{ type filter hook input priority 0; }\n");
+	else if (strcmp(chain, "FORWARD") == 0)
+		printf("{ type filter hook forward priority 0; }\n");
+	else if (strcmp(chain, "OUTPUT") == 0)
+		printf("{ type filter hook output priority 0; }\n");
+	else if (strcmp(chain, "POSTROUTING") == 0)
+		printf("{ type filter hook postrouting priority 0; }\n");
+
+	return 1;
+}
+
+static struct nft_xt_restore_cb cb_xlate = {
+	.table_new	= xlate_table_new,
+	.chain_set	= xlate_chain_set,
+	.chain_user_add	= xlate_chain_user_add,
+	.do_command	= do_command_xlate,
+	.commit		= commit,
+	.abort		= commit,
+};
+
+static int xtables_xlate_main(int family, const char *progname, int argc,
+			      char *argv[])
+{
+	int ret;
+	char *table = "filter";
+	struct nft_handle h = {
+		.family = family,
+	};
+
+	xtables_globals.program_name = progname;
+	ret = xtables_init_all(&xtables_globals, family);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version);
+				exit(1);
+	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+	init_extensions4();
+#endif
+
+	if (nft_init(&h, xtables_ipv4) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version,
+				strerror(errno));
+		nft_fini(&h);
+		exit(EXIT_FAILURE);
+	}
+
+	printf("nft ");
+	ret = do_command_xlate(&h, argc, argv, &table, false);
+	if (!ret)
+		fprintf(stderr, "Translation not implemented\n");
+
+	nft_fini(&h);
+	exit(!ret);
+}
+
+static int xtables_restore_xlate_main(int family, const char *progname,
+				      int argc, char *argv[])
+{
+	int ret;
+	struct nft_handle h = {
+		.family = family,
+	};
+	const char *file = NULL;
+	struct nft_xt_restore_parse p = {};
+	time_t now = time(NULL);
+	int c;
+
+	xtables_globals.program_name = progname;
+	ret = xtables_init_all(&xtables_globals, family);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version);
+				exit(1);
+	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+	init_extensions4();
+#endif
+
+	if (nft_init(&h, xtables_ipv4) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version,
+				strerror(errno));
+		nft_fini(&h);
+		exit(EXIT_FAILURE);
+	}
+
+	opterr = 0;
+	while ((c = getopt_long(argc, argv, "hf:", options, NULL)) != -1) {
+		switch (c) {
+		case 'h':
+			print_usage(argv[0], IPTABLES_VERSION);
+			exit(0);
+		case 'f':
+			file = optarg;
+			break;
+		}
+	}
+
+	if (file == NULL) {
+		fprintf(stderr, "ERROR: missing file name\n");
+		print_usage(argv[0], IPTABLES_VERSION);
+		exit(0);
+	}
+
+	p.in = fopen(file, "r");
+	if (p.in == NULL) {
+		fprintf(stderr, "Cannot open file %s\n", file);
+		exit(1);
+	}
+
+	printf("# Translated by %s v%s on %s",
+	       argv[0], IPTABLES_VERSION, ctime(&now));
+	xtables_restore_parse(&h, &p, &cb_xlate, argc, argv);
+
+	nft_fini(&h);
+	exit(0);
+}
+
+int xtables_ip4_xlate_main(int argc, char *argv[])
+{
+	return xtables_xlate_main(NFPROTO_IPV4, "iptables-translate",
+				  argc, argv);
+}
+
+int xtables_ip6_xlate_main(int argc, char *argv[])
+{
+	return xtables_xlate_main(NFPROTO_IPV6, "ip6tables-translate",
+				  argc, argv);
+}
+
+int xtables_ip4_xlate_restore_main(int argc, char *argv[])
+{
+	return xtables_restore_xlate_main(NFPROTO_IPV4,
+					  "iptables-translate-restore",
+					  argc, argv);
+}
+
+int xtables_ip6_xlate_restore_main(int argc, char *argv[])
+{
+	return xtables_restore_xlate_main(NFPROTO_IPV6,
+					  "ip6tables-translate-restore",
+					  argc, argv);
+}
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 1ab86d5..3cf09e0 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1959,3 +1959,54 @@ void get_kernel_version(void)
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
 	kernel_version = LINUX_VERSION(x, y, z);
 }
+
+struct xt_buf {
+	char	*data;
+	int	size;
+	int	rem;
+	int	off;
+};
+
+struct xt_buf *xt_buf_alloc(int size)
+{
+	struct xt_buf *buf;
+
+	buf = malloc(sizeof(struct xt_buf));
+	if (buf == NULL)
+		xtables_error(RESOURCE_PROBLEM, "OOM");
+
+	buf->data = malloc(size);
+	if (buf->data == NULL)
+		xtables_error(RESOURCE_PROBLEM, "OOM");
+
+	buf->size = size;
+	buf->rem = size;
+	buf->off = 0;
+
+	return buf;
+}
+
+void xt_buf_free(struct xt_buf *buf)
+{
+	free(buf);
+}
+
+void xt_buf_add(struct xt_buf *buf, const char *fmt, ...)
+{
+	va_list ap;
+	int len;
+
+	va_start(ap, fmt);
+	len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
+	if (len < 0 || len >= buf->rem)
+		xtables_error(RESOURCE_PROBLEM, "OOM");
+
+	va_end(ap);
+	buf->rem -= len;
+	buf->off += len;
+}
+
+const char *xt_buf_get(struct xt_buf *buf)
+{
+	return buf->data;
+}
-- 
1.7.10.4

