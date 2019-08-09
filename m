Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F5DC31E40
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F046C208C4
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406534AbfHILeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 07:34:21 -0400
Received: from correo.us.es ([193.147.175.20]:49800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfHILeV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 07:34:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4E4B6C2B0B
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:34:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F858DA730
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:34:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35522A590; Fri,  9 Aug 2019 13:34:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27C77D1929
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:34:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 13:34:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 985B44102CB4
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:34:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: shell: move chain priority and policy to chain folder
Date:   Fri,  9 Aug 2019 13:34:06 +0200
Message-Id: <20190809113407.2442-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move new chain tests for variable priority and policy to chain folder.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../{nft-f/0021priority_variable_0 => chains/0031priority_variable_0}     | 0
 .../{nft-f/0022priority_variable_0 => chains/0032priority_variable_0}     | 0
 .../{nft-f/0023priority_variable_1 => chains/0033priority_variable_1}     | 0
 .../{nft-f/0024priority_variable_1 => chains/0034priority_variable_1}     | 0
 .../{nft-f/0025policy_variable_0 => chains/0035policy_variable_0}         | 0
 .../{nft-f/0026policy_variable_0 => chains/0036policy_variable_0}         | 0
 .../{nft-f/0027policy_variable_1 => chains/0037policy_variable_1}         | 0
 .../{nft-f/0028policy_variable_1 => chains/0038policy_variable_1}         | 0
 8 files changed, 0 insertions(+), 0 deletions(-)
 rename tests/shell/testcases/{nft-f/0021priority_variable_0 => chains/0031priority_variable_0} (100%)
 rename tests/shell/testcases/{nft-f/0022priority_variable_0 => chains/0032priority_variable_0} (100%)
 rename tests/shell/testcases/{nft-f/0023priority_variable_1 => chains/0033priority_variable_1} (100%)
 rename tests/shell/testcases/{nft-f/0024priority_variable_1 => chains/0034priority_variable_1} (100%)
 rename tests/shell/testcases/{nft-f/0025policy_variable_0 => chains/0035policy_variable_0} (100%)
 mode change 100644 => 100755
 rename tests/shell/testcases/{nft-f/0026policy_variable_0 => chains/0036policy_variable_0} (100%)
 mode change 100644 => 100755
 rename tests/shell/testcases/{nft-f/0027policy_variable_1 => chains/0037policy_variable_1} (100%)
 mode change 100644 => 100755
 rename tests/shell/testcases/{nft-f/0028policy_variable_1 => chains/0038policy_variable_1} (100%)
 mode change 100644 => 100755

diff --git a/tests/shell/testcases/nft-f/0021priority_variable_0 b/tests/shell/testcases/chains/0031priority_variable_0
similarity index 100%
rename from tests/shell/testcases/nft-f/0021priority_variable_0
rename to tests/shell/testcases/chains/0031priority_variable_0
diff --git a/tests/shell/testcases/nft-f/0022priority_variable_0 b/tests/shell/testcases/chains/0032priority_variable_0
similarity index 100%
rename from tests/shell/testcases/nft-f/0022priority_variable_0
rename to tests/shell/testcases/chains/0032priority_variable_0
diff --git a/tests/shell/testcases/nft-f/0023priority_variable_1 b/tests/shell/testcases/chains/0033priority_variable_1
similarity index 100%
rename from tests/shell/testcases/nft-f/0023priority_variable_1
rename to tests/shell/testcases/chains/0033priority_variable_1
diff --git a/tests/shell/testcases/nft-f/0024priority_variable_1 b/tests/shell/testcases/chains/0034priority_variable_1
similarity index 100%
rename from tests/shell/testcases/nft-f/0024priority_variable_1
rename to tests/shell/testcases/chains/0034priority_variable_1
diff --git a/tests/shell/testcases/nft-f/0025policy_variable_0 b/tests/shell/testcases/chains/0035policy_variable_0
old mode 100644
new mode 100755
similarity index 100%
rename from tests/shell/testcases/nft-f/0025policy_variable_0
rename to tests/shell/testcases/chains/0035policy_variable_0
diff --git a/tests/shell/testcases/nft-f/0026policy_variable_0 b/tests/shell/testcases/chains/0036policy_variable_0
old mode 100644
new mode 100755
similarity index 100%
rename from tests/shell/testcases/nft-f/0026policy_variable_0
rename to tests/shell/testcases/chains/0036policy_variable_0
diff --git a/tests/shell/testcases/nft-f/0027policy_variable_1 b/tests/shell/testcases/chains/0037policy_variable_1
old mode 100644
new mode 100755
similarity index 100%
rename from tests/shell/testcases/nft-f/0027policy_variable_1
rename to tests/shell/testcases/chains/0037policy_variable_1
diff --git a/tests/shell/testcases/nft-f/0028policy_variable_1 b/tests/shell/testcases/chains/0038policy_variable_1
old mode 100644
new mode 100755
similarity index 100%
rename from tests/shell/testcases/nft-f/0028policy_variable_1
rename to tests/shell/testcases/chains/0038policy_variable_1
-- 
2.11.0

