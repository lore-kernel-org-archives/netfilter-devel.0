Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA60DC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKULZJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiKULYe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275879AC87
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:20:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4qJ-0002QL-GN; Mon, 21 Nov 2022 12:20:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 5/5] generic.xlate: make one replay test case work
Date:   Mon, 21 Nov 2022 12:19:32 +0100
Message-Id: <20221121111932.18222-6-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221121111932.18222-1-fw@strlen.de>
References: <20221121111932.18222-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is just to demonstrate yet another problem.

For the rule itself it doesn't matter if '-i' or '-s' is passed first,
but the test script has no deeper understanding for the rules and will
do a simple textual comparision, this will fail because as-is the output
is different than the input (options are written out in different
order).

We either need to sanoitize the input or update the test script to
split lines and re-order the options or similar.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/generic.txlate | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 6779d6f86dec..e95432552ef8 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -4,7 +4,7 @@ nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
 iptables-translate -F -t nat
 nft flush table ip nat
 
-iptables-translate -I INPUT -i iifname -s 10.0.0.0/8
+iptables-translate -I INPUT -s 10.0.0.0/8 -i iifname
 nft insert rule ip filter INPUT iifname "iifname" ip saddr 10.0.0.0/8 counter
 
 iptables-translate -A INPUT -i iif+ ! -d 10.0.0.0/8
-- 
2.37.4

