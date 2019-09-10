Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4090C4740A
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B7DD208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfIJNnd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfIJNnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:43:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCBF8E8B1A;
        Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 256E85C207;
        Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 2/3] tests: shell: add huge JSON transaction
Date:   Tue, 10 Sep 2019 09:43:27 -0400
Message-Id: <20190910134328.11535-2-eric@garver.life>
In-Reply-To: <20190910134328.11535-1-eric@garver.life>
References: <20190910134328.11535-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expand the test case to also check for returned rule handles in the JSON
output.

Signed-off-by: Eric Garver <eric@garver.life>
---
 tests/shell/testcases/transactions/0049huge_0 | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/testcases/transactions/0049huge_0
index 2791249512b6..f029ee3c54d7 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -13,3 +13,19 @@ for ((i = 0; i < ${RULE_COUNT}; i++)); do
 done
 )
 test $($NFT -e -a -f - <<< "$RULESET" |grep "#[ ]\+handle[ ]\+[0-9]\+" |wc -l) -eq ${RULE_COUNT} || exit 1
+
+# same thing, but with JSON rules
+#
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+
+RULESET=$(
+echo '{"nftables": ['
+for ((i = 0; i < $((${RULE_COUNT} - 1)); i++)); do
+	echo '{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "expr": [{"accept": null}], "comment": "rule'$i'"}}},'
+done
+	echo '{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "expr": [{"accept": null}], "comment": "rule'$((${RULE_COUNT} - 1))'"}}}'
+echo ']}'
+)
+test $($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\)/\n\1/g' |grep '"handle"' |wc -l) -eq ${RULE_COUNT} || exit 1
-- 
2.20.1

