Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8BFC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Nov 2021 23:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhK2XyZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhK2XyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 18:54:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463D9C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Nov 2021 15:51:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mrqQE-000400-Ex; Tue, 30 Nov 2021 00:50:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] exthdr: fix type number saved in udata
Date:   Tue, 30 Nov 2021 00:50:53 +0100
Message-Id: <20211129235053.17314-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This should store the index of the protocol template, but
x[i] - x[0] is always i, so remove the divide.  Also add test case.

Fixes: 01fbc1574b9e ("exthdr: add parse and build userdata interface")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/exthdr.c                                       | 4 +---
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft | 5 +++++
 tests/shell/testcases/sets/typeof_sets_0           | 5 +++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 22a08b0c9c2b..00d338f07302 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -165,9 +165,7 @@ static struct expr *exthdr_expr_parse_udata(const struct nftnl_udata *attr)
 static unsigned int expr_exthdr_type(const struct exthdr_desc *desc,
 				     const struct proto_hdr_template *tmpl)
 {
-	unsigned int offset = (unsigned int)(tmpl - &desc->templates[0]);
-
-	return offset / sizeof(*tmpl);
+	return (unsigned int)(tmpl - &desc->templates[0]);
 }
 
 static int exthdr_expr_build_udata(struct nftnl_udata_buf *udbuf,
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 565369fb7be5..06d891e682b7 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -14,6 +14,11 @@ table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s4 {
+		typeof frag frag-off
+		elements = { 1, 1024 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 9b2712e56177..a6ff8ca772e2 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -20,6 +20,11 @@ EXPECTED="table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s4 {
+		typeof frag frag-off
+		elements = { 1, 1024 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
-- 
2.32.0

