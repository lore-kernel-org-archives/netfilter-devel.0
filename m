Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D592C4361B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33A49225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgLIRvC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgLIRvC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:51:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DFC061285
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:50:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3bP-0004Rk-3h; Wed, 09 Dec 2020 18:50:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 10/10] tests: icmp, icmpv6: check we don't add second dependency
Date:   Wed,  9 Dec 2020 18:49:24 +0100
Message-Id: <20201209174924.27720-11-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If dependency is already fulfilled, do not add another one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t                |  1 +
 tests/py/ip/icmp.t.payload.ip     | 12 ++++++++++++
 tests/py/ip6/icmpv6.t             |  1 +
 tests/py/ip6/icmpv6.t.payload.ip6 |  9 +++++++++
 4 files changed, 23 insertions(+)

diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index 996e1fc321e4..c22b55eb1e3f 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -60,6 +60,7 @@ icmp sequence != { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp
 icmp sequence { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence { 33-55}
 icmp sequence != { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33-55}
 icmp id 1 icmp sequence 2;ok;icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
+icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2;ok
 
 icmp mtu 33;ok
 icmp mtu 22-33;ok
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index e238c4bb142c..d75d12a06125 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -514,6 +514,18 @@ ip
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ cmp eq reg 1 0x02000100 ]
 
+# icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 00000008  : 0 [end]
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x02000100 ]
+
 # icmp mtu 33
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 67fa6ca8490f..8b411a8bf439 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -66,6 +66,7 @@ icmpv6 mtu {33, 55, 67, 88};ok
 icmpv6 mtu != {33, 55, 67, 88};ok
 icmpv6 mtu {33-55};ok
 icmpv6 mtu != {33-55};ok
+icmpv6 type packet-too-big icmpv6 mtu 1280;ok;icmpv6 mtu 1280
 
 icmpv6 id 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id 33-45
 icmpv6 id != 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != 33-45
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 406bdd6dab93..171b7eade6d3 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -408,6 +408,15 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# icmpv6 type packet-too-big icmpv6 mtu 1280
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00050000 ]
+
 # icmpv6 id 33-45
 __set%d test-ip6 3
 __set%d test-ip6 0
-- 
2.26.2

