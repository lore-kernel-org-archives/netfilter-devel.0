Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794953716;
	b=W77y224N/gG0K5i+0x3jCYDVGQzcGQ0PcSj45+8mZWwrF2dKc8nQ/3sfcTXhNp0VneTN
	 C9wyNOtJ6cnpRl9PtDRP8C1fJCU3kuLx16J55GtcsDnxsIfw1W1gYWYffceEBczA/ltw+
	 83q6TQxieauopmHb6+vpgsbIeVvXbniXsBm7E8mNZoAeod5nzDrfaNyt5S9n99TeN95Hm
	 XhHffqqqCoKpYnAJsspk0sxgwAfme+InF+2TaR5y5efqH0ZyuKNbLw0izmkWWtkWVooix
	 v+OgNJBBsD+05mgMWGiqLMkVOL4IJWBhvYmoe6vE//8w1YaPsEFiQ/6WFMGsEZRV7zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953716;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=8ycVE2UmW3DebPDIbsZiB+ZMC+2SCDccT4KDmfo8koc=;
	b=LLfznN7K443o1DD+YRdsCFwM4r6PAN5Bzk6GdUxhCkAvknc+q85FDADHPUJqoZUX1TYC
	 jgNnDt7IPRIxpJt9UM33GP1/fk8LzUefOXTe5KPIUupicwgyoLe+mfu7tAyvzpmDpLbJX
	 Vs1lG6+dNi7MU0wQIRpJaRCOKOA3Xz9xowVipmK4iPfPKJWvntJQ3AP/GNKXLscPzZqF0
	 pNBMQMgBPDJYTtz9ZzkF3FFQHbMIMBpPRfEp5jm3lEd0qgSfdAJRBG6TCW19t+NHtrbyq
	 4nZHgNV3GvQ8gSToXKrZr7TDAs83hDFEaUOKa5tpBEOUiuvJAKMuUvzeN06jtLzM52g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=huvcwVxd;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78452606A32A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 22:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78452606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=huvcwVxd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794953713;
	bh=8ycVE2UmW3DebPDIbsZiB+ZMC+2SCDccT4KDmfo8koc=;
	h=From:To:Cc:Subject:Date:From;
	b=huvcwVxdbttbpdhOU7dGOYOMc27K8N/6h3VhM7l3PxtZLm6hfcKDTqcdlncS3yFnA
	 G7XWGUbYpyTGoRdxhg6K/8B7rQyEBxh5s2y+JXqhIBrlBC79wbQv5cWJ4CIobBJIDR
	 fnsVtBIOARe0OYJKl0gYw1GXQ74JRZiOHq7X7Dz0sFPgQp9gCwQdsGQAWpW0pqcWHd
	 Pu3viQFk9uluIbq0oc2pAvo4gQMvZdrA9JkTenZzrBnfpnVqPwc4265Eje2kY720Ty
	 IFq/uALpRBzG2/fTJ4q9Q7LR87pw+DzzKWHQomdz/ugWNQkFQRJDXFX8v1pf4shl11
	 Gl2Nv0L4iCOBA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 018276008A;
	Tue, 17 Nov 2026 23:15:12 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fmancera@suse.de
Subject: [PATCH nf,v5] netfilter: nf_reject_ipv6: fix locally generated packet to local address
Date: Tue, 17 Nov 2026 23:15:09 +0100
Message-ID: <20261117221509.3108808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix reject expression in inet/ingress for locally generated IPv6 packets
that are sent to a local address on ethX arrives through lo, really
perform the similar handling as ip6_rcv_core().

Reported by sashiko.

Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
Tested-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: add helper function as suggested by Fernando.

 net/ipv6/netfilter/nf_reject_ipv6.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 7c9464184517..fcd9c279b60d 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -448,6 +448,19 @@ static bool reject6_csum_ok(struct sk_buff *skb, int hook)
 	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
 }
 
+static int nf_reject6_ingress_iff(const struct sk_buff *skb)
+{
+	const struct inet6_dev *idev;
+
+	if (skb_valid_dst(skb)) {
+		idev = ip6_dst_idev(skb_dst(skb));
+		if (idev)
+			return idev->dev->ifindex;
+	}
+
+	return skb->dev->ifindex;
+}
+
 void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 		      unsigned char code, unsigned int hooknum)
 {
@@ -459,7 +472,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 
 	if (hooknum == NF_INET_INGRESS) {
 		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
-		IP6CB(skb_in)->iif = skb_in->skb_iif;
+		IP6CB(skb_in)->iif = nf_reject6_ingress_iff(skb_in);
 	}
 
 	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
-- 
2.47.3

