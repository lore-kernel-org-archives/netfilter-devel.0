Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208C40A924
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787587443; cv=none; b=jKdlQnnc/wlcFOeZMqkogLdkvvRBWi3nypMp0B0qU10hWUtb8OJb5qRcTMnzfSIKBQGa3ZNHZeQYOCQiMl/UoXPa5NlMAunP1ANpamU8odm7eLGMkFQiai6IzZDd84KD85hN9uKXn4dkR3Ku3Ve535xB218G0Dwf3r3V5UTVQE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787587443; c=relaxed/simple;
	bh=VxjIimb7fERSGPIUa3r5Yhus37fYugItqrMBLCkMtQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL1VNtGnrCPVmLonled9UJaVd+0tmz4HpYL/kXGmHUj8HnfqoSgOTedvLfnH1JUoEp6VGNfhFnWqKnxkdQ8KohsF4ocRDgCdhqpLKUNjHEbE5eFXm6LwoNjnbMmxmgnToQJK4GCH97WYLeET417edSEbKgNW2GuanFOR3cD4V6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9FB4B6035B; Mon, 24 Aug 2026 18:04:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 5/5] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Mon, 24 Aug 2026 18:03:28 +0200
Message-ID: <20260824160328.12099-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824160328.12099-1-fw@strlen.de>
References: <20260824160328.12099-1-fw@strlen.de>
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
 net/netfilter/ipset/ip_set_hash_gen.h | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index d86ee5898773..266cab31180e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -658,6 +658,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
@@ -710,11 +727,8 @@ mtype_remove_random(struct ip_set *set, struct htype *h)
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

