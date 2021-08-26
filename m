Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A64C4320A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039CF6103A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhHZNzY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 09:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhHZNzX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 09:55:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F7C061757
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Aug 2021 06:54:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mJFpy-0000YQ-AG; Thu, 26 Aug 2021 15:54:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/3] netfilter: conntrack: sanitize table size default settings
Date:   Thu, 26 Aug 2021 15:54:19 +0200
Message-Id: <20210826135422.31063-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826135422.31063-1-fw@strlen.de>
References: <20210826135422.31063-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

conntrack has two distinct table size settings:
nf_conntrack_max and nf_conntrack_buckets.

The former limits how many conntrack objects are allowed to exist
in each namespace.

The second sets the size of the hashtable.

As all entries are inserted twice (once for original direction, once for
reply), there should be at least twice as many buckets in the table than
the maximum number of conntrack objects that can exist at the same time.

Change the default multiplier to 1 and increase the chosen bucket sizes.
This results in the same nf_conntrack_max settings as before but reduces
the average bucket list length.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../networking/nf_conntrack-sysctl.rst        | 13 ++++----
 net/netfilter/nf_conntrack_core.c             | 30 +++++++++----------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 024d784157c8..de3815dd4d49 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -17,9 +17,8 @@ nf_conntrack_acct - BOOLEAN
 nf_conntrack_buckets - INTEGER
 	Size of hash table. If not specified as parameter during module
 	loading, the default size is calculated by dividing total memory
-	by 16384 to determine the number of buckets but the hash table will
-	never have fewer than 32 and limited to 16384 buckets. For systems
-	with more than 4GB of memory it will be 65536 buckets.
+	by 16384 to determine the number of buckets. The hash table will
+	never have fewer than 1024 and never more than 262144 buckets.
 	This sysctl is only writeable in the initial net namespace.
 
 nf_conntrack_checksum - BOOLEAN
@@ -100,8 +99,12 @@ nf_conntrack_log_invalid - INTEGER
 	Log invalid packets of a type specified by value.
 
 nf_conntrack_max - INTEGER
-	Size of connection tracking table.  Default value is
-	nf_conntrack_buckets value * 4.
+        Maximum number of allowed connection tracking entries. This value is set
+        to nf_conntrack_buckets by default.
+        Note that connection tracking entries are added to the table twice -- once
+        for the original direction and once for the reply direction (i.e., with
+        the reversed address). This means that with default settings a maxed-out
+        table will have a average hash chain length of 2, not 1.
 
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d31dbccbe7bd..cdd8a1dc2275 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2594,26 +2594,24 @@ int nf_conntrack_init_start(void)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
 	if (!nf_conntrack_htable_size) {
-		/* Idea from tcp.c: use 1/16384 of memory.
-		 * On i386: 32MB machine has 512 buckets.
-		 * >= 1GB machines have 16384 buckets.
-		 * >= 4GB machines have 65536 buckets.
-		 */
 		nf_conntrack_htable_size
 			= (((nr_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
-			nf_conntrack_htable_size = 65536;
+		if (BITS_PER_LONG >= 64 &&
+		    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
+			nf_conntrack_htable_size = 262144;
 		else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
-			nf_conntrack_htable_size = 16384;
-		if (nf_conntrack_htable_size < 32)
-			nf_conntrack_htable_size = 32;
-
-		/* Use a max. factor of four by default to get the same max as
-		 * with the old struct list_heads. When a table size is given
-		 * we use the old value of 8 to avoid reducing the max.
-		 * entries. */
-		max_factor = 4;
+			nf_conntrack_htable_size = 65536;
+
+		if (nf_conntrack_htable_size < 1024)
+			nf_conntrack_htable_size = 1024;
+		/* Use a max. factor of one by default to keep the average
+		 * hash chain length at 2 entries.  Each entry has to be added
+		 * twice (once for original direction, once for reply).
+		 * When a table size is given we use the old value of 8 to
+		 * avoid implicit reduction of the max entries setting.
+		 */
+		max_factor = 1;
 	}
 
 	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
-- 
2.31.1

