From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  03/15] nft: Add nft expressions translation engine as a library
Date: Fri, 19 Jul 2013 18:17:32 +0300
Message-ID: <1374247064-3361-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GSPSA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:00 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnfttrans is a generic translation engine from nft expressions to
registered "complex instructions". It works on a simple tree based
pattern matching algorithm.

Idea is to be able to register any kind of expressions suit (or pattern=
)
linked to a parsing function representing the "complex instruction".
Then, being able to go through the whole expression list of a rule and
retrieving the original complex instructions suit.

Once applied on xtables (iptables over nftables), this will allow to
retrieve the exact iptables_command_state structure for instance.
However, such engine is generic enough to be reused in any other tool,
like future arptables and ebtables compatible tool over nftables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 Makefile.am                   |   3 +
 configure.ac                  |   1 +
 include/nft-translator.h      |  85 ++++++
 libnfttrans/Makefile.am       |  28 ++
 libnfttrans/libnfttrans.pc.in |  11 +
 libnfttrans/nft-translator.c  | 618 ++++++++++++++++++++++++++++++++++=
++++++++
 6 files changed, 746 insertions(+)
 create mode 100644 include/nft-translator.h
 create mode 100644 libnfttrans/Makefile.am
 create mode 100644 libnfttrans/libnfttrans.pc.in
 create mode 100644 libnfttrans/nft-translator.c

diff --git a/Makefile.am b/Makefile.am
index 4eb63eb..8123a87 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,6 +4,9 @@ ACLOCAL_AMFLAGS  =3D -I m4
 AUTOMAKE_OPTIONS =3D foreign subdir-objects
=20
 SUBDIRS          =3D libiptc libxtables
+if ENABLE_NFTABLES
+SUBDIRS		+=3D libnfttrans
+endif
 if ENABLE_DEVEL
 SUBDIRS         +=3D include
 endif
diff --git a/configure.ac b/configure.ac
index e228078..6f144bf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -176,5 +176,6 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile in=
clude/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
+	libnfttrans/Makefile libnfttrans/libnfttrans.pc
 	include/xtables.h include/iptables/internal.h])
 AC_OUTPUT
