Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F292EF9DD;
	Fri, 25 Jul 2025 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463040; cv=none; b=Ab8mffgd2rxxP9mOqySnnuFLH457+SzroqpRvVkkOHMgGKXe+rEV7cNS+9+8DmMrQ7ASvKijxbO45r8nbbZYmWF0ubU9LLUuCWW68TtEa9tyB3HBV81YRsF7Vklrlp+Xv55jAWocs7Qy+PV7PIjAnqWKmHDFxaezOOCqCcuKIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463040; c=relaxed/simple;
	bh=BOLU5QOK+YH/yG+PhN+P2flBYXG1/HheE+IOdsvn4gI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=deKEBTcMSl23IbAWRpSE7pXUTEDm1aaKpmT2jf9oslWJ9lch5Q2LXySiIs0SEgMfZ9hgvZ4tMqxYrAjGzK3C1oAtrflRTBXhJPfXB+w42nPCxVHzyIzJtskRx5yaDCjd+8EuaD0E7sxmfcyLELbs2p2p3OukTKAoWqogsnokZTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YJQtxwke; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KQ99mIe9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YJQtxwke";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KQ99mIe9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4FDF56027A; Fri, 25 Jul 2025 19:03:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463037;
	bh=Wn8h+Dbkwl8cqv+f3+hYtZ5OvocJ0emTTnm7f22XZs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJQtxwkebAHlBRQqU3a65AmCIIpzsjgIU+P+KIcR3xT91v7UmqLwCTQRPfER2IFQq
	 yvpDLifHPdX87S4aBRz7uXXz0o1XqzI4vwede+WST8DuoWVR2+Wdsp6VM7rwcDtrMA
	 PGIyC1PTSVsSSLjLdSgis1S812mAIXT+reH89nYQtDdGwgA2/ySGLyH1x2USpduTZ8
	 IiRIZA142th73ncKZ0UMRONWBzliQX68pelpdtRbBigDKHTTqw/Gmhlc/Mrjrq5nUX
	 yOBxzVQS59yCEWDupMTWhkVx0J3vXb0ful07LaNoUGngFNrzTeU8GprgrGdclO7Za7
	 wvim6pNNuzIaw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B095860276;
	Fri, 25 Jul 2025 19:03:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463036;
	bh=Wn8h+Dbkwl8cqv+f3+hYtZ5OvocJ0emTTnm7f22XZs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQ99mIe9lE6TouB8ZFOEYLO4CjJTF7ejkMDVTHxp0i99Mb02ccVolweZzBKRrbwas
	 AKuYg3vAKQjid6oz/JvqjtVV0EeoG+LJ4NVvcqWrhWZNBvEC6vIbPl4zys1tuDUdhG
	 xaT4zq/P0xu1mPTqDwbQdYSFNy3CKnyU3p/9A7KvUmJbqTRgEJ0+rj+Ak/xPgkyBxo
	 7lL/NoYn2nHqz1vwEaYZeoWkpgKaeoUBmcTLM0J9T+dRdjWLzBg69oRB4hLASz1Ibz
	 Blxq+HMdj5rkxTlhTGieZAkywmFqcFCu5BSaFBzCubjl2Hn45fXomaOV013NhQQ65f
	 CbqZ31R8AKeTA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/19] netfilter: conntrack: Remove unused net in nf_conntrack_double_lock()
Date: Fri, 25 Jul 2025 19:03:26 +0200
Message-Id: <20250725170340.21327-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yue Haibing <yuehaibing@huawei.com>

Since commit a3efd81205b1 ("netfilter: conntrack: move generation
seqcnt out of netns_ct") this param is unused.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fbd901b3b7ce..344f88295976 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -136,8 +136,8 @@ static void nf_conntrack_double_unlock(unsigned int h1, unsigned int h2)
 }
 
 /* return true if we need to recompute hashes (in case hash table was resized) */
-static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
-				     unsigned int h2, unsigned int sequence)
+static bool nf_conntrack_double_lock(unsigned int h1, unsigned int h2,
+				     unsigned int sequence)
 {
 	h1 %= CONNTRACK_LOCKS;
 	h2 %= CONNTRACK_LOCKS;
@@ -613,7 +613,7 @@ static void __nf_ct_delete_from_lists(struct nf_conn *ct)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	clean_from_lists(ct);
 	nf_conntrack_double_unlock(hash, reply_hash);
@@ -890,7 +890,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	max_chainlen = MIN_CHAINLEN + get_random_u32_below(MAX_CHAINLEN);
 
@@ -1234,7 +1234,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	/* We're not in hash table, and we refuse to set up related
 	 * connections for unconfirmed conns.  But packet copies and
-- 
2.30.2

