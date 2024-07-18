Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C725144D10
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2024 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721319432; cv=none; b=BjG9XSSm+QvvHq2Pwpo1XdzmLeAMMl/NQ1P2JM0Wina+g+rzd7UFLEzMy2zZWcsSrcqN8HqTKK2h2xbGRCrG6loHIllo/Uda7UkwZXjSUcejY8DYdq06IHXywjYuXct0Z1i1/sAU1KWqjESV/Iopoc9csJQyHi3zLjvLZYIkFBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721319432; c=relaxed/simple;
	bh=oaYHinWLGlS1apiAdY23oeixcuOPgf2acIxTma5pOOM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ZLX4CV7Ig8ACqfInbyQl13kBXAYOScakoJiVzMadm//OvCzkFcNWiHp2QW4a2I/NEdOgvANj1Ez9q5TZ5/2u684LkqOUYcr1wx6HCWP4/DJdF/vglQUW+dex1ZUoNSgfF2ZgqLpTOquX0atkoY2yjcVBPfNuwUzDloJqyEk92tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: skip variables in nat statements
Date: Thu, 18 Jul 2024 18:17:03 +0200
Message-Id: <20240718161703.27613-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not hit assert():

  nft: optimize.c:486: rule_build_stmt_matrix_stmts: Assertion `k >= 0' failed.

variables are not supported by -o/--optimize at this stage.

Fixes: 9be404a153bc ("optimize: ignore existing nat mapping")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                |  6 ++-
 tests/shell/testcases/optimizations/variables | 52 ++++++++++++++++---
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 62dd9082a587..9f0965cd5fe9 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -408,9 +408,11 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			break;
 		case STMT_NAT:
 			if ((stmt->nat.addr &&
-			     stmt->nat.addr->etype == EXPR_MAP) ||
+			     (stmt->nat.addr->etype == EXPR_MAP ||
+			      stmt->nat.addr->etype == EXPR_VARIABLE)) ||
 			    (stmt->nat.proto &&
-			     stmt->nat.proto->etype == EXPR_MAP)) {
+			     (stmt->nat.proto->etype == EXPR_MAP ||
+			      stmt->nat.proto->etype == EXPR_VARIABLE))) {
 				clone->ops = &unsupported_stmt_ops;
 				break;
 			}
diff --git a/tests/shell/testcases/optimizations/variables b/tests/shell/testcases/optimizations/variables
index fa986065006b..4cb322dbc73c 100755
--- a/tests/shell/testcases/optimizations/variables
+++ b/tests/shell/testcases/optimizations/variables
@@ -2,14 +2,52 @@
 
 set -e
 
-RULESET="define addrv4_vpnnet = 10.1.0.0/16
+RULESET='define addrv4_vpnnet = 10.1.0.0/16
+define wan = "eth0"
+define lan = "eth1"
+define vpn = "tun0"
+define server = "10.10.10.1"
 
-table ip nat {
-    chain postrouting {
-        type nat hook postrouting priority 0; policy accept;
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy drop;
+	}
+	chain forward {
+		type filter hook forward priority 1; policy drop;
 
-        ip saddr \$addrv4_vpnnet counter masquerade fully-random comment \"masquerade ipv4\"
-    }
-}"
+		iifname $lan oifname $lan accept;
+
+		iifname $lan oifname $wan ct state new accept
+		iifname $lan oifname $wan ct state {established, related} accept
+
+		iifname $wan oifname $lan ct state {established, related} accept
+
+		iifname $vpn oifname $wan accept
+		iifname $wan oifname $vpn accept
+		iifname $lan oifname $vpn accept
+		iifname $vpn oifname $lan accept
+
+		iifname $lan oifname $server accept
+		iifname $server oifname $lan accept
+		iifname $server oifname $wan accept
+		iifname $wan oifname $server accept
+	}
+	chain output {
+		type filter hook output priority 0; policy drop;
+	}
+}
+
+table nat {
+	chain prerouting {
+		type nat hook prerouting priority -100; policy accept;
+		iifname $wan tcp dport 10000 dnat to $server:10000;
+	}
+	chain postrouting {
+		type nat hook postrouting priority 100; policy accept;
+		ip saddr $addrv4_vpnnet counter masquerade fully-random comment "masquerade ipv4"
+		oifname $vpn masquerade
+		oifname $wan masquerade
+	}
+}'
 
 $NFT -c -o -f - <<< $RULESET
-- 
2.30.2

