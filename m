Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC029ACEE;
	Thu, 22 May 2025 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932815; cv=none; b=ax6/aVdQZb2976s9MstHqktKibTEd1zEII20Kedu/aluq/Z83oQ0+YLzeAvo3OJFGu0GhKzboYJwX25hqEteMw/pM2vmVEZ1/eMPtbZPiDaB9DMIJxPn4A/JtWVVWaWL/IZ/oD6XCXamRhqaPZJ3q+TTKrXk0llLljoFLrf4oUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932815; c=relaxed/simple;
	bh=huX5s2jt6QhetzdfiPHuuoJ42u8Z9XpNv3iMTITCNDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=on6YXIaYXY1gKsdQpJs3JOgNp/oZBB1yM71yFZg8Z/4wlVfw1wbvma4OjSTRA8QD5ERsmUdHRBViXCB+KYUvJl++WxCOIdJumWe4rIHtQ6jgmMYfw+knwyu/eXIpcqrf6WhdWJCUP9ma18NX3wvgniiX4INldQZ5izH12AO0IxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TyIbV5jk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AJHABPTh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TyIbV5jk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AJHABPTh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1A99A60713; Thu, 22 May 2025 18:53:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932813;
	bh=pO15yqgd3S7qV91H4F5ej5qFTOFZIB7kJNnWTuWGhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyIbV5jkhQKfn9QaNRTKVq4PmYa1XoylrlUFLTv2+CHkmcyTIUV5e8TieFVWLJ6YI
	 k30+0NcN8UAzTO9FugBunvKI2tD7xsYN8TMmd68QBmHWJratB9JRNsS1TnrJnaFG9F
	 2mFQRwqbVTCugaeCIHj+ElAVf3CIyTtUgJk4ihPBzeZXobNX88sLdRhWlzB2/TozTv
	 /E9kGKLdtZeqT1rIRPrTucJeaH3QH2pUMUIxOvzS0ey+HkqPXhfNdW363KwYPWph/F
	 2nceR22rdXtLZQJca5+vykyyjBkMfjkJktXC+bIVEfQdxkic08exDKngksQA4p+Gef
	 Elw+jEi5EhE2g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E798360729;
	Thu, 22 May 2025 18:53:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932781;
	bh=pO15yqgd3S7qV91H4F5ej5qFTOFZIB7kJNnWTuWGhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJHABPThtwC3yrFpxzJvlYucpsdtovdKmytznXVZF6tPskV33srAbLO54fOycz7DT
	 55SfkwBMTQf2MPn5OUBiwzQVP6Ql+DDJ4i5GdZD6SF5bvLCHU60rtc0lcO7tB798e2
	 YDlq596u84CbcBWNWWJXWA76DEMhx2Fln/ncoE6dLSiUU7IQ3+i+sl/MZRWE5XqPXh
	 54Cg4ds2PXcp5d3l2o2Phdmn9L+FBQhhUgjt1sFesSvDmUynxNi0KBdfdfxs+gtQG8
	 zo1YwpFNgYCV8akBGnUFQFzh6y5GiQT1TU0H3QhL719vOdiypUNE56pi2c3v/oiR9N
	 EjNy3m/3Mh4IQ==
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
Date: Thu, 22 May 2025 18:52:33 +0200
Message-Id: <20250522165238.378456-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
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

