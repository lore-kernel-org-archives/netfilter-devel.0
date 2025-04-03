Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F0924C09F;
	Thu,  3 Apr 2025 11:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743681487; cv=none; b=QjT3f98jnzCv6JK+s1JV+PFpkdUc74bVO66+FGg9d2MHdg3oo2wMp5RWNKbIKy3pmrCI8LJMBkAvgQqEodTO3jmxYmHdRD1MZ+eU5IMDH67wQGnqqxWcPC/+Ryb0lAleYoa6BqMfJVcwuyQDlig8QYr8XWRtgIwGelrcObtYbxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743681487; c=relaxed/simple;
	bh=GmFPSg3msBAwuO8Ba3nJQqzs7M/6zwxRi3rWQuUmHfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qakadSpZSJ7RTgM8YSpp0dlzAFcalghw6JYJv+JWdRusy2qrQm723g/4TzP805bivmzYi/8XDCIamcEU22eXNGLkZYeTAVhHm3Q638kU+m0BMhzYR4zaYqqEVRgrhHVHAMHyjzR+sASd/NUkMN8ad6WXoweLSzB84tj5+fBM67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vzQjVbzN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dGpX9usw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vzQjVbzN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dGpX9usw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C495960642; Thu,  3 Apr 2025 13:58:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681483;
	bh=BJYD028tH9CCyBESIrr1lBopoqzJNrWmxI8xceiy30Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzQjVbzN6Vff3n+NOsyVJqT5Fun4q/dhrUe33qN7o/rdjjVyX4zx97VN55qQGQATN
	 BXpdh87HuneG5BKXX6WZFXQKGSnxRcwTQzLv7rcr91iBFk4DrDK3gCoA4S8GL4YxCU
	 ZV5imVt/ZhuSHKcoAESITgt/ZOmJbfYD07HsioOPHdls7f8KhYdCbpPyLNfQSu66BG
	 cw4GLE0cE62i6wdd0MCINx3lifaY0qpj9+RYcq9+P2qAWdD8iBws3jT/KAqAJmAwHT
	 bM63WPyxoPOcWo46HU9odt2xz/Q5STpNYJBs6wsVg0Jy4f668YVnhHh3wXJxrIbR10
	 KTqF6++XNLQoA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CA4E96063F;
	Thu,  3 Apr 2025 13:58:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681481;
	bh=BJYD028tH9CCyBESIrr1lBopoqzJNrWmxI8xceiy30Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGpX9uswX9dKkUOGoy15YiHYhAfxCm9fa73oQgMhG7PbIfK4jej0dFbehIXdHk6Pq
	 F7vRbtSkP7MtOsvmk2tHj0kU3gqO7K/HLmYjXeOVK2mizS4RIrxp/LXpkZah25+Wa+
	 D2nzymw/dRCbMaTDIPHYMZ5PoRPHApWXDxNr5wtAlGbRfGUDjckKYp2ps0MDjrIRar
	 FmnihwpaKn89LDBmEknjrD1ad0WPqKZ8dgKUzqkvDjUt0D8m2YW+31LcE/tgzBK880
	 O3ej2DbcjfEdIao4IbcskjyrVtR8Yo71aaljoO62y/qwitD90GPokGw7jr9Z2JS1au
	 8+tXg2c7ZmoQA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/3] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Thu,  3 Apr 2025 13:57:50 +0200
Message-Id: <20250403115752.19608-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250403115752.19608-1-pablo@netfilter.org>
References: <20250403115752.19608-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

conncount has its own GC handler which determines when to reap stale
elements, this is convenient for dynamic sets. However, this also reaps
non-dynamic sets with static configurations coming from control plane.
Always run connlimit gc handler but honor feedback to reap element if
this set is dynamic.

Fixes: 290180e2448c ("netfilter: nf_tables: add connlimit support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8bfac4185ac7..abb0c8ec6371 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -309,7 +309,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.30.2

