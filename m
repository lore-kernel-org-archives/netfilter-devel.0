Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C34CB35;
	Thu, 11 Apr 2024 23:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878978; cv=none; b=VLlQTJz0Rb5uCrCYVGv4BR/TdxJkbvN1lT8H+uWxetowK/YVblzS22Hi/3zYt//gjCR1EP2TS93SuoWx1M/HvbzBAeTNq1hAos7zHR5yIxgYBKlek1KyWAG2+dPj7Lo4LidQ96r/sOUhgMw/8ItZ3QvivXUwIorn0c8fWW5YS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878978; c=relaxed/simple;
	bh=2Hh4nH18F/BspuGkgUlfVfmcFWC4T+LIPE1Yap9F2Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcevwNv48GTgRNMDg5IM6j1YbQRpvmdp6DZGVqlK5fmKoOfA3i773TDrgoc+JkVauQSvlsI5ySUFHTbn7v8xZOkpX3l/3o/iuZYbTm8au7Z42ZhKIreEIy3BfMhfe+vhHzB3EbnicdlDwuaqV6QKflHSr+TMkNSPQ4Z6THfoNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44G-0000wN-AH; Fri, 12 Apr 2024 01:42:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 09/15] selftests: netfilter: place checktool helper in lib.sh
Date: Fri, 12 Apr 2024 01:36:14 +0200
Message-ID: <20240411233624.8129-10-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240411233624.8129-1-fw@strlen.de>
References: <20240411233624.8129-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... so it doesn't have to be repeated everywhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/br_netfilter.sh      | 6 +-----
 .../testing/selftests/net/netfilter/conntrack_ipip_mtu.sh  | 7 -------
 tools/testing/selftests/net/netfilter/lib.sh               | 7 +++++++
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index ea3afd6d401f..1084faf88f0b 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -11,11 +11,7 @@
 
 source lib.sh
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft tool"
 
 cleanup() {
 	cleanup_all_ns
diff --git a/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh b/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
index f87ca4c59d3b..ac0dff0f80d7 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
@@ -24,13 +24,6 @@ source lib.sh
 
 rx=$(mktemp)
 
-checktool (){
-	if ! $1 > /dev/null 2>&1; then
-		echo "SKIP: Could not $2"
-		exit $ksft_skip
-	fi
-}
-
 checktool "iptables --version" "run test without iptables"
 checktool "socat -h" "run test without socat"
 
diff --git a/tools/testing/selftests/net/netfilter/lib.sh b/tools/testing/selftests/net/netfilter/lib.sh
index eb109eb527db..bedd35298e15 100644
--- a/tools/testing/selftests/net/netfilter/lib.sh
+++ b/tools/testing/selftests/net/netfilter/lib.sh
@@ -1,3 +1,10 @@
 net_netfilter_dir=$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")
 
 source "$net_netfilter_dir/../lib.sh"
+
+checktool (){
+	if ! $1 > /dev/null 2>&1; then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
-- 
2.43.2

