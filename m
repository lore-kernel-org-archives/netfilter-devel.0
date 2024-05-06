Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4BB142E87;
	Mon,  6 May 2024 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996236; cv=none; b=G29BHRSrFBHcglpMzpeVKr9gBT5hr83YY3u/Qhqmjsg6BxouR+iiylAStBov0vszyZaiBi6MgFHMomI4CV+Bz6wsCyWT7evLZLoIPVmYITMkcREZzfsjyfvsQvuLn6D5viv6cpb9WsShHwebI7OT776IkH4jOBMJjGLd3oqiAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996236; c=relaxed/simple;
	bh=y6cqDXl03vpDlI1WoQ3qF+Vekj9+MML61XpUT2jK0uI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pX3EZUxvyUvtFamczbbkoXHzN6wg1rN3L5dThzbCAMCZm6a6+9vHv8PWsCf4zt1z7j2Mw3K/MC0X50KZNgEYFCg3zdrA8jXbLXNRBVNJUxGzVkEYhxM4elUdc/PVvbpMYRwomWV0fiaCuih42o6c48/08NCEw1tf9CMcIabxPps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s3wrO-0003r1-NL; Mon, 06 May 2024 13:50:22 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] selftests: netfilter: conntrack_tcp_unreplied.sh: wait for initial connection attempt
Date: Mon,  6 May 2024 13:43:16 +0200
Message-ID: <20240506114320.12178-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Netdev CI reports occasional failures with this test
("ERROR: ns2-dX6bUE did not pick up tcp connection from peer").

Add explicit busywait call until the initial connection attempt shows
up in conntrack rather than a one-shot 'must exist' check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_tcp_unreplied.sh  | 25 +++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh b/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
index 1f862c089028..121ea93c0178 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
@@ -106,6 +106,23 @@ ip netns exec "$ns1" bash -c 'for i in $(seq 1 $BUSYWAIT_TIMEOUT) ; do
 	sleep 0.1
 	done' &
 
+wait_for_attempt()
+{
+	count=$(ip netns exec "$ns2" conntrack -L -p tcp --dport 80 2>/dev/null | wc -l)
+	if [ "$count" -gt 0 ]; then
+		return 0
+	fi
+
+	return 1
+}
+
+# wait for conntrack to pick the new connection request up before loading
+# the nat redirect rule.
+if ! busywait "$BUSYWAIT_TIMEOUT" wait_for_attempt; then
+	echo "ERROR: $ns2 did not pick up tcp connection from peer"
+	exit 1
+fi
+
 ip netns exec "$ns2" nft -f - <<EOF
 table inet nat {
 	chain prerouting {
@@ -119,12 +136,6 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
-count=$(ip netns exec "$ns2" conntrack -L -p tcp --dport 80 2>/dev/null | wc -l)
-if [ "$count" -eq 0 ]; then
-	echo "ERROR: $ns2 did not pick up tcp connection from peer"
-	exit 1
-fi
-
 wait_for_redirect()
 {
 	count=$(ip netns exec "$ns2" conntrack -L -p tcp --reply-port-src 8080 2>/dev/null | wc -l)
@@ -136,7 +147,7 @@ wait_for_redirect()
 }
 echo "INFO: NAT redirect added in ns $ns2, waiting for $BUSYWAIT_TIMEOUT ms for nat to take effect"
 
-busywait $BUSYWAIT_TIMEOUT wait_for_redirect
+busywait "$BUSYWAIT_TIMEOUT" wait_for_redirect
 ret=$?
 
 expect="packets 1 bytes 60"
-- 
2.43.2

