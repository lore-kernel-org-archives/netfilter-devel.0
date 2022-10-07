Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D605C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJGQgc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 12:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJGQgb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 12:36:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631D79E2F7
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 09:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2ukNJDtm3tWYW4oyk7q7B7azUpbgd6Y7MjMKa8+q6Ck=; b=FSW0ps5SnDd7kmLprpsf2KX01S
        w8b0yIm4wR4mvybwmSSuiJm51/P5ZcbG0KKa1qlGDER+BkmVIihkQHauw4l99J/BE8XjyM8/fp4j0
        GmmfuCN602H5IJWNVY3lhzJyQkRRN2e6mwJPZt5wQgbFpuHKaEAP+fPQxGqs9et9Xq7J5sbQ4qHou
        zpWzQRQzgdQizuTQoncP0bdTDEAs4byQIhuzOb9DvWix7OKJkJu3dyPqKyNrTGB4jgQUgb/MSLaph
        N5ozh01CX+a9hdHHX+stgyFls/3l2KJ5AUlx44ZVJznIJmrCWqtL8jQddJi57Qp5jABXTNyHcbYV8
        wbaklvew==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogqKh-0001bt-3Q; Fri, 07 Oct 2022 18:36:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Julien Castets <castets.j@gmail.com>
Subject: [iptables PATCH] libiptc: Fix for segfault when renaming a chain
Date:   Fri,  7 Oct 2022 18:36:10 +0200
Message-Id: <20221007163610.8503-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an odd bug: If the number of chains is right and one renames the
last one in the list, libiptc dereferences a NULL pointer. Add fix and
test case for it.

Fixes: 64ff47cde38e4 ("libiptc: fix chain rename bug in libiptc")
Reported-by: Julien Castets <castets.j@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/chain/0006rename-segfault_0     | 19 +++++++++++++++++++
 libiptc/libiptc.c                             |  9 +++++++++
 2 files changed, 28 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/chain/0006rename-segfault_0

diff --git a/iptables/tests/shell/testcases/chain/0006rename-segfault_0 b/iptables/tests/shell/testcases/chain/0006rename-segfault_0
new file mode 100755
index 0000000000000..c10a8006b56b4
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0006rename-segfault_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+#
+# Cover for a bug in libiptc:
+# - the chain 'node-98-tmp' is the last in the list sorted by name
+# - there are 81 chains in total, so three chain index buckets
+# - the last index bucket contains only the 'node-98-tmp' chain
+# => rename temporarily removes it from the bucket, leaving a NULL bucket
+#    behind which is dereferenced later when inserting the chain again with new
+#    name again
+
+(
+	echo "*filter"
+	for chain in node-1 node-10 node-101 node-102 node-104 node-107 node-11 node-12 node-13 node-14 node-15 node-16 node-17 node-18 node-19 node-2 node-20 node-21 node-22 node-23 node-25 node-26 node-27 node-28 node-29 node-3 node-30 node-31 node-32 node-33 node-34 node-36 node-37 node-39 node-4 node-40 node-41 node-42 node-43 node-44 node-45 node-46 node-47 node-48 node-49 node-5 node-50 node-51 node-53 node-54 node-55 node-56 node-57 node-58 node-59 node-6 node-60 node-61 node-62 node-63 node-64 node-65 node-66 node-68 node-69 node-7 node-70 node-71 node-74 node-75 node-76 node-8 node-80 node-81 node-86 node-89 node-9 node-92 node-93 node-95 node-98-tmp; do
+		echo ":$chain - [0:0]"
+	done
+	echo "COMMIT"
+) | $XT_MULTI iptables-restore
+$XT_MULTI iptables -E node-98-tmp node-98
+exit $?
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index ceeb017b39400..97823f935d1ee 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -606,6 +606,15 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, struct xtc_handl
 
 	if (index_ptr == &c->list) { /* Chain used as index ptr */
 
+		/* If this is the last chain in the list, its index bucket just
+		 * became empty. Adjust the size to avoid a NULL-pointer deref
+		 * later.
+		 */
+		if (next == &h->chains) {
+			h->chain_index_sz--;
+			return 0;
+		}
+
 		/* See if its possible to avoid a rebuild, by shifting
 		 * to next pointer.  Its possible if the next pointer
 		 * is located in the same index bucket.
-- 
2.34.1

