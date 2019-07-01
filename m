Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88017C06511
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 16:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6197921473
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 16:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfGAQjA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 12:39:00 -0400
Received: from mail.us.es ([193.147.175.20]:43700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbfGAQjA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 12:39:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CFD47FFB70
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 18:38:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2578DA7B6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 18:38:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7E6C91E1; Mon,  1 Jul 2019 18:38:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C262CDA4D0;
        Mon,  1 Jul 2019 18:38:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 18:38:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9100E4265A31;
        Mon,  1 Jul 2019 18:38:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com, phil@nwl.cc
Subject: [PATCH nft 2/2] tests: shell: restore element expiration
Date:   Mon,  1 Jul 2019 18:38:51 +0200
Message-Id: <20190701163851.11200-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190701163851.11200-1-pablo@netfilter.org>
References: <20190701163851.11200-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a test for 24f33c710e8c ("src: enable set expiration
date for set elements").

This is also implicitly testing for a cache corruption bug that is fixed
by 9b032cd6477b ("monitor: fix double cache update with --echo").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0036add_set_element_expiration_0 | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0036add_set_element_expiration_0

diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
new file mode 100755
index 000000000000..b9b44b0d1c98
--- /dev/null
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+NFT=nft
+
+set -e
+
+RULESET="add table ip x
+add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
+add element ip x y { 1.1.1.1 timeout 30s expires 15s }"
+
+test_output=$($NFT -e -f - <<< "$RULESET" 2>&1)
+
+diff_output=$(diff -u <(echo "$test_output") <(echo "$RULESET"))
-- 
2.11.0

