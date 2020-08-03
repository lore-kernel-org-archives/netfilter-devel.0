Return-Path: <SRS0=uIll=BN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F07C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 14:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8FA206DA
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 14:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ae1filsw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgHCOGt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Aug 2020 10:06:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726785AbgHCOGt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 10:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596463608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+nErukrAL6b+3MTARVppWBFZ5zbrhuSn/CLte4HL6t8=;
        b=Ae1filswSKyCeqzO0lqrtr9zS6hhfDEHYtgruMPuttDmjMVH8S2fGpdh0EXonAr4ItVIEI
        /6TDihyVZrhKeauBrwYUEmYLss0mCK/84z6Y+99MdnyrXxDz8ES0XSbHwI+4btvyfuMeBX
        7zKn0ueYTK9fPBOV+zVOkeemMib/nQU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-2pvOWqXIPkS0UAaI86nrWQ-1; Mon, 03 Aug 2020 10:06:46 -0400
X-MC-Unique: 2pvOWqXIPkS0UAaI86nrWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65E94E91B;
        Mon,  3 Aug 2020 14:06:45 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F29971765;
        Mon,  3 Aug 2020 14:06:44 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: 0043concatenated_ranges_0: Fix checks for add/delete failures
Date:   Mon,  3 Aug 2020 16:06:39 +0200
Message-Id: <1201d76f21c3272d2e0db35326f3c64239f8a3dc.1596461357.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test won't stop if we simply precede commands expected to fail
by !. POSIX.1-2017 says:

  -e
      When this option is on, if a simple command fails for any of
      the reasons listed in Consequences of Shell Errors or returns
      an exit status value >0, and is not part of the compound list
      following a while, until or if keyword, and is not a part of
      an AND or OR list, and is not a pipeline preceded by the "!"
      reserved word, then the shell will immediately exit.

...but I didn't care about the last part.

Replace those '! nft ...' commands by 'nft ... && exit 1' to actually
detect failures.

As a result, I didn't notice that now, correctly, inserting elements
into a set that contains the same exact element doesn't actually
fail, because nft doesn't pass NLM_F_EXCL on a simple 'add'. Drop
re-insertions from the checks we perform here, overlapping elements
are already covered by other tests.

Fixes: 618393c6b3f2 ("tests: Introduce test for set with concatenated ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0043concatenated_ranges_0  | 27 +++++++------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 408040291aa8..11767373bcd2 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -6,11 +6,10 @@
 # all possible permutations, and:
 # - add entries to set
 # - list them
-# - check that they can't be added again
 # - get entries by specifying a value matching ranges for all fields
 # - delete them
+# - check that they can't be deleted again
 # - add them with 1s timeout
-# - check that they can't be added again right away
 # - check that they are not listed after 1s, just once, for the first entry
 # - delete them
 # - make sure they can't be deleted again
@@ -138,17 +137,11 @@ for ta in ${TYPES}; do
 				   -e "${a2} . ${b2} . ${c2}${mapv}"		\
 				   -e "${a3} . ${b3} . ${c3}${mapv}") -eq 3 ]
 
-			! ${NFT} "add element inet filter test \
-				  { ${a1} . ${b1} . ${c1}${mapv} };
-				  add element inet filter test \
-				  { ${a2} . ${b2} . ${c2}${mapv} };
-				  add element inet filter test \
-				  { ${a3} . ${b3} . ${c3}${mapv} }" 2>/dev/null
-
 			${NFT} delete element inet filter test \
 				"{ ${a1} . ${b1} . ${c1}${mapv} }"
-			! ${NFT} delete element inet filter test \
-				"{ ${a1} . ${b1} . ${c1}${mapv} }" 2>/dev/null
+			${NFT} delete element inet filter test \
+				"{ ${a1} . ${b1} . ${c1}${mapv} }" \
+				2>/dev/null && exit 1
 
 			eval add_a=\$ADD_${ta}
 			eval add_b=\$ADD_${tb}
@@ -157,9 +150,6 @@ for ta in ${TYPES}; do
 				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
 			[ $(${NFT} list ${setmap} inet filter test |	\
 			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
-			! ${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}" \
-				2>/dev/null
 
 			eval get_a=\$GET_${ta}
 			eval get_b=\$GET_${tb}
@@ -175,17 +165,18 @@ for ta in ${TYPES}; do
 				{ ${a2} . ${b2} . ${c2}${mapv} };
 				delete element inet filter test \
 				{ ${a3} . ${b3} . ${c3}${mapv} }"
-			! ${NFT} "delete element inet filter test \
+			${NFT} "delete element inet filter test \
 				  { ${a2} . ${b2} . ${c2}${mapv} };
 				  delete element inet filter test \
-				  { ${a3} . ${b3} . ${c3} ${mapv} }" 2>/dev/null
+				  { ${a3} . ${b3} . ${c3} ${mapv} }" \
+				  2>/dev/null && exit 1
 
 			if [ ${timeout_tested} -eq 1 ]; then
 				${NFT} delete element inet filter test \
 					"{ ${add_a} . ${add_b} . ${add_c} ${mapv} }"
-				! ${NFT} delete element inet filter test \
+				${NFT} delete element inet filter test \
 					"{ ${add_a} . ${add_b} . ${add_c} ${mapv} }" \
-					2>/dev/null
+					2>/dev/null && exit 1
 				continue
 			fi
 
-- 
2.27.0

