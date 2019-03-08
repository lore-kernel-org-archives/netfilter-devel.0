Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC91C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB2F2087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfCHNfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:35:11 -0500
Received: from mail.us.es ([193.147.175.20]:37714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbfCHNfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:35:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47625505528
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 14:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36644DA86E
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 14:35:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35A00DA86C; Fri,  8 Mar 2019 14:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BA33DA84E
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 14:35:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 14:35:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2AB304265A4E
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 14:35:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: bogus EBUSY in set deletion after flush
Date:   Fri,  8 Mar 2019 14:35:04 +0100
Message-Id: <20190308133504.11024-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

delete.nft:6:1-32: Error: Could not process rule: Device or resource busy
delete map ip filter group_7933
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/0046set_0 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0046set_0

diff --git a/tests/shell/testcases/transactions/0046set_0 b/tests/shell/testcases/transactions/0046set_0
new file mode 100755
index 000000000000..172e24dd314a
--- /dev/null
+++ b/tests/shell/testcases/transactions/0046set_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+RULESET='add table ip filter
+add chain ip filter group_7933
+add map ip filter group_7933 { type ipv4_addr : classid; flags interval; }
+add rule ip filter group_7933 meta priority 0 meta priority set ip saddr map @group_7933 counter
+add element ip filter group_7933 { 10.4.22.0/24 : "1:0xc7cb" }
+'
+
+set -e
+$NFT -f - <<< "$RULESET"
+
+RULESET='delete element ip filter group_7933 { 10.4.22.0/24 }
+flush chain ip filter group_7933
+delete chain ip filter group_7933
+delete map ip filter group_7933'
+
+$NFT -f - <<< "$RULESET"
-- 
2.11.0

