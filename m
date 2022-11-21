Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A089C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiKULZE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiKULYa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDFEB4F16
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:20:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4qF-0002QC-Cf; Mon, 21 Nov 2022 12:19:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 4/5] xlate-test: extra-escape of '"' for replay mode
Date:   Mon, 21 Nov 2022 12:19:31 +0100
Message-Id: <20221121111932.18222-5-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221121111932.18222-1-fw@strlen.de>
References: <20221121111932.18222-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before, nft fails to restore some rules because it sees:
insert rule ip filter INPUT iifname iifname ip ...

Add extra escaping for " so that the shell won't remove it and
nft will see 'iifname "iifname"'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 xlate-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index f3fcd797af90..5711a6427d78 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -104,7 +104,7 @@ def test_one_replay(name, sourceline, expected, result):
             "flush ruleset",
             "add table " + fam + table_name,
             "add chain " + fam + table_name + " " + chain_name
-    ] + [ l.removeprefix("nft ") for l in expected.split("\n") ]
+    ] + [ l.removeprefix("nft ") for l in expected.replace('\"', '\\"', -1).split("\n") ]
 
     # feed input via the pipe to make sure the shell "does its thing"
     cmd = "echo \"" + "\n".join(nft_input) + "\" | " + args.nft + " -f -"
-- 
2.37.4

