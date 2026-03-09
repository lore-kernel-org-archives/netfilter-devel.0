Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281413D5226
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Mar 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071142; cv=none; b=NVDikd9nm6tufkbXd5JOZBfT7CPuAGwQhCItw78M6THVx5vl7t3HhcpKTsWSHVST/czInw3Cw6i2q6EfpxTwL29cLCo1dAdfwp4rsoGw76rYXPRgaQt4ZQaq+MxhRswKsqh/HAHush6MQG4j6n2YS+3cRa/9prv/6yHi/QPFa6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071142; c=relaxed/simple;
	bh=Rdv37xjTeY00UMMFjbe2W/Ow8f2bIeb8AZwlmGG3MYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CsG2+Vuh7xGa/XLUEL0kVdPA42JfSQzR4WvHo6a7vbW2cAXc6rh0lKY5VbKW4nhctnFeOPUQR/NBrFuHvyo/KRMKH1GDf1mjGFRvnV6+K5klV5q5hCY/I6aKgO0c/PBWZQFgBYy+p+Bhk7sd4ZhJaaK6Guoxvj9A6iO7wtGQh3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 72C266047A; Mon, 09 Mar 2026 16:45:39 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_conntrack] tests: add a wrapper for the filter test case
Date: Mon,  9 Mar 2026 16:45:31 +0100
Message-ID: <20260309154534.8366-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test requires traffic + active conntrack to pass.
Add a wrapper script that creates a new netns, enables
conntrack and then creates traffic (== ctnetlink events).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/test_filter.sh | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 tests/test_filter.sh

diff --git a/tests/test_filter.sh b/tests/test_filter.sh
new file mode 100755
index 000000000000..0910a61070ce
--- /dev/null
+++ b/tests/test_filter.sh
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+exec unshare -n bash -c '
+ip link set lo up
+nft -f -<<EOF
+table t {
+	chain c {
+		ct state new accept
+	}
+}
+EOF
+
+timeout 20 ./test_filter | grep -q NEW &
+rp=$!
+sleep 1
+
+for i in $(seq 1 127); do
+	timeout 1 ping -q -c 1 -I 127.0.0.$i 127.0.0.$i
+done > /dev/null
+
+wait $rp
+ret=$?
+
+echo "test_filter: return $ret"
+
+exit $ret
+'
-- 
2.52.0

