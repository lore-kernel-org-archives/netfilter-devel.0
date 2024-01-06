Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F78D6FC8
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jan 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rM5i7-0006aG-3G; Sat, 06 Jan 2024 13:23:31 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: prefer project nft to system-wide nft
Date: Sat,  6 Jan 2024 13:23:24 +0100
Message-ID: <20240106122327.565375-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use $NFT (src/nft, in-tree binary), not the one installed by the distro.
Else we may not find newly added bugs unless user did "make install" or
bug has propagated to release.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/payload      | 38 +++++++++----------
 tests/shell/testcases/parsing/large_rule_pipe |  2 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 1a89d853ae82..9f4587d27e22 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -102,19 +102,19 @@ table inet payload_inet {
 
 	ip netns exec "$ns1" $NFT list ruleset
 
-	ip netns exec "$ns1" nft list counter netdev payload_netdev ingress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_ingress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_ingress_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter netdev payload_netdev egress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_egress | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_egress_match | grep -v "packets 0" > /dev/null || exit 1
-
-	ip netns exec "$ns1" nft list counter inet payload_inet input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter inet payload_inet mangle_input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter inet payload_inet mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter inet payload_inet output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter inet payload_inet mangle_output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter inet payload_inet mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev ingress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_ingress_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev egress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev mangle_egress_match | grep -v "packets 0" > /dev/null || exit 1
+
+	ip netns exec "$ns1" $NFT list counter inet payload_inet input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter inet payload_inet mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
 
 	#
 	# ... next stage
@@ -166,12 +166,12 @@ RULESET="table bridge payload_bridge {
 
 	ip netns exec "$ns1" $NFT list ruleset
 
-	ip netns exec "$ns1" nft list counter bridge payload_bridge input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_input | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter bridge payload_bridge output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_output | grep -v "packets 0" > /dev/null || exit 1
-	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
 }
 
 run_test "4" "10.141.10.2" "10.141.10.3" "24"
diff --git a/tests/shell/testcases/parsing/large_rule_pipe b/tests/shell/testcases/parsing/large_rule_pipe
index fac0afaabed0..b6760c018ceb 100755
--- a/tests/shell/testcases/parsing/large_rule_pipe
+++ b/tests/shell/testcases/parsing/large_rule_pipe
@@ -566,6 +566,6 @@ table inet firewalld {
 	}
 }"
 
-( echo "flush ruleset;"; echo "${RULESET}" ) | nft -f -
+( echo "flush ruleset;"; echo "${RULESET}" ) | $NFT -f -
 
 exit 0
-- 
2.43.0

