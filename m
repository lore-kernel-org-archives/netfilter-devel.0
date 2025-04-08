Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458351B043C
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122147; cv=none; b=NRIhF9xAAIMMGALLk0k6sCgVbjLDrQD6E0GnFrKvWcl4c0wBUCi/SbdW8S7Y2MFQ9+pEStfCFqr9rN2DPYgFUcz2UW+5lD9PVZExE1BB7FIZ6GTN1u+uNyBznlNBtpBLsgyeG9gBJmO9sxVSHyqM6HsdQzzLfgDyMjwHrutr7II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122147; c=relaxed/simple;
	bh=Shf6CvwU7HAx9SpqWP7Q+QtIIr6MBgDZbmDaQZkP+PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktLkolQ2OvL8tf2bRTkqZDNFK8ppN47Bl/0aNDSxlsLgK8xqi6hYDO2/c5EnJ8J5nmubB8JhTJUhFHxjqAFFDXc7LUJK7qaUniIHeFQvWNJlaUfJHcgYAmlIZ2zaGZGPce1i0pqIaV+IaegRd1Vpfqtd7Hw3Cd/fXjiquRowXmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29qJ-0002yA-Ux; Tue, 08 Apr 2025 16:22:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 4/4] tests: shell: add feature check for count output change
Date: Tue,  8 Apr 2025 16:21:32 +0200
Message-ID: <20250408142135.23000-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408142135.23000-1-fw@strlen.de>
References: <20250408142135.23000-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New kernels with latest nft release will print the number
of set elements allocated on the kernel side.

This causes shell test dump validation to fail in several
places.  We can't just update the affected dump files
because the test cases are also supposed to pass on current
-stable releases.

Add a feature check for this.  Dump failure can then use
sed to postprocess the stored dump file and can then call
diff a second time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/setcount.sh              | 13 ++++++++
 tests/shell/helpers/test-wrapper.sh           | 33 +++++++++++++++----
 .../testcases/rule_management/0011reset_0     | 30 ++++++++++-------
 .../rule_management/dumps/0011reset_0.nft     |  2 +-
 .../sets/dumps/0016element_leak_0.nft         |  2 +-
 .../sets/dumps/0017add_after_flush_0.nft      |  2 +-
 .../sets/dumps/0018set_check_size_1.nft       |  2 +-
 .../sets/dumps/0019set_check_size_0.nft       |  2 +-
 .../sets/dumps/0045concat_ipv4_service.nft    |  2 +-
 .../sets/dumps/0057set_create_fails_0.nft     |  2 +-
 .../sets/dumps/0060set_multistmt_1.nft        |  2 +-
 11 files changed, 65 insertions(+), 27 deletions(-)
 create mode 100755 tests/shell/features/setcount.sh

diff --git a/tests/shell/features/setcount.sh b/tests/shell/features/setcount.sh
new file mode 100755
index 000000000000..9c2f75c3ae96
--- /dev/null
+++ b/tests/shell/features/setcount.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+$NFT -f - <<EOF
+table ip t {
+	set s {
+		type ipv4_addr
+		size 2
+		elements = { 1.2.3.4 }
+	}
+}
+EOF
+
+$NFT list set ip t s | grep -q 'size 2	# count 1'
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index c016e0ce1d39..8c0263febaef 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -5,6 +5,8 @@
 #
 # For some printf debugging, you can also patch this file.
 
