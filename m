From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 14/29] add sort option to the "list" command
Date: Wed, 10 Jul 2013 19:25:12 +0100
Message-ID: <1373480727-11254-15-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46333 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3GJS0R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:17 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so5927403lbh.37
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:16 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a new "sort" option to the "list" command, allowing nfacct object listed
to be sorted by name (default), packets, bytes or not to be sorted at all (as
was the case up until now);

* add a new nfacct_list.c source (in addition to the nfacct_list.h)
implementing the main sort function, in addition to the existing linked-list
routines.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/Makefile.am   |   2 +-
 src/nfacct.c      |  70 ++++++++++++++++++++++++-
 src/nfacct_list.c | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/nfacct_list.h |   4 ++
 4 files changed, 222 insertions(+), 3 deletions(-)
 create mode 100644 src/nfacct_list.c

diff --git a/src/Makefile.am b/src/Makefile.am
index 133ce61..ae60a51 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,6 +2,6 @@ include $(top_srcdir)/Make_global.am
 
 sbin_PROGRAMS = nfacct
 
-nfacct_SOURCES = nfacct.c nfacct_utils.c
+nfacct_SOURCES = nfacct.c nfacct_utils.c nfacct_list.c
 
 nfacct_LDADD = ${LIBMNL_LIBS} ${LIBNETFILTER_ACCT_LIBS}
diff --git a/src/nfacct.c b/src/nfacct.c
index c778d1c..3eb8b68 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -53,6 +53,49 @@ static void free_nfa_list(void) {
 	}
 }
 
+enum nfacct_sort_mode {
+	NFACCT_SORT_NONE = 0,
+	NFACCT_SORT_NAME,
+	NFACCT_SORT_PKTS,
+	NFACCT_SORT_BYTES,
+};
+
+static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list_head *b)
+{
+	struct nfa *nfa1, *nfa2;
+	uint64_t v1, v2;
+	enum nfacct_attr_type attr = NFACCT_ATTR_NAME;
+	enum nfacct_sort_mode *mode = (enum nfacct_sort_mode *)priv;
+
+	nfa1 = nfacct_list_entry(a, struct nfa, head);
+	nfa2 = nfacct_list_entry(b, struct nfa, head);
+
+	switch(*mode) {
+	case NFACCT_SORT_PKTS:
+				attr = NFACCT_ATTR_PKTS;
+				break;
+	case NFACCT_SORT_BYTES:
+				attr = NFACCT_ATTR_BYTES;
+	case NFACCT_SORT_NAME:
+				break;
+	default: /* unsorted */
+		return 0;
+	}
+	if (attr != NFACCT_ATTR_NAME) {
+		v1 = nfacct_attr_get_u64(nfa1->nfacct, attr);
+		v2 = nfacct_attr_get_u64(nfa2->nfacct, attr);
+		if (v1 < v2) {
+			return -1;
+		} else if (v1 > v2) {
+			return 1;
+		}
+	}
+	return strcmp(nfacct_attr_get_str(nfa1->nfacct,
+					  NFACCT_ATTR_NAME),
+		      nfacct_attr_get_str(nfa2->nfacct,
+					  NFACCT_ATTR_NAME));
+}
+
 /* xml header & footer strings */
 #define NFACCT_XML_HEADER	"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" \
 				"<nfacct>\n"
@@ -219,7 +262,7 @@ err:
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool nfnl_msg = false, xml = false;
-	bool b_fmt = false;
+	bool b_fmt = false, b_sort = false;
 	struct mnl_socket *nl;
 	char buf[70000];
 	struct nlmsghdr *nlh;
@@ -228,6 +271,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	struct nfa *nfa = NULL;
 	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
 	uint16_t fmt = NFACCT_FMT_MAX;
