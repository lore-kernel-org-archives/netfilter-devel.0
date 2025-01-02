Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C5125D6
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jan 2025 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735837940; cv=none; b=WwM6RYQzGYB3abVlaiNQsvA51n5AuhnwnrVQWRTs06EoyT7DXPHOGutYPtQ/UgcYPOwYRFC/WU/tbjQBYFc7zGPcSz4TkvJRin7Nxdx3H+Z+h4JwjdIen9TgDm+Cl3/gOM3G/R7HtlUSp4ljsc6TGf9uRTgDXKoBnJkB83Oj7WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735837940; c=relaxed/simple;
	bh=Z46N1MLulNDpGXn+9LeqEar8d+rRUDXlaKKmVtzZNwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ob0TQ76zgEkZp0NPAGHgk8MiK3jSCQJ6JjAbdLKBCoOlWHsglAocu1F04XJYrqgxPMGewiWoXJso0vaR056RxIUFMRTOBr5rTh2qTTWLgbMTr+3hy2fj3+gtdEnAzx2K5+v1+xSmXa1HCNrVve3AL3Oesg3mnOvfJuSELEXI+qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tTOk3-0002f2-BN; Thu, 02 Jan 2025 18:12:15 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add cgroupv2 socket match test case
Date: Thu,  2 Jan 2025 18:08:30 +0100
Message-ID: <20250102170833.18692-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a test case for nft_socket cgroupv2 matching, including
support for matching inside a cgroupv2 mount space added in kernel
commit 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces").

Test is thus run twice, once in the initial namespace and once with
a changed cgroupv2 root.

In case we can't create a cgroup or the 2nd half (unshared re-run)
fails, indicate SKIP.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/cgroupv2     | 143 ++++++++++++++++++
 .../packetpath/dumps/cgroupv2.nodump          |   0
 2 files changed, 143 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/cgroupv2
 create mode 100644 tests/shell/testcases/packetpath/dumps/cgroupv2.nodump

