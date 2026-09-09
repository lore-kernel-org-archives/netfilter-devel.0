Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EE1422E34;
	Wed,  9 Sep 2026 22:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992345; cv=none; b=hP1XsH21qv0VNU1ljFIZCiDTv1j/YXacTfvPcPR70H0IixThA/hxBZkvpsxt1FEf9K22dvb3T2hoJyh4A7Bh4NIS6nflV00GZR8obfr/7NGaD4t9rHxW33Mn1zwf+v78/5BaUyjq2CXGfjEQZ3gk97oeUAcBa9qUZa7Pz/cu6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992345; c=relaxed/simple;
	bh=xGYjHJzkn6gPDklqwYCNO0gLT5YppmbRrSPlSh40KIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK0N1gUtGZgS6khCusUqDmlkGO9GHMCMIC9ke+g/6okjBezS8FSf3S4dWf6168FTBRmEkvVUdylNQxTWX5R6/s1JPjt8iojl523wYu7wL6OWi2DVd7oOnouIUUjZo25iWbsu4cDY6itQnR+r51pfTd59jqDwU+rhEZnuBUWgjhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XQGtKwwz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XQGtKwwz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992337;
	bh=s7DnACV4Eqfs/JWZb9stVI6jlXIUGcizH+vMPTfX1TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQGtKwwzs2ISyxaZ1TPsm+cvNSbYRIHv44AyTrarDm5MnH3wH0qjwh4aY4fmUpmAP
	 pvvfCbU15c/YyARmQW8O2L8v3rowuvzuOUJCmDQ62WW6YD5fm+LpuVCA9fdLvTbwM8
	 FtWac7ul8uNIMZCqLI5Sd7b/k2HZwndR77sluZe2vGTq38nz4DSE2BJMwjnnyUI1rN
	 XvVR6FIfdPOK47bYj6yAuMyy9hqqTbCqCh4cHfAy4Bx/+hTm77VpTKilBTRlFttJr5
	 6htyHtic2MLCTROgPc8y0jk7YsJQ3hcocmdK98vEjwV2I7xDkBRuP8VCVGjIZi8riW
	 p6MqGJKBB89NA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6F759607C2;
	Thu, 10 Sep 2026 00:18:56 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 4/7] ipvs: revalidate ihl before icmp_send
Date: Thu, 10 Sep 2026 00:18:41 +0200
Message-ID: <20260909221844.1650275-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

While the outer IP header is already pulled into the skb head,
we must be careful and revalidate the embedded headers after
reading them from the skb frags to prevent out-of-bounds
access.

One such place reported by Sashiko is ip_vs_in_icmp() where
local process can change the ihl field and after
pskb_may_pull() we can see larger value which is a problem
for the icmp_send() call.

Add check to drop the packet if the ihl field is changed and
make sure the transport header is updated.

Also, provide correct protocol to ipv4_update_pmtu().

Fixes: 7fcc2fe39fed ("net: icmp: avoid invalid transport header access in icmp_send tracepoint")
Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Link: https://sashiko.dev/#/patchset/20260806105211.34622-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ba0957798bad..c41fac3ed873 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1934,7 +1934,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
 				  outer_proto, &ip_hdr(skb)->saddr,
 				  &ip_hdr(skb)->daddr, mtu);
-			ipv4_update_pmtu(skb, ipvs->net, mtu, 0, 0);
+			ipv4_update_pmtu(skb, ipvs->net, mtu, 0,
+					 ip_hdr(skb)->protocol);
 			/* Client uses PMTUD? */
 			if (!(frag_off & htons(IP_DF)))
 				goto ignore_tunnel;
@@ -1960,6 +1961,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;
+		skb_set_transport_header(skb, hlen_orig);
+		/* Before now we may used ihl from skb frag, revalidate it after
+		 * copying it into skb head to prevent out-of-bounds access
+		 */
+		if (ip_hdr(skb)->ihl * 4 != hlen_orig)
+			goto ignore_tunnel;
 		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
 			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
 			type, code, ntohl(info));
-- 
2.47.3

