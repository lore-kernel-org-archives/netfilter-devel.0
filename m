Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792535354;
	b=GlB7ogK5BYPAeKetRNWopDit2yVoEUGBlx0chzjIoKhXpEWn+ratiptB6XLoArsz/6eW
	 iVMrNkZqYb7hp4Jekkhn9SvqXQicYWviYtyEUTBro8KyxEnAxT53j80TeiB1T1IYMkrqN
	 x37XLBGln4nmhHxJjeVdTLe6IwrwWL4LE7Hb3O9NxnDanN4dglz0KLoDhM4TebVG/U+6z
	 Pvl6LRdzz1qyI3nDo/hXx9DqdQ648QAZApZGTmsExPZsGzvmz6RgoWsH1pX6UJ0YtJIcm
	 NixTaLo9zMtTDpkDQXTjOnafEW/5a41OGn1vGE1mYvprFV3ss4RSRXcNK2KO7PoTNeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535354;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=cKexEd8LcvDTEF/kszLQ4gFpnEYlIui7W9UKATALzA0=;
	b=QxJgWP80yVuFR5Hu4u9wY0mfV8OOACbXQj29RadLO9oVKlMu7AHz5h4AAVPVJT2grli6
	 vyjMYGFqlO6iyy83Q1ITvphVfZPgDEFlU7eGw+Z1fcVjyHUp/s9SH8dqfPB9cVZU5M6Id
	 3YTZGW7qQur+GaVhMnruR3SzG4eJa73/Ai/iimuecv9zSYO1ANdDfA1nLONYIElLrie/x
	 2+ISPK5iU3oZHxFkTfzSyFhEAI0PjHTw7JjeENhIdfcs6HQUUlm9ChOQxU3tRsye+DFg6
	 PuhB6ZHg3/31tpJQOB09wZrGwV4omYlu8r49TyhAoBE9fGnBrAsJDffbWUWK5FHglyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=M0aDA1mO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7271A606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 22:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7271A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=M0aDA1mO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792535352;
	bh=cKexEd8LcvDTEF/kszLQ4gFpnEYlIui7W9UKATALzA0=;
	h=From:To:Cc:Subject:Date:From;
	b=M0aDA1mONHQNy4rRb6j6qiV9/s523CX8l8xbtTI4rIkMxULveIqJPPf4JOzfN6mjN
	 sTRDaozCXQNEKc+yCGT+L2eynOsdskXnauqI69b7N998moXHGdBiJp6iClnFZr6RQk
	 BNl/KlTKMwzk9iKWQauSbDuNoSOe/1g32jjcx4cTi/HPrz1WkSC4CH9V+LXWgHhDVV
	 gvriZ5aiukjfWxl1KNuCoykiqh8+3yEeaUdowiC/WtrhxYUSHKzvLsaKEEBwuSl36P
	 9RXWrp5xWVENDcd34DHBBP/JerW9LeixPYA8G/lnA3moqFPCiQBESyBPGlOyVKB7DS
	 EcaEMUCufb5uQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2CE9660050;
	Wed, 21 Oct 2026 00:29:12 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf] netfilter: flowtable: use skb_pull_rcsum() to pull IPIP tunnel header
Date: Wed, 21 Oct 2026 00:29:09 +0200
Message-ID: <20261020222909.1937894-1-pablo@netfilter.org>
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

Use skb_pull_rcsum() to pop the IPIP and IP6IP6 tunnel header so this
works with CHECKSUM_COMPLETE.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index bb894c4f2b4a..f9b6119c9db5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -370,7 +370,7 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 	    ctx->tun.inner_proto != IPPROTO_IPV6)
 		return;
 
-	skb_pull(skb, ctx->tun.hdr_size);
+	skb_pull_rcsum(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
 }
 
-- 
2.47.3

