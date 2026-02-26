Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F6466B65
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 20:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772137306; cv=none; b=YyojJyQ6OaI7H42WbTYhtcs36FPoHKQMtAeFTMqGMmvmYBvSjTU6OC7PNN6tRYBT54h3fjgeuO0MiWrUhS3flvCBtOMnTBBK8QTgUCZe9AQlfZnNkhbmISCrd2YyIzH70howl8gd/Dt2svf3xwc5weRtTW/Fcq9bwIHCh4PN2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772137306; c=relaxed/simple;
	bh=sERXavQtOQ1ps0sCix2PfRW7N6eUE8rETWhJnJAWLDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMNDrpioN3YrEq7RInCLVBpXW8rzvEla8x5Q7rQc+SbGWG3iZr+h0jPQKJKhFZh0bn7wmYKagyyqhdbaSPJjN3F9Uy2QAQc9gXFhd6gzQrFOBKMxcHsz6KLH9DzcojnVyeIEW+sdWeB+f69N3pEJ8ONSmZwTO984cDEb3L+g4Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8944760336; Thu, 26 Feb 2026 21:21:44 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/3] ipv6: make ipv6_anycast_destination logic useable without dst_entry
Date: Thu, 26 Feb 2026 21:21:25 +0100
Message-ID: <20260226202129.15033-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260226202129.15033-1-fw@strlen.de>
References: <20260226202129.15033-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_fib_ipv6 uses ipv6_anycast_destination(), but upcoming patch removes
the dst_entry usage in favor of fib6_result.

Move the 'plen > 127' logic to a new helper and call it from the
existing one.
---
 v2: new in this series.

 include/net/ip6_route.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index a55f9bf95fe3..0c8eeb6abe7a 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -252,15 +252,22 @@ static inline bool ipv6_unicast_destination(const struct sk_buff *skb)
 	return rt->rt6i_flags & RTF_LOCAL;
 }
 
+static inline bool __ipv6_anycast_destination(const struct rt6key *rt6i_dst,
+					      u32 rt6i_flags,
+					      const struct in6_addr *daddr)
+{
+	return rt6i_flags & RTF_ANYCAST ||
+	       (rt6i_dst->plen < 127 &&
+	       !(rt6i_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) &&
+	       ipv6_addr_equal(&rt6i_dst->addr, daddr));
+}
+
 static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 					    const struct in6_addr *daddr)
 {
 	const struct rt6_info *rt = dst_rt6_info(dst);
 
-	return rt->rt6i_flags & RTF_ANYCAST ||
-		(rt->rt6i_dst.plen < 127 &&
-		 !(rt->rt6i_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) &&
-		 ipv6_addr_equal(&rt->rt6i_dst.addr, daddr));
+	return __ipv6_anycast_destination(&rt->rt6i_dst, rt->rt6i_flags, daddr);
 }
 
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
-- 
2.52.0

