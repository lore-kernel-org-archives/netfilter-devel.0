Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EDE1420BE;
	Mon, 22 Apr 2024 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713781828; cv=none; b=N907gtfH4zD+KH3oib7kKzS6296ZqxNd6pz4EkY09mcxepcW/VKnt4MM657tgWxCbtoj/zi33yuIyIUZLUrMRsbjEcmS+Rl7QONBVs2wVq2xJmqG13YFVCG4nsV/iu/Um1GMNHD/FO7WZnHlOGbLOwqAtmCnh7niqfT2zoOhXw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713781828; c=relaxed/simple;
	bh=3MQhatjy3nFgVtpGbogJCThiA7pafumKB69E/FV0Lkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ag8lzgnaGKpfpb3pLju2mHRzixonf2V6qWG+EA2YyBIxnQbpWynqxeJIj7Xr7zI0XAuvJw1t4q2bCrOOOOHn933fye5wxpqdBapFSQfhOGB68f5LkwJUNu8JgpMdOkxqid2khZhyvxw0NS9VskUkA366vz8XWob/SFIADm78Law=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ryqwA-0006xD-9o; Mon, 22 Apr 2024 12:30:14 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] selftests: netfilter: nft_zones_many.sh: set ct sysctl after ruleset load
Date: Mon, 22 Apr 2024 12:25:42 +0200
Message-ID: <20240422102546.2494-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_conntrack_udp_timeout sysctl only exist once conntrack module is loaded,
if this test runs standalone on a modular kernel sysctl setting fails,
this can result in test failure as udp conntrack entries expire too fast.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_zones_many.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_zones_many.sh b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
index db53de348783..4ad75038f6ff 100755
--- a/tools/testing/selftests/net/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
@@ -28,7 +28,6 @@ fi
 test_zones() {
 	local max_zones=$1
 
-ip netns exec "$ns1" sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
 ip netns exec "$ns1" nft -f /dev/stdin<<EOF
 flush ruleset
 table inet raw {
@@ -46,6 +45,9 @@ if [ "$?" -ne 0 ];then
 	echo "SKIP: Cannot add nftables rules"
 	exit $ksft_skip
 fi
+
+	ip netns exec "$ns1" sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
+
 	(
 		echo "add element inet raw rndzone {"
 	for i in $(seq 1 "$max_zones");do
-- 
2.43.2

