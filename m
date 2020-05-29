Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36072C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 14:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FE920721
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 14:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgE2OoA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 10:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2OoA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 10:44:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537DFC03E969
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 07:44:00 -0700 (PDT)
Received: from localhost ([::1]:57646 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jegEn-0007zK-LS; Fri, 29 May 2020 16:43:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Fix syntax in ipt-restore/0010-noflush-new-chain_0
Date:   Fri, 29 May 2020 16:43:49 +0200
Message-Id: <20200529144349.29880-1-phil@nwl.cc>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The here-doc statement missed the final delimiter. Worked anyways
because end-of-file would do the trick.

Fixes: a103fbfadf4c1 ("xtables-restore: Fix parser feed from line buffer")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0   | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0 b/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0
index 739e684a21183..2817376ed913e 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0010-noflush-new-chain_0
@@ -8,3 +8,4 @@ $XT_MULTI iptables-restore --noflush <<EOF
 :foobar - [0:0]
 -A foobar -j ACCEPT
 COMMIT
+EOF
-- 
2.26.2

