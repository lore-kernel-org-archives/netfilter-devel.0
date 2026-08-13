Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E203B1025
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 23:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786662727; cv=none; b=FowrRiwcnIzgocQxDBGye4l61MexMcEJq/OzjjfRJnHQvpv/8PmAa8rSqUl3ayRPbWwbuYpRPkkt9JPxWBgXN4oFdwsBrm2Mp6fOQBeHGg69d5gSx62Ji/wZFIzbJakJVFD3G2jA0YfCuOfqYrXOSTj7CkTnViXYIEIYJlnAUgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786662727; c=relaxed/simple;
	bh=DKu1o8jt2wmWu2P/24BEIjII3VafEsPrLV8ZbpVJUPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CX835L8eetB3nS/pUk0LW9KR9JAJQqV2JeG5K2qa4lKv0y2rXV4IsFhbIVQdc55KSltF2JUqjTMrsEQzZy6oozK/PWCTFGM+7c7plwg1obYLF516cWGScd8xnEZsE/bsIaacLzUIjsBNced4ilRN/nNNCFoGx3Yaydiiqg8lYdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 977136038C; Fri, 14 Aug 2026 01:04:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] tests: runtest.sh: do kmemleak scan if available
Date: Fri, 14 Aug 2026 01:04:01 +0200
Message-ID: <20260813230404.19951-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we find that the kernel has kmemleak support, run a scan
at the end of the test and report an error in case there are new
reports.  It won't report any leaks that existed before in order
to not indicate errors in case of earlier memory leaks triggered
by other, non-ipset related tests.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/runtest.sh | 52 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/tests/runtest.sh b/tests/runtest.sh
index 1b00b7bc55d5..3571c310095e 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -36,6 +36,45 @@ cleanup() {
 	ip link del eth0
 }
 trap cleanup EXIT
+
+kmemleak_found=0
+test -f /sys/kernel/debug/kmemleak && kmemleak_found=$(grep "unreferenced object" /sys/kernel/debug/kmemleak | wc -l)
+
+check_kmemleak_force()
+{
+	echo scan > /sys/kernel/debug/kmemleak
+
+	local lines=$(grep "unreferenced object" /sys/kernel/debug/kmemleak | wc -l)
+	if [ $lines -ne $kmemleak_found ];then
+		echo "FAILED"
+		cat /sys/kernel/debug/kmemleak
+		failcount=$((failcount+1))
+	else
+		echo "OK"
+	fi
+}
+
+check_failcount() {
+	local ret=0
+
+	if [ -f /sys/kernel/debug/kmemleak ]; then
+		echo -n  "Waiting 30 seconds, then doing kmemleak scan "
+		sleep 30
+		check_kmemleak_force
+	fi
+
+	rmmod ip_set >/dev/null 2>&1
+
+	if [ "$failcount" -eq 0 ]; then
+		echo "All tests are passed"
+	else
+		echo "$failcount tests have failed"
+		ret=1
+	fi
+
+	exit $ret
+}
+
 tmpdir=$(mktemp -t -d ip-set-XXXXXXXX)
 
 ip link set lo up
@@ -111,7 +150,9 @@ else
 fi
 
 # Make sure the scripts are executable
-chmod a+x check_* *.sh
+for f in check_* *.sh; do
+	test -x "$f" || chmod a+x "$f"
+done
 
 failcount=0
 for types in $tests; do
@@ -181,10 +222,5 @@ for x in $tests; do
 		;;
 	esac
 done
-rmmod ip_set >/dev/null 2>&1
-if [ "$failcount" -eq 0 ]; then
-	echo "All tests are passed"
-else
-	echo "$failcount tests have failed"
-	exit 1
-fi
+
+check_failcount
-- 
2.54.0

