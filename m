Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD233D7A07
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664561; cv=none; b=MbLHIAFtyJq2aVthe7CfTaykwHvHWYZhCN2Wr2L8EGf1g+AHRH+QLiaUODxitLob6IdmOIPowhLgKrNysmwufMqnKsaA+7Y2/XVXODlrI+Ywg8q1HgQgHmfjkNV3XVoVum/DsvOPQBckzAc4nF8/AX+Mg5OLI3Sro2c0tsiSdsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664561; c=relaxed/simple;
	bh=oiLh9KwqRJhppfe3knovdQXyJ2Ys/O8Sx7x7TD3kefA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nA60WXr0fTKjCskr5hVQ+SdYaxNRDOyRNYuyKo0xzwWrH2NNUIBSW5dDXkNMbbTVhV+I7W1Z9hTeESawaG8ImaWh2yceyl1rkS71wLdksINBIFvkwU//wbKQS7e4P3rqL0z5G/YhUqH200Q8BDXD1gXeDDUR18obQ+Y/QtPtRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 855AF6027F; Tue, 25 Aug 2026 15:29:18 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 5/5] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Tue, 25 Aug 2026 15:28:43 +0200
Message-ID: <20260825132843.1692-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132843.1692-1-fw@strlen.de>
References: <20260825132843.1692-1-fw@strlen.de>
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
 v2: no changes.
 net/netfilter/ipset/ip_set_hash_gen.h | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1bb803be3dcb..dd30dcb5b157 100644
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

