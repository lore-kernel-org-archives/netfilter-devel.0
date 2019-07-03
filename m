Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8564EC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6380321882
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfGCLNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 07:13:04 -0400
Received: from mail.us.es ([193.147.175.20]:52460 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfGCLNE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 07:13:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E240612BFF2
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:13:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D401CDA708
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:13:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9B1DDA4CA; Wed,  3 Jul 2019 13:13:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1D54DA708
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:13:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 13:13:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 81B144265A31
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 13:13:00 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: update test to include reset command
Date:   Wed,  3 Jul 2019 13:12:57 +0200
Message-Id: <20190703111257.4638-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update tests to invoke the reset command.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0024named_objects_0           | 5 +++++
 tests/shell/testcases/sets/dumps/0024named_objects_0.nft | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tests/shell/testcases/sets/0024named_objects_0 b/tests/shell/testcases/sets/0024named_objects_0
index 10f99b62a143..3bd16f2fd028 100755
--- a/tests/shell/testcases/sets/0024named_objects_0
+++ b/tests/shell/testcases/sets/0024named_objects_0
@@ -9,6 +9,9 @@ table inet x {
 	counter user123 {
 		packets 12 bytes 1433
 	}
+	counter user321 {
+		packets 12 bytes 1433
+	}
 	quota user123 {
 		over 2000 bytes
 	}
@@ -31,3 +34,5 @@ table inet x {
 
 set -e
 $NFT -f - <<< "$RULESET"
+
+$NFT reset counter inet x user321
diff --git a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
index 91c3c46b6637..2ffa4f2ff757 100644
--- a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
+++ b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
@@ -3,6 +3,10 @@ table inet x {
 		packets 12 bytes 1433
 	}
 
+	counter user321 {
+		packets 0 bytes 0
+	}
+
 	quota user123 {
 		over 2000 bytes
 	}
-- 
2.11.0

