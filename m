Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64E9204583
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754574609; cv=none; b=HPSmGzePFE8NlheFiNCnVMwoKkbvR95Op0uAThDlPeRVupqYUULCq4appOyOYgDANU/dU8h1b1fv2yqsZx4NbdSI25FtnN64y8mG+7O92z8DyxU2eOq4sD1xU7k9AAoGgfxk6e73EB//vbJnXEoNEjoCALOxhIObaiEpM+Lp7l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754574609; c=relaxed/simple;
	bh=/pLp4pWVIEkPaZa3ey6RyY+SyalhBm2cCIVUqWVcNxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=laYAGrcsPcyRGC/Vvr52RQ9IUOmQxnTSTjTmcww4rxo+jc8/xj1Wd1BbMPStm5pmB/WOUsT2qNp+tEkWXjm+rJ6G+8ywnAGfJtQJDDNDWHYXlAHE6lzR2T6Ondfr8el/Dfy7wL7xf+yRZElIKfJf5sCwPIGTX83pfdUxrxRSQLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=htNA1KHQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="htNA1KHQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XjBAXK95jbPsjBdvfElNYE0xZmFPikHuM/86HFsDKdo=; b=htNA1KHQwlj2wxz/LThebAwTDT
	4W4fJg/xUmbVF42OrWhEoFkZodMLTlJWccpqvcbC7bfgcoIIEYrq5HzOnR9VamY2h0kmg8IcT792t
	qcKSUiHdYzA65QcDjABS9ZRWEWt6TN0POkdXjpftGAMY+fDdY9l+PKuAGXmMpfXmaBJf/G+p3gUiU
	0IVjApnAZKnt+TiG26UA/QdseyobOhC0AZ+NhGjy42f+jzubkc8El2V2Yu6o2xi1zcYJVOzcmxKWc
	ynnQ+/7u0Cz6ILH9LY7iBcLo9egrN9G1WdNuRpL5G/GyG65RQXYANhDvV2EPSs6bmrdvLRRRxpQXg
	GOGyLwxg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uk10O-000000002rr-2Uwt;
	Thu, 07 Aug 2025 15:50:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX
Date: Thu,  7 Aug 2025 15:49:59 +0200
Message-ID: <20250807134959.1815-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new attribute is supposed to be used instead of NFTA_DEVICE_NAME
for simple wildcard interface specs. It holds a NUL-terminated string
representing an interface name prefix to match on.

While kernel code to distinguish full names from prefixes in
NFTA_DEVICE_NAME is simpler than this solution, reusing the existing
attribute with different semantics leads to confusion between different
versions of kernel and user space though:

* With old kernels, wildcards submitted by user space are accepted yet
  silently treated as regular names.
* With old user space, wildcards submitted by kernel may cause crashes
  since libnftnl expects NUL-termination when there is none.

Using a distinct attribute type sanitizes these situations as the
receiving part detects and rejects the unexpected attribute nested in
*_HOOK_DEVS attributes.

Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 42 +++++++++++++++++-------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2beb30be2c5f..8e0eb832bc01 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1784,10 +1784,12 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_PREFIX,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a7240736f98e..9f0eef139930 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1958,6 +1958,18 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
+static bool hook_is_prefix(struct nft_hook *hook)
+{
+	return strlen(hook->ifname) >= hook->ifnamelen;
+}
+
+static int nft_nla_put_hook_dev(struct sk_buff *skb, struct nft_hook *hook)
+{
+	int attr = hook_is_prefix(hook) ? NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
+
+	return nla_put_string(skb, attr, hook->ifname);
+}
+
 static int nft_dump_basechain_hook(struct sk_buff *skb,
 				   const struct net *net, int family,
 				   const struct nft_base_chain *basechain,
@@ -1989,16 +2001,15 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
 			if (!first)
 				first = hook;
 
-			if (nla_put(skb, NFTA_DEVICE_NAME,
-				    hook->ifnamelen, hook->ifname))
+			if (nft_nla_put_hook_dev(skb, hook))
 				goto nla_put_failure;
 			n++;
 		}
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
-		    nla_put(skb, NFTA_HOOK_DEV,
-			    first->ifnamelen, first->ifname))
+		    !hook_is_prefix(first) &&
+		    nla_put_string(skb, NFTA_HOOK_DEV, first->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -2307,7 +2318,8 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 }
 
 static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
-					      const struct nlattr *attr)
+					      const struct nlattr *attr,
+					      bool prefix)
 {
 	struct nf_hook_ops *ops;
 	struct net_device *dev;
@@ -2324,7 +2336,8 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	if (err < 0)
 		goto err_hook_free;
 
-	hook->ifnamelen = nla_len(attr);
+	/* include the terminating NUL-char when comparing non-prefixes */
+	hook->ifnamelen = strlen(hook->ifname) + !prefix;
 
 	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 	 * indirectly serializing all the other holders of the commit_mutex with
@@ -2371,14 +2384,22 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
 	int rem, n = 0, err;
+	bool prefix;
 
 	nla_for_each_nested(tmp, attr, rem) {
-		if (nla_type(tmp) != NFTA_DEVICE_NAME) {
+		switch (nla_type(tmp)) {
+		case NFTA_DEVICE_NAME:
+			prefix = false;
+			break;
+		case NFTA_DEVICE_PREFIX:
+			prefix = true;
+			break;
+		default:
 			err = -EINVAL;
 			goto err_hook;
 		}
 
-		hook = nft_netdev_hook_alloc(net, tmp);
+		hook = nft_netdev_hook_alloc(net, tmp, prefix);
 		if (IS_ERR(hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			err = PTR_ERR(hook);
@@ -2424,7 +2445,7 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
-		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
+		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV], false);
 		if (IS_ERR(hook)) {
 			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
@@ -9419,8 +9440,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	list_for_each_entry_rcu(hook, hook_list, list,
 				lockdep_commit_lock_is_held(net)) {
-		if (nla_put(skb, NFTA_DEVICE_NAME,
-			    hook->ifnamelen, hook->ifname))
+		if (nft_nla_put_hook_dev(skb, hook))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.49.0

