Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF444E92FFB
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Oct 2023 09:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjJFJoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Oct 2023 05:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjJFJoK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2023 05:44:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FE5BE
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 02:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696585403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppKJ8BojkAk7QeOEmq+k75zKV1DUB0JgxK9nS9unI50=;
        b=f4oQrMpnjbde4H3irTJK8bN0THLFliKewxdg0zW6aGuT187iCcCVrT1vGBzlLOdWTwLFAF
        RFZk+fHQiemW9w+zLzozswsS5LRhLKp/rnY60ytZf9LVaK/stsiBk51ByeH+nXEiSwFUQx
        LprOZll7nWHrG3/9Dtm1qY3Oyz1P75Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-4HooiBEFOumiW7bbGYr-5A-1; Fri, 06 Oct 2023 05:43:22 -0400
X-MC-Unique: 4HooiBEFOumiW7bbGYr-5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC0EB1DD35D3
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 09:43:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 937B2215670B;
        Fri,  6 Oct 2023 09:43:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 3/3] tests/shell: add "-S|--setup-host" option to set sysctl for rootless tests
Date:   Fri,  6 Oct 2023 11:42:20 +0200
Message-ID: <20231006094226.711628-3-thaller@redhat.com>
In-Reply-To: <20231006094226.711628-1-thaller@redhat.com>
References: <20231006094226.711628-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most tests can run just fine without root. A few of them will fail if
/proc/sys/net/core/{wmem_max,rmem_max} is too small (as it is by default
on the host).

The easy workaround is to bump those limits once. This has to be
repeated after each reboot.

Doing that manually (every time) is cumbersome. Add a "--setup-host"
option for that.

Usage:

  $ sudo ./tests/shell/run-tests.sh -S
  Setting up host for running as rootless (requires root).
      echo 4096000 > /proc/sys/net/core/rmem_max (previous value 100000)
      echo 4096000 > /proc/sys/net/core/wmem_max (previous value 100000)

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 7672b2fe5074..22105c2e90e2 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -166,6 +166,9 @@ usage() {
 	echo " -s|--sequential : Sets NFT_TEST_JOBS=0, which also enables global cleanups."
 	echo "                   Also sets NFT_TEST_SHUFFLE_TESTS=n if left unspecified."
 	echo " -Q|--quick      : Sets NFT_TEST_SKIP_slow=y."
+	echo " -S|--setup-host : Modify the host to run as rootless. Otherwise, some tests will be"
+	echo "                   skipped. Basically, this bumps /proc/sys/net/core/{wmem_max,rmem_max}."
+	echo "                   Must run as root and this option must be specified alone."
 	echo " --              : Separate options from tests."
 	echo " [TESTS...]      : Other options are treated as test names,"
 	echo "                   that is, executables that are run by the runner."
@@ -302,10 +305,25 @@ export NFT_TEST_RANDOM_SEED
 
 TESTS=()
 
+SETUP_HOST=
+SETUP_HOST_OTHER=
+
+ARGV_ORIG=( "$@" )
+
 while [ $# -gt 0 ] ; do
 	A="$1"
 	shift
 	case "$A" in
+		-S|--setup-host)
+			;;
+		*)
+			SETUP_HOST_OTHER=y
+			;;
+	esac
+	case "$A" in
+		-S|--setup-host)
+			SETUP_HOST="$A"
+			;;
 		-v)
 			VERBOSE=y
 			;;
@@ -353,6 +371,34 @@ while [ $# -gt 0 ] ; do
 	esac
 done
 
+sysctl_bump() {
+	local sysctl="$1"
+	local val="$2"
+	local cur;
+
+	cur="$(cat "$sysctl" 2>/dev/null)" || :
+	if [ -n "$cur" -a "$cur" -ge "$val" ] ; then
+		echo "# Skip: echo $val > $sysctl (current value $cur)"
+		return 0
+	fi
+	echo "    echo $val > $sysctl (previous value $cur)"
+	echo "$val" > "$sysctl"
+}
+
+setup_host() {
+	echo "Setting up host for running as rootless (requires root)."
+	sysctl_bump /proc/sys/net/core/rmem_max $((4000*1024)) || return $?
+	sysctl_bump /proc/sys/net/core/wmem_max $((4000*1024)) || return $?
+}
+
+if [ -n "$SETUP_HOST" ] ; then
+	if [ "$SETUP_HOST_OTHER" = y ] ; then
+		msg_error "The $SETUP_HOST option must be specified alone."
+	fi
+	setup_host
+	exit $?
+fi
+
 find_tests() {
 	find "$1" -type f -executable | sort
 }
-- 
2.41.0

