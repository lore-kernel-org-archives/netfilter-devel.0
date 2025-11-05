Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB133372C
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361337; cv=none; b=dpkiRESOynv2P1/D4JqRP1aLN6GjDBze32+HUsU7/Rcte13CaH12B16DQJqYEz3g+pVu4hAuEd7nkSMiKidUuPBth+TsF/EBAb7pseJm6tCw/QOeV9kL+mVfp0ur3lW8szAzfQs8fHlaTiR7KikDdPpZTuJfyIyd+qwcKZgo6tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361337; c=relaxed/simple;
	bh=8hW75Y7rVbc8VEviOcbhA8sMVCcUV6rsGWbnONVa92w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn8SmjqpZK0O6gMU02XoxjIeAaxq/4/BvaIbesjVsMUo/H0QXWrWbdhTCkbLIec1xJiCzyjDj4sIhudUCwGvdqnwaK+avYxUpWMXZ7BvJKRPhXkTStD2cOMOZ3DNOIDW2MAsHqJCXiSC8WN9Che0rmOI5t4Y9x6NDTdRttz09B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3DF5D603B8; Wed,  5 Nov 2025 17:48:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 09/11] netfilter: conntrack: delay conntrack hashtable allocation until needed
Date: Wed,  5 Nov 2025 17:48:03 +0100
Message-ID: <20251105164805.3992-10-fw@strlen.de>
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

Don't allocate the hashtable at netns init time.
Delay this until userspace requests it.

For netfilter users (iptables, nftables), do it before we register the
first conntrack hooks.

The table is allocated in any of these cases:

1. ctnetlink tries to insert an entry
2. sysctl is used to reallocate the table (reallocation == allocation)
3. conntrack base hooks get registered for the first time

TC and OVS need special handling, call the new init helper where needed.

Hashtable release happens at netns exit time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_bpf.c     |  5 +++
 net/netfilter/nf_conntrack_core.c    | 57 ++++++++++++++++++++++++++--
 net/netfilter/nf_conntrack_netlink.c | 19 +++++++---
 net/netfilter/nf_conntrack_proto.c   |  4 ++
 net/openvswitch/conntrack.c          |  6 +++
 net/sched/act_connmark.c             |  6 +++
 net/sched/act_ct.c                   |  7 ++++
 net/sched/act_ctinfo.c               |  7 ++++
 9 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index e6c3a7dba8dd..7212bcaab02f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -347,6 +347,7 @@ struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
 int nf_conntrack_hash_resize(struct net *net, unsigned int hashsize);
+int nf_conntrack_hash_init(struct net *net);
 
 extern seqcount_spinlock_t nf_conntrack_generation;
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 4a136fc3a9c0..545ba9b70286 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -421,6 +421,11 @@ __bpf_kfunc struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
+	if (!READ_ONCE(net->ct.nf_conntrack_hash)) {
+		nf_conntrack_free(nfct);
+		return NULL;
+	}
+
 	if (!nf_ct_is_confirmed(nfct))
 		nfct->timeout += nfct_time_stamp;
 	nfct->status |= IPS_CONFIRMED;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index bbe195f34904..6e69b52572b5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -728,6 +728,9 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 	nf_conntrack_get_ht(net, &ct_hash, &hsize);
 	bucket = reciprocal_scale(hash, hsize);
 
+	if (unlikely(!ct_hash))
+		return NULL;
+
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
 		struct nf_conn *ct;
 
@@ -2579,6 +2582,14 @@ int nf_conntrack_hash_resize(struct net *net, unsigned int hashsize)
 		return -ENOMEM;
 
 	mutex_lock(&nf_conntrack_mutex);
+
+	if (!net->ct.nf_conntrack_hash) {
+		net->ct.nf_conntrack_hash = hash;
+		net->ct.nf_conntrack_htable_size = hashsize;
+		mutex_unlock(&nf_conntrack_mutex);
+		return 0;
+	}
+
 	old_size = net->ct.nf_conntrack_htable_size;
 	if (old_size == hashsize) {
 		mutex_unlock(&nf_conntrack_mutex);
@@ -2630,6 +2641,48 @@ int nf_conntrack_hash_resize(struct net *net, unsigned int hashsize)
 	return 0;
 }
 