diff --git a/tests/shell/testcases/packetpath/cgroupv2 b/tests/shell/testcases/packetpath/cgroupv2
new file mode 100755
index 000000000000..20bd18ae3b4f
--- /dev/null
+++ b/tests/shell/testcases/packetpath/cgroupv2
@@ -0,0 +1,143 @@
+#!/bin/bash
+
+doit="$1"
+rc=0
+
+# Create hierarchy:
+# / -> nft-test1a/nft-test2a
+# |              `nft-test2b
+# `--> nft-test1b/nft-test2a
+# test1b/nft-test2a will remain empty and
+# should never match, it only exists so we
+# can create cgroupv2 match rules.
+
+if ! socat -h > /dev/null ; then
+	echo "socat tool is missing"
+	exit 77
+fi
+
+if [ ! -r /sys/fs/cgroup/cgroup.procs ] ;then
+	echo "cgroup filesystem not available"
+	exit 77
+fi
+
+cleanup()
+{
+	echo $$ > "/sys/fs/cgroup/cgroup.procs"
+
+	rmdir "/sys/fs/cgroup/nft-test1a/nft-test2a"
+	rmdir "/sys/fs/cgroup/nft-test1a/nft-test2b"
+	rmdir "/sys/fs/cgroup/nft-test1b/nft-test2a"
+	rmdir "/sys/fs/cgroup/nft-test1a"
+	rmdir "/sys/fs/cgroup/nft-test1b"
+
+	# nft list is broken after cgroupv2 removal, as nft
+	# can't find the human-readable names anymore.
+	$NFT delete table inet testcgrpv2
+}
+
+do_initial_setup()
+{
+	trap cleanup EXIT
+	ip link set lo up
+
+	mkdir -p "/sys/fs/cgroup/nft-test1a/nft-test2a" || exit 1
+	mkdir -p "/sys/fs/cgroup/nft-test1b/nft-test2a" || exit 1
+
+	mkdir "/sys/fs/cgroup/nft-test1a/nft-test2b" || exit 1
+
+	# After this, we can create cgroupv2 rules for the these cgroups.
+	# test1a and test2a should match while test1b/test2b should not:
+$NFT -f - <<EOF
+table inet testcgrpv2 {
+       counter nft-test1a {}
+       counter nft-test1a2a {}
+       counter nft-test1a2b {}
+       counter nft-test1b {}
+       counter nft-test1b2a {}
+
+       chain output {
+               type filter hook output priority 0;
+
+		socket cgroupv2 level 1 "nft-test1a" counter name "nft-test1a"
+		socket cgroupv2 level 2 "nft-test1a/nft-test2a" counter name "nft-test1a2a"
+
+		# Next must never match
+		socket cgroupv2 level 2 "nft-test1a/nft-test2b" counter name "nft-test1a2b"
+
+		# Must never match
+		socket cgroupv2 level 1 "nft-test1b" counter name "nft-test1b"
+		# Same, must not match.
+		socket cgroupv2 level 2 "nft-test1b/nft-test2a" counter name "nft-test1b2a"
+       }
+}
+EOF
+}
+
+test_counters()
+{
+	local subtest="$1"
+
+	local t1a="$2"
+	local t1a2a="$3"
+
+	$NFT list ruleset
+
+	$NFT reset counter inet testcgrpv2 nft-test1a | grep -q "packets $t1a" || rc=1
+	$NFT reset counter inet testcgrpv2 nft-test1a2a | grep -q "packets $t1a2a" || rc=2
+
+	# dummy cgroup counters, must not match.
+	$NFT reset counter inet testcgrpv2 nft-test1a2b | grep -q 'packets 0' || rc=3
+	$NFT reset counter inet testcgrpv2 nft-test1b   | grep -q 'packets 0' || rc=4
+	$NFT reset counter inet testcgrpv2 nft-test1b2a | grep -q 'packets 0' || rc=5
+
+	if [ $rc -ne 0 ]; then
+		echo "Counters did not match expected values fur subtest $subtest, return $rc"
+		exit $rc
+	fi
+}
+
+run_test()
+{
+	echo $$ > "/sys/fs/cgroup/nft-test1a/nft-test2a/cgroup.procs" || exit 2
+	socat -u STDIN TCP:127.0.0.1:8880,connect-timeout=4 < /dev/null > /dev/null
+
+	test_counters "a1,a2" 1 1
+
+	echo $$ > "/sys/fs/cgroup/nft-test1a/cgroup.procs" || exit 2
+	socat -u STDIN TCP:127.0.0.1:8880,connect-timeout=4 < /dev/null > /dev/null
+	test_counters "a1 only" 1 0
+}
+
+
+if [ "$doit" != "setup-done" ];then
+	mkdir -p "/sys/fs/cgroup/nft-test1a" || exit 77
+
+	do_initial_setup
+	run_test
+
+	if [ $rc -ne 0 ]; then
+		exit $rc
+	fi
+
+	echo "Re-running test with changed cgroup root"
+	echo $$ > "/sys/fs/cgroup/nft-test1a/cgroup.procs" || exit 2
+	unshare --fork --pid --mount -n -C $0 "setup-done"
+	rc=$?
+else
+	want_inode=$(stat --printf=%i "/sys/fs/cgroup/nft-test1a/")
+	mount -t cgroup2 cgroup2 /sys/fs/cgroup
+
+	# /sys/fs/cgroup/  should now match "/sys/fs/cgroup/nft-test1a/cgroup.procs"
+	rootinode=$(stat --printf=%i "/sys/fs/cgroup/")
+
+	if [ $want_inode -ne $rootinode ] ;then
+		echo "Failed to remount cgroupv2 fs, wanted inode $want_inode as root node, but got $rootinode"
+		exit 77
+	fi
+
+	do_initial_setup
+	run_test
+fi
+
+exit $rc
diff --git a/tests/shell/testcases/packetpath/dumps/cgroupv2.nodump b/tests/shell/testcases/packetpath/dumps/cgroupv2.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.45.2

