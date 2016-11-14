From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] tests: py: missing range conversion in icmpv6
Date: Mon, 14 Nov 2016 22:01:29 +0100
Message-ID: <1479157289-26503-2-git-send-email-pablo@netfilter.org>
References: <1479157289-26503-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33266 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753468AbcKNVCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 16:02:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F18A1F4B6F
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EDB9A7D43
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DA26A7D43
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:02:16 +0100 (CET)
In-Reply-To: <1479157289-26503-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use range expression to negate ranges.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip6/icmpv6.t.payload.ip6 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index a00f392e9bb7..8d33249e49f3 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -389,8 +389,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmpv6 max-delay {33, 55, 67, 88}
 __set%d test-ip6 3
-- 
2.1.4