+rc_dump=0
+
 array_contains() {
 	local needle="$1"
 	local a
@@ -25,6 +27,29 @@ show_file() {
 	printf "<<<<\n"
 }
 
+diff_check_setcount() {
+	local dumpfile="$1"
+	local after="$2"
+
+	if $DIFF -u "$dumpfile" "$after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
+		rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
+		return
+	fi
+
+	if [ $NFT_TEST_HAVE_setcount = n ];then
+		# old kernel or nft binary, expect "size 42", not "size 42	# count 1".
+		sed s/.\#\ count\ .\*//g "$dumpfile" > "$NFT_TEST_TESTTMPDIR/ruleset-diff-postprocess"
+
+		if $DIFF -u "$NFT_TEST_TESTTMPDIR/ruleset-diff-postprocess" "$after" > /dev/null ; then
+			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff" "$NFT_TEST_TESTTMPDIR/ruleset-diff-postprocess"
+			return
+		fi
+	fi
+
+	show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff" "Failed \`$DIFF -u \"$dumpfile\" \"$after\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+	rc_dump=1
+}
+
 json_pretty() {
 	"$NFT_TEST_BASEDIR/helpers/json-pretty.sh" "$@" 2>&1 || :
 }
@@ -195,15 +220,9 @@ if [ "$rc_test" -eq 0 -a '(' "$DUMPGEN" = all -o "$DUMPGEN" = y ')' ] ; then
 	fi
 fi
 
-rc_dump=0
 if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
 	if [ -f "$DUMPFILE" ] ; then
-		if ! $DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
-			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff" "Failed \`$DIFF -u \"$DUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
-			rc_dump=1
-		else
-			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
-		fi
+		diff_check_setcount "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after"
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
 		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
index 2004b17d5822..5e65ced946e5 100755
--- a/tests/shell/testcases/rule_management/0011reset_0
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -4,6 +4,12 @@
 
 set -e
 
+if [ $NFT_TEST_HAVE_setcount = y ]; then
+	size="size 65535	# count 1"
+else
+	size="size 65535"
+fi
+
 echo "loading ruleset with anonymous set"
 $NFT -f - <<EOF
 table t {
@@ -60,10 +66,10 @@ EOF
 echo "resetting specific rule"
 handle=$($NFT -a list chain t c | sed -n 's/.*accept # handle \([0-9]*\)$/\1/p')
 $NFT reset rule t c handle $handle
-EXPECT='table ip t {
+EXPECT="table ip t {
 	set s {
 		type ipv4_addr
-		size 65535
+		$size
 		flags dynamic
 		counter
 		elements = { 1.1.1.1 counter packets 1 bytes 11 }
@@ -90,7 +96,7 @@ table ip t2 {
 		counter packets 7 bytes 17 accept
 		counter packets 8 bytes 18 drop
 	}
-}'
+}"
 $DIFF -u <(echo "$EXPECT") <($NFT list ruleset)
 
 echo "resetting specific chain"
@@ -103,10 +109,10 @@ EXPECT='table ip t {
 $DIFF -u <(echo "$EXPECT") <($NFT reset rules chain t c2)
 
 echo "resetting specific table"
-EXPECT='table ip t {
+EXPECT="table ip t {
 	set s {
 		type ipv4_addr
-		size 65535
+		$size
 		flags dynamic
 		counter
 		elements = { 1.1.1.1 counter packets 1 bytes 11 }
@@ -121,14 +127,14 @@ EXPECT='table ip t {
 		counter packets 0 bytes 0 accept
 		counter packets 0 bytes 0 drop
 	}
-}'
+}"
 $DIFF -u <(echo "$EXPECT") <($NFT reset rules table t)
 
 echo "resetting specific family"
-EXPECT='table ip t {
+EXPECT="table ip t {
 	set s {
 		type ipv4_addr
-		size 65535
+		$size
 		flags dynamic
 		counter
 		elements = { 1.1.1.1 counter packets 1 bytes 11 }
@@ -149,14 +155,14 @@ table ip t2 {
 		counter packets 7 bytes 17 accept
 		counter packets 8 bytes 18 drop
 	}
-}'
+}"
 $DIFF -u <(echo "$EXPECT") <($NFT reset rules ip)
 
 echo "resetting whole ruleset"
-EXPECT='table ip t {
+EXPECT="table ip t {
 	set s {
 		type ipv4_addr
-		size 65535
+		$size
 		flags dynamic
 		counter
 		elements = { 1.1.1.1 counter packets 1 bytes 11 }
@@ -183,5 +189,5 @@ table ip t2 {
 		counter packets 0 bytes 0 accept
 		counter packets 0 bytes 0 drop
 	}
-}'
+}"
 $DIFF -u <(echo "$EXPECT") <($NFT reset rules)
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.nft
index 3b4f5a11a96e..3c29b582355d 100644
--- a/tests/shell/testcases/rule_management/dumps/0011reset_0.nft
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.nft
@@ -1,7 +1,7 @@
 table ip t {
 	set s {
 		type ipv4_addr
-		size 65535
+		size 65535	# count 1
 		flags dynamic
 		counter
 		elements = { 1.1.1.1 counter packets 1 bytes 11 }
diff --git a/tests/shell/testcases/sets/dumps/0016element_leak_0.nft b/tests/shell/testcases/sets/dumps/0016element_leak_0.nft
index 9d2b0afed425..debd819dfc2b 100644
--- a/tests/shell/testcases/sets/dumps/0016element_leak_0.nft
+++ b/tests/shell/testcases/sets/dumps/0016element_leak_0.nft
@@ -1,7 +1,7 @@
 table ip x {
 	set s {
 		type ipv4_addr
-		size 2
+		size 2	# count 1
 		elements = { 1.1.1.1 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0017add_after_flush_0.nft b/tests/shell/testcases/sets/dumps/0017add_after_flush_0.nft
index 9d2b0afed425..debd819dfc2b 100644
--- a/tests/shell/testcases/sets/dumps/0017add_after_flush_0.nft
+++ b/tests/shell/testcases/sets/dumps/0017add_after_flush_0.nft
@@ -1,7 +1,7 @@
 table ip x {
 	set s {
 		type ipv4_addr
-		size 2
+		size 2	# count 1
 		elements = { 1.1.1.1 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0018set_check_size_1.nft b/tests/shell/testcases/sets/dumps/0018set_check_size_1.nft
index 8cd3707607b3..c4b69ef8e409 100644
--- a/tests/shell/testcases/sets/dumps/0018set_check_size_1.nft
+++ b/tests/shell/testcases/sets/dumps/0018set_check_size_1.nft
@@ -1,7 +1,7 @@
 table ip x {
 	set s {
 		type ipv4_addr
-		size 2
+		size 2	# count 2
 		elements = { 1.1.1.1, 1.1.1.2 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0019set_check_size_0.nft b/tests/shell/testcases/sets/dumps/0019set_check_size_0.nft
index 8cd3707607b3..c4b69ef8e409 100644
--- a/tests/shell/testcases/sets/dumps/0019set_check_size_0.nft
+++ b/tests/shell/testcases/sets/dumps/0019set_check_size_0.nft
@@ -1,7 +1,7 @@
 table ip x {
 	set s {
 		type ipv4_addr
-		size 2
+		size 2	# count 2
 		elements = { 1.1.1.1, 1.1.1.2 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft
index e548a17a142d..fb9634e685d3 100644
--- a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft
+++ b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.nft
@@ -1,7 +1,7 @@
 table inet t {
 	set s {
 		type ipv4_addr . inet_service
-		size 65536
+		size 65536	# count 1
 		flags dynamic,timeout
 		elements = { 192.168.7.1 . 22 }
 	}
diff --git a/tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft b/tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft
index de43d565084b..443ca7110f4f 100644
--- a/tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft
+++ b/tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft
@@ -1,7 +1,7 @@
 table inet filter {
 	set test {
 		type ipv4_addr
-		size 65535
+		size 65535	# count 1
 		elements = { 1.1.1.1 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
index befc2f75bd42..0743453f62e0 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
@@ -1,7 +1,7 @@
 table ip x {
 	set y {
 		type ipv4_addr
-		size 65535
+		size 65535	# count 3
 		flags dynamic
 		counter quota 500 bytes
 		elements = { 1.1.1.1 counter packets 0 bytes 0 quota 500 bytes,
-- 
2.49.0

