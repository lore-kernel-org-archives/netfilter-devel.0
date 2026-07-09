Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938A729E116
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627469; cv=none; b=o1R10HYINBrxRlvrvDk8BcumcfT1jXjaOD0Czr1R+8+WjfP7GRfExc5xl1ul3eqjyji9XEII4gUt1H8MGo+p4tZuhJTGWSw2F/nRiXsFRp/Gj/QNaU9D1X7rEeGI6ljwCYjj1HISr7i8Su4l8Xw1ijlOL7CYCuaS2WavzPWrXyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627469; c=relaxed/simple;
	bh=4RQwp8g4pXikjbvayxHHO9X1Fu4B5Kg0Jz1pr6+lw3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOUzfJq+OgdtrdocBXRI5MPdDiUnauGQ1QQbN1D8cG83IeJVAALM4QIY2reon0FVY+PJVPj40hPo0tM3rkjP/Oy0XqR1ejKQjUSGrO4x9mYk0mMPFrIJCNCiC22EuWnTgt+VDvX2s4i08zO1HeChDYNdgtalJIgUkyg87Dt0DfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0928B602A9; Thu, 09 Jul 2026 22:04:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 5/7] tests: setlist_ns.sh: use local ipset binary and don't rely on userns
Date: Thu,  9 Jul 2026 22:03:56 +0200
Message-ID: <20260709200358.15504-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The script runs command in network+user namespace with remapped uid0.

In case this fails (e.g. because user namespaces are disabled), we
should re-try with plain "-n" before giving up and returning an error.

Also, in case 'ipset' isn't in $PATH, this fails.
Let runtest.sh export the ipset binary to use and refer to that.

While at it, parallelize the test and also run it 124 times, not just
4 times - missing $() resulted in 'for x in a b c d ..'.

Signed-off-by: Florian Westphal <fw@strlen.de>

x
---
 tests/runtest.sh    |  1 +
 tests/setlist_ns.sh | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/tests/runtest.sh b/tests/runtest.sh
index 766335fda768..ba4683f59e5d 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -22,6 +22,7 @@ tests="$tests comment setlist restore"
 if [ "$IPSET_UNSHARED" = "" ]; then
 	# Re-execute in new network namespace
 	export IPSET_UNSHARED="yes"
+	export IPSET_BIN="$ipset"
 	sysctl net.netfilter.nf_log_all_netns=1
 	exec unshare -n -- "$0" "$@"
 fi
diff --git a/tests/setlist_ns.sh b/tests/setlist_ns.sh
index 9e47d65e95dc..67232acdd906 100755
--- a/tests/setlist_ns.sh
+++ b/tests/setlist_ns.sh
@@ -2,21 +2,42 @@
 
 set -e
 
+[ -z "$IPSET_BIN" ] && IPSET_BIN=ipset
+
 CMD=$(cat <<EOF
 for x in \$(seq 0 127); do
     echo "create h\$x hash:ip"
     echo "create l\$x list:set timeout 10 comment"
-done | ipset restore
+done | $IPSET_BIN restore
 for x in \$(seq 0 127); do
     for y in \$(seq 0 127); do
         echo "add l\$x h\$y timeout 1000 comment \"l\$x h\$y\""
     done
-done | ipset restore
+done | $IPSET_BIN restore
 # Wait for GC
 sleep 15
 EOF
 )
 
-for x in seq 0 123; do
-    unshare -Urn bash -c "$CMD"
+# First try with user namespaces and remapped-root.
+options="-Urn"
+if ! unshare "$options" bash -c "$CMD"; then
+	# Doesn't work - try with plain network namespaces.
+	if unshare -n bash -c "$CMD"; then
+		# "-Ur" unsupported
+		options="-n"
+	else
+		# Either network namespaces are not
+		# supported at all or $CMD is failing.
+		exit 1
+	fi
+fi
+
+parallel=16
+for x in $(seq 1 123); do
+    unshare "$options" bash -c "$CMD" &
+
+    [ $((x % $parallel)) -eq 0 ] && wait
 done
+
+wait
-- 
2.54.0

