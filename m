Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263EEB660;
	Thu, 13 Jun 2024 01:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240542; cv=none; b=c+DtKUqQjcClwhOz9B+t8qj6ts0keibeJRsiFxBrHtJ2XvcT3w+7DY5yGOyxXnsUxZOYAZipZAnEhujThqG3BSaVoI51EFB4XeyxgNPojVcs8dgeqIs2yKAl0pE3iifZcmx6tuoYlSjMYTS1Tg4ZpQy8AFPIFCon9zN39jCcREA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240542; c=relaxed/simple;
	bh=t6/91beBzYiI5JbwqdOO1kgtlwKqiWwoKIv//s3hCSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gh13VkuI0uU61Fl87ttm7vSh+1yvJYc66utmt/CW0mP87QzE7FG1lTCU3XPd5HyNkE+SblXxTDSQmLzxLTXLswf3AIVL9JrRTJoIKpCsAEU+kggpmr6jYlzWwcxb7SCdz0vl6Hhz4XLY4UYeuzAItOLwFpvcvyD0N2oMdHMfKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 04/40] netfilter: nft_set_rbtree: allow loose matching of closing element in interval
Date: Thu, 13 Jun 2024 03:01:33 +0200
Message-Id: <20240613010209.104423-5-pablo@netfilter.org>
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

commit 3b18d5eba491b2328b31efa4235724a2354af010 upstream.

Allow to find closest matching for the right side of an interval (end
flag set on) so we allow lookups in inner ranges, eg. 10-20 in 5-25.

Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 60ef5dea89fa..81b69aa7e35c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -145,9 +145,12 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 		d = memcmp(this, key, set->klen);
 		if (d < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
-			interval = rbe;
+			if (!(flags & NFT_SET_ELEM_INTERVAL_END))
+				interval = rbe;
 		} else if (d > 0) {
 			parent = rcu_dereference_raw(parent->rb_right);
+			if (flags & NFT_SET_ELEM_INTERVAL_END)
+				interval = rbe;
 		} else {
 			if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = rcu_dereference_raw(parent->rb_left);
@@ -170,7 +173,10 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
 	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_interval_end(interval)) {
+	    ((!nft_rbtree_interval_end(interval) &&
+	      !(flags & NFT_SET_ELEM_INTERVAL_END)) ||
+	     (nft_rbtree_interval_end(interval) &&
+	      (flags & NFT_SET_ELEM_INTERVAL_END)))) {
 		*elem = interval;
 		return true;
 	}
-- 
2.30.2

