Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5153F411B;
	Mon, 17 Aug 2026 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009415; cv=none; b=Pr7/fYHlcerUjKHmXRl4YQ/5Kl5Dd9ae4F04JidkCeGvKl2i2oP1GBO5yVFc3MjjzXZSgOXBptSQhZPQvVHpqJkYDVZZHx7o3lNppsYSxZoqUQNq11DBWnwocsQaMnMPnMYI8q3hqvZH3qQ88QRp7YFy9pwlmYGjm1k7CY/tpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009415; c=relaxed/simple;
	bh=PXdhRNegM3gATf5csHZrj3IrMOspETRPJIpDfVRJ+MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMEsXEhYoRR19dvHqE0WCFVAghPUYXIYMO8nDGJBmaWt9934EBpQvFgWMgzfm0LWCW1EURiS7UPRbA/G2IZkpq2xeVSz0sSCsdxc5TZ6+xYuj/k08mGA1EPbrc4hn3CHtNqiedVD1OlJ8w0F5ljmu2OtcBQEAOIgPbsqvcNye1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KitNumcu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KitNumcu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009410;
	bh=0zBmsEH3RMdt7+ogTv9bwiL2N9CldzLNE30HYWvl33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KitNumcu+Glt4Ov9nUq6eT+7OE3AavnySJOcPfXqwzn1HsoKaZc3sNVhksnx6kyyI
	 Kp8Vu791DTEQJJNXgz/8zXw1nN5zHvFujNBE9oU6QMPalDu79nay0hTwZaILygdo2l
	 LdH7Tu+I+/SBP+MpgTMzLg4X2rKoMndrPGwJ5IXWkyArvHUNyoJHGzF7i0AVPX+tCB
	 pe+92rxsQQ3+sjT5HNfADNeSWG93/q5+SUDxoPh8hszNr9Ra2WKaD70Thdzi/s58hy
	 WSTkzwbxOkxtQcmAHTbqzp0W003tV4VLIDVb3VPGeUW0QogagGLbvtv7MYXlsTS9Dd
	 XCr4JvnbOTVug==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 557D560090;
	Tue, 18 Aug 2026 01:30:10 +0200 (CEST)
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
Subject: [PATCH net-next 5/8] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Tue, 18 Aug 2026 01:29:54 +0200
Message-ID: <20260817232957.1281637-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose expectation flags included in the NF_CT_EXPECT_MASK bitmask
only. The DEAD flag is internal, do not expose it.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fc3f60099af3..9b4e29557ec3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3042,7 +3042,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.47.3

