Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12C8C4361B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A78B5225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgLIRvD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgLIRvC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:51:02 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D15C061282
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:50:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3bK-0004Rd-RQ; Wed, 09 Dec 2020 18:50:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 09/10] tests: ip: add one test case to cover both id and sequence
Date:   Wed,  9 Dec 2020 18:49:23 +0100
Message-Id: <20201209174924.27720-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are two 2-byte matches, so nft will merge the accesses to
a single 4-byte load+compare.

Check this is properly demangled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t            |  2 ++
 tests/py/ip/icmp.t.payload.ip | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index e81aeca76088..996e1fc321e4 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -59,6 +59,7 @@ icmp sequence { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp se
 icmp sequence != { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33, 55, 67, 88}
 icmp sequence { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence { 33-55}
 icmp sequence != { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33-55}
+icmp id 1 icmp sequence 2;ok;icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
 
 icmp mtu 33;ok
 icmp mtu 22-33;ok
@@ -83,3 +84,4 @@ icmp gateway { 33-55};ok
 icmp gateway != { 33-55};ok
 icmp gateway != 34;ok
 icmp gateway != { 333, 334};ok
+
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 6ed4dff86d10..e238c4bb142c 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -502,6 +502,18 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# icmp id 1 icmp sequence 2
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000000  : 0 [end]
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
-- 
2.26.2