+	enum nfacct_sort_mode sort_mode = NFACCT_SORT_NAME;
 
 	while (argc > 0) {
 		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
@@ -235,6 +279,21 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
+		} else if (!b_sort && nfacct_matches(argv[0],"sort")) {
+			NFACCT_GET_NEXT_ARG();
+			if (nfacct_matches(argv[0],"name")) {
+				sort_mode = NFACCT_SORT_NAME;
+			} else if (nfacct_matches(argv[0],"packets") ||
+				   nfacct_matches(argv[0],"pkts")) {
+				sort_mode = NFACCT_SORT_PKTS;
+			} else if (nfacct_matches(argv[0],"bytes")) {
+				sort_mode = NFACCT_SORT_BYTES;
+			} else if (nfacct_matches(argv[0],"none")) {
+				sort_mode = NFACCT_SORT_NONE;
+			} else {
+				NFACCT_RET_ARG_ERR();
+			}
+			b_sort = true;
 		} else if (!b_fmt && (nfacct_matches(argv[0],"format") ||
 			   nfacct_matches(argv[0],"fmt"))) {
 			NFACCT_GET_NEXT_ARG();
@@ -288,6 +347,9 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	if (xml)
 		printf(NFACCT_XML_HEADER);
 
+	if (sort_mode != NFACCT_SORT_NONE)
+		nfacct_list_sort(&sort_mode, &nfa_list, nfacct_cmp);
+
 	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
 		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
 				nfa->nfacct,
@@ -667,11 +729,12 @@ static const char help_msg[] =
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n\n"
 	"Parameters:\n"
-	"  LST_PARAMS := [ reset ] [ format FMT_SPEC ] [ xml ]\n"
+	"  LST_PARAMS := [ reset ] [ format FMT_SPEC ] [ sort SORT_SPEC ] [ xml ]\n"
 	"  ADD_PARAMS := [ replace ]\n"
 	"  GET_PARAMS := [ reset ] [ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
+	"  SORT_SPEC := { none | name | packets | bytes }"
 	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib |"
 		  " eib |\n"
 	"  \t   si | kb | mb | gb | tb | pb | eb }\n";
@@ -691,6 +754,7 @@ static int nfacct_cmd_save(int argc, char *argv[])
 	int ret = -1, i;
 	bool ignore_width = true;
 	struct nfa *nfa = NULL;
+	enum nfacct_sort_mode sort_mode = NFACCT_SORT_NAME;
 
 	if (argc > 0) {
 		NFACCT_RET_ERR("too many arguments");
@@ -733,6 +797,8 @@ static int nfacct_cmd_save(int argc, char *argv[])
 	}
 	mnl_socket_close(nl);
 
+	nfacct_list_sort(&sort_mode, &nfa_list, nfacct_cmp);
+
 	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
 		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
 				nfa->nfacct,
diff --git a/src/nfacct_list.c b/src/nfacct_list.c
new file mode 100644
index 0000000..242ac0c
--- /dev/null
+++ b/src/nfacct_list.c
@@ -0,0 +1,149 @@
+/*
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ */
+
+#include <string.h>
+
+#include "nfacct_list.h"
+#include "nfacct_utils.h"
+
+#define MAX_LIST_LENGTH_BITS 20
+
+/*
+ * Returns a list organized in an intermediate format suited
+ * to chaining of merge() calls: null-terminated, no reserved or
+ * sentinel head node, "prev" links not maintained.
+ */
+static struct nfacct_list_head *merge(void *priv,
+				int (*cmp)(void *priv,
+					struct nfacct_list_head *a,
+					struct nfacct_list_head *b),
+				struct nfacct_list_head *a,
+				struct nfacct_list_head *b)
+{
+	struct nfacct_list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+/*
+ * Combine final list merge with restoration of standard doubly-linked
+ * list structure.  This approach duplicates code from merge(), but
+ * runs faster than the tidier alternatives of either a separate final
+ * prev-link restoration pass, or maintaining the prev links
+ * throughout.
+ */
+static void merge_and_restore_back_links(void *priv,
+				int (*cmp)(void *priv,
+					struct nfacct_list_head *a,
+					struct nfacct_list_head *b),
+				struct nfacct_list_head *head,
+				struct nfacct_list_head *a,
+				struct nfacct_list_head *b)
+{
+	struct nfacct_list_head *tail = head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a->prev = tail;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b->prev = tail;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a ? : b;
+
+	do {
+		/*
+		 * In worst cases this loop may run many iterations.
+		 * Continue callbacks to the client even though no
+		 * element comparison is needed, so the client's cmp()
+		 * routine can invoke cond_resched() periodically.
+		 */
+		(*cmp)(priv, tail->next, tail->next);
+
+		tail->next->prev = tail;
+		tail = tail->next;
+	} while (tail->next);
+
+	tail->next = head;
+	head->prev = tail;
+}
+
+/**
+ * nfacct_list_sort - sort a list
+ * @priv: private data, opaque to nfacct_list_sort(), passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
+ *
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
+ */
+void nfacct_list_sort(void *priv, struct nfacct_list_head *head,
+		int (*cmp)(void *priv, struct nfacct_list_head *a,
+			struct nfacct_list_head *b))
+{
+	/* sorted partial lists	-- last slot is a sentinel */
+	struct nfacct_list_head *part[MAX_LIST_LENGTH_BITS+1];
+	size_t lev;  /* index into part[] */
+	size_t max_lev = 0;
+	struct nfacct_list_head *list;
+
+	if (nfacct_list_empty(head))
+		return;
+
+	memset(part, 0, sizeof(part));
+
+	head->prev->next = NULL;
+	list = head->next;
+
+	while (list) {
+		struct nfacct_list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (lev >= ARRAY_SIZE(part)-1) {
+				lev--;
+			}
+			max_lev = lev;
+		}
+		part[lev] = cur;
+	}
+
+	for (lev = 0; lev < max_lev; lev++)
+		if (part[lev])
+			list = merge(priv, cmp, part[lev], list);
+
+	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+}
+
diff --git a/src/nfacct_list.h b/src/nfacct_list.h
index 5ef1b9d..1fe5674 100644
--- a/src/nfacct_list.h
+++ b/src/nfacct_list.h
@@ -52,6 +52,10 @@ static inline int nfacct_list_empty(struct nfacct_list_head *head)
 	return head->next == head;
 }
 
+extern void nfacct_list_sort(void *priv, struct nfacct_list_head *head,
+		int (*cmp)(void *priv, struct nfacct_list_head *a,
+		struct nfacct_list_head *b));
+
 #define nfacct_container_of(ptr, type, member) ({			\
         typeof( ((type *)0)->member ) *__mptr = (ptr);			\
         (type *)( (char *)__mptr - ((size_t) &((type *)0)->member));})
-- 
1.8.3.1

