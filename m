Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52913F8DF2;
	Wed,  1 Apr 2026 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039826; cv=none; b=BmTRKcsvsH7huSDA2A0NIXSc5eWRivrss31lpt2m7xCbn97aJUpmtc68nvXR47X7s7im22zbO8aObf2CEcA9rUjVGCgx6jQTYMT25opPGp+po8NgxYXYONcxJhi7Zri0EIYIAaNUZ7kOQWv3vCyBHL77u3V/8V6ojY2+V+T6X1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039826; c=relaxed/simple;
	bh=LDua6l7j6jtNFsovAU9ikX1oFDfWHAgBdK+Ab7rUDf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVIu/W3M2llr0Ge1xPVE606ivdgym1xPibe6XjZjgMtzqKxpiM/wp8KITb2pR9gLjwV0TI9+IrFlFWJrVH/h+ZPt6NEIuSLauH66xqcl6wmSVP38kIySTujhqiIJH9hP4Szi2hrtir6VLio9ZkYvm2cKabGm01WGmex/P2JNhn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pQs8cMMb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pQs8cMMb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2231960272;
	Wed,  1 Apr 2026 12:37:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039822;
	bh=X324xNx22Xucf04VylLGVr4hQLPFQjcxmEpdO6xyMVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQs8cMMbEEY+NIzNyCskn9H+oEeQzSAfl5b4rtqNauRn1tfxU/4anMfw+42FXks/b
	 zHysIw+Y/nPBKA8+ts18goetGJazin3ppndDXhnr1cdC+D9gydl1kLdueuiTHt2BsM
	 T5OiI8VjBYke4m+i+icClf7VwWDnwjCfqxkQb/yG10W0+fQuzpPq4XOV/OJtb+N8U8
	 h2qQDaf/qqkR7umD5/Vs2y4gNrVrj4ZIeWMjOmGGHId5DEOePE+4n6jOfhWmOUXBrP
	 UkFrUION+BxVFXCO5YH8LYmQEjNigMU9kz/0E/KtkAKz4PtrXrxdQ0WzsxmIhXgDd2
	 rp7QAJje5ZyAQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/10] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Wed,  1 Apr 2026 12:36:44 +0200
Message-ID: <20260401103646.1015423-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yifan Wu <yifanwucs@gmail.com>

mtype_del() counts empty slots below n->pos in k, but it only drops the
bucket when both n->pos and k are zero. This misses buckets whose live
entries have all been removed while n->pos still points past deleted slots.

Treat a bucket as empty when all positions below n->pos are unused and
release it directly instead of shrinking it further.

Fixes: 8af1c6fbd923 ("netfilter: ipset: Fix forceadd evaluation path")
Cc: stable@vger.kernel.org
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 181daa9c2019..b79e5dd2af03 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1098,7 +1098,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
-- 
2.47.3

