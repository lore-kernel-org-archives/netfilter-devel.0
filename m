Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229C1C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 15:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E6F2238C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 15:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbfGYPTa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 11:19:30 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53770 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388976AbfGYPTa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 11:19:30 -0400
Received: from localhost ([::1]:38628 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hqfWi-0004Tp-J0; Thu, 25 Jul 2019 17:19:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xtables: Drop support for /etc/xtables.conf
Date:   Thu, 25 Jul 2019 17:19:14 +0200
Message-Id: <20190725151914.28723-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725151914.28723-1-phil@nwl.cc>
References: <20190725151914.28723-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As decided upon at NFWS2019, drop support for configurable nftables base
chains to use with iptables-nft.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac                     |  16 --
 iptables/.gitignore              |   3 -
 iptables/Makefile.am             |   8 +-
 iptables/nft.c                   | 162 +-------------------
 iptables/nft.h                   |  16 --
 iptables/xtables-config-parser.y | 248 -------------------------------
 iptables/xtables-config-syntax.l |  54 -------
 7 files changed, 9 insertions(+), 498 deletions(-)
 delete mode 100644 iptables/xtables-config-parser.y
 delete mode 100644 iptables/xtables-config-syntax.l

diff --git a/configure.ac b/configure.ac
index c922f7a05ac27..eb70bd118ad0c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -141,22 +141,6 @@ if test "x$enable_nftables" = "xyes"; then
 		echo "    iptables-compat over nftables support."
 		exit 1
 	fi
-
-	AM_PROG_LEX
-	AC_PROG_YACC
-
-	if test -z "$ac_cv_prog_YACC"
-	then
-		echo "*** Error: No suitable bison/yacc found. ***"
-		echo "    Please install the 'bison' package."
-		exit 1
-	fi
-	if test -z "$ac_cv_prog_LEX"
-	then
-	        echo "*** Error: No suitable flex/lex found. ***"
-	        echo "    Please install the 'flex' package."
-	        exit 1
-	fi
 fi
 
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
diff --git a/iptables/.gitignore b/iptables/.gitignore
index d46adc8a32f02..cd7d87b127ae6 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -20,9 +20,6 @@
 /xtables-multi
 /xtables-legacy-multi
 /xtables-nft-multi
-/xtables-config-parser.c
-/xtables-config-parser.h
-/xtables-config-syntax.c
 /xtables-monitor.8
 
 /xtables.pc
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index d2207a47a7a26..21ac7f08b7c1f 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -2,7 +2,6 @@
 
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
-AM_YFLAGS = -d
 
 BUILT_SOURCES =
 
@@ -27,7 +26,6 @@ xtables_legacy_multi_LDADD   += ../libxtables/libxtables.la -lm
 
 # iptables using nf_tables api
 if ENABLE_NFTABLES
-BUILT_SOURCES += xtables-config-parser.h
 xtables_nft_multi_SOURCES  = xtables-nft-multi.c iptables-xml.c
 xtables_nft_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_nft_multi_LDADD    = ../extensions/libext.a ../extensions/libext_ebt.a
@@ -35,7 +33,6 @@ if ENABLE_STATIC
 xtables_nft_multi_CFLAGS  += -DALL_INCLUSIVE
 endif
 xtables_nft_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
-xtables_nft_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
@@ -46,8 +43,6 @@ xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-eb-translate.c \
 				xtables-translate.c
 xtables_nft_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ${libnetfilter_conntrack_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a ../extensions/libext_arpt.a
-# yacc and lex generate dirty code
-xtables_nft_multi-xtables-config-parser.o xtables_nft_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 xtables_nft_multi_SOURCES += xshared.c
 xtables_nft_multi_LDADD   += ../libxtables/libxtables.la -lm
 endif
@@ -68,8 +63,7 @@ man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
                    ebtables-nft.8
 endif
 CLEANFILES       = iptables.8 xtables-monitor.8 \
-		   iptables-translate.8 ip6tables-translate.8 \
-		   xtables-config-parser.c xtables-config-syntax.c
+		   iptables-translate.8 ip6tables-translate.8
 
 vx_bin_links   = iptables-xml
 if ENABLE_IPV4
diff --git a/iptables/nft.c b/iptables/nft.c
index 9f8df5414d4c4..53b1ebe3ff5b3 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1274,9 +1274,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	struct nftnl_rule *r;
 	int type;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_append;
 
@@ -1791,8 +1789,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	struct nftnl_chain_list_iter *iter;
 	struct nftnl_chain *c;
 
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_flush;
 
@@ -1843,9 +1840,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	nft_fn = nft_chain_user_add;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	if (nft_chain_exists(h, table, chain)) {
 		errno = EEXIST;
@@ -2022,9 +2017,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 		return 0;
 	}
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	/* Config load changed errno. Ensure genuine info for our callers. */
 	errno = 0;
@@ -2198,8 +2191,7 @@ err_out:
 
 void nft_table_new(struct nft_handle *h, const char *table)
 {
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 }
 
 static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
@@ -2342,9 +2334,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	struct nftnl_rule *r = NULL, *new_rule;
 	struct nftnl_chain *c;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_insert;
 
@@ -2524,9 +2514,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	struct nftnl_chain *c;
 	bool found = false;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	ops = nft_family_ops_lookup(h->family);
 
@@ -2631,9 +2619,7 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 	struct nftnl_chain *c;
 	int ret = 0;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_xt_builtin_init(h, table);
+	nft_xt_builtin_init(h, table);
 
 	if (!nft_is_table_compatible(h, table)) {
 		xtables_error(OTHER_PROBLEM, "table `%s' is incompatible, use 'nft' tool.\n", table);
@@ -3232,138 +3218,6 @@ const char *nft_strerror(int err)
 	return strerror(err);
 }
 
-static void xtables_config_perror(uint32_t flags, const char *fmt, ...)
-{
-	va_list args;
-
-	va_start(args, fmt);
-
-	if (flags & NFT_LOAD_VERBOSE)
-		vfprintf(stderr, fmt, args);
-
-	va_end(args);
-}
-
-static int __nft_xtables_config_load(struct nft_handle *h, const char *filename,
-				     uint32_t flags)
-{
-	struct nftnl_table_list *table_list = NULL;
-	struct nftnl_chain_list *chain_list = NULL;
-	struct nftnl_table_list_iter *titer = NULL;
-	struct nftnl_chain_list_iter *citer = NULL;
-	struct nftnl_table *table;
-	struct nftnl_chain *chain;
-	uint32_t table_family, chain_family;
-	bool found = false;
-
-	table_list = nftnl_table_list_alloc();
-	chain_list = nftnl_chain_list_alloc();
-
-	if (xtables_config_parse(filename, table_list, chain_list) < 0) {
-		if (errno == ENOENT) {
-			xtables_config_perror(flags,
-				"configuration file `%s' does not exists\n",
-				filename);
-		} else {
-			xtables_config_perror(flags,
-				"Fatal error parsing config file: %s\n",
-				 strerror(errno));
-		}
-		goto err;
-	}
-
-	/* Stage 1) create tables */
-	titer = nftnl_table_list_iter_create(table_list);
-	while ((table = nftnl_table_list_iter_next(titer)) != NULL) {
-		table_family = nftnl_table_get_u32(table,
-						      NFTNL_TABLE_FAMILY);
-		if (h->family != table_family)
-			continue;
-
-		found = true;
-
-		if (batch_table_add(h, NFT_COMPAT_TABLE_ADD, table) < 0) {
-			if (errno == EEXIST) {
-				xtables_config_perror(flags,
-					"table `%s' already exists, skipping\n",
-					(char *)nftnl_table_get(table, NFTNL_TABLE_NAME));
-			} else {
-				xtables_config_perror(flags,
-					"table `%s' cannot be create, reason `%s'. Exitting\n",
-					(char *)nftnl_table_get(table, NFTNL_TABLE_NAME),
-					strerror(errno));
-				goto err;
-			}
-			continue;
-		}
-		xtables_config_perror(flags, "table `%s' has been created\n",
-			(char *)nftnl_table_get(table, NFTNL_TABLE_NAME));
-	}
-	nftnl_table_list_iter_destroy(titer);
-	nftnl_table_list_free(table_list);
-
-	if (!found)
-		goto err;
-
-	/* Stage 2) create chains */
-	citer = nftnl_chain_list_iter_create(chain_list);
-	while ((chain = nftnl_chain_list_iter_next(citer)) != NULL) {
-		chain_family = nftnl_chain_get_u32(chain,
-						      NFTNL_CHAIN_TABLE);
-		if (h->family != chain_family)
-			continue;
-
-		if (batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, chain) < 0) {
-			if (errno == EEXIST) {
-				xtables_config_perror(flags,
-					"chain `%s' already exists in table `%s', skipping\n",
-					(char *)nftnl_chain_get(chain, NFTNL_CHAIN_NAME),
-					(char *)nftnl_chain_get(chain, NFTNL_CHAIN_TABLE));
-			} else {
-				xtables_config_perror(flags,
-					"chain `%s' cannot be create, reason `%s'. Exitting\n",
-					(char *)nftnl_chain_get(chain, NFTNL_CHAIN_NAME),
-					strerror(errno));
-				goto err;
-			}
-			continue;
-		}
-
-		xtables_config_perror(flags,
-			"chain `%s' in table `%s' has been created\n",
-			(char *)nftnl_chain_get(chain, NFTNL_CHAIN_NAME),
-			(char *)nftnl_chain_get(chain, NFTNL_CHAIN_TABLE));
-	}
-	nftnl_chain_list_iter_destroy(citer);
-	nftnl_chain_list_free(chain_list);
-
-	h->config_done = 1;
-
-	return 0;
-
-err:
-	nftnl_table_list_free(table_list);
-	nftnl_chain_list_free(chain_list);
-
-	if (titer != NULL)
-		nftnl_table_list_iter_destroy(titer);
-	if (citer != NULL)
-		nftnl_chain_list_iter_destroy(citer);
-
-	h->config_done = -1;
-
-	return -1;
-}
-
-int nft_xtables_config_load(struct nft_handle *h, const char *filename,
-			    uint32_t flags)
-{
-	if (!h->config_done)
-		return __nft_xtables_config_load(h, filename, flags);
-
-	return h->config_done;
-}
-
 struct chain_zero_data {
 	struct nft_handle	*handle;
 	bool			verbose;
diff --git a/iptables/nft.h b/iptables/nft.h
index da078a44bab7b..5e5e765b0d043 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -170,22 +170,6 @@ int nft_init_eb(struct nft_handle *h, const char *pname);
 int ebt_get_current_chain(const char *chain);
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 
-/*
- * Parse config for tables and chain helper functions
- */
-#define XTABLES_CONFIG_DEFAULT  "/etc/xtables.conf"
-
-struct nftnl_table_list;
-struct nftnl_chain_list;
-
-extern int xtables_config_parse(const char *filename, struct nftnl_table_list *table_list, struct nftnl_chain_list *chain_list);
-
-enum {
-	NFT_LOAD_VERBOSE = (1 << 0),
-};
-
-int nft_xtables_config_load(struct nft_handle *h, const char *filename, uint32_t flags);
-
 /*
  * Translation from iptables to nft
  */
diff --git a/iptables/xtables-config-parser.y b/iptables/xtables-config-parser.y
deleted file mode 100644
index 89bfee7394526..0000000000000
--- a/iptables/xtables-config-parser.y
+++ /dev/null
@@ -1,248 +0,0 @@
-%{
-/*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <string.h>
-#include <errno.h>
-#include <stdarg.h>
-#include <libiptc/linux_list.h>
-#include <libnftnl/table.h>
-#include <libnftnl/chain.h>
-
-#include <netinet/in.h>
-#include <linux/netfilter.h>
-
-extern char *yytext;
-extern int yylineno;
-
-static LIST_HEAD(xtables_stack);
-
-struct stack_elem {
-	struct list_head	head;
-	int			token;
-	size_t			size;
-	char			data[];
-};
-
-static void *stack_push(int token, size_t size)
-{
-	struct stack_elem *e;
-
-	e = calloc(1, sizeof(struct stack_elem) + size);
-
-	e->token = token;
-	e->size = size;
-
-	list_add(&e->head, &xtables_stack);
-
-	return e->data;
-}
-
-static struct stack_elem *stack_pop(void)
-{
-	struct stack_elem *e;
-
-	e = list_entry(xtables_stack.next, struct stack_elem, head);
-
-	if (&e->head == &xtables_stack)
-		return NULL;
-
-	list_del(&e->head);
-	return e;
-}
-
-static inline void stack_put_i32(void *data, int value)
-{
-	memcpy(data, &value, sizeof(int));
-}
-
-static inline void stack_put_str(void *data, const char *str)
-{
-	memcpy(data, str, strlen(str));
-}
-
-static void stack_free(struct stack_elem *e)
-{
-	free(e);
-}
-
-%}
-
-%union {
-	int	val;
-	char	*string;
-}
-
-%token T_FAMILY
-%token T_TABLE
-%token T_CHAIN
-%token T_HOOK
-%token T_PRIO
-
-%token <string> T_STRING
-%token <val>	T_INTEGER
-
-%%
-
-configfile	:
-		| lines
-		;
-
-lines		: line
-		| lines line
-		;
-
-line		: family
-		;
-
-family		: T_FAMILY T_STRING '{' tables '}'
-		{
-			void *data = stack_push(T_FAMILY, strlen($2)+1);
-			stack_put_str(data, $2);
-		}
-		;
-
-tables		: table
-		| tables table
-		;
-
-table		: T_TABLE T_STRING '{' chains '}'
-		{
-			/* added in reverse order to pop it in order */
-			void *data = stack_push(T_TABLE, strlen($2)+1);
-			stack_put_str(data, $2);
-		}
-		;
-
-chains		: chain
-		| chains chain
-		;
-
-chain		: T_CHAIN T_STRING T_HOOK T_STRING T_PRIO T_INTEGER
-		{
-			/* added in reverse order to pop it in order */
-			void *data = stack_push(T_PRIO, sizeof(int32_t));
-			stack_put_i32(data, $6);
-			data = stack_push(T_HOOK, strlen($4)+1);
-			stack_put_str(data, $4);
-			data = stack_push(T_CHAIN, strlen($2)+1);
-			stack_put_str(data, $2);
-		}
-		;
-
-%%
-
-int __attribute__((noreturn))
-yyerror(char *msg)
-{
-	fprintf(stderr, "parsing config file in line (%d), symbol '%s': %s\n",
-			 yylineno, yytext, msg);
-	exit(EXIT_FAILURE);
-}
-
-static int hooknametonum(const char *hookname)
-{
-	if (strcmp(hookname, "NF_INET_LOCAL_IN") == 0)
-		return NF_INET_LOCAL_IN;
-	else if (strcmp(hookname, "NF_INET_FORWARD") == 0)
-		return NF_INET_FORWARD;
-	else if (strcmp(hookname, "NF_INET_LOCAL_OUT") == 0)
-		return NF_INET_LOCAL_OUT;
-	else if (strcmp(hookname, "NF_INET_PRE_ROUTING") == 0)
-		return NF_INET_PRE_ROUTING;
-	else if (strcmp(hookname, "NF_INET_POST_ROUTING") == 0)
-		return NF_INET_POST_ROUTING;
-
-	return -1;
-}
-
-static int32_t familytonumber(const char *family)
-{
-	if (strcmp(family, "ipv4") == 0)
-		return AF_INET;
-	else if (strcmp(family, "ipv6") == 0)
-		return AF_INET6;
-
-	return -1;
-}
-
-int xtables_config_parse(char *filename, struct nftnl_table_list *table_list,
-			 struct nftnl_chain_list *chain_list)
-{
-	FILE *fp;
-	struct stack_elem *e;
-	struct nftnl_table *table = NULL;
-	struct nftnl_chain *chain = NULL;
-	int prio = 0;
-	int32_t family = 0;
-
-	fp = fopen(filename, "r");
-	if (!fp)
-		return -1;
-
-	yyrestart(fp);
-	yyparse();
-	fclose(fp);
-
-	for (e = stack_pop(); e != NULL; e = stack_pop()) {
-		switch(e->token) {
-		case T_FAMILY:
-			family = familytonumber(e->data);
-			if (family == -1)
-				return -1;
-			break;
-		case T_TABLE:
-			table = nftnl_table_alloc();
-			if (table == NULL)
-				return -1;
-
-			nftnl_table_set_u32(table, NFTNL_TABLE_FAMILY, family);
-			nftnl_table_set(table, NFTNL_TABLE_NAME, e->data);
-			/* This is intentionally prepending, instead of
-			 * appending, since the elements in the stack are in
-			 * the reverse order that chains appear in the
-			 * configuration file.
-			 */
-			nftnl_table_list_add(table, table_list);
-			break;
-		case T_PRIO:
-			memcpy(&prio, e->data, sizeof(int32_t));
-			break;
-		case T_CHAIN:
-			chain = nftnl_chain_alloc();
-			if (chain == NULL)
-				return -1;
-
-			nftnl_chain_set(chain, NFTNL_CHAIN_TABLE,
-				(char *)nftnl_table_get(table, NFTNL_TABLE_NAME));
-			nftnl_chain_set_u32(chain, NFTNL_CHAIN_FAMILY,
-				nftnl_table_get_u32(table, NFTNL_TABLE_FAMILY));
-			nftnl_chain_set_s32(chain, NFTNL_CHAIN_PRIO, prio);
-			nftnl_chain_set(chain, NFTNL_CHAIN_NAME, e->data);
-			/* Intentionally prepending, instead of appending */
-			nftnl_chain_list_add(chain, chain_list);
-			break;
-		case T_HOOK:
-			nftnl_chain_set_u32(chain, NFTNL_CHAIN_HOOKNUM,
-						hooknametonum(e->data));
-			break;
-		default:
-			printf("unknown token type %d\n", e->token);
-			break;
-		}
-		stack_free(e);
-	}
-
-	return 0;
-}
diff --git a/iptables/xtables-config-syntax.l b/iptables/xtables-config-syntax.l
deleted file mode 100644
index a895c8bce8e3e..0000000000000
--- a/iptables/xtables-config-syntax.l
+++ /dev/null
@@ -1,54 +0,0 @@
-%{
-/*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
- */
-
-#include <string.h>
-#include "xtables-config-parser.h"
-%}
-
-%option yylineno
-%option noinput
-%option nounput
-
-ws		[ \t]+
-comment         #.*$
-nl		[\n\r]
-
-is_on		[o|O][n|N]
-is_off		[o|O][f|F][f|F]
-integer		[\-\+]?[0-9]+
-string		[a-zA-Z][a-zA-Z0-9\.\-\_]*
-
-%%
-"family"		{ return T_FAMILY; }
-"table"			{ return T_TABLE; }
-"chain"			{ return T_CHAIN; }
-"hook"			{ return T_HOOK; }
-"prio"			{ return T_PRIO; }
-
-{integer}		{ yylval.val = atoi(yytext); return T_INTEGER; }
-{string}		{ yylval.string = strdup(yytext); return T_STRING; }
-
-{comment}	;
-{ws}		;
-{nl}		;
-
-<<EOF>>		{ yyterminate(); }
-
-.		{ return yytext[0]; }
-
-%%
-
-int
-yywrap()
-{
-	return 1;
-}
-- 
2.22.0

