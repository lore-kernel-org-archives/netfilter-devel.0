Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793664670;
	b=kPel6XiChKYgK8tF/rZeTygZYu/GufgwXnOc6TGF1eiGq+OgC3AV+1EosGc/C7JNbE9y
	 +fx+D1MlPvJhujy+fHD3Z9ShL9v7NzeczhUIeNtbEFLfFmbGsmR68KmCGIMBDVT7btgJQ
	 Syj61FpulGe945N3SGxAY9g21AlII6HdJvN/Z4MjZINiScKePy30rxp5nHIngO7n5Rnlf
	 NwLF4TQzDEEeTJIMzFSO9o6S6WQvfFtinHZPYs2a/uwgggvWHVqPUM7l6chC9+bf1FbOI
	 +hiPUpt07xGa3ELNtbUuCIsz5tbf28a6N6QsHL6VQTeflDG2cJH0BS9Igeoc7yyQ8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793664670;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=fYx82PF450mtCVkFsMXGvGkBMko96dPNczM0QIVlTyM=;
	b=vuJsATMShpT+1AL+/4u/yjeR5nHv/vzPEQZABJs1lqgS6MEZFKMJrScqlrtuBeI4j0Dd
	 /cFENKbeYYT+eSXOCrNSM680Js14I/01iJBxZJ0+KGnBGmBR1GYCSqj4sQNWWenNnLHQE
	 i87TXgLQ8y/956CcsYuESxG+OEBAfyucHital/0FztNR/ZmJHMFaYFA8dJx8J42fmFKuM
	 1m8T0u/pkm/4GdRLQBPzqb9vvdMMWHvTwaNsN9FsVQY0REeRX+Q7nAxhH9/FBxRcGZiN/
	 QiWNz8zZNNhJK0SQxYCVflxQDOrmcJJ1J+jAwVAp5zYL0i3FcpxzHtRCLxGotvlP3oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ndOXkRXi;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B260606A324
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 00:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B260606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ndOXkRXi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793664666;
	bh=fYx82PF450mtCVkFsMXGvGkBMko96dPNczM0QIVlTyM=;
	h=From:To:Cc:Subject:Date:From;
	b=ndOXkRXigC3QNQDDLZdf/IHJinAlpwF/ZaNwk8NuLAUEzFxxRtrmVKS+ERh2zTkXs
	 VCjamkomspVPBWHluGaqnHljPRUjHeHFeTK6/XqKvIt8NLClGun31OpMcfOoMLAkRF
	 Qh28eA2zP+IX0QLzbYF0X7pgxNzICqAGFPEoYPFM9gs0zfg3ORQvl5eCriop7fVp9i
	 ZZcQQpLfRl7orbHeH5Am+QSbxQ36Y38e4Wd7l70GSTLx1JNpo9EU6LBTMoJiB30tUB
	 RefiwV26b7i9gcapXAnvf8BZUCRV3UY1LRNiSVSBLqA3b6bR9o6PGP2JwNcysAnVxQ
	 t0tdoNUm9Jt8w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E64960054;
	Tue,  3 Nov 2026 01:11:06 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: do not scrub as crossing netns
Date: Tue,  3 Nov 2026 01:11:03 +0100
Message-ID: <20261103001103.564344-1-pablo@netfilter.org>
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

IPIP tunneling support does not result in crossing a netns, therefore,
adopt the more conservative variant of skb_scrub_packet() by specifying
!xnet, keep the existing skb mark in place.

Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Lorenzo: Do you remember the reason why this is scrubbing as crossing netns?
There is a LLM report that is flagging this as an issue when interacting with
other subsystem, eg. packets was marked. At least in the tunnel driver I can
see this is conditional.

 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..78bba416dd5b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	skb_clear_hash_if_not_l4(skb);
 
 	/* Push down and install the IP header. */
@@ -699,7 +699,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_scrub_packet(skb, true);
+	skb_scrub_packet(skb, false);
 	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
-- 
2.47.3

