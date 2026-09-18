Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948A4E5350;
	Fri, 18 Sep 2026 11:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730941; cv=none; b=fMT5r9NwX9kp/mRrpyqeW9GgJpFf9KFATyv5ECpopLl44XO1hPoX3DhYPmqsJoOrEMkSjNW62CHnv+9BcAcMH92e7hnNp5/rjDchdcZ9n+lasjzJ8Sgq2ouKnfHBva4YPpcS0QDlitIjf7oIRu4D6p+47L8Ht6MKNlautXy9meE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730941; c=relaxed/simple;
	bh=LRBAn/gSjLVMiBYvPCXU4zVNeROpHhD72QB9Hh1Yets=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYGypnVnhJ8EZDGAY8Tl/m4qADUHPR2S+DIuTArfqRe2HRqtbrW8+rpN/D03b5Hy0G9aAhdydX3gZZA0qwjsTTOm3wOYZi8IvHX759tVGb9wEiOD+8QT2zwBunHpvmGlq1zkD9tOhcG8WvpUjwCK0LDr8zIiCz1MQ967UnDpOIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QfcL/YsQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QfcL/YsQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730937;
	bh=pwI87iUI9Q4Tgu3BTmxXOF1xrw0BpTWMEKE/AgAXBLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfcL/YsQqWZasp++9Iobi4aVakFfsJzUEWuKcEgnpvynKiekeOxr51zXzWyxdZ8k1
	 mBoJQOQHa9g9i0isTFGy8SSA0LVcZifGufnKJhRGVaveyC3y3CU/vH2usMi2tLM/Ih
	 BHmyzxw4XwmaKAY4UXPlK4qkpeicx9Zaw0dPtqHmwRDDefZf44xRXtqdyljUufPVbL
	 xVhp8gPiB/RhOV/B5mMynsL7vAbnYUNraqka6VrzOkrkvRbp+l/iNi+Z8q1+vK7Vvn
	 73mNLVP63nv401bog2E3/namAUr/8FBmUjINPFwdJnio0aOADFBQiXx7uACrY3HSlH
	 76Q2BK5QThmVA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E594F60060;
	Fri, 18 Sep 2026 13:28:56 +0200 (CEST)
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
Subject: [PATCH net 6/8] ipvs: revalidate ihl before icmp_send
Date: Fri, 18 Sep 2026 13:28:42 +0200
Message-ID: <20260918112844.194503-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

While the outer IP header is already pulled into the skb head, we must
be careful and revalidate the embedded headers after reading them from
the skb frags to prevent possible out-of-bounds access.

One such place reported by Sashiko is ip_vs_in_icmp() where local
process can change the ihl field and after pskb_may_pull() we can see
larger value. Even if icmp_send() has checks to prevent out-of-bounds
access, play safe and add check to drop the packet if the ihl field is
changed.  As the outer headers are pulled, make sure the transport
header is updated too, it was used before commit 7fcc2fe39fed ("net:
icmp: avoid invalid transport header access in icmp_send tracepoint")

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Link: https://sashiko.dev/#/patchset/20260806105211.34622-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ba0957798bad..fd503f0efb57 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1960,6 +1960,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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

