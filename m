Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85735439335
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011636; cv=none; b=MOiZyEvhj7mPPx7y58AkAu+dlcc7NLKJY6r3Qks1V1bbTUSJ7nYZdebFbdUQHoqhTPepORxxxl7YYlgMAcChqRvxfC2IVIBfLFikrLLioCa55pyGm8amCdc3dLXLMw2/IVjPjAxViHobpeRLkI756zptt4tgNADpnAOSKwTOaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011636; c=relaxed/simple;
	bh=9Q4pMGVMlnX+/JKAwumSfqfReXhqOAUIDJecmxrLAr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgBsvLFUag7AX4TJpKSozE4B5JJVgrxAEozkSgqT36s8ZtXYoD8A+CHTAkIWOuih1VkIxi37a4CyyVBjqKnolZqV2T/oTALZeaQpJfIXrRWiyp5YnPG6FdZNFj6pCqqy0Cmj5Gtk2F6YGf2w02T6PAw764CMeggjAAoiwxb8LC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8919F60240; Thu, 06 Aug 2026 12:20:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 7/7] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Thu,  6 Aug 2026 12:19:47 +0200
Message-ID: <20260806101947.2802-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260806101947.2802-1-fw@strlen.de>
References: <20260806101947.2802-1-fw@strlen.de>
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
 Not part of RFC.

 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 2bb3ec147ae3..506dae7cec82 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -643,6 +643,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
-- 
2.54.0

