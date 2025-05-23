Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EF629345B;
	Fri, 23 May 2025 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006900; cv=none; b=K6czmKbrw6HwBMyCteX9z+V93/5+H0svKZ3YFO5jHawhl7qn/CymnOQVT8aTrfAynbCQv2FhXlxy46o14EADRkCAUMzkPaKX0Ro1ArccxjYGkSCQT8ks3xepG4bC5RVFW/It1hsimdyhy/Zefy6KXnbwcc7UGaJquPDBuV/A2s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006900; c=relaxed/simple;
	bh=R3ku4dQRx0EnSTgnWW4dEk/tS7kOM5uKTUJUGxk5GgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDxFhWBzb94+qDw46shqNOutE0HGBwUZoMYYzbpz7Di+sx423goPa9QYWu8H4n2YnmERdpEoNQNH5m9hKloyJA/LFDjB68c5Vjg34v2sNvMgeeO/P54LwaAsWckrxi88+QQVbKAyymgc8FybzlLGm/VBy1MPUofen6SV3udQq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FkuP0rFw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UDh9e9rj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FkuP0rFw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UDh9e9rj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8420D606F1; Fri, 23 May 2025 15:28:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006897;
	bh=VqiTHhMZ9biq751h23zm4+9hDI1M7W9afAkweMrigW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkuP0rFwL9qf9/e7sPKp8ABrJ4B3Jbas5vo5ULVNpnWiDlMmhgnOKjU4iAN5GygoQ
	 v8xEl7ttG03pXawRv4gvY1XjYfpVuKUZg3XNWTCF9TMylb2GtQY2TpeOyOW5d27CxM
	 tVVhpPU7QahZdZJ+T7tQjnTQd6Kt6TikJ/0IHsXR5Jxz/rideT6CvXVCx3FGWfFAOI
	 +bTOpJiLWs/NkkGOzxd9GSiH3yicYW/aSZv63eKO624ZMQqXCAswuV2BZ5epKxU+iF
	 6n0jwU0ychFrDNtQimF5w1GMqaekx9bh/zsl9LTjwIAVkTTks98k+FpK3ZeVwYv6Wq
	 ox0y3toUzlvRg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ED24A60777;
	Fri, 23 May 2025 15:27:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006856;
	bh=VqiTHhMZ9biq751h23zm4+9hDI1M7W9afAkweMrigW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDh9e9rjv44g2Pd1uLLu33hWv7SWw98L9aCTiuL0d9/pdGdyqNpAxdxJwcGjr902P
	 9jMazqTe7cKI3wtP9FTY4sqkRN5x7OLr8zS1AiLuPznPxQDhc4rnAITsfM1ahjQ5/Y
	 f5InawSrC+Cv5oUHTUd8mIaYkvEJOcqzR2SXvhDYCp1RQ86zz2JTjbd7JaXI6TV61Z
	 ee5xW1tGisAPlBzWB7DVge9V8oJvnClPQoLorPxcqxbpk3wwllBLXAed/RBB5iRBlI
	 564KHAnPXeU1AO8zZHVQ6hKd6WFgg5BgkviRhSbxq4zuXZKVoYCI+zNbH2JUV3VIAY
	 UoWhKHvLFz7eg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 24/26] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Fri, 23 May 2025 15:27:10 +0200
Message-Id: <20250523132712.458507-25-pablo@netfilter.org>
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

User space may pass non-nul-terminated NFTA_DEVICE_NAME attribute values
to indicate a suffix wildcard.
Expect for multiple devices to match the given prefix in
nft_netdev_hook_alloc() and populate 'ops_list' with them all.
When checking for duplicate hooks, compare the shortest prefix so a
device may never match more than a single hook spec.
Finally respect the stored prefix length when hooking into new devices
from event handlers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    | 29 ++++++++++++++---------------
 net/netfilter/nft_chain_filter.c |  2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fabc82c98871..a7240736f98e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2330,24 +2330,22 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, hook->ifname);
-	if (!dev) {
-		err = -ENOENT;
-		goto err_hook_free;
-	}
+	for_each_netdev(net, dev) {
+		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
+			continue;
 
-	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
-	if (!ops) {
-		err = -ENOMEM;
-		goto err_hook_free;
+		ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
+		if (!ops) {
+			err = -ENOMEM;
+			goto err_hook_free;
+		}
+		ops->dev = dev;
+		list_add_tail(&ops->list, &hook->ops_list);
 	}
-	ops->dev = dev;
-	list_add_tail(&ops->list, &hook->ops_list);
-
 	return hook;
 
 err_hook_free:
-	kfree(hook);
+	nft_netdev_hook_free(hook);
 	return ERR_PTR(err);
 }
 
@@ -2357,7 +2355,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strcmp(hook->ifname, this->ifname))
+		if (!strncmp(hook->ifname, this->ifname,
+			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
 	}
 
@@ -9696,7 +9695,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b59f8be6370e..b16185e9a6dd 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -328,7 +328,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
-- 
2.30.2

