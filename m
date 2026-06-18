Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4286271A71
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 08:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772581; cv=none; b=WQyoL+z6KTrdWeta9RqvP4kEReM8hda+dmUXhX530aiFgfKAoXc9K5lMyQaMM80HZfzHp4VDAQn7He6iLwRIRt2io//57Zye1sLDgEDdCfKDwmPz7zWvlXxSQ1TNUemECqMXI3ifwffFP3okzuH12hxTV1xWy3NljnGqHWclvhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772581; c=relaxed/simple;
	bh=hO08rUFs1ovjoEOZGw+f+ZwtjlH0AveTUke7Iqubkbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pURV1HmqIZFLIWxyYPlkeb7GQg9J0+1BCyfzF2z+DAVb4ZA+6bvWERXVrV8LK4+VYcywmVv0ZPKdutNnboP4+NtjqZZC9Jx7o1pHzxaz/xViIIqXH6yWNYxLRq6/zQWcaHeLugiAEAVISSn3WNoG+jOtE8uqCklJ+DsDlB20OiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B08B160541; Thu, 18 Jun 2026 10:49:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Thu, 18 Jun 2026 10:49:24 +0200
Message-ID: <20260618084927.2659-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not a big deal but this hould have used the real ip header length and not the
base header size.  As-is, if there are options then
nf_skb_is_icmp_unreach() result will be random.

Fixes: db99b2f2b3e2 ("netfilter: nf_reject: don't reply to icmp error messages")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index fecf6621f679..4626dc46808f 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -89,7 +89,7 @@ static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
 	if (iph->protocol != IPPROTO_ICMP)
 		return false;
 
-	thoff = skb_network_offset(skb) + sizeof(*iph);
+	thoff = skb_network_offset(skb) + ip_hdrlen(skb);
 
 	tp = skb_header_pointer(skb,
 				thoff + offsetof(struct icmphdr, type),
-- 
2.53.0

