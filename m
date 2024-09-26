Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84ADD1AFB0E;
	Thu, 26 Sep 2024 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348859; cv=none; b=XCXBJoY6r3/3Of2lPPcLpjixeJp+3vSpjmNhaq5eG2rSPMksmwoe2I9omVLy4HiaMqw+XdzWjx5BlawmAyDZPN2q8YUVf0wkTh2GsEFSrCWkN79o4C50DiMtD6J+GLbGQVt5DN6CoEyqxTpy20H/NXNacdatjVYa4l4UiKCukiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348859; c=relaxed/simple;
	bh=9A0/WHC4DgcCjDTtATyqd4HzjsrzO34/cKY8pOogQNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OY/ifwVK/g7WQdjtVX9mevBSYH/4t2255hEDVNOiNNRjAYKG1TyPIGhCI+UTYN531Gzq87bixljrxzdIo6JjT5s0QeHYlqgmsygWgQYYpKyDSs7c32kyGb9/gV+VGN4cgTGawZQvZkPaP5GgI3NNerC2zOsskJpHKOMaJpStEtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 14/14] selftests: netfilter: Avoid hanging ipvs.sh
Date: Thu, 26 Sep 2024 13:07:17 +0200
Message-Id: <20240926110717.102194-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

If the client can't reach the server, the latter remains listening
forever. Kill it after 5s of waiting.

Fixes: 867d2190799a ("selftests: netfilter: add ipvs test script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 4ceee9fb3949..d3edb16cd4b3 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -97,7 +97,7 @@ cleanup() {
 }
 
 server_listen() {
-	ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
+	ip netns exec "$ns2" timeout 5 socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
 	server_pid=$!
 	sleep 0.2
 }
-- 
2.30.2

