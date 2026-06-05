Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05B51A3160
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665098; cv=none; b=a+wFs6mD1p4DKpWQIhSz+UluUnSzAOzGSxWQrmpIE4ERxsWntU0rc42VEYYBJyTLApJKrDxGVqQYkCu30dLgWZfYKOeukHzJAN/EKou+NI6N8wvLq2o3YSrdYxIG8OVg1cyxLc9ZxvmDMkXgAbr6cmisBX+7hEGjLVL+3u1qZso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665098; c=relaxed/simple;
	bh=s/77MdnLB7eMiofCPN2VNt0beCx3tnIIOkznVTShK2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2NyZZuzdWRb8AQ6OC4E0K036UzFjgL8XZsEHvnoqVUib1032lCzAa2qQuhGEvlTXHRruJF0o/yxaVded99TOIvDdlt2qdeRocgpze1B+ThCQeHc+ZztopNWkFvqxyRnLdX9jNuDXDXSp88fMzdcDgXwOOl4ZJQIIapCQS+KCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 00A4460425; Fri, 05 Jun 2026 15:11:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 1/5] netfilter: nf_conncount: callers must hold rcu read lock
Date: Fri,  5 Jun 2026 15:11:19 +0200
Message-ID: <20260605131123.19435-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605131123.19435-1-fw@strlen.de>
References: <20260605131123.19435-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcu_derefence_raw() should not have been used here, it concealed this bug.
Its used because struct rb_node lacks __rcu annotated pointers, so plain
rcu_derefence causes sparse warnings.

The major tradeoff is that rcu_derefence_raw() doesn't warn when the caller
isn't in a rcu read section.

Extend the rcu read lock scope accordingly and cause sparse warnings,
those warnings are the lesser evil.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Closes: https://sashiko.dev/#/patchset/20260603230610.7900-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: no changes.

 net/netfilter/nf_conncount.c | 6 +++---
 net/openvswitch/conntrack.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index ab28b47395bd..81e4a4e20df5 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -499,7 +499,7 @@ count_tree(struct net *net,
 	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference_raw(root->rb_node);
+	parent = rcu_dereference(root->rb_node);
 	while (parent) {
 		int diff;
 
@@ -507,9 +507,9 @@ count_tree(struct net *net,
 
 		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
-			parent = rcu_dereference_raw(parent->rb_left);
+			parent = rcu_dereference(parent->rb_left);
 		} else if (diff > 0) {
-			parent = rcu_dereference_raw(parent->rb_right);
+			parent = rcu_dereference(parent->rb_right);
 		} else {
 			int ret;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 7c9256572284..c6fd9c424e8f 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1797,10 +1797,10 @@ static int ovs_ct_limit_get_zone_limit(struct net *net,
 		} else {
 			rcu_read_lock();
 			limit = ct_limit_get(info, zone);
-			rcu_read_unlock();
 
 			err = __ovs_ct_limit_get_zone_limit(
 				net, info->data, zone, limit, reply);
+			rcu_read_unlock();
 			if (err)
 				return err;
 		}
-- 
2.53.0

