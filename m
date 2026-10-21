Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579461;
	b=HZ4AzbSzqO0P6uu5VedVRqKb5NX28oMh/hWM0nqTzjuQTRTacvTQAI+IBpxNc+b3ISLY
	 vl1yvQ1N9CG/0/XC2cnH+OWJhTrmE7QiS2dYRzHmfLeZx+ff1Z3Cp0ndb0f3nvjkp9KGC
	 YjAcqQWTvwHLPqSBmOK3iBHTYWazjcx25RVF0UsSbDky1hk6ZvpjeNxz/R437EAktfHz7
	 dUqP/VvTfEESUyz8NQM5IyXc+aZAq3Vtf73wGs2Jm15MwXrOGrDeHSIEIKbLV0UqGClwc
	 Vz9BYz6IvwkXBEgfaAJzR6rb3f7q//ENAwMJDL6O2qDfrw2ORtl6DUk6T8+3nx6Qe+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579461;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=O+uC5Ld/q8I1E3NSK4Lisr1pZ6f6SqNRZsaiDA2lO9M=;
	b=ZZauIBGwU1XTt6ieuTaKeZW0U651wxZl6i6RxJpb6PvUqFTI250vtg7n4BPRF7nzABmx
	 20KC0QAJEIBFIvh4jDGzyn+emO8cV6SZA+AfSPeGpc+8Dm7I9K3pUe+cyYCAIwJs7ZDkA
	 7SkYQvolbVUCkxLv0Lz4xqVakxPAZ6x0/Zgx2jDfDd6X+MNdyz33AEVvnMZFNsoEndfzt
	 6NwJ7qd6vtbKnS57RCvoUJrIUv+ipzL/dIMGJxi9xCg5Vugwuu0mmq6/lpjjJwse6tbs/
	 kdMLVqX/72BgfdAVgIZyrembOPhn8pro1BG8sJNBTOlUrIYUNoXyMIaSXvyKKoVmjrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hg3Qt5mT;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE8606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4BE8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hg3Qt5mT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792579458;
	bh=O+uC5Ld/q8I1E3NSK4Lisr1pZ6f6SqNRZsaiDA2lO9M=;
	h=From:To:Subject:Date:From;
	b=hg3Qt5mTLpwCDKSAbJmRTQGl+xKweIzTNcw4y7K+oy1cIBehYQi8csUOOKn0J9BbW
	 bXtSsu8RcUfzcj5Ad9THGat8SavnSXmNSpaR2gco90kHDUyNv6F3Kz77kB82wsiFLD
	 EnE6JPpSJuofw/gNMz1OBycnrKSpZsveQ7n6fbgbNUycn7tKtUXhYLd5ERUHfAmjvs
	 YP4I7smOYL/ijbguCZIHDBxH/0cZlkPI/LLMNuOY8I+aRYO46KKX9AtF3xLnhSdiVL
	 MpjiEFX8+Ni3ulhNVLSh8rIUCApM49eUWS2hiPpFcNV8BVmO6aWsfoMHfOUMpzfcRE
	 vBrHGnnL0RhQw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 834E260052
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:44:18 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nf_reject_ipv6: fix locally generated packet to local address
Date: Wed, 21 Oct 2026 12:44:15 +0200
Message-ID: <20261021104415.1968147-1-pablo@netfilter.org>
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

Set on skb dst before checking if this packet is in the inet/ingress
path. The inet/ingress hook runs before prerouting, no skb dst should be
found in most cases.

This fixes reject for locally generated packet that are sent to a
local address on ethX arrives through lo, really perform the same
handling as ip6_rcv_core().

Reported by sashiko.

Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: skb dst should always be set on after nf_reject6_fill_skb_dst,
    remove dead branch in if (hooknum == NF_INET_INGRESS).

 net/ipv6/netfilter/nf_reject_ipv6.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..fe838918e622 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -444,14 +444,20 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+		return;
+
 	if (hooknum == NF_INET_INGRESS) {
+		const struct inet6_dev *idev;
+
 		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
-		IP6CB(skb_in)->iif = skb_in->skb_iif;
+		idev = ip6_dst_idev(skb_dst(skb_in));
+		if (idev)
+			IP6CB(skb_in)->iif = idev->dev->ifindex;
+		else
+			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
 	}
 
-	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
-		return;
-
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
-- 
2.47.3

