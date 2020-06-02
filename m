Return-Path: <SRS0=DvnY=7P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AC3C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 23:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54AD32072F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 23:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxg5nfCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBXvd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:51:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56529 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726589AbgFBXvc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 19:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591141891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l+mb2V/isa/qLkWFZHbRQ2FLM5Ztvu+ixS3M1koeaHM=;
        b=bxg5nfCc+MXjz1sgMYHRLT1q1wr4fehwphSm5c1bHWjjTAew2UYqNJbmkn/PXHBp+pgszR
        8jnDc5/KuL/AvNyEFseOE5+6ax/vIp/2U8NjFQEvro2NvYMzYG2JAVOQQHYUT49SLncJGF
        lDPOFdIMoVD4ZvjiIpWG/h6D/I3uZWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-gfktLlVfOHWeAus7PXyrnw-1; Tue, 02 Jun 2020 19:51:27 -0400
X-MC-Unique: gfktLlVfOHWeAus7PXyrnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D2F61B18BCA;
        Tue,  2 Jun 2020 23:51:26 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B7C861984;
        Tue,  2 Jun 2020 23:51:25 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mike Dillinger <miked@softtalker.com>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: 0044interval_overlap_0: Repeat insertion tests with timeout
Date:   Wed,  3 Jun 2020 01:51:20 +0200
Message-Id: <99aaa1c20475b24ce52d767d1104a7ad64c00350.1591141568.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mike Dillinger reported issues with insertion of entries into sets
supporting intervals that were denied because of false conflicts with
elements that were already expired. Partial failures would occur to,
leading to the generation of new intervals the user didn't specify,
as only the opening or the closing elements wouldn't be inserted.

The reproducer provided by Mike looks like this:

  #!/bin/bash
  nft list set ip filter blacklist4-ip-1m
  for ((i=1;i<=10;i++)); do
        nft add element filter blacklist4-ip-1m {$i.$i.$i.$i}
        sleep 1
  done
  nft list set ip filter blacklist4-ip-1m

which, run in a loop at different intervals, show the different kind
of failures.

Extend the existing test case for overlapping and non-overlapping
intervals to systematically cover sets with a configured timeout.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0044interval_overlap_0     | 81 ++++++++++++++-----
 1 file changed, 61 insertions(+), 20 deletions(-)

diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
index fad92ddcf356..16f661a00116 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_0
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -7,6 +7,13 @@
 #   existing one
 # - for concatenated ranges, the new element is less specific than any existing
 #   overlapping element, as elements are evaluated in order of insertion
+#
+# Then, repeat the test with a set configured for 1s timeout, checking that:
+# - we can insert all the elements as described above
+# - once the timeout has expired, we can insert all the elements again, and old
+#   elements are not present
+# - before the timeout expires again, we can re-add elements that are not
+#   expected to fail, but old elements might be present
 
 #	Accept	Interval	List
 intervals_simple="
@@ -39,28 +46,62 @@ intervals_concat="
 	y	15-20 . 49-61	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29, 15-20 . 49-61
 "
 
-$NFT add table t
-$NFT add set t s '{ type inet_service ; flags interval ; }'
-$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
+match_elements() {
+	skip=0
+	n=0
+	out=
+	for a in $($NFT list set t ${1})}; do
+		[ ${n} -eq 0 ] && [ "${a}" = "elements" ] && n=1
+		[ ${n} -eq 1 ] && [ "${a}" = "=" ]	  && n=2
+		[ ${n} -eq 2 ] && [ "${a}" = "{" ]	  && n=3 && continue
+		[ ${n} -lt 3 ] 					 && continue
+
+		[ "${a}" = "}" ]				 && break
+
+		[ ${skip} -eq 1 ] && skip=0 && out="${out},"	 && continue
+		[ "${a}" = "expires" ] && skip=1		 && continue
+
+		[ -n "${out}" ] && out="${out} ${a}" || out="${a}"
+	done
+	[ "${out%,}" = "${2}" ]
+}
 
-IFS='	
+add_elements() {
+	set="s"
+	IFS='	
 '
-set="s"
-for t in ${intervals_simple} switch ${intervals_concat}; do
-	[ "${t}" = "switch" ] && set="c"         && continue
-	[ -z "${pass}" ]      && pass="${t}"     && continue
-	[ -z "${interval}" ]  && interval="${t}" && continue
+	for t in ${intervals_simple} switch ${intervals_concat}; do
+		unset IFS
+		[ "${t}" = "switch" ] && set="c"         && continue
+		[ -z "${pass}" ]      && pass="${t}"     && continue
+		[ -z "${interval}" ]  && interval="${t}" && continue
 
-	if [ "${pass}" = "y" ]; then
-		$NFT add element t ${set} "{ ${interval} }"
-	else
-		! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
-	fi
-	$NFT list set t ${set} | tr -d '\n\t' | tr -s ' ' | \
-		grep -q "elements = { ${t} }"
+		if [ "${pass}" = "y" ]; then
+			$NFT add element t ${set} "{ ${interval} }"
+		else
+			! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
+		fi
 
-	pass=
-	interval=
-done
+		[ "${1}" != "nomatch" ] && match_elements "${set}" "${t}"
 
-unset IFS
+		pass=
+		interval=
+		IFS='	
+'
+	done
+	unset IFS
+}
+
+$NFT add table t
+$NFT add set t s '{ type inet_service ; flags interval ; }'
+$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
+add_elements
+
+$NFT flush ruleset
+$NFT add table t
+$NFT add set t s '{ type inet_service ; flags interval,timeout; timeout 1s; gc-interval 1s; }'
+$NFT add set t c '{ type inet_service . inet_service ; flags interval,timeout ; timeout 1s; gc-interval 1s; }'
+add_elements
+sleep 1
+add_elements
+add_elements nomatch
-- 
2.26.2

