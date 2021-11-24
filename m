Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA79BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhKXR1e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbhKXR12 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5514C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:18 -0800 (PST)
Received: from localhost ([::1]:44892 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0G-000198-Vv; Wed, 24 Nov 2021 18:24:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 12/15] include: Use struct nftnl_set_desc
Date:   Wed, 24 Nov 2021 18:22:48 +0100
Message-Id: <20211124172251.11539-13-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since libnftnl now exports the data structure, use it in struct set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index be31695636df4..5e6647f9d6cca 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -6,6 +6,7 @@
 #include <list.h>
 #include <netinet/in.h>
 #include <libnftnl/object.h>	/* For NFTNL_CTTIMEOUT_ARRAY_MAX. */
+#include <libnftnl/set.h>
 #include <linux/netfilter/nf_tables.h>
 #include <string.h>
 #include <cache.h>
@@ -330,9 +331,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @policy:	set mechanism policy
  * @automerge:	merge adjacents and overlapping elements, if possible
  * @comment:	comment
- * @desc.size:		count of set elements
- * @desc.field_len:	length of single concatenated fields, bytes
- * @desc.field_count:	count of concatenated fields
+ * @desc:	set element meta data
  */
 struct set {
 	struct list_head	list;
@@ -354,11 +353,7 @@ struct set {
 	bool			automerge;
 	bool			key_typeof_valid;
 	const char		*comment;
-	struct {
-		uint32_t	size;
-		uint8_t		field_len[NFT_REG32_COUNT];
-		uint8_t		field_count;
-	} desc;
+	struct nftnl_set_desc	desc;
 };
 
 extern struct set *set_alloc(const struct location *loc);
-- 
2.33.0