+/**
+ * nf_conntrack_hash_init - allocate initial conntrack table
+ *
+ * @net: network namespace to operate in
+ *
+ * In order to not waste memory, the hash table is not allocated
+ * on network namespace initialisation, but when userspace requests
+ * the functionality.
+ *
+ * Memory is released from the pernet_ops exit handler.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int nf_conntrack_hash_init(struct net *net)
+{
+	int err = 0;
+
+	if (net->ct.nf_conntrack_hash)
+		return 0;
+
+	mutex_lock(&nf_conntrack_mutex);
+	if (!net->ct.nf_conntrack_hash) {
+		unsigned int size = READ_ONCE(net->ct.nf_conntrack_htable_size);
+		struct hlist_nulls_head *hash;
+
+		hash = nf_ct_alloc_hashtable(&size, 1);
+		if (hash) {
+			struct nf_conntrack_net *cnet = nf_ct_pernet(net);
+
+			net->ct.nf_conntrack_hash = hash;
+			net->ct.nf_conntrack_htable_size = size;
+			cnet->htable_size_user = size;
+		} else {
+			err = -ENOMEM;
+		}
+	}
+
+	mutex_unlock(&nf_conntrack_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_hash_init);
+
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 {
 	unsigned int hashsize;
@@ -2770,10 +2823,6 @@ int nf_conntrack_init_net(struct net *net)
 		max_factor = 8;
 	}
 
-	net->ct.nf_conntrack_hash = nf_ct_alloc_hashtable(&ht_size, 1);
-	if (!net->ct.nf_conntrack_hash)
-		return ret;
-
 	net->ct.nf_conntrack_htable_size = ht_size;
 	cnet->htable_size_user = ht_size;
 	net->ct.nf_conntrack_max = ht_size * max_factor;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d707ef7e2d75..47a966a15f07 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1227,6 +1227,9 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	int res, i;
 	spinlock_t *lockp;
 
+	if (!net->ct.nf_conntrack_hash)
+		return skb->len;
+
 	i = 0;
 
 	local_bh_disable();
@@ -2379,17 +2382,21 @@ ctnetlink_create_conntrack(struct net *net,
 	if (tstamp)
 		tstamp->start = ktime_get_real_ns();
 
-	err = nf_conntrack_hash_check_insert(ct);
+	rcu_read_unlock();
+
+	err = nf_conntrack_hash_init(net);
 	if (err < 0)
 		goto err3;
 
-	rcu_read_unlock();
+	err = nf_conntrack_hash_check_insert(ct);
+	if (err < 0) {
+err3:
+		if (ct->master)
+			nf_ct_put(ct->master);
+		goto err1;
+	}
 
 	return ct;
-
-err3:
-	if (ct->master)
-		nf_ct_put(ct->master);
 err2:
 	rcu_read_unlock();
 err1:
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 01eec82f4cba..be78cbe5b50b 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -580,6 +580,10 @@ int nf_ct_netns_get(struct net *net, u8 nfproto)
 {
 	int err;
 
+	err = nf_conntrack_hash_init(net);
+	if (err)
+		return err;
+
 	switch (nfproto) {
 	case NFPROTO_INET:
 		err = nf_ct_netns_inet_get(net);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e573e9221302..a5c1f575bbc1 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1402,6 +1402,12 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	if (err)
 		return err;
 
+	err = nf_conntrack_hash_init(net);
+	if (err) {
+		OVS_NLERR(log, "Failed to allocate conntrack table");
+		return err;
+	}
+
 	/* Set up template for tracking connections in specific zones. */
 	ct_info.ct = nf_ct_tmpl_alloc(net, &ct_info.zone, GFP_KERNEL);
 	if (!ct_info.ct) {
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 3e89927d7116..fbb296d19d87 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -121,6 +121,12 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_CONNMARK_PARMS])
 		return -EINVAL;
 
+	err = nf_conntrack_hash_init(net);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot allocate conntrack table");
+		return err;
+	}
+
 	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
 	if (!nparms)
 		return -ENOMEM;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 6749a4a9a9cd..12799e5ac056 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1366,6 +1366,13 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		NL_SET_ERR_MSG_MOD(extack, "Missing required ct parameters");
 		return -EINVAL;
 	}
+
+	err = nf_conntrack_hash_init(net);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot allocate conntrack table");
+		return err;
+	}
+
 	parm = nla_data(tb[TCA_CT_PARMS]);
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 71efe04d00b5..cc959bfe9abd 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -181,6 +181,13 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 				   "Missing required TCA_CTINFO_ACT attribute");
 		return -EINVAL;
 	}
+
+	err = nf_conntrack_hash_init(net);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot allocate conntrack table");
+		return err;
+	}
+
 	actparm = nla_data(tb[TCA_CTINFO_ACT]);
 
 	/* do some basic validation here before dynamically allocating things */
-- 
2.51.0

