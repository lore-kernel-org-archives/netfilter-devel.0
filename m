Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B49C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 08:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiHIIzV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiHIIzU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 04:55:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84D6B626B
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 01:55:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] tests/py: disable arp family for queue statement
Date:   Tue,  9 Aug 2022 10:55:15 +0200
Message-Id: <20220809085515.169605-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel commit:

  commit 47f4f510ad586032b85c89a0773fbb011d412425
  Author: Florian Westphal <fw@strlen.de>
  Date:   Tue Jul 26 19:49:00 2022 +0200

    netfilter: nft_queue: only allow supported familes and hooks

restricts supported families, excluding arp.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/queue.t | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index f12acfafe19b..2e51136267c5 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -3,7 +3,6 @@
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
-*arp;test-arp;output
 *bridge;test-bridge;output
 
 queue;ok;queue to 0
-- 
2.30.2

