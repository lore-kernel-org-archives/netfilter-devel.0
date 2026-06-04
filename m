Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764CA31A057
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585811; cv=none; b=HWJH4op/o5lMow5bEHieKCuSWT6ySy+vPeVh06lv0XFVp2MlNdzBNU0vU5/ajfdPOWkeZvIYm4AR5Ue8Y8WJ6dHqdLmN47P/HkW31MABOD+AkHMrpC4wW5/H4SvlidLNos3ufJOUaZJ/geCl4vjcDahb1jptO05AyWqfVe7GLe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585811; c=relaxed/simple;
	bh=lP8U1ipB3Y73Yly7DC2bq29vuycoA+Tj2neGOeL8wV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLT/oZfNM257yeKEwEqVt2o2oFWJgVgLSCC8ixUjDsDiFahQMmowglfu8giqaYIuOca+4lzOrSiV3sSKE0je+cStGNV+Wc1lMApWBUamNnMmjQVK6XTqIzsMUP8w6iPtCHGyCu1lxHHde7tuQMxF4MUp2MEHnaDozrU2ec1AVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CD83060337; Thu, 04 Jun 2026 17:10:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 1/5] netfilter: nf_conncount: callers must hold rcu read lock
Date: Thu,  4 Jun 2026 17:03:34 +0200
Message-ID: <20260604150338.163592-2-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260604150338.163592-1-fw@strlen.de>
References: <20260604150338.163592-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcu_derefence_raw() should not have been used here, it concealed
this bug.

Extend the rcu read lock scope accordingly.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Closes: https://sashiko.dev/#/patchset/20260603230610.7900-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: new in v3.

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
2.54.0

