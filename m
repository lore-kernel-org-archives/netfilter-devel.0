Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37FFC11D24
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 02:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B37F208C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 02:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfjzVSZx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgBUCFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 21:05:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728992AbgBUCFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 21:05:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582250721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDfm4ckYp8Tl1n3ZgU2lnIr9uy+DIZUf+1lgFQTZ1o0=;
        b=XfjzVSZxAUdrBr6FJGIv4GrcLppcroo0EbCbg/PrMYtBid8nD9u1jqmQijO6Np80j11ovJ
        d7x5cmPAm6YPzhbXbLWeX93+YHoJRQFlwK0G+jCADZu/vTUYW3res8CXsUnTKUocneKgrO
        3+zy5KkDZpHxJ7Ye4o97mgs6GfswoJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-67UbIRgDOJizuv2JlKENWg-1; Thu, 20 Feb 2020 21:05:17 -0500
X-MC-Unique: 67UbIRgDOJizuv2JlKENWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96CE107ACC9;
        Fri, 21 Feb 2020 02:05:16 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8353260C87;
        Fri, 21 Feb 2020 02:05:15 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf 2/2] selftests: nft_concat_range: Add test for reported add/flush/add issue
Date:   Fri, 21 Feb 2020 03:04:22 +0100
Message-Id: <e436a4071322d80b2b858d75fdf127f5126d7cd9.1582250437.git.sbrivio@redhat.com>
In-Reply-To: <cover.1582250437.git.sbrivio@redhat.com>
References: <cover.1582250437.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a specific test for the crash reported by Phil Sutter and addressed
in the previous patch. The test cases that, in my intention, should
have covered these cases, that is, the ones from the 'concurrency'
section, don't run these sequences tightly enough and spectacularly
failed to catch this.

While at it, define a convenient way to add these kind of tests, by
adding a "reported issues" test section.

It's more convenient, for this particular test, to execute the set
setup in its own function. However, future test cases like this one
might need to call setup functions, and will typically need no tools
other than nft, so allow for this in check_tools().

The original form of the reproducer used here was provided by Phil.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../selftests/netfilter/nft_concat_range.sh   | 43 +++++++++++++++++--
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tool=
s/testing/selftests/netfilter/nft_concat_range.sh
index aca21dde102a..dc810e32c59e 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -13,11 +13,12 @@
 KSELFTEST_SKIP=3D4
=20
 # Available test groups:
+# - reported_issues: check for issues that were reported in the past
 # - correctness: check that packets match given entries, and only those
 # - concurrency: attempt races between insertion, deletion and lookup
 # - timeout: check that packets match entries until they expire
 # - performance: estimate matching rate, compare with rbtree and hash ba=
selines
-TESTS=3D"correctness concurrency timeout"
+TESTS=3D"reported_issues correctness concurrency timeout"
 [ "${quicktest}" !=3D "1" ] && TESTS=3D"${TESTS} performance"
=20
 # Set types, defined by TYPE_ variables below
@@ -25,6 +26,9 @@ TYPES=3D"net_port port_net net6_port port_proto net6_po=
rt_mac net6_port_mac_proto
        net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_po=
rt
        net_port_mac_proto_net"
=20
+# Reported bugs, also described by TYPE_ variables below
+BUGS=3D"flush_remove_add"
+
 # List of possible paths to pktgen script from kernel tree for performan=
ce tests
 PKTGEN_SCRIPT_PATHS=3D"
 	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -327,6 +331,12 @@ flood_spec	ip daddr . tcp dport . meta l4proto . ip =
saddr
 perf_duration	0
 "
=20
+# Definition of tests for bugs reported in the past:
+# display	display text for test report
+TYPE_flush_remove_add=3D"
+display		Add two elements, flush, re-add
+"
+
 # Set template for all tests, types and rules are filled in depending on=
 test
 set_template=3D'
 flush ruleset
@@ -440,6 +450,8 @@ setup_set() {
=20
 # Check that at least one of the needed tools is available
 check_tools() {
+	[ -z "${tools}" ] && return 0
+
 	__tools=3D
 	for tool in ${tools}; do
 		if [ "${tool}" =3D "nc" ] && [ "${proto}" =3D "udp6" ] && \
@@ -1430,6 +1442,23 @@ test_performance() {
 	kill "${perf_pid}"
 }
=20
+test_bug_flush_remove_add() {
+	set_cmd=3D'{ set s { type ipv4_addr . inet_service; flags interval; }; =
}'
+	elem1=3D'{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
+	elem2=3D'{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
+	for i in `seq 1 100`; do
+		nft add table t ${set_cmd}	|| return ${KSELFTEST_SKIP}
+		nft add element t s ${elem1}	2>/dev/null || return 1
+		nft flush set t s		2>/dev/null || return 1
+		nft add element t s ${elem2}	2>/dev/null || return 1
+	done
+	nft flush ruleset
+}
+
+test_reported_issues() {
+	eval test_bug_"${subtest}"
+}
+
 # Run everything in a separate network namespace
 [ "${1}" !=3D "run" ] && { unshare -n "${0}" run; exit $?; }
 tmp=3D"$(mktemp)"
@@ -1438,9 +1467,15 @@ trap cleanup EXIT
 # Entry point for test runs
 passed=3D0
 for name in ${TESTS}; do
-	printf "TEST: %s\n" "${name}"
-	for type in ${TYPES}; do
-		eval desc=3D\$TYPE_"${type}"
+	printf "TEST: %s\n" "$(echo ${name} | tr '_' ' ')"
+	if [ "${name}" =3D "reported_issues" ]; then
+		SUBTESTS=3D"${BUGS}"
+	else
+		SUBTESTS=3D"${TYPES}"
+	fi
+
+	for subtest in ${SUBTESTS}; do
+		eval desc=3D\$TYPE_"${subtest}"
 		IFS=3D'
 '
 		for __line in ${desc}; do
--=20
2.25.0

