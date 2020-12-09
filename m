Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC55C19425
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4813923B99
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E78C06138C
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:50:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3bG-0004RW-K9; Wed, 09 Dec 2020 18:50:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 08/10] tests: icmp, icmpv6: avoid remaining warnings
Date:   Wed,  9 Dec 2020 18:49:22 +0100
Message-Id: <20201209174924.27720-9-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case of id/sequence, both 'reply' and 'request' are valid types.

nft currently does not remove dependencies that don't have
a fixed rhs constant.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t    | 35 ++++++++++++++++++-----------------
 tests/py/ip6/icmpv6.t | 41 ++++++++++++++++-------------------------
 2 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index cb3b3e356964..e81aeca76088 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -40,24 +40,25 @@ icmp checksum != { 11-343} accept;ok
 icmp checksum { 1111, 222, 343} accept;ok
 icmp checksum != { 1111, 222, 343} accept;ok
 
-icmp id 1245 log;ok
-icmp id 22;ok
-icmp id != 233;ok
-icmp id 33-45;ok
-icmp id != 33-45;ok
-icmp id { 33-55};ok
-icmp id != { 33-55};ok
-icmp id { 22, 34, 333};ok
-icmp id != { 22, 34, 333};ok
+icmp id 1245 log;ok;icmp type { echo-reply, echo-request} icmp id 1245 log
+icmp id 22;ok;icmp type { echo-reply, echo-request} icmp id 22
+icmp id != 233;ok;icmp type { echo-reply, echo-request} icmp id != 233
+icmp id 33-45;ok;icmp type { echo-reply, echo-request} icmp id 33-45
+icmp id != 33-45;ok;icmp type { echo-reply, echo-request} icmp id != 33-45
+icmp id { 33-55};ok;icmp type { echo-reply, echo-request} icmp id { 33-55}
+icmp id != { 33-55};ok;icmp type { echo-reply, echo-request} icmp id != { 33-55}
 
-icmp sequence 22;ok
-icmp sequence != 233;ok
-icmp sequence 33-45;ok
-icmp sequence != 33-45;ok
-icmp sequence { 33, 55, 67, 88};ok
-icmp sequence != { 33, 55, 67, 88};ok
-icmp sequence { 33-55};ok
-icmp sequence != { 33-55};ok
+icmp id { 22, 34, 333};ok;icmp type { echo-request, echo-reply} icmp id { 22, 34, 333}
+icmp id != { 22, 34, 333};ok;icmp type { echo-request, echo-reply} icmp id != { 22, 34, 333}
+
+icmp sequence 22;ok;icmp type { echo-reply, echo-request} icmp sequence 22
+icmp sequence != 233;ok;icmp type { echo-reply, echo-request} icmp sequence != 233
+icmp sequence 33-45;ok;icmp type { echo-reply, echo-request} icmp sequence 33-45
+icmp sequence != 33-45;ok;icmp type { echo-reply, echo-request} icmp sequence != 33-45
+icmp sequence { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp sequence { 33, 55, 67, 88}
+icmp sequence != { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33, 55, 67, 88}
+icmp sequence { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence { 33-55}
+icmp sequence != { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33-55}
 
 icmp mtu 33;ok
 icmp mtu 22-33;ok
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 8d794115d51e..67fa6ca8490f 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -44,9 +44,8 @@ icmpv6 checksum != { 222, 226};ok
 icmpv6 checksum { 222-226};ok
 icmpv6 checksum != { 222-226};ok
 
-# BUG: icmpv6 parameter-problem, pptr, mtu, packet-too-big
+# BUG: icmpv6 parameter-problem, pptr
 # [ICMP6HDR_PPTR]         = ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
-# [ICMP6HDR_MTU]          = ICMP6HDR_FIELD("packet-too-big", icmp6_mtu),
 # $ sudo nft add rule ip6 test6 input icmpv6 parameter-problem 35
 # <cmdline>:1:53-53: Error: syntax error, unexpected end of file
 # add rule ip6 test6 input icmpv6 parameter-problem 35
@@ -59,11 +58,6 @@ icmpv6 checksum != { 222-226};ok
 # <cmdline>:1:54-54: Error: syntax error, unexpected end of file
 # add rule ip6 test6 input icmpv6 parameter-problem 2-4
 
-# BUG: packet-too-big
-# $ sudo nft add rule ip6 test6 input icmpv6 packet-too-big 34
-# <cmdline>:1:50-50: Error: syntax error, unexpected end of file
-# add rule ip6 test6 input icmpv6 packet-too-big 34
-
 icmpv6 mtu 22;ok
 icmpv6 mtu != 233;ok
 icmpv6 mtu 33-45;ok
@@ -73,27 +67,24 @@ icmpv6 mtu != {33, 55, 67, 88};ok
 icmpv6 mtu {33-55};ok
 icmpv6 mtu != {33-55};ok
 
-- icmpv6 id 2;ok
-- icmpv6 id != 233;ok
-icmpv6 id 33-45;ok
-icmpv6 id != 33-45;ok
-icmpv6 id {33, 55, 67, 88};ok
-icmpv6 id != {33, 55, 67, 88};ok
-icmpv6 id {33-55};ok
-icmpv6 id != {33-55};ok
+icmpv6 id 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id 33-45
+icmpv6 id != 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != 33-45
+icmpv6 id {33, 55, 67, 88};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id { 33, 55, 67, 88}
+icmpv6 id != {33, 55, 67, 88};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != { 33, 55, 67, 88}
+icmpv6 id {33-55};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id { 33-55}
+icmpv6 id != {33-55};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != { 33-55}
+
+icmpv6 sequence 2;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence 2
+icmpv6 sequence {3, 4, 5, 6, 7} accept;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence { 3, 4, 5, 6, 7} accept
 
-icmpv6 sequence 2;ok
-icmpv6 sequence {3, 4, 5, 6, 7} accept;ok
 
-icmpv6 sequence {2, 4};ok
-icmpv6 sequence != {2, 4};ok
-icmpv6 sequence 2-4;ok
-icmpv6 sequence != 2-4;ok
-icmpv6 sequence { 2-4};ok
-icmpv6 sequence != { 2-4};ok
+icmpv6 sequence {2, 4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence { 2, 4}
+icmpv6 sequence != {2, 4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != { 2, 4}
+icmpv6 sequence 2-4;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence 2-4
+icmpv6 sequence != 2-4;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != 2-4
+icmpv6 sequence { 2-4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence { 2-4}
+icmpv6 sequence != { 2-4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != { 2-4}
 
-- icmpv6 max-delay 22;ok
-- icmpv6 max-delay != 233;ok
 icmpv6 max-delay 33-45;ok
 icmpv6 max-delay != 33-45;ok
 icmpv6 max-delay {33, 55, 67, 88};ok
-- 
2.26.2

