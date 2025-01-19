Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6F886331;
	Sun, 19 Jan 2025 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737307270; cv=none; b=TnPYp/Rcv9eW8l7dO4XkiPebdB2rRjFRRjm3hcy/oiMgeAouhQaDkhunaMhevWGGHlPxcd2YTOMmyyOZhUET7An6rd0m747Dyw51pVStHIlDhwt6fMJk2KCHqQqFb2w4Q3MoZvZrhX4s75OPlP6Hkio4iHpsftRYKy6ojp4CdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737307270; c=relaxed/simple;
	bh=LWcSmBspHWeka0sHNHkTYxSbwhWDR4iq8THQAIynXuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vE5Y/ZmT0M/XhKTBx+9mTJCzIur7FuwA05G6rKomIA6mZKK0JKGdC6cjYuwvxx8omxDJty0nNFGnt4s1BjVa0IyOmKyjFEhPijcazWr6nXYeVQRqZZ66bA5DT6XgjkqMHlH1d+GF7deH7RoLE+wbjflr1KVOpN0Vemd/r0L0xtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 04/14] netfilter: nf_tables: Store user-defined hook ifname
Date: Sun, 19 Jan 2025 18:20:41 +0100
Message-Id: <20250119172051.8261-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250119172051.8261-1-pablo@netfilter.org>
References: <20250119172051.8261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
and store the interface name and length as specified by the user upon
creation. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f6958118986a..bd93d085b6fb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1201,6 +1201,8 @@ struct nft_hook {
 	struct list_head	list;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
+	char			ifname[IFNAMSIZ];
+	u8			ifnamelen;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e41c77e5eefd..95d8d33589b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2276,7 +2276,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 					      const struct nlattr *attr)
 {
 	struct net_device *dev;
-	char ifname[IFNAMSIZ];
 	struct nft_hook *hook;
 	int err;
 
@@ -2286,12 +2285,17 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_alloc;
 	}
 
-	nla_strscpy(ifname, attr, IFNAMSIZ);
+	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
+	if (err < 0)
+		goto err_hook_dev;
+
+	hook->ifnamelen = nla_len(attr);
+
 	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, ifname);
+	dev = __dev_get_by_name(net, hook->ifname);
 	if (!dev) {
 		err = -ENOENT;
 		goto err_hook_dev;
-- 
2.30.2

