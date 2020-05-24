Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6287DC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2258E20776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KX//J4Uw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgEXNAG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25250 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgEXNAG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=amIRaCQJsifw59sAdCoNsH1Xquev8M0L1J8U8PCCSkU=;
        b=KX//J4UwAfpJsfF4+Evr/Qk56w3H0MTAmRIvmpQcBtlHNFtHkBOwaVeXGo2HpUYXG+MP+X
        59ybKQC7BASBNL0W8QayHlaMkIygu9XOlRHlR1EdfVy5agsztvqwP2IsnPfFj5rDanIYRl
        9ob3SWAf+MQRDu3OSaxh8FzYwqIduvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-LLkR7up6Nl2lskQjUC3OgA-1; Sun, 24 May 2020 09:00:02 -0400
X-MC-Unique: LLkR7up6Nl2lskQjUC3OgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E15FB1800D42;
        Sun, 24 May 2020 13:00:00 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C679E5C1B2;
        Sun, 24 May 2020 12:59:59 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: Avoid breaking basic connectivity when run
Date:   Sun, 24 May 2020 14:59:57 +0200
Message-Id: <9742365b595a791d4bd47abee6ad6271abe0950b.1590323912.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It might be convenient to run tests from a development branch that
resides on another host, and if we break connectivity on the test
host as tests are executed, we con't run them this way.

To preserve connectivity, for shell tests, we can simply use the
'forward' hook instead of 'input' in chains/0036_policy_variable_0
and transactions/0011_chain_0, without affecting test coverage.

For py tests, this is more complicated as some test cases install
chains for all the available hooks, and we would probably need a
more refined approach to avoid dropping relevant traffic, so I'm
not covering that right now.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/shell/testcases/chains/0036policy_variable_0       | 2 +-
 tests/shell/testcases/transactions/0011chain_0           | 2 +-
 tests/shell/testcases/transactions/dumps/0011chain_0.nft | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/shell/testcases/chains/0036policy_variable_0 b/tests/shell/testcases/chains/0036policy_variable_0
index d4d98ede0d8d..e9246dd9e974 100755
--- a/tests/shell/testcases/chains/0036policy_variable_0
+++ b/tests/shell/testcases/chains/0036policy_variable_0
@@ -9,7 +9,7 @@ define default_policy = \"drop\"
 
 table inet global {
     chain prerouting {
-        type filter hook prerouting priority filter
+        type filter hook forward priority filter
         policy \$default_policy
     }
 }"
diff --git a/tests/shell/testcases/transactions/0011chain_0 b/tests/shell/testcases/transactions/0011chain_0
index 3bed16dddf40..bdfa14975180 100755
--- a/tests/shell/testcases/transactions/0011chain_0
+++ b/tests/shell/testcases/transactions/0011chain_0
@@ -5,7 +5,7 @@ set -e
 RULESET="add table x
 add chain x y
 delete chain x y
-add chain x y { type filter hook input priority 0; }
+add chain x y { type filter hook forward priority 0; }
 add chain x y { policy drop; }"
 
 $NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/transactions/dumps/0011chain_0.nft b/tests/shell/testcases/transactions/dumps/0011chain_0.nft
index df88ad47c5d9..a12726069efc 100644
--- a/tests/shell/testcases/transactions/dumps/0011chain_0.nft
+++ b/tests/shell/testcases/transactions/dumps/0011chain_0.nft
@@ -1,5 +1,5 @@
 table ip x {
 	chain y {
-		type filter hook input priority filter; policy drop;
+		type filter hook forward priority filter; policy drop;
 	}
 }
-- 
2.26.2