diff --git a/include/nft-translator.h b/include/nft-translator.h
new file mode 100644
index 0000000..aa2eb7f
--- /dev/null
+++ b/include/nft-translator.h
@@ -0,0 +1,85 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _NFT_TRANSLATOR_H
+#define _NFT_TRANSLATOR_H
+
+#include <stdint.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+enum nft_instruction {
+	NFT_INSTRUCTION_BITWISE   =3D 0,
+	NFT_INSTRUCTION_BYTEORDER =3D 1,
+	NFT_INSTRUCTION_CMP       =3D 2,
+	NFT_INSTRUCTION_COUNTER   =3D 3,
+	NFT_INSTRUCTION_CT        =3D 4,
+	NFT_INSTRUCTION_EXTHDR    =3D 5,
+	NFT_INSTRUCTION_IMMEDIATE =3D 6,
+	NFT_INSTRUCTION_LIMIT     =3D 7,
+	NFT_INSTRUCTION_LOG       =3D 8,
+	NFT_INSTRUCTION_LOOKUP    =3D 9,
+	NFT_INSTRUCTION_MATCH     =3D 10,
+	NFT_INSTRUCTION_META      =3D 11,
+	NFT_INSTRUCTION_NAT       =3D 12,
+	NFT_INSTRUCTION_PAYLOAD   =3D 13,
+	NFT_INSTRUCTION_REJECT    =3D 14,
+	NFT_INSTRUCTION_TARGET    =3D 15,
+	NFT_INSTRUCTION_MAX       =3D 16,
+};
+
+struct nft_trans_instruction_tree;
+struct nft_trans_rule_context;
+struct nft_trans_instruction_context;
+
+typedef int (*nft_trans_parse_callback_f)(const char *ident,
+					  void *data,
+					  void *user_data);
+
+typedef int
+(*nft_trans_parse_instruction_f)(struct nft_trans_rule_context *rule_c=
tx,
+				 struct nft_trans_instruction_context *first,
+				 struct nft_trans_instruction_context *last,
+				 nft_trans_parse_callback_f user_cb,
+				 void *user_data);
+
+struct nft_trans_instruction {
+	enum nft_instruction *instructions;
+	nft_trans_parse_instruction_f function;
+};
+
+struct nft_trans_instruction_tree *nft_trans_instruction_tree_new(void=
);
+
+void
+nft_trans_instruction_tree_destroy(struct nft_trans_instruction_tree *=
tree);
+
+int nft_trans_add_instruction(struct nft_trans_instruction_tree *tree,
+			      struct nft_trans_instruction *ipt_i);
+
+int
+nft_trans_rulecontext_inhibate_instruction(struct nft_trans_rule_conte=
xt *rule_ctx,
+					   nft_trans_parse_instruction_f function);
+
+int
+nft_trans_rule_translate_to_instructions(struct nft_trans_instruction_=
tree *tree,
+					 struct nft_rule *rule,
+					 nft_trans_parse_callback_f user_cb,
+					 void *user_data);
+
+struct nft_trans_instruction_context *
+nft_trans_instruction_context_get_next(struct nft_trans_instruction_co=
ntext *i_ctx);
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_expr(struct nft_trans_instruction_co=
ntext *i_ctx);
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_register(struct nft_trans_instructio=
n_context *i_ctx,
+					   int reg);
+
+#endif /* _NFT_TRANSLATOR_H */
diff --git a/libnfttrans/Makefile.am b/libnfttrans/Makefile.am
new file mode 100644
index 0000000..5befb63
--- /dev/null
+++ b/libnfttrans/Makefile.am
@@ -0,0 +1,28 @@
+# -*- Makefile -*-
+if ENABLE_NFTABLES
+if HAVE_LIBMNL
+if HAVE_LIBNFTABLES
+
+AM_CFLAGS   =3D ${regular_CFLAGS}
+AM_CPPFLAGS =3D ${regular_CPPFLAGS}  -I${top_builddir}/include \
+		-I${top_srcdir}/include  -I./ ${kinclude_CPPFLAGS}
+
+lib_LTLIBRARIES       =3D libnfttrans.la
+libnfttrans_la_SOURCES =3D nft-translator.c
+libnfttrans_la_LDFLAGS =3D
+libnfttrans_la_LIBADD  =3D
+if ENABLE_STATIC
+# With --enable-static, shipped extensions are linked into the main ex=
ecutable,
+# so we need all the LIBADDs here too
+libnfttrans_la_LIBADD +=3D -lm
+endif
+if ENABLE_SHARED
+libnfttrans_la_CFLAGS  =3D ${AM_CFLAGS}
+libnfttrans_la_LIBADD +=3D -ldl
+else
+libnfttrans_la_CFLAGS  =3D ${AM_CFLAGS} -DNO_SHARED_LIBS=3D1
+endif
+
+endif # HAVE_LIBNFTABLES
+endif #=C2=A0HAVE_LIBMNL
+endif # ENABLE_NFTABLES
diff --git a/libnfttrans/libnfttrans.pc.in b/libnfttrans/libnfttrans.pc=
=2Ein
new file mode 100644
index 0000000..f3363de
--- /dev/null
+++ b/libnfttrans/libnfttrans.pc.in
@@ -0,0 +1,11 @@
+
+prefix=3D@prefix@
+exec_prefix=3D@exec_prefix@
+libdir=3D@libdir@
+includedir=3D@includedir@
+
+Name:		libnfttrans
+Description:	Small engine to translate nft expressions list into more =
complex registered subset
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -lnfttrans
+Cflags:		-I${includedir}
diff --git a/libnfttrans/nft-translator.c b/libnfttrans/nft-translator.=
c
new file mode 100644
index 0000000..50db967
--- /dev/null
+++ b/libnfttrans/nft-translator.c
@@ -0,0 +1,618 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <nft-translator.h>
+
+static const char *nft_instruction_name[NFT_INSTRUCTION_MAX] =3D {
+	"bitwise",
+	"byteorder",
+	"cmp",
+	"counter",
+	"ct",
+	"exthdr",
+	"immediate",
+	"limit",
+	"log",
+	"lookup",
+	"match",
+	"meta",
+	"nat",
+	"payload",
+	"reject",
+	"target",
+};
+
+typedef void (*free_function_f)(void *);
+
+struct s_list {
+	void *data;
+	struct s_list *next;
+};
+
+struct nft_trans_instruction_node {
+	struct s_list *functions;
+	struct nft_trans_instruction_node *nodes[NFT_INSTRUCTION_MAX];
+};
+
+struct nft_trans_instruction_tree {
+	struct s_list *nodes;
+	struct nft_trans_instruction_node *root;
+};
+
+struct nft_trans_register_context {
+	struct nft_rule_expr *reg[NFT_REG_MAX];
+};
+
+struct nft_trans_instruction_context {
+	struct nft_trans_instruction_context *next;
+
+	struct nft_rule_expr *current_expr;
+	enum nft_instruction instruction;
+	struct nft_trans_register_context *registers;
+};
+
+struct nft_trans_rule_context {
+	struct nft_trans_instruction_context *instr_contexts;
+
+	/* Some complex instructions cannot be seen multiple times */
+	struct s_list *inhibited;
+};
+
+struct nft_trans_found_instruction {
+	const struct s_list *functions;
+	struct nft_trans_instruction_context *position;
+};
+
+static enum nft_instruction str2nft_intruction(const char *name)
+{
+	enum nft_instruction i;
+
+	for (i =3D 0; i < NFT_INSTRUCTION_MAX; i++) {
+		 if (strncmp(nft_instruction_name[i], name,
+					strlen(nft_instruction_name[i])) =3D=3D 0)
+			 return i;
+	}
+
+	return NFT_INSTRUCTION_MAX;
+}
+
+static struct s_list *s_list_prepend(struct s_list *list, void *data)
+{
+	struct s_list *n_list;
+
+	n_list =3D calloc(1, sizeof(struct s_list));
+	if (n_list =3D=3D NULL)
+		return list;
+
+	n_list->data =3D data;
+	n_list->next =3D list;
+
+	return n_list;
+}
+
+static void _s_list_free(struct s_list *list, int data_too,
+			 free_function_f _free)
+{
+	struct s_list *previous =3D NULL;
+
+	for (; list !=3D NULL; list =3D list->next) {
+		if (previous !=3D NULL) {
+			if (previous->data !=3D NULL && data_too !=3D 0) {
+				if (_free !=3D NULL)
+					_free(previous->data);
+				else
+					free(previous->data);
+			}
+
+			free(previous);
+		}
+
+		previous =3D list;
+	}
+
+	if (previous !=3D NULL) {
+		if (previous->data !=3D NULL && data_too !=3D 0) {
+			if (_free !=3D NULL)
+				_free(previous->data);
+			else
+				free(previous->data);
+		}
+
+		free(previous);
+	}
+}
+
+static inline void s_list_free(struct s_list *list)
+{
+	_s_list_free(list, 0, NULL);
+}
+
+static inline void s_list_free_all(struct s_list *list)
+{
+	_s_list_free(list, 1, NULL);
+}
+
+static inline void s_list_free_full(struct s_list *list, free_function=
_f _free)
+{
+	_s_list_free(list, 1, _free);
+}
+
+struct nft_trans_instruction_tree *nft_trans_instruction_tree_new(void=
)
+{
+	struct nft_trans_instruction_tree *tree;
+
+	tree =3D calloc(1, sizeof(struct nft_trans_instruction_tree));
+	if (tree !=3D NULL) {
+		tree->root =3D calloc(1, sizeof(struct nft_trans_instruction_node));
+		if (tree->root =3D=3D NULL)
+			goto error;
+
+		tree->nodes =3D s_list_prepend(tree->nodes, tree->root);
+		if (tree->nodes =3D=3D NULL)
+			goto error;
+	}
+
+	return tree;
+
+error:
+	free(tree);
+	return NULL;
+}
+
+static void _free_nft_trans_instruction_node(void *data)
+{
+	struct nft_trans_instruction_node *node =3D data;
+
+	if (node =3D=3D NULL)
+		return;
+
+	s_list_free(node->functions);
+	free(node);
+}
+
+void
+nft_trans_instruction_tree_destroy(struct nft_trans_instruction_tree *=
tree)
+{
+	if (tree =3D=3D NULL)
+		return;
+
+	s_list_free_full(tree->nodes, _free_nft_trans_instruction_node);
+	free(tree);
+}
+
+int nft_trans_add_instruction(struct nft_trans_instruction_tree *tree,
+			      struct nft_trans_instruction *ipt_i)
+{
+	struct nft_trans_instruction_node *node;
+	enum nft_instruction *instr;
+
+	if (tree =3D=3D NULL)
+		return -EINVAL;
+
+	node =3D tree->root;
+	for (instr =3D ipt_i->instructions;
+				*instr < NFT_INSTRUCTION_MAX; instr++) {
+		if (node->nodes[*instr] =3D=3D NULL) {
+			node->nodes[*instr] =3D calloc(1,
+					sizeof(struct nft_trans_instruction_node));
+			if (node->nodes[*instr] =3D=3D NULL)
+				return -ENOMEM;
+		}
+
+		node =3D node->nodes[*instr];
+		tree->nodes =3D s_list_prepend(tree->nodes, node);
+	}
+
+	node->functions =3D s_list_prepend(node->functions, ipt_i->function);
+
+	return 0;
+}
+
+static void
+free_nft_trans_instruction_context(struct nft_trans_instruction_contex=
t *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return;
+
+	free(i_ctx->registers);
+	free(i_ctx);
+}
+
+static void
+destroy_nft_trans_rule_context(struct nft_trans_rule_context *rule_ctx=
)
+{
+	if (rule_ctx =3D=3D NULL)
+		return;
+
+	if (rule_ctx->instr_contexts !=3D NULL) {
+		struct nft_trans_instruction_context *i_ctx, *prev =3D NULL;
+
+		for (i_ctx =3D rule_ctx->instr_contexts;
+					i_ctx !=3D NULL; i_ctx =3D i_ctx->next) {
+			free_nft_trans_instruction_context(prev);
+			prev =3D i_ctx;
+		}
+
+		free_nft_trans_instruction_context(prev);
+	}
+
+	if (rule_ctx->inhibited !=3D NULL)
+		s_list_free(rule_ctx->inhibited);
+
+	free(rule_ctx);
+}
+
+static void
+update_register_from_bitwise(struct nft_rule_expr *expr,
+			     struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_BITWISE_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_BITWISE_DREG)] =3D expr;
+}
+
+static void
+update_register_from_byteorder(struct nft_rule_expr *expr,
+			       struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_BYTEORDER_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+					NFT_EXPR_BYTEORDER_DREG)] =3D expr;
+}
+
+static void
+update_register_from_ct(struct nft_rule_expr *expr,
+			struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_CT_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_CT_DREG)] =3D expr;
+}
+
+static void
+update_register_from_exthdr(struct nft_rule_expr *expr,
+			    struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_EXTHDR_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_EXTHDR_DREG)] =3D expr;
+}
+
+static void
+update_register_from_immediate(struct nft_rule_expr *expr,
+			       struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_IMM_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_IMM_DREG)] =3D expr;
+}
+
+static void
+update_register_from_lookup(struct nft_rule_expr *expr,
+			    struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_LOOKUP_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_LOOKUP_DREG)] =3D expr;
+}
+
+static void
+update_register_from_meta(struct nft_rule_expr *expr,
+			  struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_META_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_META_DREG)] =3D expr;
+}
+
+static void
+update_register_from_payload(struct nft_rule_expr *expr,
+			     struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_PAYLOAD_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_PAYLOAD_DREG)] =3D expr;
+}
+
+static struct nft_trans_register_context *
+update_registers(enum nft_instruction instruction, struct nft_rule_exp=
r *expr,
+		 struct nft_trans_register_context *registers)
+{
+	struct nft_trans_register_context *new_registers;
+
+	new_registers =3D calloc(1, sizeof(struct nft_trans_register_context)=
);
+	if (new_registers =3D=3D NULL)
+		return NULL;
+
+	memcpy(new_registers, registers, sizeof(struct nft_trans_register_con=
text));
+
+	switch (instruction) {
+	case NFT_INSTRUCTION_BITWISE:
+		update_register_from_bitwise(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_BYTEORDER:
+		update_register_from_byteorder(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_CMP:
+	case NFT_INSTRUCTION_COUNTER:
+		break;
+	case NFT_INSTRUCTION_CT:
+		update_register_from_ct(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_EXTHDR:
+		update_register_from_exthdr(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_IMMEDIATE:
+		update_register_from_immediate(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_LIMIT:
+	case NFT_INSTRUCTION_LOG:
+		break;
+	case NFT_INSTRUCTION_LOOKUP:
+		update_register_from_lookup(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_MATCH:
+		break;
+	case NFT_INSTRUCTION_META:
+		update_register_from_meta(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_NAT:
+		break;
+	case NFT_INSTRUCTION_PAYLOAD:
+		update_register_from_payload(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_REJECT:
+	case NFT_INSTRUCTION_TARGET:
+		break;
+	case NFT_INSTRUCTION_MAX:
+		return NULL;
+	};
+
+	return new_registers;
+}
+
+static struct nft_trans_rule_context *
+generate_nft_trans_rule_context(struct nft_rule *rule)
+{
+	struct nft_trans_instruction_context *cur_ctx =3D NULL;
+	struct nft_trans_register_context *cur_regs =3D NULL;
+	struct nft_trans_rule_context *rule_ctx;
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+
+	rule_ctx =3D calloc(1, sizeof(struct nft_trans_rule_context));
+	if (rule_ctx =3D=3D NULL)
+		return NULL;
+
+	iter =3D nft_rule_expr_iter_create(rule);
+	if (iter =3D=3D NULL)
+		goto error;
+
+	cur_regs =3D calloc(1, sizeof(struct nft_trans_register_context));
+	if (cur_regs =3D=3D NULL)
+		goto error;
+
+	expr =3D nft_rule_expr_iter_next(iter);
+	while (expr !=3D NULL) {
+		struct nft_trans_instruction_context *ctx;
+		enum nft_instruction instr;
+
+		ctx =3D calloc(1, sizeof(struct nft_trans_instruction_context));
+		if (ctx =3D=3D NULL)
+			goto error;
+
+		instr =3D str2nft_intruction(nft_rule_expr_get_str(expr,
+						NFT_RULE_EXPR_ATTR_NAME));
+		if (instr =3D=3D NFT_INSTRUCTION_MAX)
+			goto error;
+
+		ctx->current_expr =3D expr;
+		ctx->instruction =3D instr;
+		ctx->registers =3D cur_regs;
+
+		if (cur_ctx =3D=3D NULL)
+			rule_ctx->instr_contexts =3D ctx;
+		else
+			cur_ctx->next =3D ctx;
+
+		cur_ctx =3D ctx;
+
+		cur_regs =3D update_registers(instr, expr, cur_regs);
+		if (cur_regs =3D=3D NULL)
+			goto error;
+
+		expr =3D nft_rule_expr_iter_next(iter);
+	}
+
+	if (cur_regs !=3D NULL)
+		free(cur_regs);
+
+	nft_rule_expr_iter_destroy(iter);
+
+	return rule_ctx;
+
+error:
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	if (cur_regs !=3D NULL)
+		free(cur_regs);
+
+	if (iter !=3D NULL)
+		nft_rule_expr_iter_destroy(iter);
+
+	return NULL;
+}
+
+int
+nft_trans_rulecontext_inhibate_instruction(struct nft_trans_rule_conte=
xt *rule_ctx,
+					   nft_trans_parse_instruction_f function)
+{
+	if (rule_ctx =3D=3D NULL)
+		return -EINVAL;
+
+	rule_ctx->inhibited =3D s_list_prepend(rule_ctx->inhibited, function)=
;
+
+	return 0;
+}
+
+static struct s_list *
+retrieve_nft_trans_instructions(struct nft_trans_instruction_tree *tre=
e,
+				struct nft_trans_instruction_context *instructions)
+{
+	struct s_list *nft_trans_instructions =3D NULL;
+	struct nft_trans_instruction_context *ctx;
+	struct nft_trans_found_instruction *ipt_i;
+	struct nft_trans_instruction_node *node;
+
+	ctx =3D instructions;
+	node =3D tree->root;
+
+	while (ctx !=3D NULL) {
+		if (node->nodes[ctx->instruction] !=3D NULL) {
+			node =3D node->nodes[ctx->instruction];
+
+			if (node->functions !=3D NULL) {
+				ipt_i =3D calloc(1,
+					sizeof(struct nft_trans_found_instruction));
+
+				ipt_i->functions =3D node->functions;
+				ipt_i->position =3D ctx;
+
+				/* It prepends since "longest path first"
+				 * is applied */
+				nft_trans_instructions =3D s_list_prepend(
+						nft_trans_instructions, ipt_i);
+			}
+		} else
+			break;
+
+		ctx =3D ctx->next;
+	};
+
+	return nft_trans_instructions;
+}
+
+static bool is_instruction_inhibited(struct s_list *inhibited, void *d=
ata)
+{
+	for (; inhibited !=3D NULL; inhibited =3D inhibited->next) {
+		if (inhibited->data =3D=3D data)
+			return true;
+	}
+
+	return false;
+}
+
+static struct nft_trans_instruction_context *
+execute_relevant_instruction(struct s_list *instructions,
+			     struct nft_trans_rule_context *rule_ctx,
+			     struct nft_trans_instruction_context *position,
+			     nft_trans_parse_callback_f user_cb,
+			     void *user_data)
+{
+	for (; instructions !=3D NULL; instructions =3D instructions->next) {
+		struct nft_trans_found_instruction *i_f =3D instructions->data;
+		const struct s_list *fl;
+
+		for (fl =3D i_f->functions; fl !=3D NULL; fl =3D fl->next) {
+			nft_trans_parse_instruction_f function =3D fl->data;
+
+			if (is_instruction_inhibited(rule_ctx->inhibited,
+								function))
+				continue;
+
+			if (function(rule_ctx, position, i_f->position,
+						user_cb, user_data) =3D=3D 0)
+				return i_f->position;
+		}
+	}
+
+	return NULL;
+}
+
+int
+nft_trans_rule_translate_to_instructions(struct nft_trans_instruction_=
tree *tree,
+					 struct nft_rule *rule,
+					 nft_trans_parse_callback_f user_cb,
+					 void *user_data)
+{
+	struct nft_trans_instruction_context *position;
+	struct s_list *nft_trans_instructions;
+	struct nft_trans_rule_context *rule_ctx;
+
+	if (tree =3D=3D NULL)
+		return -1;
+
+	rule_ctx =3D generate_nft_trans_rule_context(rule);
+	if (rule_ctx =3D=3D NULL)
+		return -1;
+
+	position =3D rule_ctx->instr_contexts;
+	while (position !=3D NULL) {
+		struct nft_trans_instruction_context *pos;
+
+		nft_trans_instructions =3D retrieve_nft_trans_instructions(tree,
+								position);
+		if (nft_trans_instructions =3D=3D NULL)
+			goto error;
+
+		pos =3D execute_relevant_instruction(nft_trans_instructions,
+				rule_ctx, position, user_cb, user_data);
+		if (pos =3D=3D NULL)
+			goto error;
+
+		s_list_free_all(nft_trans_instructions);
+		position =3D pos->next;
+	}
+
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	return 0;
+
+error:
+	s_list_free_all(nft_trans_instructions);
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	return -1;
+}
+
+struct nft_trans_instruction_context *
+nft_trans_instruction_context_get_next(struct nft_trans_instruction_co=
ntext *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return NULL;
+
+	return i_ctx->next;
+}
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_expr(struct nft_trans_instruction_co=
ntext *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return NULL;
+
+	return i_ctx->current_expr;
+}
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_register(struct nft_trans_instructio=
n_context *i_ctx,
+					int register_index)
+{
+	if (i_ctx =3D=3D NULL || i_ctx->registers =3D=3D NULL ||
+					register_index >=3D NFT_REG_MAX)
+		return NULL;
+
+	return i_ctx->registers->reg[register_index];
+}
+
--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
