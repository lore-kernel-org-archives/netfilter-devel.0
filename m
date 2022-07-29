Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223B6C00144
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiG2Jbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiG2Jbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:31:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4311B4D4C2
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:31:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC 1/3] netfilter: add Aho-Corasick string match implementation
Date:   Fri, 29 Jul 2022 11:31:27 +0200
Message-Id: <20220729093129.3108-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729093129.3108-1-pablo@netfilter.org>
References: <20220729093129.3108-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This implementation uses a tree of arrays for constant access time at
pattern search time. The tree is composed of two type of state nodes:

- Normal state, that has an array of edge pointers to the next state.
  The current matching character is used as the array index to access
  the next state.

- Final state has no edge pointers, it represents the last state for a
  matching pattern. Final state provides an output field which specifies
  the number of bytes that have been matched.

Additionally, a normal state might also have a output field. This
implementation allows to store two words with the same prefix pattern in
the tree, the search algorithm stops at the shortest length pattern
match.

Each state also has a fail pointer to backtrack in the tree states in
case of mismatching, so this tree is actually a graph that represents
a state-machine.

The implementation provides no specific locking mechanism, it is up to
the user to protect this data structure from concurrent access.
Nftables follows a lockless approach by allowing updates on a clone,
then use RCU to replace the stale tree by the updated clone from the
commit phase.

An internal stack is used to iterate over the tree nodes to avoid
recursive calls, to delete patterns and to walk the tree.

Maximum string size is 128 bytes.

A dictionary of 370105 English words consumes ~150 Mbytes.

This algorithm is described in "Efficient string matching: An aid to
bibliographic search" by Alfred V. Aho and Margaret J. Corasick (published in
June 1975) at Communications of the ACM 18 (6): 333–340.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ahocorasick.h |  27 ++
 net/netfilter/Kconfig               |   7 +
 net/netfilter/Makefile              |   2 +
 net/netfilter/ahocorasick.c         | 677 ++++++++++++++++++++++++++++
 4 files changed, 713 insertions(+)
 create mode 100644 include/net/netfilter/ahocorasick.h
 create mode 100644 net/netfilter/ahocorasick.c

diff --git a/include/net/netfilter/ahocorasick.h b/include/net/netfilter/ahocorasick.h
new file mode 100644
index 000000000000..2e7795912558
--- /dev/null
+++ b/include/net/netfilter/ahocorasick.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _NET_NF_AHOCORASICK_H
+#define _NET_NF_AHOCORASICK_H
+
+#define AC_MAXLEN	128
+
+struct ac_tree;
+
+struct ac_tree *ac_create(void);
+void ac_destroy(struct ac_tree *tree);
+
+int ac_add(struct ac_tree *tree, const char *word, uint32_t len, bool create);
+void ac_del(struct ac_tree *tree, const char *word, uint32_t len);
+int ac_resolve_fail(struct ac_tree *tree);
+
+int ac_find(struct ac_tree *tree, const char *text, size_t text_len);
+bool ac_find_word(struct ac_tree *tree, const char *word, uint32_t len);
+
+struct ac_iter;
+
+struct ac_iter *ac_iter_create(struct ac_tree *tree);
+int ac_iterate(struct ac_iter *iter, int (*cb)(const char *word, void *data), void *data);
+void ac_iter_destroy(struct ac_iter *ctx);
+
+struct ac_tree *ac_clone(struct ac_tree *tree);
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ddc54b6d18ee..383af17f0399 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -662,6 +662,13 @@ config NFT_TPROXY
 	help
 	  This makes transparent proxy support available in nftables.
 
+config NFT_STRING
+	bool "Netfilter nf_tables string expression support"
+	help
+	   The string expression allows you to look for pattern matchings in
+	   packets using an implementation of Aho-Corasick string matching
+	   algorithm.
+
 config NFT_SYNPROXY
 	tristate "Netfilter nf_tables SYNPROXY expression support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 238b6a620e88..18127c83b88c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -90,6 +90,8 @@ nf_tables-objs += nft_set_pipapo_avx2.o
 endif
 endif
 
