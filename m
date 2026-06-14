Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EBB39FCC8;
	Sun, 14 Jun 2026 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437576; cv=none; b=ddMFhviEGIkjvVLz7JDqT0mXpSFGFNwSE+ZzoeEmOD4P+hfZWx4XX5HTkGlXtPuluuB9ieamZuJwzjmdbKX7g+N/4bY6ZgzSQcbjRmWVAC0U9d5W6+NbfKFgm4RZLSANaUb2TOucbs6UDCOL4jRwVwclFP3h72PciUnTj3Vlhzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437576; c=relaxed/simple;
	bh=ZVcDchxMiLjJ4Tdvd2pzQoiVQBvPX8+jZqXlo7jtgDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRigDZiRzBaA7CZnFWb+kGDOLIlN/NP9W0l+Hb3ao6RXOPSlWkOgNHg4UXi2p/lOwL/A7dan6zHEsQMgtBBtDCrrwG4T4tohYxboKhC68ahTdk3JvDoZR1h0Q7ynw/fZqzhTd0HG9Ie1zYD0qbebFgk6zR+3T2BnY8mm5XmX694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pL9fjbBI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pL9fjbBI"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E41D6019B;
	Sun, 14 Jun 2026 13:46:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437573;
	bh=VFILDsq6lReinWTJuU8H/g7KCPBs/GkApyvXdfYmgl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL9fjbBIAdHjhj5zlCiZlXh84GwJ8JZLipMdpNEqPm1Cf5sSMCLpfCd6aSiqrEJtK
	 rNdwQVvqRB9Wy4CkWWBs3t4DIxJNb13wx8S45J5l75bv7gNGD1vJzWzD/6qPHpMmsG
	 gB5QP/R1PJ5luqNZorODIOx6PxCLxmfnQLV/fz9DMgWEnOlASK8g45m/qWV4cnCvzz
	 +a59wtv9KqNeDs46gNRiMZ+R96/Cbkh+mqLIszuAnWZn//nc7chh7UB5IgIejCwYIi
	 chCJXD7hh+1G2Zd6Du+fTXaTMWvvc+1GwrjauuA85iDjCuokOHnwy9mYx7vM/AP3AA
	 VFi0AiRB1GzmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 03/11] netfilter: nf_conncount: callers must hold rcu read lock
Date: Sun, 14 Jun 2026 13:45:57 +0200
Message-ID: <20260614114605.474783-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

