Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456211717;
	Thu, 18 Jul 2024 02:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721268589; cv=none; b=N7LiOnMxSF7zh05R+kEemABObSGf9ufGZo8bxiFkOEt9AmMiIj7hDCRbw3yuw60HAREfa+DYMM/k8afgvqeHvieP7xCSRtkNpYwchsqRB++O2eaTG0K6e4opfbto3lkvJ1a2FIBl4GM+Azftorf4BwI0b9XXWLw3Pzg0BzKD5zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721268589; c=relaxed/simple;
	bh=ulv1tXiSd72eJq66dbBvV1+i3DdlZ3K/rCLvFN2wq6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JEdqjm+lHuPid0e3ucmJCrQz4eJVHkym9/XOy0Ri+GZc9klC+v2Qh4rTuDBV3JBPVg1KqVhBSTTXm1qeHDkUPuD+8q0YAoqB3ABO5rBQo7yfXNrP8kdpJ50Med1GfuqE5R1Wr2vwOg3By13lCz4gnvXeZ0Szzc0hc+tGwRrKMG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDuYYcdf; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDuYYcdf"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-79ef82c6391so11242085a.3;
        Wed, 17 Jul 2024 19:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721268586; x=1721873386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HIjoFDgLWia6GhzZOLluZd+9MD5Wkl/yCGIWN6hDfXo=;
        b=iDuYYcdfGsWtdYalKb40Rwu2L8W9EipczzGhkWs4P0yBIvYwfYQf/9j8GjvJtZvvUW
         EjhWaXFX+YGjnNZt0XWpORRjUjzmMNZZzHSoQ4U+lNOIg7W/+MS8R5SSm+FHqg56/eoh
         CrW9IK0MudJnHJmW3lDy3JazCxXYz4bIu4DED8ACvVghOWqDRJ6DF3nnxpgOay9n2R3f
         Vegr1UNH48zbJmDZmJNdZwuZAxuPfNAb89IX9qjs/U/lr/UkS3ERSkAtSjcS907kVHab
         C7+4Zn6oJkcujSCLx+4v0wuOTmO4ENNuemZ4L9d2EFNe0RRzBaToNwXTKfCz+oWmVD15
         fOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721268586; x=1721873386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIjoFDgLWia6GhzZOLluZd+9MD5Wkl/yCGIWN6hDfXo=;
        b=f50MJIbY7q4FcvUL+pAWgZ2bvFNcElYnmlo5OKwLc9xErvIOCn4zK9A1FzGZBsNfeZ
         aShaIsRNCWQf2xwEC9qZj9LiAi26zpp62TqgWtoHVYcikE6VCHIniWpJVaADxgl8uE5Y
         K21MTzd4FmXhIDXntpofyGZhw5w3ieT4CUn2VqmTuDS9vHp23z9s5UYmifB+/kfJ+hE3
         kcMWyOQ6IAyjwA3UxfdJE0PMsp6eug/l5MK7LB3I6KG0zp3GkciOxPceT50aJ8L0EWvc
         RWNxHMs6gqd6Xt1QCloVAJ44PYqXV9xI7QqmhNwYLbaXDnhHjtZaYmxanF3e2Qe2sjS0
         eLOQ==
X-Forwarded-Encrypted: i=1; AJvYcCV188aXyNs8j4eLGBIRR6/kIafKi8Q8AOVTz9NWFzE1Zht8sd8MtsSkYtZBDLo9iAs8QHrQPzPcd0szL3IdxsKK13CihjT0
X-Gm-Message-State: AOJu0YzBq4b1iuYWkx9yP5b4X8XcLpOZyM0x2azliDEBuvv57S8HfLsP
	dkQBd5YlN1ZsEFjMM5/4lzOCg6OPQNs66R0y1Zbny7Lar0efGxCveFycjQ==
X-Google-Smtp-Source: AGHT+IFrR0BhqA7+VbjsO6Av0aPL9qFq4JFg4BmEJkL1FNLB8Wc0/Hz2g0uV13PPQorM5Tzn+Gjjhg==
X-Received: by 2002:a05:6214:234d:b0:6b0:48fb:138e with SMTP id 6a1803df08f44-6b78ca22e8amr31417956d6.14.1721268586078;
        Wed, 17 Jul 2024 19:09:46 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b79c67b642sm3843296d6.146.2024.07.17.19.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 19:09:45 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	network dev <netdev@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pravin B Shelar <pshelar@ovn.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next] netfilter: move nf_ct_netns_get out of nf_conncount_init
Date: Wed, 17 Jul 2024 22:09:44 -0400
Message-ID: <7380c37e2d58a93164b7f2212c90cd23f9d910f8.1721268584.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is to move nf_ct_netns_get() out of nf_conncount_init()
and let the consumers of nf_conncount decide if they want to turn
on netfilter conntrack.

It makes nf_conncount more flexible to be used in other places and
avoids netfilter conntrack turned on when using it in openvswitch
conntrack.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
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
index 3b980bf2770b..056f6120ee36 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1576,8 +1576,7 @@ static int ovs_ct_limit_init(struct net *net, struct ovs_net *ovs_net)
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; i++)
 		INIT_HLIST_HEAD(&ovs_net->ct_limit_info->limits[i]);
 
-	ovs_net->ct_limit_info->data =
-		nf_conncount_init(net, NFPROTO_INET, sizeof(u32));
+	ovs_net->ct_limit_info->data = nf_conncount_init(net, sizeof(u32));
 
 	if (IS_ERR(ovs_net->ct_limit_info->data)) {
 		err = PTR_ERR(ovs_net->ct_limit_info->data);
@@ -1594,7 +1593,7 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 	const struct ovs_ct_limit_info *info = ovs_net->ct_limit_info;
 	int i;
 
-	nf_conncount_destroy(net, NFPROTO_INET, info->data);
+	nf_conncount_destroy(net, info->data);
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; ++i) {
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
-- 
2.43.0

