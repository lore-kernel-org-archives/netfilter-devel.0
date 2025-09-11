Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04849214A8B;
	Thu, 11 Sep 2025 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601511; cv=none; b=p0M9GHKEdmADzQNytKgUazADkxzEy+rhUXJcGXpKJJ93tgbMRZ1qZ27+VMQFY2E4s3LzuFp/jOa6zTQSxhwiFWCTmv7yONyUbuJFxtcLGHaC/VhEDGQJFM8WIyNmikRi3iK2WEOp55vI1ukGlFHoy3lRF6olNETRbpUFQxd0FZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601511; c=relaxed/simple;
	bh=FSnIpU6ZCAXqQ8bL/82fDks9DVR6kr4M84ujrVqiLLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOkpnwKGewUOle0VOThSNNMHM/kX+mZicWYdTNi6F2WpPvQ6wQgWv2oMeitlDRec7SUR3QCrvk6/8ALZB41iKxz4i0IM0xHnVCepkQ9JmLnXA9oZZ4ckw893OxPlWHIBvOejvrgxx8bsv1/lxmUHN0qzFI7wq7UULh08tI0tqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18DDE60326; Thu, 11 Sep 2025 16:38:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 1/5] selftest:net: fixed spelling mistakes
Date: Thu, 11 Sep 2025 16:38:15 +0200
Message-ID: <20250911143819.14753-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250911143819.14753-1-fw@strlen.de>
References: <20250911143819.14753-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andres Urian Florez <andres.emb.sys@gmail.com>

Fixed spelling errors in test_redirect6() error message and
test_port_shadowing() comments

Signed-off-by: Andres Urian Florez <andres.emb.sys@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_nat.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat.sh b/tools/testing/selftests/net/netfilter/nft_nat.sh
index a954754b99b3..b3ec2d0a3f56 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat.sh
@@ -569,7 +569,7 @@ test_redirect6()
 	ip netns exec "$ns0" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 
 	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
-		echo "ERROR: cannnot ping $ns1 from $ns2 via ipv6"
+		echo "ERROR: cannot ping $ns1 from $ns2 via ipv6"
 		lret=1
 	fi
 
@@ -859,7 +859,7 @@ EOF
 	# from router:service bypass connection tracking.
 	test_port_shadow_notrack "$family"
 
-	# test nat based mitigation: fowarded packets coming from service port
+	# test nat based mitigation: forwarded packets coming from service port
 	# are masqueraded with random highport.
 	test_port_shadow_pat "$family"
 
-- 
2.49.1

