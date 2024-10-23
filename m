Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B871F429E
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 22:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729722463; cv=none; b=S3EwnlSucTjypiycFt5213HlWIKdgvQfkhA3ZTzC+Lis7EltcjWwOjTY0qvZcueUb7wWzxVwbrUv+LE9G27g5UsWFWIaMkWeHksVLu9jmprVzmoPWWUSxZiNGWuU/jltdy3o6naByEEjXt8dE77rBO5/o/Gb8LhZHNa8llDNGRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729722463; c=relaxed/simple;
	bh=Sg5M6vGfofN6eHYxkEZJxGlkSE3OxW6vXuxRw47C3hM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KKT6NZHhcboYFhBJGheG6qlC/AL4r2HOrcu9Hti2V2o/yrcbtIqH4XOeaXoHZNwfb2xw9tzteIRl6XXxXmTBImCg2CxS4HIFEu+izxV/QK3PY1mD+wg29GAsv2jy8rFnZX71C1UYeWMCwTw24vq5eiEZ0n12hnA4mUkrH3YyER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] rule: netlink attribute offset is uint32_t for struct nlerr_loc
Date: Thu, 24 Oct 2024 00:27:26 +0200
Message-Id: <20241023222727.251229-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241023222727.251229-1-pablo@netfilter.org>
References: <20241023222727.251229-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The maximum netlink message length (nlh->nlmsg_len) is uint32_t, struct
nlerr_loc stores the offset to the netlink attribute which must be
uint32_t, not uint16_t.

Fixes: f8aec603aa7e ("src: initial extended netlink error reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index a1628d82d275..3fcfa445d103 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -695,7 +695,7 @@ void monitor_free(struct monitor *m);
 #define NFT_NLATTR_LOC_MAX 32
 
 struct nlerr_loc {
-	uint16_t		offset;
+	uint32_t		offset;
 	const struct location	*location;
 };
 
-- 
2.30.2

