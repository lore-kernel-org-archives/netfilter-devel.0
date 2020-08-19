Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040AFC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 22:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2EC2078D
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 22:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pl5cu4JM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHSWAk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 18:00:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHSWAj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 18:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597874438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aa16Dob3UKsYXcNy1TDw8/Lwx6mMR2YoFH5nBUurNG8=;
        b=Pl5cu4JMO1N3ZkPZklCGKR9/F9anHQwMmiScC6NLi3nv5u4V9qcj6xGX9x9xreNnbLf1zu
        5ZA0SYrpIqT5qHK8Vo+AusXgrScdg/0QXWS2wdfw1Y/8R1Pnvr+ulA3FKvMHrrhWzxc58Z
        jYfKiizUKjiK1FN0XM0Zm2f0CBYYVs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-z-78fNU5MNaZQHq4oE_2ww-1; Wed, 19 Aug 2020 18:00:31 -0400
X-MC-Unique: z-78fNU5MNaZQHq4oE_2ww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 966051005E65;
        Wed, 19 Aug 2020 22:00:30 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8684F1014171;
        Wed, 19 Aug 2020 22:00:29 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Andreas Fischer <netfilter@d9c.eu>
Subject: [PATCH nft] tests: sets: Check rbtree overlap detection after tree rotations
Date:   Thu, 20 Aug 2020 00:00:18 +0200
Message-Id: <d314b0680aa7dcbddebcf768a335db67ef6c33dd.1597873284.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ticket https://bugzilla.netfilter.org/show_bug.cgi?id=1449 showed
an issue with rbtree overlap detection coming from the fact that,
after tree rotations performed as part of tree rebalancing, caused
by deletions, end elements are not necessarily descendants of their
corresponding start elements.

Add single-sized elements, delete every second one of them, and
re-add them (they will always be full overlaps) in order to check
overlap detection after tree rotations.

Port indices used in the sets are pseudo-random numbers generated
with Marsaglia's Xorshift algorithm with triplet (5, 3, 1), chosen
for k-distribution over 16-bit periods, which gives a good
statistical randomness and forces 201 rebalancing operations out of
250 deletions with the chosen seed (1).

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0044interval_overlap_1     | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0044interval_overlap_1

diff --git a/tests/shell/testcases/sets/0044interval_overlap_1 b/tests/shell/testcases/sets/0044interval_overlap_1
new file mode 100755
index 000000000000..eeea1943ee55
--- /dev/null
+++ b/tests/shell/testcases/sets/0044interval_overlap_1
@@ -0,0 +1,36 @@
+#!/bin/sh -e
+#
+# 0044interval_overlap_1 - Single-sized intervals can never overlap partially
+#
+# Check that inserting, deleting, and inserting single-sized intervals again
+# never leads to a partial overlap. Specifically trigger rbtree rebalancing in
+# the process, to ensure different tree shapes of equivalent sets don't lead to
+# false positives, by deleting every second inserted item.
+
+xorshift() {
+	# Adaptation of Xorshift algorithm from:
+	#   Marsaglia, G. (2003). Xorshift RNGs.
+	#   Journal of Statistical Software, 8(14), 1 - 6.
+	#   doi:http://dx.doi.org/10.18637/jss.v008.i14
+	# with triplet (5, 3, 1), suitable for 16-bit ranges.
+
+	: $((port ^= port << 5))
+	: $((port ^= port >> 3))
+	: $((port ^= port << 1))
+}
+
+$NFT add table t
+$NFT add set t s '{ type inet_service ; flags interval ; }'
+
+for op in add delete add; do
+	port=1
+	skip=0
+	for i in $(seq 1 500); do
+		xorshift
+		if [ "${op}" = "delete" ]; then
+			[ ${skip} -eq 0 ] && skip=1 && continue
+			skip=0
+		fi
+		$NFT ${op} element t s "{ { $((port % 32768 + 32768)) } }"
+	done
+done
-- 
2.28.0

