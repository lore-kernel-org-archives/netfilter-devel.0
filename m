Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B55242D89;
	Mon, 21 Jul 2025 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753137435; cv=none; b=ZJyOKapGlEnYkDKN1dXL+P7EEP2GzER2QiaAYey8o6O0rCOmgIZwRzSDZjiqA5/caDun2K7qpHw8IbI753+17N2u6XhwpImlFVAf2xVSZ5oIFQFxSe/yf8v8jjdVmPVulBiK/YaLARi8H1jWJooo+6UJZrhoySLwcs/jcxcoyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753137435; c=relaxed/simple;
	bh=rakyVmC8acBtMLGlf8GJCt3AzwSf5tFyHzeVS9O573o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ixvVDgbeBZjgPhdOiNNWjhu5HPCPgk3FEtw8EWxFogRnvCVFXF5gUCHgPQo29YTJIORO/N21f8O5EM+Ou9XRN0DdA0SFip/VH9W0fS5qKjBl/4MZoPnEqxgNgSLQYHs6dmzrUl5OJSmPkT1pEmRRdpZ/zzyK7zhzGJEqEO89Vy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C432604C6; Tue, 22 Jul 2025 00:37:10 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net] selftests: netfilter: tone-down conntrack clash test
Date: Tue, 22 Jul 2025 00:36:49 +0200
Message-ID: <20250721223652.6956-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test is supposed to observe that the 'clash_resolve' stat counter
incremented (i.e., the code path was covered).
This check was incorrect, 'conntrack -S' needs to be called in the
revevant namespace, not the initial netns.

The clash resolution logic in conntrack is only exercised when multiple
packets with the same udp quadruple race. Depending on kernel config,
number of CPUs, scheduling policy etc.  this might not trigger even
after several retries.  Thus the script eventually returns SKIP if the
retry count is exceeded.

The udpclash tool with also exit with a failure if it did not observe
the expected number of replies.

In the script, make a note of this but do not fail anymore, just check if
the clash resolution logic triggered after all.

Remove the 'single-core' test: while unlikely, with preemptible kernel it
should be possible to also trigger clash resolution logic.

With this change the test will either SKIP or pass.

Hard error could be restored later once its clear whats going on, so
also dump 'conntrack -S' when some packets went missing to see if
conntrack dropped them on insert.

Fixes: 78a588363587 ("selftests: netfilter: add conntrack clash resolution test case")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
  - leave udpclash tool as-is, relax script error handling instead
  - fix commit message to mention the conntrack -S bug fix
  - get rid of the single-cpu shortcut

 .../net/netfilter/conntrack_clash.sh          | 45 +++++++++----------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
index 3712c1b9b38b..606a43a60f73 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -93,32 +93,28 @@ ping_test()
 run_one_clash_test()
 {
 	local ns="$1"
-	local daddr="$2"
-	local dport="$3"
+	local ctns="$2"
+	local daddr="$3"
+	local dport="$4"
 	local entries
 	local cre
 
 	if ! ip netns exec "$ns" ./udpclash $daddr $dport;then
-		echo "FAIL: did not receive expected number of replies for $daddr:$dport"
-		ret=1
-		return 1
+		echo "INFO: did not receive expected number of replies for $daddr:$dport"
+		ip netns exec "$ctns" conntrack -S
+		# don't fail: check if clash resolution triggered after all.
 	fi
 
-	entries=$(conntrack -S | wc -l)
-	cre=$(conntrack -S | grep -v "clash_resolve=0" | wc -l)
+	entries=$(ip netns exec "$ctns" conntrack -S | wc -l)
+	cre=$(ip netns exec "$ctns" conntrack -S | grep "clash_resolve=0" | wc -l)
 
-	if [ "$cre" -ne "$entries" ] ;then
+	if [ "$cre" -ne "$entries" ];then
 		clash_resolution_active=1
 		return 0
 	fi
 
-	# 1 cpu -> parallel insertion impossible
-	if [ "$entries" -eq 1 ]; then
-		return 0
-	fi
-
-	# not a failure: clash resolution logic did not trigger, but all replies
-	# were received.  With right timing, xmit completed sequentially and
+	# not a failure: clash resolution logic did not trigger.
+	# With right timing, xmit completed sequentially and
 	# no parallel insertion occurs.
 	return $ksft_skip
 }
@@ -126,20 +122,23 @@ run_one_clash_test()
 run_clash_test()
 {
 	local ns="$1"
-	local daddr="$2"
-	local dport="$3"
+	local ctns="$2"
+	local daddr="$3"
+	local dport="$4"
+	local softerr=0
 
 	for i in $(seq 1 10);do
-		run_one_clash_test "$ns" "$daddr" "$dport"
+		run_one_clash_test "$ns" "$ctns" "$daddr" "$dport"
 		local rv=$?
 		if [ $rv -eq 0 ];then
 			echo "PASS: clash resolution test for $daddr:$dport on attempt $i"
 			return 0
-		elif [ $rv -eq 1 ];then
-			echo "FAIL: clash resolution test for $daddr:$dport on attempt $i"
-			return 1
+		elif [ $rv -eq $ksft_skip ]; then
+			softerr=1
 		fi
 	done
+
+	[ $softerr -eq 1 ] && echo "SKIP: clash resolution for $daddr:$dport did not trigger"
 }
 
 ip link add veth0 netns "$nsclient1" type veth peer name veth0 netns "$nsrouter"
@@ -161,11 +160,11 @@ spawn_servers "$nsclient2"
 
 # exercise clash resolution with nat:
 # nsrouter is supposed to dnat to 10.0.2.1:900{0,1,2,3}.
-run_clash_test "$nsclient1" 10.0.1.99 "$dport"
+run_clash_test "$nsclient1" "$nsrouter" 10.0.1.99 "$dport"
 
 # exercise clash resolution without nat.
 load_simple_ruleset "$nsclient2"
-run_clash_test "$nsclient2" 127.0.0.1 9001
+run_clash_test "$nsclient2" "$nsclient2" 127.0.0.1 9001
 
 if [ $clash_resolution_active -eq 0 ];then
 	[ "$ret" -eq 0 ] && ret=$ksft_skip
-- 
2.49.1

