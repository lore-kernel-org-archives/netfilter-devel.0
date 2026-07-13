Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032B43636E
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950955; cv=none; b=V/Oj3Hxwd2oZy1nBVXJ0PPOjLvXNOWqGEUOgNuA3rd/Dbh+3X0q9fPZz37A0frbJ5qg9YIm2ATKiVpakBFvXmcpqA6XPeBGwCY5n4twO52/+q9mrp1A6vdIWw7FUf+3VwsOgsI6R0gQuCrhq6iKbF0oP9aEk0Tyz1vu3F0rYUWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950955; c=relaxed/simple;
	bh=ENgwMjO60ePXPSK2UXnI6GvwprwIgr3oNoHtH/lCuAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YC0YK3NLRpF1avHUaKtoegXf/c9J/fm85JZqfpOF2nPnM4/6zUtAVp0ozuPlp/mzj6JOtUgNFMtUZGoqATr3LnG5s6ZRDyoc8MYoCNmw4kma8vZhm1F70lsSqMRZdrgw7fv6vMujbxjIBJ6Ues0qHcIPlEzLMMY0+9kusFpJu7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A712C602A3; Mon, 13 Jul 2026 15:55:44 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnflog] utils: add minimal nfnlog test case
Date: Mon, 13 Jul 2026 15:55:31 +0200
Message-ID: <20260713135539.2936-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check that nfulnl_test receives 4 log messages each for ping/ping6 packets.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Seems I forgot to send it, I have carried this locally for more than
 a month :-/

 utils/nfulnl_test.c  |  1 +
 utils/nfulnl_test.sh | 58 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100755 utils/nfulnl_test.sh

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index 4f29f1757c81..840c0bea3a86 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -121,6 +121,7 @@ int main(int argc, char **argv)
 
 		/* handle messages in just-received packet */
 		nflog_handle_packet(h, buf, rv);
+		fflush(stdout);
 	}
 
 	printf("unbinding from group 100\n");
diff --git a/utils/nfulnl_test.sh b/utils/nfulnl_test.sh
new file mode 100755
index 000000000000..b23ccab04bae
--- /dev/null
+++ b/utils/nfulnl_test.sh
@@ -0,0 +1,58 @@
+#!/bin/bash
+
+# Configuration
+NFLOG_GROUP=0
+PING_COUNT=2
+out=""
+
+cleanup() {
+	rm -f "$out"
+}
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+if [ "$1" = "" ]; then
+	# Re-execute in new network namespace
+	exec unshare -n -- "$0" "run"
+fi
+
+trap cleanup EXIT
+set -e
+out=$(mktemp)
+
+timeout 5 ./nfulnl_test > "$out" &
+
+# Create ruleset to log ICMP/ICMPv6
+nft -f - <<EOF
+table inet filter {
+	chain icmp-log {
+		type filter hook prerouting priority 0; policy accept;
+
+		meta l4proto icmp counter log group $NFLOG_GROUP prefix "test icmp "
+		meta l4proto ipv6-icmp counter log group $NFLOG_GROUP prefix "test icmp6 "
+	}
+}
+EOF
+
+# Ensure the namespace has loopback and can send traffic
+ip link set lo up
+
+sleep 1
+
+# Trigger ICMP echo requests to ourselves (127.0.0.1 and ::1)
+ping -q -c "$PING_COUNT" 127.0.0.1 > /dev/null
+ping6 -q -c "$PING_COUNT" ::1 > /dev/null
+
+wait
+
+set +e
+cnt4=$(grep -c '^hw_protocol=0x0800 hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 mark=0 indev=1 prefix="test icmp " payload_len=84' "$out")
+cnt6=$(grep -c '^hw_protocol=0x86dd hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 mark=0 indev=1 prefix="test icmp6 " payload_len=104' "$out")
+
+[ "$cnt4" -ne 4 ] && die "Expected 2 counts each for ipv4 and ipv6, got $cnt4, $cnt6"
+[ "$cnt6" -ne 4 ] && die "Expected 2 counts each for ipv4 and ipv6, got $cnt4, $cnt6"
+
+echo "Completed, 4 log lines found for ipv4 and ipv6 each"
-- 
2.54.0

