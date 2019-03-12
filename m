Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06101C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D14762075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfCLLc5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:32:57 -0400
Received: from mail.us.es ([193.147.175.20]:44618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfCLLc5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 07:32:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63866114812
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:32:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5093EDA38C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:32:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 43061DA3F6; Tue, 12 Mar 2019 12:32:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C48B1DA86A
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:32:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Mar 2019 12:32:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A5D5C4265A4E
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:32:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: bogus ENOENT on element deletion in interval set
Date:   Tue, 12 Mar 2019 12:32:47 +0100
Message-Id: <20190312113247.9127-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/0047set_0 | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0047set_0

diff --git a/tests/shell/testcases/transactions/0047set_0 b/tests/shell/testcases/transactions/0047set_0
new file mode 100755
index 000000000000..0a2723115452
--- /dev/null
+++ b/tests/shell/testcases/transactions/0047set_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+RULESET='add table ip filter
+add map ip filter group_10060 { type ipv4_addr : classid; flags interval; }
+add element ip filter group_10060 { 10.1.26.2/32 : "1:0xbbf8" }
+add element ip filter group_10060 { 10.1.26.3/32 : "1:0xc1ad" }
+add element ip filter group_10060 { 10.1.26.4/32 : "1:0xb2d7" }
+add element ip filter group_10060 { 10.1.26.5/32 : "1:0xf705" }
+add element ip filter group_10060 { 10.1.26.6/32 : "1:0xb895" }
+add element ip filter group_10060 { 10.1.26.7/32 : "1:0xec4c" }
+add element ip filter group_10060 { 10.1.26.8/32 : "1:0xde78" }
+add element ip filter group_10060 { 10.1.26.9/32 : "1:0xb4f3" }
+add element ip filter group_10060 { 10.1.26.10/32 : "1:0xdec6" }
+add element ip filter group_10060 { 10.1.26.11/32 : "1:0xb4c0" }
+add element ip filter group_10060 { 10.1.26.12/32 : "1:0xb4a2" }
+add element ip filter group_10060 { 10.1.26.13/32 : "1:0xa8ab" }
+add element ip filter group_10060 { 10.1.26.14/32 : "1:0xb3c1" }'
+
+set -e
+$NFT -f - <<< "$RULESET"
+
+RULESET='delete element ip filter group_10060 { 10.1.26.13/32 }
+delete element ip filter group_10060 { 10.1.26.14/32 }
+delete element ip filter group_10060 { 10.1.26.12/32 }'
+
+$NFT -f - <<< "$RULESET"
-- 
2.11.0

