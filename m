Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684739;
	b=3uIlnuQhw6TbatMkdsG3kIHP6pzfNQFj4meTGD9PuL/wr4/6pWfZN43cVXdH1EV2Uz15
	 KamuDq4vxkWFOYQPbvmdRYtSzP4ws2QFR7PS1kgLEsweiwu4RWmJsk8HndwZubDlGpNmB
	 JTUlXkTmZx+yKjDwfgHXJX5h8k091uq2xR5u43C8oC16SdmvhQeLuSAA/qnq3bd5FrqDk
	 0X1+TLZ0bFiOkspKjcJcaWM0KiH1SdoqpWKgOtUuIkI1+YE2yVq5IkASJc7qpyrnGGYK2
	 xGgxN4iZxZWjZK75Ed6hVQ+Rf2PTcKUrJ4y2rID8M3aKStgdfYGTHoNiUDuzZXYamEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684739;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=6f2B9SPA0hexlwjF6akXh9tIFDg9vZoZaFEabAchjrA=;
	b=pae6nAOm8RBSaNITeUVL3lBLvYc0c/h/3KDwZl27QCpiRfFy2NkIk8m6ZdURYvSFvRSp
	 GhvSbRMtpTmX7FmgNtsNyo5oeMbHn1mcqCji1FIE82/bdHF3Zer23r2kHI8F6t+itdcjT
	 5gsa2GF3R2PXLoTjkU1cTTaGE8JBsfnN/csOBetnC/1zPh9ln0Q9CHQ7iOdP0xIoHqKTa
	 PFueq25oTOjtXjx/BcrG+noSsiVwm60UOiT3P286F62CEJ21tKQIfjtF5SGKGeYWTPNgX
	 +m6PDFwTwj228p8sauG4LkD2odxk0T2sdUymPVx1wG0B419GPaKEesgkEh9WRkaWH1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZHAhHa80;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43A606A319
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F43A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZHAhHa80
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684737;
	bh=6f2B9SPA0hexlwjF6akXh9tIFDg9vZoZaFEabAchjrA=;
	h=From:To:Subject:Date:From;
	b=ZHAhHa80LzCIBRD9lOg0Dp2eCuqfZJFmbjN4ng8I0BA1IRFgRQCE8TELCmsjifZRd
	 EHnHI5xqCnye/vLh1uJM0Gb+Slog7yQKNy3J+4Dl50YvkXj8gD/Oynfa4dHAtUkPYe
	 BjSFiBcveFvXJwjuHayQQkHT/9C3b/RROm/BeEe5Q9QC1HC5cAMP+xBHh3KlXPm6rj
	 VlZBfl9qa/tddRXvPzNYwXuwt4hxwkZVMdgJaZmayDwvD+5M5cb8JR866Lv4uakvy8
	 eChkH3cIX+DQvoxeS5Ip5AkaYSX5ZFG+jVVPNIMKWIXo/abSTOaJIXbE61zsNn3Hmb
	 40EK99JQ96KPw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8ABEB60081
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:58:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4] netfilter: nf_reject_ipv6: fix locally generated packet to local address
Date: Thu, 22 Oct 2026 17:58:54 +0200
Message-ID: <20261022155854.2004977-1-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: do not move route lookup before, this seems to interfer with the special loopback case.

 net/ipv6/netfilter/nf_reject_ipv6.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..8551e40faf04 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -445,8 +445,19 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 		skb_in->dev = net->loopback_dev;
 
 	if (hooknum == NF_INET_INGRESS) {
+		const struct inet6_dev *idev;
+
 		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
-		IP6CB(skb_in)->iif = skb_in->skb_iif;
+
+		if (skb_valid_dst(skb_in)) {
+			idev = ip6_dst_idev(skb_dst(skb_in));
+			if (idev)
+				IP6CB(skb_in)->iif = idev->dev->ifindex;
+			else
+				IP6CB(skb_in)->iif = skb_in->dev->ifindex;
+		} else {
+			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
+		}
 	}
 
 	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
-- 
2.47.3

