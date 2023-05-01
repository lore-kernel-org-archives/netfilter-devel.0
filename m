Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95628C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 May 2023 10:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjEAKKC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 May 2023 06:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjEAKKB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2023 06:10:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D3EE6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2023 03:09:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ptQTe-0004J0-6x; Mon, 01 May 2023 12:09:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: list set/map flag keywords in a table
Date:   Mon,  1 May 2023 12:09:44 +0200
Message-Id: <20230501100944.386410-1-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

add descriptions of the set/map flags.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 83f0f8bb155a..19ba55d96505 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -597,8 +597,7 @@ string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark
 data type of set element |
 expression to derive the data type from
 |flags |
-set flags |
-string: constant, dynamic, interval, timeout
+set flags | string: constant, dynamic, interval, timeout.  Used to describe the sets properties.
 |timeout |
 time an element stays in the set, mandatory if set is added to from the packet path (ruleset)|
 string, decimal followed by unit. Units are: d, h, m, s
@@ -650,7 +649,7 @@ data type of set element |
 expression to derive the data type from
 |flags |
 map flags |
-string: constant, interval
+string, same as set flags
 |elements |
 elements contained by the map |
 map data type
@@ -662,6 +661,22 @@ map policy |
 string: performance [default], memory
 |=================
 
+Users can specifiy the properties/features that the set/map must support.
+This allows the kernel to pick an optimal internal representation.
+If a required flag is missing, the ruleset might still work, as
+nftables will auto-enable features if it can infer this from the ruleset.
+This may not work for all cases, however, so it is recommended to
+specify all required features in the set/map definition manually.
+
+.Set and Map flags
+[options="header"]
+|=================
+|Flag		| Description
+|constant	| Set contents will never change after creation
+|dynamic	| Set must support updates from the packet path with the *add*, *update* or *delete* keywords.
+|interval	| Set must be able to store intervals (ranges)
+|timeout	| Set must support element timeouts (auto-removal of elements once they expire).
+|=================
 
 ELEMENTS
 --------
-- 
2.40.1