+nf_tables-$(CONFIG_NFT_STRING)	+= ahocorasick.o
+
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
diff --git a/net/netfilter/ahocorasick.c b/net/netfilter/ahocorasick.c
new file mode 100644
index 000000000000..67bdd1b85110
--- /dev/null
+++ b/net/netfilter/ahocorasick.c
@@ -0,0 +1,677 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * (C) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <net/netfilter/ahocorasick.h>
+
+enum {
+	AC_STATE_NORMAL = 0,
+	AC_STATE_FINAL,
+};
+
+struct ac_state {
+	uint8_t			type;
+	uint16_t		use;
+	uint16_t		output;
+	void			*fail;
+	/* same layout as ac_state_final */
+	uint8_t			from;
+	uint8_t			len;
+	void			**edge;
+};
+
+/* this is a subset of struct ac_state, do not change the layout. */
+struct ac_state_final {
+	uint8_t			type;
+	uint16_t		use;
+	uint16_t		output;
+	void			*fail;
+};
+
+struct ac_stack {
+	struct ac_state		*state;
+	struct ac_state		*next;
+	uint8_t			pos;
+};
+
+struct ac_tree {
+	struct ac_state		root;
+	struct ac_stack		stack[AC_MAXLEN];
+	int			stack_num;
+};
+
+#define ac_state_fail(__s)	((struct ac_state *)__s)->fail
+#define ac_state_output(__s)	((struct ac_state *)__s)->output
+#define ac_state_use(__s)	((struct ac_state *)__s)->use
+#define ac_state_type(__s)	((struct ac_state *)__s)->type
+
+static int ac_state_pos(const struct ac_state *state, int pos)
+{
+	return pos - state->from;
+}
+
+static int ac_state_edge_len(const struct ac_state *state)
+{
+	return state->from + state->len;
+}
+
+static void *ac_state_edge(const struct ac_state *state, int pos)
+{
+	if (pos < state->from)
+		return NULL;
+	else if (pos >= ac_state_edge_len(state))
+		return NULL;
+
+	return state->edge[ac_state_pos(state, pos)];
+}
+
+static void ac_state_set_edge(struct ac_state *state, int pos, void *edge)
+{
+	state->edge[ac_state_pos(state, pos)] = edge;
+}
+
+static inline uint8_t ac_text_get_char(const char *word, int pos)
+{
+	return (uint8_t)word[pos];
+}
+
+static void ac_state_free(const struct ac_state *state)
+{
+	if (ac_state_type(state) == AC_STATE_NORMAL)
+		kfree((void *)state->edge);
+
+	kfree((void *)state);
+}
+
+void ac_del(struct ac_tree *tree, const char *word, uint32_t len)
+{
+	struct ac_state *cur = &tree->root, *this;
+	struct ac_stack *ss;
+	int i, pos;
+
+	for (i = 0; i < len; i++) {
+		pos = ac_text_get_char(word, i);
+
+		ss = &tree->stack[tree->stack_num++];
+		ss->state = cur;
+		ss->pos = pos;
+
+		cur = ac_state_edge(cur, pos);
+		if (WARN_ON_ONCE(cur == NULL))
+			return;
+	}
+
+	i = 0;
+	while (tree->stack_num > 0) {
+		ss = &tree->stack[--tree->stack_num];
+
+		this = ac_state_edge(ss->state, ss->pos);
+
+		if (i == 0 && ac_state_type(this) == AC_STATE_NORMAL && ac_state_output(this))
+			ac_state_output(this) = 0;
+
+		ac_state_use(this)--;
+		if (ac_state_use(this) == 0) {
+			ac_state_free(this);
+			ac_state_set_edge(ss->state, ss->pos, NULL);
+		}
+		i++;
+	}
+}
+
+bool ac_find_word(struct ac_tree *tree, const char *word, uint32_t len)
+{
+	struct ac_state *cur = &tree->root, *next;
+	int i = 0;
+
+	while (i < len) {
+		if (ac_state_type(cur) == AC_STATE_FINAL)
+			break;
+
+		next = ac_state_edge(cur, ac_text_get_char(word, i));
+		if (next != NULL) {
+			cur = next;
+			i++;
+			continue;
+		}
+
+		return false;
+	}
+
+	if (!cur || !ac_state_output(cur))
+		return false;
+
+	return i == len ? true : false;
+}
+
+static int ac_state_resize(struct ac_state *cur, int pos)
+{
+	int old_from;
+	uint8_t len;
+	void **edge;
+
+	if (cur == NULL || ac_state_type(cur) == AC_STATE_FINAL)
+		return 0;
+
+	if (pos < cur->from) {
+		len = cur->len + (cur->from - pos);
+		edge = kcalloc(len, sizeof(void *), GFP_KERNEL_ACCOUNT);
+		if (!edge)
+			return -ENOMEM;
+
+		old_from = cur->from - pos;
+		memcpy(&edge[old_from], &cur->edge[0], cur->len * sizeof(void *));
+		kfree(cur->edge);
+		cur->edge = edge;
+		cur->len = len;
+		cur->from = pos;
+
+	} else if (pos >= ac_state_edge_len(cur)) {
+		len = pos - cur->from + 1;
+
+		edge = krealloc(cur->edge, len * sizeof(void *), GFP_KERNEL_ACCOUNT);
+		if (!edge)
+			return -ENOMEM;
+
+		memset(&edge[cur->len], 0, (len - cur->len) * sizeof(void *));
+
+		cur->edge = edge;
+		cur->len = len;
+	}
+
+	return 0;
+}
+
+static int ac_add_state(struct ac_state *cur, uint8_t pos, uint8_t next_pos)
+{
+	struct ac_state *tmp = ac_state_edge(cur, pos);
+
+	if (ac_state_resize(cur, pos) < 0)
+		return -ENOMEM;
+
+	if (tmp == NULL) {
+		tmp = kcalloc(1, sizeof(struct ac_state), GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			return -ENOMEM;
+
+		tmp->from = next_pos;
+		tmp->len = 1;
+		tmp->edge = kcalloc(1, sizeof(void *), GFP_KERNEL_ACCOUNT);
+		if (!tmp->edge) {
+			kfree(tmp);
+			return -ENOMEM;
+		}
+
+		tmp->use = 1;
+		ac_state_set_edge(cur, pos, tmp);
+
+	} else if (tmp->output != 0 && tmp->type == AC_STATE_FINAL) {
+		struct ac_state *this;
+
+		/* There are two words with the same prefix, replace the final
+		 * state by a normal state. By now, we only match the word with
+		 * the shorter prefix, to match the longest word, we have to
+		 * extend the find function.
+		 */
+		tmp = kcalloc(1, sizeof(struct ac_state), GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			return -ENOMEM;
+
+		tmp->from = next_pos;
+		tmp->len = 1;
+		tmp->edge = kcalloc(1, sizeof(void *), GFP_KERNEL_ACCOUNT);
+		if (!tmp->edge) {
+			kfree(tmp);
+			return -ENOMEM;
+		}
+
+		this = ac_state_edge(cur, pos);
+		if (WARN_ON_ONCE(this == NULL))
+			return -EINVAL;
+
+		if (this->use + 1 == 0) {
+			kfree(tmp);
+			return -EOVERFLOW;
+		}
+
+		memcpy(tmp, this, sizeof(struct ac_state_final));
+		tmp->use++;
+		tmp->type = AC_STATE_NORMAL;
+		ac_state_free(this);
+		ac_state_set_edge(cur, pos, tmp);
+	} else {
+		if (tmp->use + 1 == 0)
+			return -EOVERFLOW;
+
+		tmp->use++;
+	}
+	return 0;
+}
+
+static int ac_add_state_final(struct ac_state *cur, uint8_t pos, const char *word, uint32_t len)
+{
+	struct ac_state_final *tmp = ac_state_edge(cur, pos);
+
+	if (ac_state_resize(cur, pos) < 0)
+		return -ENOMEM;
+
+	if (!tmp) {
+		tmp = kcalloc(1, sizeof(struct ac_state_final), GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			return -ENOMEM;
+
+		tmp->use = 1;
+		ac_state_set_edge(cur, pos, tmp);
+		ac_state_output(tmp) = len;
+		ac_state_type(tmp) = AC_STATE_FINAL;
+	} else {
+		ac_state_output(tmp) = len;
+		tmp->use++;
+	}
+
+	return 0;
+}
+
+static int __ac_add(struct ac_tree *tree, const char *word, uint32_t len)
+{
+	struct ac_state *cur = &tree->root;
+	uint8_t pos, next_pos;
+	int i, err;
+
+	for (i = 0; i < len - 1; i++) {
+		pos = ac_text_get_char(word, i);
+		next_pos = ac_text_get_char(word, i + 1);
+		err = ac_add_state(cur, pos, next_pos);
+		if (err < 0)
+			goto err_add;
+
+		cur = ac_state_edge(cur, pos);
+		if (WARN_ON_ONCE(cur == NULL)) {
+			err = -EINVAL;
+			goto err_add;
+		}
+	}
+	pos = ac_text_get_char(word, i);
+	err = ac_add_state_final(cur, pos, word, len);
+	if (err < 0)
+		goto err_add;
+
+	return 0;
+err_add:
+	if (i > 0)
+		ac_del(tree, word, i);
+
+	return err;
+}
+
+int ac_add(struct ac_tree *tree, const char *word, uint32_t len, bool create)
+{
+	if (len == 0)
+		return -EINVAL;
+	else if (len > AC_MAXLEN)
+		return -E2BIG;
+
+	if (ac_find_word(tree, word, len)) {
+		if (create)
+			return -EEXIST;
+
+		return 0;
+	}
+
+	return __ac_add(tree, word, len);
+}
+
+struct ac_queue_state {
+	struct list_head	head;
+	struct ac_state		*state;
+};
+
+int ac_resolve_fail(struct ac_tree *tree)
+{
+	struct ac_state *cur = &tree->root, *s, *fail;
+	struct ac_queue_state *q;
+	LIST_HEAD(queue);
+	int i;
+
+	/* first level of the tree. */
+	for (i = cur->from; i < ac_state_edge_len(cur); i++) {
+		if (ac_state_edge(cur, i) != NULL) {
+			struct ac_queue_state *new;
+
+			ac_state_fail(ac_state_edge(cur, i)) = tree;
+
+			new = kmalloc(sizeof(struct ac_queue_state), GFP_KERNEL_ACCOUNT);
+			if (new == NULL)
+				return -ENOMEM;
+
+			new->state = ac_state_edge(cur, i);
+			list_add_tail(&new->head, &queue);
+		}
+	}
+	/* second level of tree and further. */
+	while (!list_empty(&queue)) {
+		q = (struct ac_queue_state *) queue.next;
+
+		/* we reached final state, next in queue. */
+		if (ac_state_output(q->state) != 0 &&
+		    ac_state_type(q->state) == AC_STATE_FINAL) {
+			list_del(&q->head);
+			kfree(q);
+			continue;
+		}
+		/* this is a normal state, add edges to queue. */
+		for (i = q->state->from; i < ac_state_edge_len(q->state); i++) {
+			struct ac_queue_state *new;
+
+			s = ac_state_edge(q->state, i);
+			if (s == NULL)
+				continue;
+
+			fail = ac_state_fail(q->state);
+
+			/* our zerostate has fail set to NULL. */
+			while (fail && (ac_state_type(fail) == AC_STATE_FINAL ||
+					ac_state_edge(fail, i) == NULL)) {
+				fail = ac_state_fail(fail);
+			}
+			if (fail)
+				ac_state_fail(s) = ac_state_edge(fail, i);
+			else
+				ac_state_fail(s) = cur;
+
+			new = kmalloc(sizeof(struct ac_queue_state), GFP_KERNEL_ACCOUNT);
+			if (new == NULL)
+				return -ENOMEM;
+
+			new->state = s;
+			list_add_tail(&new->head, &queue);
+		}
+		list_del(&q->head);
+		kfree(q);
+	}
+	return 0;
+}
+
+static void
+ac_add_edges_to_stack(struct ac_tree *tree, struct ac_state *cur, int i)
+{
+	struct ac_stack *ss;
+
+	while (1) {
+		if (ac_state_output(cur) != 0 &&
+		    ac_state_type(cur) == AC_STATE_FINAL)
+			return;
+
+		if (i >= cur->from + cur->len)
+			break;
+
+		if (ac_state_edge(cur, i) == NULL) {
+			i++;
+			continue;
+		}
+
+		ss = &tree->stack[tree->stack_num++];
+		if (tree->stack_num >= AC_MAXLEN)
+			return;
+
+		ss->pos = i;
+		ss->state = cur;
+		ss->next = ac_state_edge(cur, i);
+		cur = ac_state_edge(cur, i);
+		i = 0;
+	}
+}
+
+static void ac_free_edges(struct ac_tree *tree)
+{
+	struct ac_state *cur = &tree->root;
+	int i = cur->from;
+
+	while (1) {
+		struct ac_stack *ss;
+
+		ac_add_edges_to_stack(tree, cur, i);
+
+		if (tree->stack_num == 0)
+			break;
+
+		ss = &tree->stack[--tree->stack_num];
+		i = ss->pos + 1;
+		cur = ss->state;
+		ac_state_free(ss->next);
+	}
+}
+
+struct ac_tree *ac_create(void)
+{
+	struct ac_state *root;
+	struct ac_tree *tree;
+
+	tree = kcalloc(1, sizeof(struct ac_tree), GFP_KERNEL_ACCOUNT);
+	if (!tree)
+		return NULL;
+
+	root = &tree->root;
+	root->from = 'a';
+	root->len = 64;
+	root->edge = kcalloc(root->len, sizeof(void *), GFP_KERNEL_ACCOUNT);
+	if (!root->edge) {
+		kfree(tree);
+		return NULL;
+	}
+
+	return tree;
+}
+
+void ac_destroy(struct ac_tree *tree)
+{
+	ac_free_edges(tree);
+	kfree(tree->root.edge);
+	kfree(tree);
+}
+
+int ac_find(struct ac_tree *tree, const char *text, size_t text_len)
+{
+	struct ac_state *cur = &tree->root, *edge;
+	bool found = false;
+	int i = 0, pos;
+
+	while (i < text_len) {
+		pos = ac_text_get_char(text, i);
+
+		edge = ac_state_edge(cur, pos);
+		if (edge != NULL) {
+			if (ac_state_output(edge)) {
+				found = true;
+				break;
+			}
+			WARN_ON_ONCE(ac_state_type(cur) == AC_STATE_FINAL);
+
+			cur = edge;
+			i++;
+
+			/* special case: fail state takes us to output state,
+			 * this is a matching infix in the existing pattern.
+			 */
+			if (ac_state_fail(edge) &&
+			    ac_state_output(ac_state_fail(edge)))
+				return i - ac_state_output(ac_state_fail(edge));
+
+			/* special case: single character word as infix. */
+			edge = ac_state_edge(&tree->root, pos);
+			if (edge != NULL && ac_state_output(edge) != 0)
+				return i - ac_state_output(edge);
+
+			if (i < text_len)
+				continue;
+
+			edge = NULL;
+		}
+		while (edge == NULL) {
+			cur = ac_state_fail(cur);
+
+			/* our zerostate has fail set to NULL or root. */
+			if (cur == NULL || cur == &tree->root) {
+				cur = &tree->root;
+				/* otherwise retry with existing mismatch. */
+				if (ac_state_edge(cur, pos) == NULL)
+					i++;
+				break;
+			}
+
+			if (ac_state_output(cur))
+				return i - ac_state_output(cur);
+
+			edge = ac_state_edge(cur, pos);
+			/* don't increase i, test again the fail case. */
+		}
+	}
+
+	return found ? i - ac_state_output(edge) + 1 : -1;
+}
+
+struct ac_iter {
+	struct ac_tree *tree;
+	struct ac_stack stack[AC_MAXLEN];
+	char word[AC_MAXLEN];
+	bool pending;
+};
+
+struct ac_iter *ac_iter_create(struct ac_tree *tree)
+{
+	struct ac_iter *iter;
+
+	iter = kcalloc(1, sizeof(struct ac_iter), GFP_KERNEL_ACCOUNT);
+	if (!iter)
+		return NULL;
+
+	iter->tree = tree;
+
+	return iter;
+}
+
+int ac_iterate(struct ac_iter *iter, int (*cb)(const char *word, void *data), void *data)
+{
+	struct ac_state *cur = &iter->tree->root, *next;
+	struct ac_stack *stack = iter->stack;
+	char *word = iter->word;
+	int level = 0, i, err;
+	struct ac_stack *ss;
+	int stack_num = 0;
+
+	if (iter->pending) {
+		if (WARN_ON_ONCE(cb(word, data) < 0))
+			return -EINVAL;
+
+		iter->pending = false;
+	}
+
+	i = cur->from;
+	while (1) {
+		if (i >= ac_state_edge_len(cur)) {
+			if (stack_num <= 0)
+				break;
+
+			ss = &stack[--stack_num];
+			cur = ss->state;
+			i = ss->pos;
+			level--;
+			continue;
+		}
+
+		if (ac_state_edge(cur, i) == NULL) {
+			i++;
+			continue;
+		}
+
+		next = ac_state_edge(cur, i);
+		if (ac_state_type(next) == AC_STATE_FINAL) {
+			word[level] = i;
+			word[level + 1] = '\0';
+			i++;
+			err = cb(word, data);
+			if (err == 0) {
+				iter->pending = true;
+				return err;
+			} else if (err < 0) {
+				return err;
+			}
+			continue;
+		}
+
+		if (level >= AC_MAXLEN)
+			break;
+
+		word[level++] = i;
+		ss = &stack[stack_num++];
+		ss->pos = i + 1;
+		ss->state = cur;
+		cur = next;
+		i = next->from;
+
+		if (ac_state_output(next)) {
+			word[level + 1] = '\0';
+			err = cb(word, data);
+			if (err == 0) {
+				iter->pending = true;
+				return err;
+			} else if (err < 0) {
+				return err;
+			}
+		}
+	}
+
+	return 1;
+}
+
+void ac_iter_destroy(struct ac_iter *iter)
+{
+	kfree(iter);
+}
+
+static int ac_clone_cb(const char *word, void *data)
+{
+	if (__ac_add(data, word, strlen(word)) < 0)
+		return -1;
+
+	return 1;
+}
+
+struct ac_tree *ac_clone(struct ac_tree *tree)
+{
+	struct ac_tree *newtree;
+	struct ac_iter *iter;
+	int ret;
+
+	iter = ac_iter_create(tree);
+	if (!iter)
+		return NULL;
+
+	newtree = ac_create();
+	if (!newtree) {
+		ret = -1;
+		goto err_out;
+	}
+
+	ret = ac_iterate(iter, ac_clone_cb, newtree);
+
+err_out:
+	ac_iter_destroy(iter);
+
+	if (ret < 0) {
+		ac_destroy(newtree);
+		return NULL;
+	}
+
+	if (ac_resolve_fail(newtree) < 0) {
+		ac_destroy(newtree);
+		return NULL;
+	}
+
+	return newtree;
+}
-- 
2.30.2

