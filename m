Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A9B2920BA;
	Fri, 23 May 2025 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006898; cv=none; b=g3fSi3VWXFhzx85uzN+lR1GqQr6ckxj5qy08d7kr4fotvrtCLmi8uyzj8rlvUldd41oy9XHQ/sOelO48qRWYuE/NiyV7jZGgkySKvgrMyp3+9jIws/QiipO35vxsggU7ckWKYfT8VJ/4ccYvA7qtxSv7+g/xcyCE3rlaPLOMBp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006898; c=relaxed/simple;
	bh=huX5s2jt6QhetzdfiPHuuoJ42u8Z9XpNv3iMTITCNDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fy3A29nJwiQ9t42qfVIdlDyehB5DnVlQzAFU/4ODVAvXsyP5hzDAYnUJPdFh775kh+zDgXbnM3kXnhAsHqa+OMMQxrvvK9/UdgepxCoOvMJx59yXKvfqBMuWrp/RK35ESx5lmFbGfhgoKRXH+9FTfjtzqTekNgP1VFGiA3kVqzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FFu5ngMY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZLVFMtjB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FFu5ngMY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZLVFMtjB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 24EBF606EB; Fri, 23 May 2025 15:28:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006896;
	bh=pO15yqgd3S7qV91H4F5ej5qFTOFZIB7kJNnWTuWGhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFu5ngMYnvZVY/Y/huPJsDvlo5VMV/OIiJGaAtoR1XlPKevHDZ0LGOqHgMCc4sOVn
	 fTj0JX3RP2Y/86gXnOeW12oTWlq/qlSNz87orDrpUBGm+rh9zvs205Q5R4nBpT7zP+
	 2KiaMSdn9rLIeV8b76sh3yQz5U6QCm3pbCq7pk6BhYV/qVS3ocEkQen9nP7t0Bk1XD
	 OpUBA01GEqqEUKT3zrUn+WCWgoJIvjn95RCGwXyYV2Fms1x84IYSa7OzGgQLqat3vx
	 uePxNSmm8jYpxC0VH9DfRLXYatGVEs+IC5sQGYQjNYO/Rsp86FgOFtD9XMCP/9ZlzQ
	 DN9VG6yxm1RIA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 028F260782;
	Fri, 23 May 2025 15:27:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006854;
	bh=pO15yqgd3S7qV91H4F5ej5qFTOFZIB7kJNnWTuWGhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLVFMtjByhBpe4lJp0KKYH9XtRPd3+nuqr0LMp+aEMgPuz6po1zlGzPnzAMXQR9wF
	 pBkjXHLfTl+yjeliLQ6bZpwaduCiCre03d8q6ETx+wo2EMhNeBN5I9NAA9Cp116d59
	 kxpFmRbZMPATiPY5I7kXrfJZ1WJmTG2e84ltRW+JsxTuFD2PZF55uS36Pnnntds5Sl
	 NaT1Qrcbj+H5MaAVek/ZJW+8tld3oc359K/HN49BIHljbN8BosN02fH6XQexrge+qN
	 F0UC5sKpG6Fqd+rBbI1cHFWtFc9Ccx+Bel5mwauW6zTmuOvh0nKCtAkvTHFDSN1KZy
	 /O1PzT6jo81Tw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 21/26] netfilter: nf_tables: Wrap netdev notifiers
Date: Fri, 23 May 2025 15:27:07 +0200
Message-Id: <20250523132712.458507-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Handling NETDEV_CHANGENAME events has to traverse all chains/flowtables
twice, prepare for this. No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    | 34 ++++++++++++++++++----------
 net/netfilter/nft_chain_filter.c | 38 ++++++++++++++++++++------------
 2 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f0f40aeccc0c..713ea0e48772 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9736,13 +9736,28 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
+static int __nf_tables_flowtable_event(unsigned long event,
+				       struct net_device *dev)
+{
+	struct nftables_pernet *nft_net = nft_pernet(dev_net(dev));
+	struct nft_flowtable *flowtable;
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		list_for_each_entry(flowtable, &table->flowtables, list) {
+			if (nft_flowtable_event(event, dev, flowtable))
+				return 1;
+		}
+	}
+	return 0;
+}
+
 static int nf_tables_flowtable_event(struct notifier_block *this,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct nft_flowtable *flowtable;
 	struct nftables_pernet *nft_net;
-	struct nft_table *table;
+	int ret = NOTIFY_DONE;
 	struct net *net;
 
 	if (event != NETDEV_REGISTER &&
@@ -9752,17 +9767,12 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
-	list_for_each_entry(table, &nft_net->tables, list) {
-		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable)) {
-				mutex_unlock(&nft_net->commit_mutex);
-				return NOTIFY_BAD;
-			}
-		}
-	}
-	mutex_unlock(&nft_net->commit_mutex);
 
-	return NOTIFY_DONE;
+	if (__nf_tables_flowtable_event(event, dev))
+		ret = NOTIFY_BAD;
+
+	mutex_unlock(&nft_net->commit_mutex);
+	return ret;
 }
 
 static struct notifier_block nf_tables_flowtable_notifier = {
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 58000b3893eb..7795dff13408 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -363,21 +363,14 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 	return 0;
 }
 
-static int nf_tables_netdev_event(struct notifier_block *this,
-				  unsigned long event, void *ptr)
+static int __nf_tables_netdev_event(unsigned long event, struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
 	struct nft_chain *chain;
 	struct nft_table *table;
 
-	if (event != NETDEV_REGISTER &&
-	    event != NETDEV_UNREGISTER)
-		return NOTIFY_DONE;
-
 	nft_net = nft_pernet(dev_net(dev));
-	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV &&
 		    table->family != NFPROTO_INET)
@@ -392,15 +385,32 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			if (nft_netdev_event(event, dev, basechain)) {
-				mutex_unlock(&nft_net->commit_mutex);
-				return NOTIFY_BAD;
-			}
+			if (nft_netdev_event(event, dev, basechain))
+				return 1;
 		}
 	}
-	mutex_unlock(&nft_net->commit_mutex);
+	return 0;
+}
+
+static int nf_tables_netdev_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nftables_pernet *nft_net;
+	int ret = NOTIFY_DONE;
+
+	if (event != NETDEV_REGISTER &&
+	    event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
 
-	return NOTIFY_DONE;
+	nft_net = nft_pernet(dev_net(dev));
+	mutex_lock(&nft_net->commit_mutex);
+
+	if (__nf_tables_netdev_event(event, dev))
+		ret = NOTIFY_BAD;
+
+	mutex_unlock(&nft_net->commit_mutex);
+	return ret;
 }
 
 static struct notifier_block nf_tables_netdev_notifier = {
-- 
2.30.2

