Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1710295513;
	Thu, 17 Jul 2025 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745903; cv=none; b=nDGPwMqYJEz+1slTIh1K5eRA86uViAIlMq2k+68RUoyULApinvUAQX50F0jfWZx0ziMZ3yh215t66eWsObdM9qAqInPBHmcSKAwtLACafNn/quLzxLcba9HLd3UQ6OfgW7dhqbyL4I4eXgzwB0Q85c/OQtX48hNvbZ7SUmq8I9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745903; c=relaxed/simple;
	bh=VRP65eLDQUwNZ5YFItDbDQPWIJlDYgZWBgEAe6m+dyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HOodFBjit8rXrqd9D3myHxGVwJwvFg9MKVjC9Q6UahWZ+3JwWWL6rd5jbKBZ2HwOJx5YzMxOsced4CPv04Z9YwdlfsvSLkHWUP6dE3ma99g77dxOOaLZ61YEHjF/pKChrp7x8shTuGWfQM3a9AI1n1pLlN28D7fBgzlmuelj2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bZw2/b+3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z9RJ/LYh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bZw2/b+3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z9RJ/LYh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9E143602BB; Thu, 17 Jul 2025 11:51:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745898;
	bh=Sd+7apoUu2hRlAIgmFXP5TEqRCWn9Bgh3my2afGvlvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZw2/b+3nK0EtoRE0DujXEYnXfWoHdQxi8JPwqMAm7riCZ9WRy5O4JGCyik+lUHOz
	 jx9rYcTscOEO2q5F/qE5p5ZBb8jCh0Q/pQlmGzepi+WOOTm//ntn6TpFhlUUe1RSzi
	 lA5KOOQ7V9d4rgI3bBtP8asNH3JxH5qD+nHTRTCNDRoYhZ5XRM4Q3ErVYYhWic7kdy
	 N1xSnYiCMzq8QxE+AJ2GKG1Yf9bjwpsL2NhSq+tT5gIB59ixOyovMJW6MVrq3JezzN
	 AGGC3hibG2SP9Yqmc62kAqp/BEaN2kzEzboU22tU/J2WJktc/bXoOMdXqlwxhNdgiN
	 nkO/KRJsNICqQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 86A21602B6;
	Thu, 17 Jul 2025 11:51:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745892;
	bh=Sd+7apoUu2hRlAIgmFXP5TEqRCWn9Bgh3my2afGvlvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9RJ/LYh+sqQWrej3LLuLIuCAYBEI4zWEGEGc39sriR8aWcbEiPnzQ461l5l6GtDL
	 oaHTFtHwXozzeUo+d4LsyM9gonoRrV1QihmKXjM0jqfHt0RLkbZjeskd7Snh/rjnZF
	 7wA8WEOKjkoVrKOSpSgEdKo2TjelE1f4tyacG8nTSF4xDIcj+wWEHVJpgovvQWNMLw
	 AOgYXT6oRAZti+kZvp+qdi0oXoST+mpIoMFyZpjfU4gY5x6yDtvKPnSJXybBHVAPkq
	 wgH8SSsE6JTyEDubgUlYRYUvVXCLEQzJNuYcYGKpTM9iMb976O5OyO/Bf0Oumdo/JG
	 ID57bUsMxKkQA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 5/7] netfilter: nf_tables: hide clash bit from userspace
Date: Thu, 17 Jul 2025 11:51:20 +0200
Message-Id: <20250717095122.32086-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250717095122.32086-1-pablo@netfilter.org>
References: <20250717095122.32086-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Its a kernel implementation detail, at least at this time:

We can later decide to revert this patch if there is a compelling
reason, but then we should also remove the ifdef that prevents exposure
of ip_conntrack_status enum IPS_NAT_CLASH value in the uapi header.

Clash entries are not included in dumps (true for both old /proc
and ctnetlink) either.  So for now exclude the clash bit when dumping.

Fixes: 7e5c6aa67e6f ("netfilter: nf_tables: add packets conntrack state to debug trace info")
Link: https://lore.kernel.org/netfilter-devel/aGwf3dCggwBlRKKC@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index ae3fe87195ab..a88abae5a9de 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -127,6 +127,9 @@ static int nf_trace_fill_ct_info(struct sk_buff *nlskb,
 		if (nla_put_be32(nlskb, NFTA_TRACE_CT_ID, (__force __be32)id))
 			return -1;
 
+		/* Kernel implementation detail, withhold this from userspace for now */
+		status &= ~IPS_NAT_CLASH;
+
 		if (status && nla_put_be32(nlskb, NFTA_TRACE_CT_STATUS, htonl(status)))
 			return -1;
 	}
-- 
2.39.5

