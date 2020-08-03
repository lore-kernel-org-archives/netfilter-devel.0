Return-Path: <SRS0=uIll=BN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DB4C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 14:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91AA206DA
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Aug 2020 14:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TlslAM3Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHCOGi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Aug 2020 10:06:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726785AbgHCOGi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 10:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596463595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+ElkyjY4n+vBHLfO0xe8KjbtObY8psU3knRD8dAUp28=;
        b=TlslAM3Ykuf6oln4iSwxAsdORss3ybejjGsI8U8qaywVfxR/5+CWpwic9vLbs4m+0dDy9S
        ZmPVz06BDCiApsxwsrH0s9beXAOS1BIYAoxgLqVgfgar3sjrr0Hd99/rFbv+LzAe/7up1W
        BxJZCXixW5rf7Vavr12GVTMWtuGxbQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-bRNJ5V7aNwae5Nh4EcDLvg-1; Mon, 03 Aug 2020 10:06:33 -0400
X-MC-Unique: bRNJ5V7aNwae5Nh4EcDLvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC61102C7ED;
        Mon,  3 Aug 2020 14:06:30 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F16B19C4F;
        Mon,  3 Aug 2020 14:06:28 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mike Dillinger <miked@softtalker.com>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nft v2] tests: 0044interval_overlap_0: Repeat insertion tests with timeout
Date:   Mon,  3 Aug 2020 16:06:21 +0200
Message-Id: <3154841e672db057d6b4a8428743a9202e87be5e.1596461315.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

As reported by Pablo, the test would fail if we keep a one-second
timeout if it runs on a "slow" kernel (e.g. with KASan), using the
libtool wrapper in src/nft as $NFT, because we can't issue 218
commands within one second. To avoid that, introduce an adaptive
timeout based on how many times we can list a single entry with a
fixed one-second timeout.

On a single 2.9GHz AMD Epyc 7351 thread:
                                     test run   nft commands/s  timeout
- src/nft libtool wrapper, KASan:       68.4s          10         32s
- nft binary, KASan:                     5.1s         168          2s
- src/nft libtool wrapper, w/o KASan:   18.3s          37          8s
- nft binary, w/o KASan:                 2.4s         719          1s

While at it, fix expectation for insertion of '15-20 . 50-60' (it's
expected to succeed, given the list), and the reason why I didn't
notice: a simple command preceded by ! won't actually result in
the shell exiting, even if it fails. Add some clearer failure reports
too.

v2:
  - adjust set timeouts to nft commands/s
  - fix checks on expected outcome of insertions and reports

Reported-by: Mike Dillinger <miked@softtalker.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0044interval_overlap_0     | 136 +++++++++++++++---
 1 file changed, 117 insertions(+), 19 deletions(-)

diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
index fad92ddcf356..face90f2e9ae 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_0
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -7,6 +7,20 @@
 #   existing one
 # - for concatenated ranges, the new element is less specific than any existing
 #   overlapping element, as elements are evaluated in order of insertion
+#
+# Then, repeat the test with a set configured with a timeout, checking that:
+# - we can insert all the elements as described above
+# - once the timeout has expired, we can insert all the elements again, and old
+#   elements are not present
+# - before the timeout expires again, we can re-add elements that are not
+#   expected to fail, but old elements might be present
+#
+# If $NFT points to a libtool wrapper, and we're running on a slow machine or
+# kernel (e.g. KASan enabled), it might not be possible to execute hundreds of
+# commands within an otherwise reasonable 1 second timeout. Estimate a usable
+# timeout first, by counting commands and measuring against one nft rule timeout
+# itself, so that we can keep this fast for a binary $NFT on a reasonably fast
+# kernel.
 
 #	Accept	Interval	List
 intervals_simple="
@@ -32,35 +46,119 @@ intervals_concat="
 	y	0-2 . 0-3	0-2 . 0-3
 	n	0-1 . 0-2	0-2 . 0-3
 	y	10-20 . 30-40	0-2 . 0-3, 10-20 . 30-40
