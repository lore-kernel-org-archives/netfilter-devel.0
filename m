Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8E3A55;
	Sat, 11 May 2024 06:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715410108; cv=none; b=qY/xPDeIltPbyUMIwu4q6Xu0LBOKgNWGAHOOTm2Tz4CW75X7Pr5Uvhk/NQ53VIYmocRNrteUhXou9O8KolopUp7Ukoth4HZR7Hzpihf8XEmrOwkOcXbAWJU1ZZmB6YmnE1PvGyB6MGCvEd4CqvAoETlW0iq4OP/+fa05UPXm4N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715410108; c=relaxed/simple;
	bh=XS4d/IMX5x4DLImlsgQYJ1Pto/GBGmxSWxBDVruIQ+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FQZhlVN/TYxZr63JBpxiMuZkogXwmUQWAf/BVKH+h0CM9vjF26Jipb+zteEmLLmLWw2xVWGDHjxdb3v+EGhZkHUa9sfjQEVmC+7JsathM/vLJTc7ecTdGG5QUevWBSbg3JJVvwa5QcfAgPP0wR+ysGZDct3m+fwWmvjtQZrMIvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s5gWt-0003pT-K1; Sat, 11 May 2024 08:48:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: nft_flowtable.sh: bump socat timeout to 1m
Date: Sat, 11 May 2024 08:48:03 +0200
Message-ID: <20240511064814.561525-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that this test runs in netdev CI it looks like 10s isn't enough
for debug kernels:
  selftests: net/netfilter: nft_flowtable.sh
  2024/05/10 20:33:08 socat[12204] E write(7, 0x563feb16a000, 8192): Broken pipe
  FAIL: file mismatch for ns1 -> ns2
  -rw------- 1 root root 37345280 May 10 20:32 /tmp/tmp.Am0yEHhNqI
 ...

Looks like socat gets zapped too quickly, so increase timeout to 1m.

Could also reduce tx file size for KSFT_MACHINE_SLOW, but its preferrable
to have same test for both debug and nondebug.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_flowtable.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 86d516e8acd6..b3995550856a 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -17,6 +17,7 @@
 source lib.sh
 
 ret=0
+SOCAT_TIMEOUT=60
 
 nsin=""
 ns1out=""
@@ -350,12 +351,12 @@ test_tcp_forwarding_ip()
 	local dstport=$4
 	local lret=0
 
-	timeout 10 ip netns exec "$nsb" socat -4 TCP-LISTEN:12345,reuseaddr STDIO < "$nsin" > "$ns2out" &
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat -4 TCP-LISTEN:12345,reuseaddr STDIO < "$nsin" > "$ns2out" &
 	lpid=$!
 
 	busywait 1000 listener_ready
 
-	timeout 10 ip netns exec "$nsa" socat -4 TCP:"$dstip":"$dstport" STDIO < "$nsin" > "$ns1out"
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsa" socat -4 TCP:"$dstip":"$dstport" STDIO < "$nsin" > "$ns1out"
 
 	wait $lpid
 
-- 
2.45.0

