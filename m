Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1416CE732E5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjI1QTq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjI1QTp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:19:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F56199
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dJMmkjnILAvO/MDzw4yFORChFOfJQfn6CWJFDQKTq0k=; b=l27Wvg87DOSn/nYduEtnY6a/zE
        vqspTFpRe7/iz/AtYvn95a0oNoNJ23aLTi2vz4PkFKcoQIsJVrVqt0BeYCytfOZayGnfq3EX7rLjR
        S1ymA3W90qRRoTYL4mXDbXo+h6FmS2W3mxkDT4wIiYGYvLcwHVe6B0X2/X2S/LQA4iAGg5c2HQ7bz
        mxFx64aXY7K71FDimYhRmXZ+iWs4XH4HBtdU5zssAqDqu3giDy5vMpDb7+HeJHJQu5rfN+M2XuDG2
        MP1Xvw8d5Uvr16eBOQI7+sLpJA0iPZ5jrxov+RvWnhNmtDIe5jw08+BPL1nNOHMOVEyvp4PsYBeUr
        xrnXyFvg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qltjo-0004W1-ID; Thu, 28 Sep 2023 18:19:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix for failing nft-f/sample-ruleset
Date:   Thu, 28 Sep 2023 18:19:37 +0200
Message-ID: <20230928161937.4310-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For whatever reason, my system lacks an entry for 'sip' in
/etc/services. Assuming the service name is not relevant to the test,
just replace it by the respective port number.

Fixes: 68728014435d9 ("tests: shell: add sample ruleset reproducer")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/nft-f/sample-ruleset | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/nft-f/sample-ruleset b/tests/shell/testcases/nft-f/sample-ruleset
index 8cee74b94664f..763e41a1f7214 100755
--- a/tests/shell/testcases/nft-f/sample-ruleset
+++ b/tests/shell/testcases/nft-f/sample-ruleset
@@ -175,7 +175,7 @@ table inet filter {
 		log prefix "NFT REJECT FWD " flags ether flags ip options limit rate 5/second burst 10 packets reject
 	}
 	chain public_forward {
-		udp dport { sip, 7078-7097 } oifname $voip_if jump {
+		udp dport { 5060, 7078-7097 } oifname $voip_if jump {
 			ip6 saddr $sip_whitelist_ip6 accept
 			meta nfproto ipv6 log prefix "NFT DROP SIP " flags ether flags ip options limit rate 5/second burst 10 packets drop
 		}
@@ -199,7 +199,7 @@ table inet filter {
 		icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, echo-request } oifname $public_if accept
 
 		ip6 daddr $sip_whitelist_ip6 jump {
-			udp dport { 3478, sip } accept
+			udp dport { 3478, 5060 } accept
 			udp sport { 7078-7097 } accept
 			tcp dport 5061 accept
 		}
-- 
2.41.0

