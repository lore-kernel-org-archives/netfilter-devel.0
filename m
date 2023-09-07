Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BE6EB8FB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjIGWJy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjIGWJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0B1BC9
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p42J59YFB1q7R4cqDRkoV31TIvR4OX+3ZsNaguGhBug=;
        b=FTVZtiDsRyw5mr3gK8bgVAZ8jZv4bnuSXfuG5G7BlW4V2Yx9LWRVvJm6YLY7nJhNcff45p
        cf/aJWhlu8Brl/SHV2SEYuntDsYUMbiceG+ZxFuXsZRfU/36ojXgbBtwxtKQu9eoDWvXF9
        Lf3KiVqkHg3Tzl5ZgXaIFVMl6d3V9A0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-JWlHeQ0NNOCjXwT8DxJYQw-1; Thu, 07 Sep 2023 18:08:47 -0400
X-MC-Unique: JWlHeQ0NNOCjXwT8DxJYQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C75308007CE
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 412377B62;
        Thu,  7 Sep 2023 22:08:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 03/11] tests/shell: colorize terminal output with test result
Date:   Fri,  8 Sep 2023 00:07:15 +0200
Message-ID: <20230907220833.2435010-4-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Colors help to see what is important.

It honors the common NO_COLOR=<anything> to disable coloring. It also
does not colorize, if [ -t 1 ] indicates that stdout is not a terminal.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 71 ++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index e0adb27ad104..c8688587bbc4 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,15 +1,26 @@
 #!/bin/bash
 
+GREEN=""
+YELLOW=""
+RED=""
+RESET=""
+if [[ -t 1 && -z "$NO_COLOR" ]] ; then
+	GREEN=$'\e[32m'
+	YELLOW=$'\e[33m'
+	RED=$'\e[31m'
+	RESET=$'\e[0m'
+fi
+
 _msg() {
 	local level="$1"
 	shift
-	local msg
 
-	msg="$level: $*"
-	if [ "$level" = E -o "$level" = W ] ; then
-		printf '%s\n' "$msg" >&2
+	if [ "$level" = E ] ; then
+		printf '%s\n' "$RED$level$RESET: $*" >&2
+	elif [ "$level" = W ] ; then
+		printf '%s\n' "$YELLOW$level$RESET: $*" >&2
 	else
-		printf '%s\n' "$msg"
+		printf '%s\n' "$level: $*"
 	fi
 	if [ "$level" = E ] ; then
 		exit 1
@@ -28,6 +39,39 @@ msg_info() {
 	_msg I "$@"
 }
 
+align_text() {
+	local _OUT_VARNAME="$1"
+	local _LEFT_OR_RIGHT="$2"
+	local _INDENT="$3"
+	shift 3
+	local _text="$*"
+	local _text_plain
+	local _text_align
+	local _text_result
+	local _i
+
+	# This function is needed, because "$text" might contain color escape
+	# sequences. A plain `printf '%12s' "$text"` will not align properly.
+
+	# strip escape sequences
+	_text_plain="${_text//$'\e['[0-9]m/}"
+	_text_plain="${_text_plain//$'\e['[0-9][0-9]m/}"
+
+	_text_align=""
+	for (( _i = "${#_text_plain}" ; "$_i" < "$_INDENT" ; _i++ )) ; do
+		_text_align="$_text_align "
+	done
+
+	if [ "$_LEFT_OR_RIGHT" = left ] ; then
+		_text_result="$(printf "%s$_text_align-" "$_text")"
+	else
+		_text_result="$(printf "$_text_align%s-" "$_text")"
+	fi
+	_text_result="${_text_result%-}"
+
+	eval "$_OUT_VARNAME=\"\$_text_result\""
+}
+
 bool_n() {
 	case "$1" in
 		n|N|no|No|NO|0|false|False|FALSE)
@@ -459,8 +503,7 @@ print_test_header() {
 	local suffix="$4"
 	local text
 
-	text="[$status]"
-	text="$(printf '%-12s' "$text")"
+	align_text text left 12 "[$status]"
 	_msg "$msglevel" "$text $testfile${suffix:+: $suffix}"
 }
 
@@ -477,10 +520,10 @@ print_test_result() {
 
 	if [ "$rc_got" -eq 0 ] ; then
 		((ok++))
-		result_msg_status="OK"
+		result_msg_status="${GREEN}OK$RESET"
 	elif [ "$rc_got" -eq 77 ] ; then
 		((skipped++))
-		result_msg_status="SKIPPED"
+		result_msg_status="${YELLOW}SKIPPED$RESET"
 	else
 		((failed++))
 		result_msg_level="W"
@@ -492,6 +535,7 @@ print_test_result() {
 			result_msg_status="FAILED"
 			result_msg_suffix="got $rc_got"
 		fi
+		result_msg_status="$RED$result_msg_status$RESET"
 		result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" )
 	fi
 
@@ -578,7 +622,14 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-msg_info "results: [OK] $ok [SKIPPED] $skipped [FAILED] $failed [TOTAL] $((ok+skipped+failed))"
+if [ "$failed" -gt 0 ] ; then
+	RR="$RED"
+elif [ "$skipped" -gt 0 ] ; then
+	RR="$YELLOW"
+else
+	RR="$GREEN"
+fi
+msg_info "${RR}results$RESET: [OK] $GREEN$ok$RESET [SKIPPED] $YELLOW$skipped$RESET [FAILED] $RED$failed$RESET [TOTAL] $((ok+skipped+failed))"
 
 kernel_cleanup
 
-- 
2.41.0

