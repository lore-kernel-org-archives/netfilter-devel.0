Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A174C1B3953;
	Mon,  4 Nov 2024 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730610; cv=none; b=B1+f0XXxosgKDFw6THEh3BYrjyIZ4o5cQBzS++E8rEDSi7M1LuxMS22a+krReUsNNabSnie5lkvQXgwNEGnyTQn8cbdBMRFWubLL06iA0fjGU51nc9huwcTH9ntNQe1K29Ts9Ocmrr9E83yRkBeEmOyaWdxFI5thrIfTFjlkJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730610; c=relaxed/simple;
	bh=0A6qX5i83Fj3L/4nVvCgupaSpkEnVdwxCKTdNDGlXhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tooef7dfFohGTRkEYZeEZfi0K2N+1TPjoBEUIDnpzntRoCeIqjetLlmg58+D8wsCrs1EgVz4QMeywtM+JhtBZPUDl9QW0z/NC6CatFXMwmB+xvbJiuUW3v+ebYTowikmfsW8RWC/XwFWz3n1KMLFvSHO0KnaB74ydR51TCOjBus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7y5m-0006dY-OU; Mon, 04 Nov 2024 15:30:06 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix warnings with socat 1.8.0.0
Date: Mon,  4 Nov 2024 15:28:18 +0100
Message-ID: <20241104142821.2608-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updated to a more recent socat release and saw this:
 socat E xioopen_ipdgram_listen(): unknown address family 0
 socat W address is opened in read-write mode but only supports read-only

First error is avoided via pf=ipv4 option, second one via -u
(unidirectional) mode.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_queue.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index a9d109fcc15c..785e3875a6da 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -512,10 +512,10 @@ EOF
 	:> "$TMPFILE1"
 	:> "$TMPFILE2"
 
-	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12345,fork OPEN:"$TMPFILE1",trunc &
+	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12345,fork,pf=ipv4 OPEN:"$TMPFILE1",trunc &
 	local rpid1=$!
 
-	timeout 10 ip netns exec "$ns3" socat UDP-LISTEN:12345,fork OPEN:"$TMPFILE2",trunc &
+	timeout 10 ip netns exec "$ns3" socat UDP-LISTEN:12345,fork,pf=ipv4 OPEN:"$TMPFILE2",trunc &
 	local rpid2=$!
 
 	ip netns exec "$nsrouter" ./nf_queue -q 12 -d 1000 &
@@ -528,8 +528,8 @@ EOF
 	# Send two packets, one should end up in ns1, other in ns2.
 	# This is because nfqueue will delay packet for long enough so that
 	# second packet will not find existing conntrack entry.
-	echo "Packet 1" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
-	echo "Packet 2" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
+	echo "Packet 1" | ip netns exec "$ns1" socat -u STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
+	echo "Packet 2" | ip netns exec "$ns1" socat -u STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
 
 	busywait 10000 output_files_written "$TMPFILE1" "$TMPFILE2"
 
-- 
2.45.2

