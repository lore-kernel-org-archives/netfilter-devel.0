Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2A8C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9BF20863
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbfIJNnc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732122AbfIJNnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:43:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0A0818CB90D;
        Tue, 10 Sep 2019 13:43:31 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3817F5C21E;
        Tue, 10 Sep 2019 13:43:31 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 1/3] tests: shell: verify huge transaction returns expected number of rules
Date:   Tue, 10 Sep 2019 09:43:26 -0400
Message-Id: <20190910134328.11535-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verify that we get the expected number of rules with --echo (i.e. the
reply wasn't truncated).

Signed-off-by: Eric Garver <eric@garver.life>
---
 tests/shell/testcases/transactions/0049huge_0 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/testcases/transactions/0049huge_0
index 12338087c63e..2791249512b6 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -6,9 +6,10 @@ $NFT flush ruleset
 $NFT add table inet test
 $NFT add chain inet test c
 
+RULE_COUNT=3000
 RULESET=$(
-for ((i = 0; i < 3000; i++)); do
+for ((i = 0; i < ${RULE_COUNT}; i++)); do
 	echo "add rule inet test c accept comment rule$i"
 done
 )
-$NFT -e -f - <<< "$RULESET" >/dev/null
+test $($NFT -e -a -f - <<< "$RULESET" |grep "#[ ]\+handle[ ]\+[0-9]\+" |wc -l) -eq ${RULE_COUNT} || exit 1
-- 
2.20.1

