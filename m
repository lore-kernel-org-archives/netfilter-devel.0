Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855573537EE
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787930641; cv=none; b=ap/zs40cJHim/8bYqNo4Eah7sg8fTnmwQ86dLYfs2NvZ5ofTFLlgjB1QNIgRW9q//GhhtWmJAJN6XoKZyLztAbLBPa2iBvwEdMrSw3TZJSJODYR/M7LgjGW5nFWccxDMUPotbcNIiir/OSrqMFXIkETQ/OQ6iKU7BZ9WedIpAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787930641; c=relaxed/simple;
	bh=i2rNPSmcYyp+LNO9HgQ4eEp/pDfk3xxECg+C/tGJ2v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2YCqV+3enTMTCB62Fq+azo5VlGHv11HE9wThec78OLxlyX9eRf6aQ/R00S4pMT+60byc3T6XvcrBj2OySFExaeng8CbShOzCoX65VbtnRfrW8HmIfIQKebtgZfSunK8qTb/fpIKfqOm7SWbb4JGfm871ADtlTBkL9J8JI1aD5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1E5BA60795; Fri, 28 Aug 2026 17:23:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v3 5/5] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Fri, 28 Aug 2026 17:22:56 +0200
Message-ID: <20260828152256.8759-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260828152256.8759-1-fw@strlen.de>
References: <20260828152256.8759-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: no change.
 net/netfilter/ipset/ip_set_hash_gen.h | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index e156ea725f3c..245a5dbd7d5b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -668,6 +668,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
 
 static u32 mtype_remove_key(const void *data, u32 len, u32 seed)
@@ -721,11 +738,8 @@ mtype_remove_random(struct ip_set *set, struct htype *h)
 	if (e && !ipset_hash_remove(h, e))
 		removed = true;
 
-	if (removed) {
-		mtype_del_cidr_all(set, h, &e->elem);
-		ip_set_ext_destroy(set, &e->elem);
-		kfree_rcu(e, rcu);
-	}
+	if (removed)
+		ipset_hash_elem_destroy_free(set, h, e);
 
 	return removed;
 }
-- 
2.54.0

