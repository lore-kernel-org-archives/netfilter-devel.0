Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442280;
	b=JztuWXjGlEmuNhDEFzv9fD7hnke05TyNSw3SaoFH43iqcBNy8RZZSHeVbu/B9LWIyrhy
	 CyWClBvyDrBOdwlTyAVgC6e2DKJyls2yT39XoecmbQSQgzpBL26nQHE3+N4IYPhv9BaKz
	 ilN3dmq/fkgbi5o+J3rZ+uqG17NffbiViXlGLPUdfnpFRJchELO4mntso6XInmM4pVx1a
	 8UBlS2mcbePWSdlu0+ORQJV8yh6eRsi6OHnByxZonY0bSRGnW9nc83axpEjBECAP4Giqy
	 F5PnEWxufqmHXvepkdPxbFBBD4VZQ/cUTdf+M7uhG/4RHRqidbUSXfyEKnNPksFQZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442280;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=myUGGX+F6ZcHO7a3JIENspm3MjUjgJGi7zSbu1RcHZA=;
	b=Lr4mXnIjzZ/w4nlcQnBaepLX9HMNG8gpPwMs8R562nLXur1czaGaNfTEvaKcMbpjKJEY
	 bJUQO/LvzJjTbMNTtYrz+WkENCj7e6AlMAT9DQmf85VJwaaLFgy9VknV8ZPBbiYon/0Xy
	 qCbSsk+MRLoxNFZqVCVp83mKznYcLvDSqVb5c7oqj0hdCefZLo07ZOQnz4cKgScMdN4B2
	 mPAtK+/6tsMLz18jbj5QQe1LYsPQ9JIzkT4vvySdGKWBbnUgHu9O9z+4a4E1jI0YvBQOR
	 ebY6pwVLjRqyfOmtvrFzCBiDDRDaMSFahGkhKxA8MBGJCcr8EzFHR0f7iYlrrNwnaiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FLE5ZqIn;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFAE606A33D;
	Mon, 23 Nov 2026 13:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BFAE606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FLE5ZqIn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442277;
	bh=myUGGX+F6ZcHO7a3JIENspm3MjUjgJGi7zSbu1RcHZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLE5ZqInpE3/HcX3YBZyh7xUtP7y4PcO0N9lUNNi3GMQkitPolfYRXzNJ912boosE
	 bCLRSrQl8ykd2UmzCLLFsZkj94xgBjRroCMmN7NZh1QX51ijczYVvLqQTcdJInWugk
	 UI73HfSYAZCL5/T9JtRHfEyuzC6b+3ou9Uk2qHj7u+XoLUhiIrKCyX46g3V2BApjFe
	 p/OyGULIrJOFe9rZMEjIq3ye8M/jwVCPUJIFvbUvWXJn6OMM0Z/wKZNrLHFZl5vSBf
	 tVefZSnw2cRKB3HLubjr0DSMIGzzYEXvo1R/nGdsUEKSylrAe91iitk8buQe/i97dI
	 ++GmJ7swsVJDg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7CD0B602F8;
	Mon, 23 Nov 2026 14:57:56 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 13/15] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Mon, 23 Nov 2026 14:57:24 +0100
Message-ID: <20261123135726.3940688-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8ac1b0f04856..e7f2e584a7a5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -616,6 +616,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 	*elements = ipset_hash_nelems(h);
 	*ext_size = *elements *
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
+
+#ifdef IP_SET_HASH_WITH_NETS
+	{
+		const struct net_prefixes *nets;
+		int i;
+
+		rcu_read_lock();
+
+		for (i = 0; i < IPSET_NET_COUNT; i++) {
+			nets = rcu_dereference(h->rnets[i]);
+			if (nets)
+				*ext_size += ksize(nets);
+		}
+
+		rcu_read_unlock();
+	}
+#endif
 }
 
 /**
-- 
2.47.3

