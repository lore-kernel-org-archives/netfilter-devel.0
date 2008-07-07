From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 07/13: support for case insensitive searching
Date: Mon,  7 Jul 2008 14:05:24 +0200 (MEST)
Message-ID: <20080707120523.4975.35647.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58385 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbYGGMF0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:26 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: support for case insensitive searching

The function textsearch_prepare has a new flag to support case
insensitive searching.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 170f103d11a1e1186e2677fd5f75735b740c025f
tree e1ab155181637bf1ad3d39232b9cc2f40094f286
parent 48d88486554c27296e6f0e4b37aae3bbb37af5d2
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:17 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:17 +0200

 include/linux/textsearch.h |   10 +++++-----
 lib/textsearch.c           |   14 ++++++++------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 6f371f2..6c34cf2 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -10,10 +10,8 @@
 
 struct ts_config;
 
-/**
- * TS_AUTOLOAD - Automatically load textsearch modules when needed
- */
-#define TS_AUTOLOAD	1
+#define TS_AUTOLOAD	1 /* Automatically load textsearch modules when needed */
+#define TS_IGNORECASE	2 /* Searches string case insensitively */
 
 /**
  * struct ts_state - search state
@@ -39,7 +37,7 @@ struct ts_state
 struct ts_ops
 {
 	const char		*name;
-	struct ts_config *	(*init)(const void *, unsigned int, gfp_t);
+	struct ts_config *	(*init)(const void *, unsigned int, gfp_t, int);
 	unsigned int		(*find)(struct ts_config *,
 					struct ts_state *);
 	void			(*destroy)(struct ts_config *);
@@ -52,12 +50,14 @@ struct ts_ops
 /**
  * struct ts_config - search configuration
  * @ops: operations of chosen algorithm
+ * @flags: flags
  * @get_next_block: callback to fetch the next block to search in
  * @finish: callback to finalize a search
  */
 struct ts_config
 {
 	struct ts_ops		*ops;
+	int 			flags;
 
 	/**
 	 * get_next_block - fetch next block of data
diff --git a/lib/textsearch.c b/lib/textsearch.c
index be8bda3..b451fcc 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -54,10 +54,13 @@
  * USAGE
  *
  *   Before a search can be performed, a configuration must be created
- *   by calling textsearch_prepare() specyfing the searching algorithm and
- *   the pattern to look for. The returned configuration may then be used
- *   for an arbitary amount of times and even in parallel as long as a
- *   separate struct ts_state variable is provided to every instance.
+ *   by calling textsearch_prepare() specifying the searching algorithm,
+ *   the pattern to look for and flags. As a flag, you can set TS_IGNORECASE
+ *   to perform case insensitive matching. But it might slow down
+ *   performance of algorithm, so you should use it at own your risk.
+ *   The returned configuration may then be used for an arbitary
+ *   amount of times and even in parallel as long as a separate struct
+ *   ts_state variable is provided to every instance.
  *
  *   The actual search is performed by either calling textsearch_find_-
  *   continuous() for linear data or by providing an own get_next_block()
@@ -89,7 +92,6 @@
  *       panic("Oh my god, dancing chickens at %d\n", pos);
  *
  *   textsearch_destroy(conf);
- *
  * ==========================================================================
  */
 
@@ -279,7 +281,7 @@ struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 	if (ops == NULL)
 		goto errout;
 
-	conf = ops->init(pattern, len, gfp_mask);
+	conf = ops->init(pattern, len, gfp_mask, flags);
 	if (IS_ERR(conf)) {
 		err = PTR_ERR(conf);
 		goto errout;
