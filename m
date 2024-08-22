Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8EC1D1F72;
	Thu, 22 Aug 2024 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365193; cv=none; b=bzMQFBgukTuGfwJyQOOuSVBmBk04EobPdfj5G4BCS2JqohwqoE+R+I0cN94AU47maDNm+B163TEgjLYO3CvfM/ECubZggpA6NgY7na+kvagrKkm2HhJRmN8L8KtXB63SDYyniPbuisJi1l09pNxjcC0agQMGYTtpNZ0aBPwcS/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365193; c=relaxed/simple;
	bh=uIrfqigTbf6ewtVNDaonGYRV/UY7uaxUW5G+K9kr9nk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KaPH9octnYTb+PLDFM3ovJ/dPnuIq41RFkaS6RWFESigi8xV/rSPnnYkTJqTDPgt3WEoC6zxENW8HhlaZ1dxrBQzb9SL6I2U6C/vGVCWLAcwl0kv4EEyHqQzPXb8dWfyPPkdrUp4MaPXIzCMHqonFU/gnZTdgSsJB1FCsgoRdM8=
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
Subject: [PATCH net-next 6/9] netfilter: move nf_ct_netns_get out of nf_conncount_init
Date: Fri, 23 Aug 2024 00:19:36 +0200
Message-Id: <20240822221939.157858-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

This patch is to move nf_ct_netns_get() out of nf_conncount_init()
and let the consumers of nf_conncount decide if they want to turn
on netfilter conntrack.

It makes nf_conncount more flexible to be used in other places and
avoids netfilter conntrack turned on when using it in openvswitch
conntrack.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h |  6 ++----
 net/netfilter/nf_conncount.c               | 15 +++------------
 net/netfilter/xt_connlimit.c               | 15 +++++++++++++--
 net/openvswitch/conntrack.c                |  5 ++---
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index e227d997fc71..1b58b5b91ff6 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -15,10 +15,8 @@ struct nf_conncount_list {
 	unsigned int count;	/* length of list */
 };
 
-struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
-					    unsigned int keylen);
-void nf_conncount_destroy(struct net *net, unsigned int family,
-			  struct nf_conncount_data *data);
+struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen);
+void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data);
 
 unsigned int nf_conncount_count(struct net *net,
 				struct nf_conncount_data *data,
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 34ba14e59e95..4890af4dc263 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -522,11 +522,10 @@ unsigned int nf_conncount_count(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count);
 
-struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
-					    unsigned int keylen)
+struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
 	struct nf_conncount_data *data;
-	int ret, i;
+	int i;
 
 	if (keylen % sizeof(u32) ||
 	    keylen / sizeof(u32) > MAX_KEYLEN ||
@@ -539,12 +538,6 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	ret = nf_ct_netns_get(net, family);
-	if (ret < 0) {
-		kfree(data);
-		return ERR_PTR(ret);
-	}
-
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
 		data->root[i] = RB_ROOT;
 
@@ -581,13 +574,11 @@ static void destroy_tree(struct rb_root *r)
 	}
 }
 
-void nf_conncount_destroy(struct net *net, unsigned int family,
-			  struct nf_conncount_data *data)
+void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data)
 {
 	unsigned int i;
 
 	cancel_work_sync(&data->gc_work);
-	nf_ct_netns_put(net, family);
 
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
 		destroy_tree(&data->root[i]);
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 5d04ef80a61d..0e762277bcf8 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -86,6 +86,7 @@ static int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int keylen;
+	int ret;
 
 	keylen = sizeof(u32);
 	if (par->family == NFPROTO_IPV6)
@@ -93,8 +94,17 @@ static int connlimit_mt_check(const struct xt_mtchk_param *par)
 	else
 		keylen += sizeof(struct in_addr);
 
+	ret = nf_ct_netns_get(par->net, par->family);
+	if (ret < 0) {
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
+		return ret;
+	}
+
 	/* init private data */
-	info->data = nf_conncount_init(par->net, par->family, keylen);
+	info->data = nf_conncount_init(par->net, keylen);
+	if (IS_ERR(info->data))
+		nf_ct_netns_put(par->net, par->family);
 
 	return PTR_ERR_OR_ZERO(info->data);
 }
@@ -103,7 +113,8 @@ static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	const struct xt_connlimit_info *info = par->matchinfo;
 
-	nf_conncount_destroy(par->net, par->family, info->data);
+	nf_conncount_destroy(par->net, info->data);
+	nf_ct_netns_put(par->net, par->family);
 }
 
 static struct xt_match connlimit_mt_reg __read_mostly = {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a3da5ee34f92..3bb4810234aa 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1608,8 +1608,7 @@ static int ovs_ct_limit_init(struct net *net, struct ovs_net *ovs_net)
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; i++)
 		INIT_HLIST_HEAD(&ovs_net->ct_limit_info->limits[i]);
 
-	ovs_net->ct_limit_info->data =
-		nf_conncount_init(net, NFPROTO_INET, sizeof(u32));
+	ovs_net->ct_limit_info->data = nf_conncount_init(net, sizeof(u32));
 
 	if (IS_ERR(ovs_net->ct_limit_info->data)) {
 		err = PTR_ERR(ovs_net->ct_limit_info->data);
@@ -1626,7 +1625,7 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 	const struct ovs_ct_limit_info *info = ovs_net->ct_limit_info;
 	int i;
 
-	nf_conncount_destroy(net, NFPROTO_INET, info->data);
+	nf_conncount_destroy(net, info->data);
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; ++i) {
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
-- 
2.30.2

