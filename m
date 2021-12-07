Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF62EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 15:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhLGPUl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 10:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhLGPUk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 10:20:40 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF28C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 07:17:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mucDM-0001ke-VT; Tue, 07 Dec 2021 16:17:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] tests: add shift+and typeof test cases
Date:   Tue,  7 Dec 2021 16:16:56 +0100
Message-Id: <20211207151659.5507-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207151659.5507-1-fw@strlen.de>
References: <20211207151659.5507-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These tests work, but I omitted a few lines that do not:

in: frag frag-off @s4 accept
in: ip version @s8

out: (frag unknown & 0xfff8 [invalid type]) >> 3 == @s4
out:  (ip l4proto & pfsync) >> 4 == @s8

Next patches resolve this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../shell/testcases/sets/dumps/typeof_sets_0.nft  | 15 +++++++++++++++
 tests/shell/testcases/sets/typeof_sets_0          | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 8f11b110552c..ad442713f6dc 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -34,6 +34,17 @@ table inet t {
 		elements = { 1, 4 }
 	}
 
+	set s8 {
+		typeof ip version
+		elements = { 4, 6 }
+	}
+
+	set s9 {
+		typeof ip hdrlength
+		elements = { 0, 1, 2, 3, 4,
+			     15 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -53,4 +64,8 @@ table inet t {
 	chain c7 {
 		sctp chunk init num-inbound-streams @s7 accept
 	}
+
+	chain c9 {
+		ip hdrlength @s9 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 1e99e2987733..2102789e1043 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -40,6 +40,16 @@ EXPECTED="table inet t {
 		elements = { 1, 4 }
 	}
 
+	set s8 {
+		typeof ip version
+		elements = { 4, 6 }
+	}
+
+	set s9 {
+		typeof ip hdrlength
+		elements = { 0, 1, 2, 3, 4, 15 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -59,6 +69,10 @@ EXPECTED="table inet t {
 	chain c7 {
 		sctp chunk init num-inbound-streams @s7 accept
 	}
+
+	chain c9 {
+		ip hdrlength @s9 accept
+	}
 }"
 
 set -e
-- 
2.32.0

