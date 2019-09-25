Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA6CC432C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 08:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB05E2082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 08:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfIYI4V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 04:56:21 -0400
Received: from correo.us.es ([193.147.175.20]:52014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbfIYI4H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 04:56:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F7AA1C0223
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:56:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46F7DDA840
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:56:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3C7C7DA72F; Wed, 25 Sep 2019 10:56:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46117B7FF2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:55:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 10:55:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 27C404265A5A
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:55:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: delete flowtable after flush chain
Date:   Wed, 25 Sep 2019 10:55:57 +0200
Message-Id: <20190925085557.31517-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Returns EBUSY on buggy kernels.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/flowtable/0009deleteafterflush_0 | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100755 tests/shell/testcases/flowtable/0009deleteafterflush_0

diff --git a/tests/shell/testcases/flowtable/0009deleteafterflush_0 b/tests/shell/testcases/flowtable/0009deleteafterflush_0
new file mode 100755
index 000000000000..2cda5639693c
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0009deleteafterflush_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+$NFT add table x
+$NFT add chain x y
+$NFT add flowtable x f { hook ingress priority 0\; devices = { lo }\;}
+$NFT add rule x y flow add @f
+$NFT flush chain x y
+$NFT delete flowtable x f
-- 
2.11.0

