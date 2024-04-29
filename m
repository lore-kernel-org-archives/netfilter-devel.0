Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5F3AC08;
	Mon, 29 Apr 2024 11:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714388643; cv=none; b=tQhEZgREPNeHmDmJSsc0Q8t6E6Z+4mze57ztjBFE3wXC3Vo0Z6rniNNgk00ZuV5b8aX9upWXA3riACrJ4P5Yn0Rpazunre6GY9fzEUwLJGw0nfRM35B3qnBkdQ4n71f2R32iQvjVqr06Wyz3kadn3AKWlUPI+IysEVrEe44n7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714388643; c=relaxed/simple;
	bh=82zy86/WlY9ABgn7uwnlUvXv6Xkk/W0Y4dQOs6cTGng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UuAbVVSV7KpmpxtiuaBG/S73AFWhjc/0xoBx+H5gX2rIeauyxJ6IkIWVPhXwQVDU6GOWacHH+Ljhx9Wj+rJSP6MvA711pERnuuvHJqDtBesup1MyjZBKOZqzNRyomfV7QpO40wif2WXwITgF1qbd36voyOlhMTbGvSXHw/D1Q80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s1OnU-0002lX-Dw; Mon, 29 Apr 2024 13:03:48 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] selftests: netfilter: avoid test timeouts on debug kernels
Date: Mon, 29 Apr 2024 12:57:28 +0200
Message-ID: <20240429105736.22677-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports that some tests fail on netdev CI when executed in a debug
kernel.

Increase test timeout to 30m, this should hopefully be enough.
Also reduce test duration where possible for "slow" machines.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/br_netfilter.sh   | 6 +++++-
 tools/testing/selftests/net/netfilter/nft_nat_zones.sh  | 1 +
 tools/testing/selftests/net/netfilter/nft_zones_many.sh | 4 +++-
 tools/testing/selftests/net/netfilter/settings          | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index d7806753f5de..c28379a965d8 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -40,7 +40,11 @@ bcast_ping()
 	fromns="$1"
 	dstip="$2"
 
-	for i in $(seq 1 500); do
+	local packets=500
+
+	[ "$KSFT_MACHINE_SLOW" = yes ] && packets=100
+
+	for i in $(seq 1 $packets); do
 		if ! ip netns exec "$fromns" ping -q -f -b -c 1 -q "$dstip" > /dev/null 2>&1; then
 			echo "ERROR: ping -b from $fromns to $dstip"
 			ip netns exec "$ns0" nft list ruleset
diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
index 549f264b41f3..3b81d88bdde3 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
@@ -13,6 +13,7 @@ maxclients=100
 have_socat=0
 ret=0
 
+[ "$KSFT_MACHINE_SLOW" = yes ] && maxclients=40
 # client1---.
 #            veth1-.
 #                  |
diff --git a/tools/testing/selftests/net/netfilter/nft_zones_many.sh b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
index 4ad75038f6ff..7db9982ba5a6 100755
--- a/tools/testing/selftests/net/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
@@ -6,6 +6,8 @@
 source lib.sh
 
 zones=2000
+[ "$KSFT_MACHINE_SLOW" = yes ] && zones=500
+
 have_ct_tool=0
 ret=0
 
@@ -89,7 +91,7 @@ fi
 		count=$(ip netns exec "$ns1" conntrack -C)
 		duration=$((stop-outerstart))
 
-		if [ "$count" -eq "$max_zones" ]; then
+		if [ "$count" -ge "$max_zones" ]; then
 			echo "PASS: inserted $count entries from packet path in $duration ms total"
 		else
 			ip netns exec "$ns1" conntrack -S 1>&2
diff --git a/tools/testing/selftests/net/netfilter/settings b/tools/testing/selftests/net/netfilter/settings
index 288bd9704773..abc5648b59ab 100644
--- a/tools/testing/selftests/net/netfilter/settings
+++ b/tools/testing/selftests/net/netfilter/settings
@@ -1 +1 @@
-timeout=500
+timeout=1800
-- 
2.44.0

