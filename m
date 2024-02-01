Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457A35CDF5
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795466; cv=none; b=tXmh3lsUv4frjdRGXZKjVmsLr5Xj6CVL7dbTuRvNjZnlzwDEkdDfgWuj0270B8uUn3wtZQB6+4omn53ITFBIqVpsbZljQeJBuQBBVz5mnwjRd6X7FvUJLmFzQKGlnLuq5UaIUbvseg5aCwQUAGh8dFqDhvLyv1SRewHe9dHihcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795466; c=relaxed/simple;
	bh=RseSYHJ+vvR/Q9gijAex2FgcmzO/5CIN4hBRxiH1N/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8h29/IKr7BN/MMppUVy5UofOVXKvXChXdJJ1RTbVI7q4OAN9K13wNV6+D8+AKfZQf9cQZj8ptX3IRmU33YRlvr4Hq4qXvjDdievLQ4QpwJ4X0DbooL2pkhJwxpm0zVkMmgxXHMN4R2tu41mNXd/ReXldg4J81SKzGnOCoznDNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BQXf7umM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BQXf7umM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1dCYUF4/xfiwyCGLOdaqE50GS19G0LjXAFKmh1DscNU=; b=BQXf7umMf1r42GV6TffdDwp1tJ
	+J3fE8wevj+zE6n78hzLH75cQBMvu+NMKpSNQn3c3yhcsrcj8QaTI57Pd2RAKugUB8HmJwVlqwcZW
	fS8p+OmIOBdvBOE2WCYcxFL4VyGM0WSaJmrp2w8rRV6JI/FUNxE+NnVZvWqWqbNnmMqxwp4k2R/GJ
	RnHtotf6VShdU6qwTCrcm0hPZJhbmuw+nIAV3CN8B7gzaOnB8cxlmNLXmMt2nH/wEYaYMExY2AO0Q
	9lEUXXGyo7MiHznm0y4JRqaHPrUnkqVzCzblR+md1Ggg7PIPG+Vn6tYdqbhyIr3XQhpZe0fPjPABH
	+a/8Txkg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT2-000000001MB-0wQz;
	Thu, 01 Feb 2024 14:51:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 2/7] nft: ruleparse: Add missing braces around ternary
Date: Thu,  1 Feb 2024 14:50:52 +0100
Message-ID: <20240201135057.24828-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expression evaluated the sum before the ternay, consequently not
adding target->size if tgsize was zero.

Identified by ASAN for a simple rule using standard target:
| # ebtables -A INPUT -s de:ad:be:ef:0:00 -j RETURN
| # ebtables -D INPUT -s de:ad:be:ef:0:00 -j RETURN
| =================================================================
| ==18925==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x603000000120 at pc 0x7f627a4c75c5 bp 0x7ffe882b5180 sp 0x7ffe882b4928
| READ of size 8 at 0x603000000120 thread T0
| [...]

Fixes: 2a6eee89083c8 ("nft-ruleparse: Introduce nft_create_target()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 0bbdf44fafe03..3b1cbe4fa1499 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -94,7 +94,7 @@ __nft_create_target(struct nft_xt_ctx *ctx, const char *name, size_t tgsize)
 	if (!target)
 		return NULL;
 
-	size = XT_ALIGN(sizeof(*target->t)) + tgsize ?: target->size;
+	size = XT_ALIGN(sizeof(*target->t)) + (tgsize ?: target->size);
 
 	target->t = xtables_calloc(1, size);
 	target->t->u.target_size = size;
-- 
2.43.0

