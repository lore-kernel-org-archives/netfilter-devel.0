Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A3BC76188
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Apr 2023 11:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbjDELVe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Apr 2023 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjDELVd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2023 07:21:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D772D4B
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Apr 2023 04:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CTlZyikx5uyEY73+cpDY4EKVvNLJ2jCTHhLe4uQmhGA=; b=cU7X2qr7AWvmntlWk03MFQ19F+
        oL09hB1/epghaavvZIo7EVi+574AyP0rCT/zCSroM6GZe2xDAo/gkG5AXtcbMXxfBXqP5TfUrhMHb
        jXyH25Lt9SD84euYGCLdeQ2OqVzAGtWfDAHt/6Xiq5hfRFzs6o2D3Ejq8EVAZR3kxIStEiZlmqm++
        YCPO5tqvliWWdQWuFzXGBwhrILvBD6CGHcl/XBa1Zltwx8/RXv5GaX6jIam/P7VrAqk9QZ97Yy5pQ
        3I0ijOQbTsfzbyKUtpJ2FDPDPgq0j55OahLD6xSfEi0rgDFro6UJWfUGe859rME3L4YqhIfIBGjWk
        B+ALxNAQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pk1Ci-0005in-V4
        for netfilter-devel@vger.kernel.org; Wed, 05 Apr 2023 13:21:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Test for false-positive rule check
Date:   Wed,  5 Apr 2023 13:21:20 +0200
Message-Id: <20230405112120.9065-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rule comparison in legacy ip6tables was broken by commit eb2546a846776
("xshared: Share make_delete_mask() between ip{,6}tables"): A part of
the rules' data was masked out for comparison by accident.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ip6tables/0005-rule-check_0 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ip6tables/0005-rule-check_0

diff --git a/iptables/tests/shell/testcases/ip6tables/0005-rule-check_0 b/iptables/tests/shell/testcases/ip6tables/0005-rule-check_0
new file mode 100755
index 0000000000000..cc8215bf43495
--- /dev/null
+++ b/iptables/tests/shell/testcases/ip6tables/0005-rule-check_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+#
+# Test the fix in commit 78850e7dba64a ("ip6tables: Fix checking existence of
+# rule"). Happens with legacy ip6tables only, but testing ip6tables-nft doesn't
+# hurt.
+#
+# Code taken from https://bugzilla.netfilter.org/show_bug.cgi?id=1667
+# Thanks to Jonathan Caicedo <jonathan@jcaicedo.com> for providing it.
+
+RULE='-p tcp --dport 81 -j DNAT --to-destination [::1]:81'
+
+$XT_MULTI ip6tables -t nat -N testchain || exit 1
+$XT_MULTI ip6tables -t nat -A testchain $RULE || exit 1
+$XT_MULTI ip6tables -t nat -C testchain $RULE || exit 1
+
+$XT_MULTI ip6tables -t nat -C testchain ${RULE//81/82} 2>/dev/null && exit 1
+exit 0
-- 
2.38.0

