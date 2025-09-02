Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6C340D97;
	Tue,  2 Sep 2025 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839557; cv=none; b=SwUCFy7fg7YPqS7nhPIqLoZSR+40hNVf8238p5uJxjdABTER1nFDxEXl4HN4FNrtZgqydfZ1xQev1Wu3AJE3+/w4TK+cD1fZsKSH1DC/YdwYp47CJdd54cz+TIFrVWMqEhfaQ/74EGNIRc5Q2mEu+4K3GfookVKGcpz6tbLezSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839557; c=relaxed/simple;
	bh=uJQFwJTuvfeIEy4YnJz/3qaOZZLyJo9xvYPfQP+2f2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2GskdbRte3D6NuKy3ToX5jxeCr6hAmPfIHSXgBoJt2YNtlAkDQ4YWmx9SkyLEdsgitceHjomv0HS4tfINeX0dDb6xtx+a5Z1qCI93wnu8RNuqpylVYIOh2cVrF+p0DuS+l92PXiBZJJ9gZyVn31p9E0Ig3T8E99aMbJ2EYjWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7266A60288; Tue,  2 Sep 2025 20:59:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/2] netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX
Date: Tue,  2 Sep 2025 20:58:55 +0200
Message-ID: <20250902185855.25919-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902185855.25919-1-fw@strlen.de>
References: <20250902185855.25919-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
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
index 58c5425d61c2..c1082de09656 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1959,6 +1959,18 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
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
@@ -1990,16 +2002,15 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
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
@@ -2310,7 +2321,8 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 }
 
 static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
-					      const struct nlattr *attr)
+					      const struct nlattr *attr,
+					      bool prefix)
 {
 	struct nf_hook_ops *ops;
 	struct net_device *dev;
@@ -2327,7 +2339,8 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	if (err < 0)
 		goto err_hook_free;
 
-	hook->ifnamelen = nla_len(attr);
+	/* include the terminating NUL-char when comparing non-prefixes */
+	hook->ifnamelen = strlen(hook->ifname) + !prefix;
 
 	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
 	 * indirectly serializing all the other holders of the commit_mutex with
@@ -2374,14 +2387,22 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
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
@@ -2427,7 +2448,7 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
-		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
+		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV], false);
 		if (IS_ERR(hook)) {
 			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
@@ -9458,8 +9479,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	list_for_each_entry_rcu(hook, hook_list, list,
 				lockdep_commit_lock_is_held(net)) {
-		if (nla_put(skb, NFTA_DEVICE_NAME,
-			    hook->ifnamelen, hook->ifname))
+		if (nft_nla_put_hook_dev(skb, hook))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.49.1

