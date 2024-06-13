Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBF9B664;
	Thu, 13 Jun 2024 01:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240543; cv=none; b=u9ktbAz7wVSxmdmOc0S5bYZn4kr7zVEVgg7UUtEAWUZEz0LPC37Aoik3bCm0B8hcz3Q6GhhVaTWek/cfo6sJ487d43ZsO9vYBZhAhzwUCC7eWNOF7FBvdd6uDgcks7ZQCRF2JT6XtKwoG5e+J+NTdedKVigwg3mmTAjK4qC5Qfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240543; c=relaxed/simple;
	bh=PsdsJQNFnmjB7UYbPQ/+ne4chvM5RdUIiTtzk7/fRiE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FiKJmDWfRjfrnhSCb/wuAEEA+z/I1wrnHeUpQtdRWVPUPdxAXSQEqsws71r/nyCw+80swvmpAYS/uErLewsQobPvuEf4asM9jBNFcZ7Qo+8/IEqZFP5ZMGIQwFtoQ05AlDQxm4xu5J8JZ7rX+bYpARBYb9Nm01CAU/kw/IZiu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 05/40] netfilter: nft_set_rbtree: Add missing expired checks
Date: Thu, 13 Jun 2024 03:01:34 +0200
Message-Id: <20240613010209.104423-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

commit 340eaff651160234bdbce07ef34b92a8e45cd540 upstream.

Expired intervals would still match and be dumped to user space until
garbage collection wiped them out. Make sure they stop matching and
disappear (from users' perspective) as soon as they expire.

Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 81b69aa7e35c..43c9cd5d6078 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -82,6 +82,10 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
+
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (nft_rbtree_interval_end(rbe)) {
 				if (nft_set_is_anonymous(set))
 					return false;
@@ -97,6 +101,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    nft_rbtree_interval_start(interval)) {
 		*ext = &interval->ext;
 		return true;
@@ -157,6 +162,9 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
+			if (nft_set_elem_expired(&rbe->ext))
+				return false;
+
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
 			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
@@ -173,6 +181,7 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_set_elem_expired(&interval->ext) &&
 	    ((!nft_rbtree_interval_end(interval) &&
 	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
 	     (nft_rbtree_interval_end(interval) &&
@@ -360,6 +369,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&rbe->ext))
+			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.30.2

