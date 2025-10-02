Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C796A283C93
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 13:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759410048; cv=none; b=nn1qlZY4GHprA9wXs9z1I8HzO8vdd6hq/iz+6pyr14U0i2sTurDE1tJGF4CADize0cmwc2cHbEKEMCDcZODJHzjvVVDBWnysJzSDcC56/YSW4H2OLUVWoSUmA7JnkzpdnngC0hr9f7HL9yZSpaH0BLcfi4CYRYvzV/MVU4TrrxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759410048; c=relaxed/simple;
	bh=ifBpdxboWgZInpXU+S2opDJ4hJJKTzFPlaISE+3crg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZAwtbrM2p0bnr8cdVfLwq1gj0A/gZ7BVLgC3gs2ufOOar8eN4eJGJA96CS0XvUPlM6nBh8+WpdwJEKNUvVsNi15BurtqP6HCzPr7Zd79naBkOrYQU+sR9OHH5h6ZENovZ28APnn6tXHKya4OqBv9TgreVF+Hv7cBYc/o18RinDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 89C0260187; Thu,  2 Oct 2025 15:00:43 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH nf] selftests: netfilter: nft_fib.sh: fix spurious test failures
Date: Thu,  2 Oct 2025 15:00:06 +0200
Message-ID: <20251002130010.22500-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports spurious failure of nft_fib.sh test.
This is caused by a subtle bug inherited when i moved faulty ping
from one test case to another.

nft_fib.sh not only checks that the fib expression matched, it also
records the number of matches and then validates we have the expected
count.  When I did this it was under the assumption that we would
have 0 to n matching packets.  In case of the failure, the entry has
n+1 matching packets.

This happens because ping_unreachable helper uses "ping -c 1 -w 1",
instead of the intended "-W".  -w alters the meaning of -c (count),
namely, its then treated as number of wanted *replies* instead of
"number of packets to send".

So, in some cases, ping -c 1 -w 1 ends up sending two packets which then
makes the test fail as we the set recorded two packets instead of one.

Fix the actual bug (s/-w/-W) and also change the error handling:
1. Show the number of expected packets in the error message
2. Always try to delete the key from the set.
   Else, later test that makes sure we don't have unexpected keys
   in there will always fail as well.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/20250927090709.0b3cd783@kernel.org/
Fixes: 98287045c979 ("selftests: netfilter: move fib vrf test to nft_fib.sh")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_fib.sh | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 9929a9ffef65..04544905c216 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -256,12 +256,12 @@ test_ping_unreachable() {
   local daddr4=$1
   local daddr6=$2
 
-  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr4" > /dev/null; then
+  if ip netns exec "$ns1" ping -c 1 -W 0.1 -q "$daddr4" > /dev/null; then
 	echo "FAIL: ${ns1} could reach $daddr4" 1>&2
 	return 1
   fi
 
-  if ip netns exec "$ns1" ping -c 1 -w 1 -q "$daddr6" > /dev/null; then
+  if ip netns exec "$ns1" ping -c 1 -W 0.1 -q "$daddr6" > /dev/null; then
 	echo "FAIL: ${ns1} could reach $daddr6" 1>&2
 	return 1
   fi
@@ -437,14 +437,17 @@ check_type()
 	local addr="$3"
 	local type="$4"
 	local count="$5"
+	local lret=0
 
 	[ -z "$count" ] && count=1
 
 	if ! ip netns exec "$nsrouter" nft get element inet t "$setname" { "$iifname" . "$addr" . "$type" } |grep -q "counter packets $count";then
-		echo "FAIL: did not find $iifname . $addr . $type in $setname"
+		echo "FAIL: did not find $iifname . $addr . $type in $setname with $count packets"
 		ip netns exec "$nsrouter" nft list set inet t "$setname"
 		ret=1
-		return 1
+		# do not fail right away, delete entry if it exists so later test that
+		# checks for unwanted keys don't get confused by this *expected* key.
+		lret=1
 	fi
 
 	# delete the entry, this allows to check if anything unexpected appeared
@@ -456,7 +459,7 @@ check_type()
 		return 1
 	fi
 
-	return 0
+	return $lret
 }
 
 check_local()
-- 
2.49.1

