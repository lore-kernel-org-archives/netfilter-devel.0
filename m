Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E18B14B950
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750596968; cv=none; b=ET6c/VtFaUK5Yn/Qo61swkDzhDpbGg8lUq7lajyyuufLelySvt8umorcFMJWIfbQbOik/z4QFcxD40Cksj2S2DQC2mp8KqETg0FE+dLj5sdMEbdX4tNd80fujM/gc3MaV3bIvjrbqjsf5pnsAXvH9YaTGUPv1MlUmYIXtZD2muI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750596968; c=relaxed/simple;
	bh=boEPEVQHlqogKrVcLlx7HeH3skMf0lp1OcyhVcU2C04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i930m6Qlid0R3a5eM+5z2Z596mzq/jXufAfZh74k8moNDsrJuAQdZlBdUDZLkzIBtLAerxczw7+Q9pibOn6EG27HBEuTb24cIOpSIuQXThtMaw2g32YPf8jqT2KGk9MKOPx7uXGLaRTJuoN5drh9yVIMntY8W7EvXq+EUJTwDCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h48F7hFw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h48F7hFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750596964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7zFSNYjxNoDH/+vWLiHutTeKisBf/Nhi/K3SdozFSLI=;
	b=h48F7hFwmt2ZqRZH7KE5ZDOiFqrKoMfFCRePPfGY7RFwCSCTpyf/l2g5eT+XACOQ5iadi4
	rsevee9h+eI539azix18J5ewDlME4aaII4ot+TZBzoNDSwq8ragZSH19HhmUBQS8E3/yUc
	1QMIZJl+QLYb9TJGAwq3afORxGBNE9Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-EyDK8JZzNpaJhsj69dbSdQ-1; Sun,
 22 Jun 2025 08:56:03 -0400
X-MC-Unique: EyDK8JZzNpaJhsj69dbSdQ-1
X-Mimecast-MFC-AGG-ID: EyDK8JZzNpaJhsj69dbSdQ_1750596962
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AE541800289;
	Sun, 22 Jun 2025 12:56:02 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0BC5180045B;
	Sun, 22 Jun 2025 12:56:00 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 2/4] test: shell: Introduce $NFT_TEST_LIBRARY_FILE, helper/lib.sh
Date: Sun, 22 Jun 2025 20:55:52 +0800
Message-ID: <20250622125554.4960-2-yiche@redhat.com>
In-Reply-To: <20250622125554.4960-1-yiche@redhat.com>
References: <20250622125554.4960-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Consolidate frequently used functions in helper/lib.sh
switch nat_ftp and flowtables to use it.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/helpers/lib.sh                  | 30 +++++++++++++++++++++
 tests/shell/helpers/test-wrapper.sh         |  1 +
 tests/shell/testcases/packetpath/flowtables | 27 ++++---------------
 tests/shell/testcases/packetpath/nat_ftp    | 24 +++++++----------
 4 files changed, 45 insertions(+), 37 deletions(-)
 create mode 100755 tests/shell/helpers/lib.sh

diff --git a/tests/shell/helpers/lib.sh b/tests/shell/helpers/lib.sh
new file mode 100755
index 00000000..d2d20984
--- /dev/null
+++ b/tests/shell/helpers/lib.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+# contains utility functions commonly used in tests.
+
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]; then
+		echo "FAIL: ${@}"
+		if type -t assert_failout; then
+			assert_failout
+		fi
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+assert_fail()
+{
+	local ret=$?
+	if [ $ret == 0 ]; then
+		echo "FAIL: ${@}"
+		if type -t assert_failout; then
+			assert_failout
+		fi
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 4a7e8b7b..6ec4e030 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -36,6 +36,7 @@ TESTDIR="$(dirname "$TEST")"
 START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
 export TMPDIR="$NFT_TEST_TESTTMPDIR"
+export NFT_TEST_LIBRARY_FILE="$NFT_TEST_BASEDIR/helpers/lib.sh"
 
 CLEANUP_UMOUNT_VAR_RUN=n
 
diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index ab11431f..f3580a5f 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -3,6 +3,8 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 
+. $NFT_TEST_LIBRARY_FILE
+
 rnd=$(mktemp -u XXXXXXXX)
 R="flowtable-router-$rnd"
 C="flowtable-client-$rnd"
@@ -17,29 +19,10 @@ cleanup()
 }
 trap cleanup EXIT
 
-assert_pass()
-{
-	local ret=$?
-	if [ $ret != 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R cat /proc/net/nf_conntrack
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
-}
-assert_fail()
+# Call back when assertion fails.
+assert_failout()
 {
-	local ret=$?
-	if [ $ret == 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R cat /proc/net/nf_conntrack
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
+	ip netns exec $R cat /proc/net/nf_conntrack
 }
 
 ip netns add $R
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index 738bcb98..37ef14a3 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -4,6 +4,8 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
 
+. $NFT_TEST_LIBRARY_FILE
+
 cleanup()
 {
 	for i in $R $C $S;do
@@ -14,22 +16,14 @@ cleanup()
 }
 trap cleanup EXIT
 
-assert_pass()
+assert_failout()
 {
-	local ret=$?
-	if [ $ret != 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R $NFT list ruleset
-		tcpdump -nnr ${PCAP}
-		test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
-		ip netns exec $R conntrack -S
-		ip netns exec $R conntrack -L
-		ip netns exec $S ss -nitepal
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
+	ip netns exec $R $NFT list ruleset
+	tcpdump -nnr ${PCAP}
+	test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
+	ip netns exec $R conntrack -S
+	ip netns exec $R conntrack -L
+	ip netns exec $S ss -nitepal
 }
 
 rnd=$(mktemp -u XXXXXXXX)
-- 
2.49.0

