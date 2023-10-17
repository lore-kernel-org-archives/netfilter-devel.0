Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7101CDB483
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 08:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbjJQIwj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjJQIwh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 04:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A0512F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 01:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697532706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWAhkw0rJ86pIH8jacqS5LVB537+a/TJxkJm3B5Qy2s=;
        b=TaC96wpp8hP/faCpfGdyf6hsOHaxAvEee2mnvG+OIjyeNLwXnoxbrVz36bXVrvKDNo+FMq
        Wf+8KMBVBCD3t4UWBuWpY+m16c1j5YTn2vQpOKBnLc6uXo1Ejmd1EVtFAoCHNPSHkXq1eR
        B7NsNTJ0+Qoxi+/rN8jV1VJezQXMIpo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-t8T7S_I8PUCsVzpBDqJU7A-1; Tue, 17 Oct 2023 04:51:45 -0400
X-MC-Unique: t8T7S_I8PUCsVzpBDqJU7A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05D2C1C0783A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 08:51:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C290492BEF;
        Tue, 17 Oct 2023 08:51:44 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/3] tests/shell: add "tests/shell/helpers/eval-exit-code"
Date:   Tue, 17 Oct 2023 10:49:06 +0200
Message-ID: <20231017085133.1203402-2-thaller@redhat.com>
In-Reply-To: <20231017085133.1203402-1-thaller@redhat.com>
References: <20231017085133.1203402-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This script is used to compare the running kernel version (`ulimit -r`)
against a list of versions, to find out whether a test should be skipped
or not.

If kernel has a bug, a test might not pass. In that case, the test
should exit with error code 77 as we also want to pass the test suite on
distro kernels. However, if we know that the bug was fixed in a certain
kernel version, then we the failure to be fatal and noticeable.

Example usage:

    if ! _check_some_condition ; then
        echo "The condition to check for kernel bug https://git.kernel.org/XYZ failed"
        "$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel 6.5.6 6.6
        exit $?
    fi

Note that "eval-exit-code" will always exit with a non-zero exit code. It will
also print a message about the comparison, which ends up in the test output.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/eval-exit-code | 116 +++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)
 create mode 100755 tests/shell/helpers/eval-exit-code

diff --git a/tests/shell/helpers/eval-exit-code b/tests/shell/helpers/eval-exit-code
new file mode 100755
index 000000000000..d007c0fc0fd6
--- /dev/null
+++ b/tests/shell/helpers/eval-exit-code
@@ -0,0 +1,116 @@
+#!/bin/bash -e
+
+die() {
+	printf "%s\n" "$*"
+	exit 2
+}
+
+usage() {
+	echo "usage: $0 [MODE] [ARGS...]"
+	echo ""
+	echo "Evaluates whether to exit a test with skip or failure reason."
+	echo ""
+	echo "The use case is for example a kernel bug, which prevents a test from passing. We"
+	echo "know that certain newer kernel versions have the fix, and we require the test to"
+	echo "pass there. When an assertion fails, The script will determine that the test should"
+	echo "have passed and exit with code \"1\". When running against an older kernel, the failure"
+	echo "is expected and the script exits with \"77\" to indicate a skip."
+	echo ""
+	echo "The script always either exits with:"
+	echo "  1: the check determined that we have a hard failure (a message is printed)"
+	echo "  77: the check determined that we skip (a message is printed)"
+	echo "  2: an error in the script happend (invalid arguments?)"
+	echo ""
+	echo "MODE can be one of:"
+	echo " \"kernel\": compares \`ulimit -r\` against the arguments. The arguments are"
+	echo "      kernel versions for which we expect to support the feature and when called"
+	echo "      on such a kernel, the script returns \"1\" to indicate a hard failure. Against"
+	echo "      older kernels, \"77\" is returned. Multiple kernel version can be provided for"
+	echo "      example \`$0 kernel 6.5.6 6.6\`."
+	echo ""
+	echo "USAGE:"
+	echo "    if ! _check_some_condition ; then"
+	echo "        echo \"The condition to check for kernel bug https://git.kernel.org/XYZ failed\""
+	echo "        \"\$NFT_TEST_BASEDIR/helpers/eval-exit-code\" kernel 6.5.6 6.6"
+	echo "        exit \$?"
+	echo "    fi"
+	exit 2
+}
+
+[ "$#" -eq 0 ] && usage
+
+_kernel_check_skip() {
+	local kversion="$1"
+	local compare="$2"
+
+	if [ "$kversion" = "$compare" ] ; then
+		return 1
+	fi
+	if [[ "$kversion" == "$compare"[.-]* ]] ; then
+		return 1
+	fi
+
+	local a1="$(printf '%s\n' 0 "$kversion" "$compare" 100000)"
+	local a2="$(printf '%s' "$a1" | sort -V)"
+
+	if [ "$a1" != "$a2" ] ; then
+		return 1
+	fi
+	return 0
+}
+
+_PRINT_ARG="???"
+
+eval_kernel() {
+	local compare
+	local kversion
+
+	if [ -n "$_EVAL_EXIT_CODE_UNAME" ] ; then
+		# Only for testing.
+		kversion="$_EVAL_EXIT_CODE_UNAME"
+	else
+		kversion="$(uname -r)" || die "uname -r failed"
+	fi
+
+	[ $# -ge 1 ] || die "Operation kernel expects one or more kernel versions to be compared with >= against $kversion"
+
+	_PRINT_ARG="$kversion"
+
+	local all_skip=1
+	for compare; do
+		_kernel_check_skip "$kversion" "$compare" || all_skip=0
+	done
+	if [ "$all_skip" -eq 1 ] ; then
+		return 77
+	fi
+	return 1
+}
+
+run_op() {
+	local mode="$1"
+	shift
+
+	rc=2
+	"eval_$mode" "$@" || rc=$?
+	if [ "$rc" -eq 77 ] ; then
+		echo "Checking \"$mode\" ($@) against $_PRINT_ARG indicates to skip the test"
+	else
+		echo "Checking \"$mode\" ($@) against $_PRINT_ARG indicates a hard failure"
+	fi
+	exit "$rc"
+}
+
+mode="$1"
+shift
+
+case "$mode" in
+	kernel)
+		run_op "$mode" "$@"
+		;;
+	-h|--help)
+		usage
+		;;
+	*)
+		die "Invalid mode \"$mode\". Try $0 --help"
+		;;
+esac
-- 
2.41.0

