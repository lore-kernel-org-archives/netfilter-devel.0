Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F7337BA6
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361315; cv=none; b=MsDGzS09q7arqsJtGQ7QbGsTKHQ2cvwtGeWPdFpQjO/jT6PJaOpdx/NpfeI/6U08P4am+/eUiSENnJUkwXkBhjEtZROOGkvukhpXx47ZzkTwt+TTx1vnmVKOX5d3JAjdXH2+dKA8qWevMrR1kKLs08zN0QcJO5Y+9FX3nWz1IW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361315; c=relaxed/simple;
	bh=oMspLXhoGudJatRa0k2tij+Oej4d79W6X+5bAf5k2Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2QDDsiniHBHikofqRPmK1Irtkr5z4N8IPq/MrHq+0iEDEmwBANv5SmnDY6zLP8x430kXGqzAG2+GZUd61t7JVh6rvg5zzE2CQBsS1IHI13UlQUoUkuA+WiGNI/6TUF0idvf68SXK+kDH/zaoiYOD9spZ8EISZeDtjvxCIXo+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 68C726020C; Wed,  5 Nov 2025 17:48:32 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 04/11] netfilter: conntrack: pass pointer to buckets instead of index
Date: Wed,  5 Nov 2025 17:47:58 +0100
Message-ID: <20251105164805.3992-5-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparation patch to ease later conversion to pernet table.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fa6e5047d15b..fc9312bfa616 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -824,13 +824,13 @@ nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
 
 static void __nf_conntrack_hash_insert(struct nf_conn *ct,
-				       unsigned int hash,
-				       unsigned int reply_hash)
+				       struct hlist_nulls_head *head_orig,
+				       struct hlist_nulls_head *head_repl)
 {
 	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			   &nf_conntrack_hash[hash]);
+			   head_orig);
 	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
-			   &nf_conntrack_hash[reply_hash]);
+			   head_repl);
 }
 
 static bool nf_ct_ext_valid_pre(const struct nf_ct_ext *ext)
@@ -926,7 +926,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
-	__nf_conntrack_hash_insert(ct, hash, reply_hash);
+	__nf_conntrack_hash_insert(ct,
+				   &nf_conntrack_hash[hash],
+				   &nf_conntrack_hash[reply_hash]);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
@@ -1302,7 +1304,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * setting ct->timeout. The RCU barriers guarantee that no other CPU
 	 * can find the conntrack before the above stores are visible.
 	 */
-	__nf_conntrack_hash_insert(ct, hash, reply_hash);
+	__nf_conntrack_hash_insert(ct,
+				   &nf_conntrack_hash[hash],
+				   &nf_conntrack_hash[reply_hash]);
 
 	/* IPS_CONFIRMED unset means 'ct not (yet) in hash', conntrack lookups
 	 * skip entries that lack this bit.  This happens when a CPU is looking
-- 
2.51.0

