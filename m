Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA02E743FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 09:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjI2Je4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2Jez (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 05:34:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAC11195
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 02:34:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] src: reverse calloc() invocation
Date:   Fri, 29 Sep 2023 11:34:49 +0200
Message-Id: <20230929093449.79413-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Swap object size and number of elements, so number of elements is the
first argument, then object size is the second argument.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack/api.c    | 6 +++---
 src/conntrack/labels.c | 2 +-
 src/conntrack/stack.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index d27bad2703d3..cd8bea8d2bb3 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -307,7 +307,7 @@ int nfct_callback_register2(struct nfct_handle *h,
 
 	assert(h != NULL);
 
-	container = calloc(sizeof(struct __data_container), 1);
+	container = calloc(1, sizeof(struct __data_container));
 	if (container == NULL)
 		return -1;
 
@@ -1361,7 +1361,7 @@ void nfct_copy_attr(struct nf_conntrack *ct1,
  */
 struct nfct_filter *nfct_filter_create(void)
 {
-	return calloc(sizeof(struct nfct_filter), 1);
+	return calloc(1, sizeof(struct nfct_filter));
 }
 
 /**
@@ -1500,7 +1500,7 @@ int nfct_filter_detach(int fd)
  */
 struct nfct_filter_dump *nfct_filter_dump_create(void)
 {
-	return calloc(sizeof(struct nfct_filter_dump), 1);
+	return calloc(1, sizeof(struct nfct_filter_dump));
 }
 
 /**
diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
index ef85b6e26cb3..5f5019474ca1 100644
--- a/src/conntrack/labels.c
+++ b/src/conntrack/labels.c
@@ -268,7 +268,7 @@ struct nfct_labelmap *__labelmap_new(const char *name)
 
 	if (added) {
 		map->namecount = maxbit + 1;
-		map->bit_to_name = calloc(sizeof(char *), map->namecount);
+		map->bit_to_name = calloc(map->namecount, sizeof(char *));
 		if (!map->bit_to_name)
 			goto err;
 		make_name_table(map);
diff --git a/src/conntrack/stack.c b/src/conntrack/stack.c
index ac3f437375d5..66ccf1f9a03d 100644
--- a/src/conntrack/stack.c
+++ b/src/conntrack/stack.c
@@ -25,11 +25,11 @@ struct stack *stack_create(size_t elem_size, int max_elems)
 {
 	struct stack *s;
 
-	s = calloc(sizeof(struct stack), 1);
+	s = calloc(1, sizeof(struct stack));
 	if (s == NULL)
 		return NULL;
 
-	s->data = calloc(elem_size * max_elems, 1);
+	s->data = calloc(max_elems, elem_size);
 	if (s->data == NULL) {
 		free(s);
 		return NULL;
-- 
2.30.2