-	n	15-20 . 50-60	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60
+	y	15-20 . 50-60	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60
 	y	3-9 . 4-29	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
 	y	3-9 . 4-29	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
 	n	11-19 . 30-40	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
 	y	15-20 . 49-61	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29, 15-20 . 49-61
 "
 
-$NFT add table t
-$NFT add set t s '{ type inet_service ; flags interval ; }'
-$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
+count_elements() {
+	pass=
+	interval=
+	elements=0
+	for t in ${intervals_simple} ${intervals_concat}; do
+		[ -z "${pass}" ]      && pass="${t}"     && continue
+		[ -z "${interval}" ]  && interval="${t}" && continue
+		unset IFS
+
+		elements=$((elements + 1))
 
-IFS='	
+		IFS='	
 '
-set="s"
-for t in ${intervals_simple} switch ${intervals_concat}; do
-	[ "${t}" = "switch" ] && set="c"         && continue
-	[ -z "${pass}" ]      && pass="${t}"     && continue
-	[ -z "${interval}" ]  && interval="${t}" && continue
-
-	if [ "${pass}" = "y" ]; then
-		$NFT add element t ${set} "{ ${interval} }"
-	else
-		! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
+	done
+	unset IFS
+}
+
+match_elements() {
+	skip=0
+	n=0
+	out=
+	for a in $($NFT list set t ${1})}; do
+		[ ${n} -eq 0 ] && { [ "${a}" = "elements" ] && n=1; continue; }
+		[ ${n} -eq 1 ] && { [ "${a}" = "=" ] 	    && n=2; continue; }
+		[ ${n} -eq 2 ] && { [ "${a}" = "{" ]	    && n=3; continue; }
+
+		[ "${a}" = "}" ]				 && break
+
+		[ ${skip} -eq 1 ] && skip=0 && out="${out},"	 && continue
+		[ "${a}" = "expires" ] && skip=1		 && continue
+
+		[ -n "${out}" ] && out="${out} ${a}" || out="${a}"
+
+	done
+
+	if [ "${out%,}" != "${2}" ]; then
+		echo "Expected: ${2}, got: ${out%,}"
+		return 1
 	fi
-	$NFT list set t ${set} | tr -d '\n\t' | tr -s ' ' | \
-		grep -q "elements = { ${t} }"
+}
+
+estimate_timeout() {
+	count_elements
 
+	$NFT add table t
+	$NFT add set t s '{ type inet_service ; flags timeout; timeout 1s; gc-interval 1s; }'
+	execs_1s=1
+	$NFT add element t s "{ 0 }"
+	while match_elements s "0" >/dev/null; do
+		execs_1s=$((execs_1s + 1))
+	done
+
+	timeout="$((elements / execs_1s * 3 / 2 + 1))"
+}
+
+add_elements() {
+	set="s"
 	pass=
 	interval=
-done
+	IFS='	
+'
+	for t in ${intervals_simple} switch ${intervals_concat}; do
+		[ "${t}" = "switch" ] && set="c"         && continue
+		[ -z "${pass}" ]      && pass="${t}"     && continue
+		[ -z "${interval}" ]  && interval="${t}" && continue
+		unset IFS
+
+		if [ "${pass}" = "y" ]; then
+			if ! $NFT add element t ${set} "{ ${interval} }"; then
+				echo "Failed to insert ${interval} given:"
+				$NFT list ruleset
+				exit 1
+			fi
+		else
+			if $NFT add element t ${set} "{ ${interval} }" 2>/dev/null; then
+				echo "Could insert ${interval} given:"
+				$NFT list ruleset
+				exit 1
+			fi
+		fi
+
+		[ "${1}" != "nomatch" ] && match_elements "${set}" "${t}"
+
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
+estimate_timeout
+
+$NFT flush ruleset
+$NFT add table t
+$NFT add set t s "{ type inet_service ; flags interval,timeout; timeout ${timeout}s; gc-interval ${timeout}s; }"
+$NFT add set t c "{ type inet_service . inet_service ; flags interval,timeout ; timeout ${timeout}s; gc-interval ${timeout}s; }"
+add_elements
+
+sleep $((timeout * 3 / 2))
+add_elements
 
-unset IFS
+add_elements nomatch
-- 
2.27.0

