Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE12566DA
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 10:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745402573; cv=none; b=AClcz27prliaXplr2YtLKYmm0UkHTCzeQIO+0OcJFrvo+8ETqEsHNJJ1+GxBAPzCRUV5Y3Kzke1vJBhgFHCWpYU+lTCibpBuHhD9c3s+zLcqdcOmcdMlM6AmW0hJh4PRR7+6f870eNbq56tE5w0EA+ooH8oMqo0yMz8S4oTU5FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745402573; c=relaxed/simple;
	bh=1ehbzzH+Ki89oU5ziI/acO5rIgeTLCepEDY/FqrlOu4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GZOzzcMxHjgRqcDRl6+2i26Chkysbepr3aHw40fsDu8nCBuABLvY0R1cczsAiwrIwb7MniKEqOkwnjBprXdkTjBig8QjLdIw+S6ZKPn8LkQNlpzJZkuW04iVrXVc4o8A9y/I2+dmXObCcMh54zGGr4Wrejt89rqn7K5XtiMNN5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u7WwL-0001Ub-Ev; Wed, 23 Apr 2025 12:02:49 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: nft_fib.sh: check lo packets bypass fib lookup
Date: Wed, 23 Apr 2025 11:57:29 +0200
Message-ID: <20250423095734.16109-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With reverted fix:
PASS: fib expression did not cause unwanted packet drops
[   37.285169] ns1-KK76Kt nft_rpfilter: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=127.0.0.1 DST=127.0.0.1 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=32287 DF PROTO=ICMP TYPE=8 CODE=0 ID=1818 SEQ=1
FAIL: rpfilter did drop packets
FAIL: ns1-KK76Kt cannot reach 127.0.0.1, ret 0

Check for this.

Link: https://lore.kernel.org/netfilter/20250422114352.GA2092@breakpoint.cc/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_fib.sh        | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index ce1451c275fd..ea47dd246a08 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -45,6 +45,19 @@ table inet filter {
 EOF
 }
 
+load_input_ruleset() {
+	local netns=$1
+
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy accept;
+	        fib saddr . iif oif missing counter log prefix "$netns nft_rpfilter: " drop
+	}
+}
+EOF
+}
+
 load_pbr_ruleset() {
 	local netns=$1
 
@@ -165,6 +178,16 @@ check_drops || exit 1
 
 echo "PASS: fib expression did not cause unwanted packet drops"
 
+load_input_ruleset "$ns1"
+
+test_ping 127.0.0.1 ::1 || exit 1
+check_drops || exit 1
+
+test_ping 10.0.1.99 dead:1::99 || exit 1
+check_drops || exit 1
+
+echo "PASS: fib expression did not discard loopback packets"
+
 ip netns exec "$nsrouter" nft flush table inet filter
 
 ip -net "$ns1" route del default
-- 
2.49.0

