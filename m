Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF2B2144D5
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Mar 2025 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741030720; cv=none; b=un3FocZ6gJ2+nF3bzaAE8l5Ms3fskKxDqv0cSavpQKCQozLK5woAMudmNxKKRfQKy6CqYSIorJhGg7B76X/cHKG/dsGkpGkJOdzd1YyHcJ5+R03uVe36YRJVVKhnu0qME3vgIkvHEyZzEKjJu63EKkNcbiWeCnOrZJvUTGLAeyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741030720; c=relaxed/simple;
	bh=2t53YoyawXVqCyQdfu7V8nyUHTji0AISTQRD/0eZAZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i+NmImckIUANqT/u6E4Sti5TVu9d+YUgto4x5RLSLTmU5yGjzCQKTudL/Nza18XdofGv9sm5jrNe8Mos7yz4WwcE6B0HruLwWXaYxAD6byVMEP4u0RigSiQimNJVpA5PvTKY5RMcsblkLkTXS4JkakWyLemm3+DT83KKxwRoz+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tpBcY-0004U5-Bz; Mon, 03 Mar 2025 20:38:34 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: add atomic chain replace test
Date: Mon,  3 Mar 2025 20:38:20 +0100
Message-ID: <20250303193829.570630-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test that replaces one base chain and check that no
filtered packets make it through, i.e. that the 'old chain'
doesn't disappear before new one is active.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/transactions/atomic_replace.sh  | 73 +++++++++++++++++++
 .../dumps/atomic_replace.sh.nodump            |  0
 2 files changed, 73 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/atomic_replace.sh
 create mode 100644 tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump

diff --git a/tests/shell/testcases/transactions/atomic_replace.sh b/tests/shell/testcases/transactions/atomic_replace.sh
new file mode 100755
index 000000000000..dce178602a6f
--- /dev/null
+++ b/tests/shell/testcases/transactions/atomic_replace.sh
@@ -0,0 +1,73 @@
+#!/bin/bash
+
+set -e
+
+rnd=$(mktemp -u XXXXXXXX)
+ns="nft-atomic-$rnd"
+pid1=""
+pid2=""
+duration=8
+
+cleanup()
+{
+	kill "$pid1" "$pid2"
+	ip netns del "$ns"
+}
+
+trap cleanup EXIT
+
+ip netns add "$ns" || exit 111
+ip -net "$ns" link set lo up
+
+ip netns exec "$ns" ping 127.0.0.1 -q -c 1
+
+ip netns exec "$ns" $NFT -f - <<EOF
+table ip t {
+	set s {
+		type ipv4_addr
+		elements = { 127.0.0.1 }
+	}
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+		ip protocol icmp counter
+	}
+
+	chain output {
+		type filter hook output priority 0; policy accept;
+		ip protocol icmp ip daddr @s drop
+	}
+}
+EOF
+
+ip netns exec "$ns" ping -f 127.0.0.1 &
+pid1=$!
+ip netns exec "$ns" ping -f 127.0.0.1 &
+pid2=$!
+
+time_now=$(date +%s)
+time_stop=$((time_now + duration))
+repl=0
+
+while [ $time_now -lt $time_stop ]; do
+ip netns exec "$ns" $NFT -f - <<EOF
+flush chain ip t output
+table ip t {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		ip protocol icmp ip daddr @s drop
+	}
+}
+EOF
+	repl=$((repl+1))
+
+	# do at least 100 replaces and stop after $duration seconds.
+	if [ $((repl % 101)) -eq 100 ];then
+		time_now=$(date +%s)
+	fi
+done
+
+# must match, all icmp packets dropped in output.
+ip netns exec "$ns" $NFT list chain ip t input | grep "counter packets 0"
+
+echo "Completed $repl chain replacements"
diff --git a/tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump b/tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.48.1

