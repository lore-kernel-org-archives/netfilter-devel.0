Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019FFC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 09:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3FE2070D
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 09:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCNJxW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 05:53:22 -0400
Received: from mail.us.es ([193.147.175.20]:59972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbfCNJxW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 05:53:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A10501B6960
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 10:53:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C3E8DA561
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 10:53:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 63497DA876; Thu, 14 Mar 2019 10:53:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1947ABAABD;
        Thu, 14 Mar 2019 10:53:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 10:53:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CE2384265A4C;
        Thu, 14 Mar 2019 10:53:15 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com
Subject: [PATCH nft] tests: shell: bogus EBUSY on helper deletion from transaction
Date:   Thu, 14 Mar 2019 10:53:11 +0100
Message-Id: <20190314095311.19380-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/0048helpers_0 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0048helpers_0

diff --git a/tests/shell/testcases/transactions/0048helpers_0 b/tests/shell/testcases/transactions/0048helpers_0
new file mode 100755
index 000000000000..675a977ef4a1
--- /dev/null
+++ b/tests/shell/testcases/transactions/0048helpers_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+RULESET='add table ip filter
+add chain ip filter filter { type filter hook prerouting priority mangle; policy accept; }
+add ct helper ip filter ftp { type "ftp" protocol tcp; };
+add rule ip filter filter tcp dport 33 ct helper set "ftp"'
+
+set -e
+$NFT -f - <<< "$RULESET"
+
+RULESET='flush chain ip filter filter
+delete chain filter filter
+delete ct helper ip filter ftp'
+
+$NFT -f - <<< "$RULESET"
-- 
2.11.0

