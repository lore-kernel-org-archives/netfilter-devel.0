Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E3D1E487;
	Tue, 14 May 2024 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715698660; cv=none; b=HOutgrAby4iZYqEpGRBKOe4G32o25fMbiahuLq5IonQymxulMIORa6Vgo4zHNANqfwt2gMOul/lb9zJj9DhYxwUFRae0f1/JKxb39lHk3t+tT+ZwH/WboyQlmPgyjD2PePGNcl5IdeXXlkTwa3Hh7pWrJgpPSX8P5YhQZNI7A+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715698660; c=relaxed/simple;
	bh=RZQZpzHs2BgG3hOCcNdUNpDuaLfwbtWKwlnC4BAy3FM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gVmjfXYdvY3BjSzrO7zBMiEw5mVSqpxs5r5qH9SiYWaIr+KBxtPBaWNlp/sJ8VObq1XX2s7mpwQf+s74Tw6/SRPeI+e9i2Zz5ldFnfXL94+ib5WR0HSXr9Jv/ulVw6EX/QNP8/ijHp1uP+/UVJIEdLS+bs5dnxm47+7J+tUVZE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6tax-0001vl-Sk; Tue, 14 May 2024 16:57:35 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: fix packetdrill conntrack testcase
Date: Tue, 14 May 2024 16:44:09 +0200
Message-ID: <20240514144415.11433-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some versions of conntrack(8) default to ipv4-only, so this needs to request
ipv6 explicitly, like all other spots already do.

Fixes: a8a388c2aae4 ("selftests: netfilter: add packetdrill based conntrack tests")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240513114649.6d764307@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Can't target net because ATM Fixes-commit is only in net-next.

 .../net/netfilter/packetdrill/conntrack_synack_reuse.pkt        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt
index 21e1bb6395e4..842242f8ccf7 100644
--- a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt
@@ -30,5 +30,5 @@
 
 1.5 < S 2000:2000(0) win 32792 <mss 1000,nop,wscale 0, TS val 233 ecr 0,nop,nop>
 
-+0 `conntrack -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV`
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV`
 +0 `iptables -v -S INPUT | grep INVALID | grep -q -- "-c 0 0"`
-- 
2.43.2

