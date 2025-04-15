Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAAC2973CA
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731901; cv=none; b=e/Q4nLFqMRiKwf46NFRpdGEc0w7eroBU+t3TaP1QX1b5oa0x8nlQZqAbl4GCVKwgvA+hFFKuaRVo8fGBd1ZuO2dS/op1FIquxMjBdHfZ4osUtqphY5VBYKm/WAUhUw8X2xVA2R1myIjocvlqNN4cofuQfGwyf2MXsvpgbi56u4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731901; c=relaxed/simple;
	bh=Sb6BZfVcJP4Cp0wLMg1fkskeEwkcBP79dCuKJB2DlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ2VDKLA0b+YJvuMy+Su0GffD53PGGj+0QI0JfEPAp51QgQfSEaSh/VEZm3Rlbw2irUEId5gYR+na8cn2F/cAAkupdAKB8Gn37/d38vIp9rL21/df6ORwYMJg/FCP1zUxC85hd4okftS2taFxSLNGLGEc5XWKY/DhvMImw+bHwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VJgbRLA0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VJgbRLA0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jbgSKWJ8jeXk9QIsYfauTVweN3QBOkVYNYdBGlmVlB0=; b=VJgbRLA0BzG6KRBmF2d28LtSBg
	iNthGIT8wZqt0XHtBS5E5SOD4+xJFnXN6r34p0qke3ApKIdpOGkpqJ7Bm8Si8xam5FlSau+eXBTlF
	e1+7lA0V9Ri5lv5hu+mHc1VT+RO7hADSLLIL0qaUHsn2HmcUhbRfKE+2FhgUKALddc6/NLYpCaOPX
	KQt7/eQaP5sGBn+uombQmzT0ilJ7RKfnqa0y7uIUh24RT+e16wjMP4I9hbvWERMXVpXoEoU4vQJbJ
	iTKUnw6/CTWy/fFvKPXCeeomBVqwm72BtnsqHG2okM9O21sGeK/b44z4GOe97Vzrb8L66NJ6hbkfH
	nYtLNr1Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iSy-000000004yT-0AU1;
	Tue, 15 Apr 2025 17:44:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 10/12] netfilter: nf_tables: Support wildcard netdev hook specs
Date: Tue, 15 Apr 2025 17:44:38 +0200
Message-ID: <20250415154440.22371-11-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User space may pass non-nul-terminated NFTA_DEVICE_NAME attribute values
to indicate a suffix wildcard.
Expect for multiple devices to match the given prefix in
nft_netdev_hook_alloc() and populate 'ops_list' with them all.
When checking for duplicate hooks, compare the shortest prefix so a
device may never match more than a single hook spec.
Finally respect the stored prefix length when hooking into new devices
from event handlers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 33 ++++++++++++++++----------------
 net/netfilter/nft_chain_filter.c |  2 +-
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1e6fde6d3a07..04712e5363fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2323,7 +2323,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 
 	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	if (err < 0)
-		goto err_hook_dev;
+		goto err_ops_alloc;
 
 	hook->ifnamelen = nla_len(attr);
 
@@ -2331,24 +2331,22 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	 * indirectly serializing all the other holders of the commit_mutex with
 	 * the rtnl_mutex.
 	 */
-	dev = __dev_get_by_name(net, hook->ifname);
-	if (!dev) {
-		err = -ENOENT;
-		goto err_hook_dev;
-	}
+	for_each_netdev(net, dev) {
+		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
+			continue;
 
-	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
-	if (!ops) {
-		err = -ENOMEM;
-		goto err_hook_dev;
+		ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
+		if (!ops) {
+			err = -ENOMEM;
+			goto err_ops_alloc;
+		}
+		ops->dev = dev;
+		list_add_tail(&ops->list, &hook->ops_list);
 	}
-	ops->dev = dev;
-	list_add_tail(&ops->list, &hook->ops_list);
-
 	return hook;
 
-err_hook_dev:
-	kfree(hook);
+err_ops_alloc:
+	nft_netdev_hook_free(hook);
 err_hook_alloc:
 	return ERR_PTR(err);
 }
@@ -2359,7 +2357,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strcmp(hook->ifname, this->ifname))
+		if (!strncmp(hook->ifname, this->ifname,
+			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
 	}
 
@@ -9672,7 +9671,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 
 	list_for_each_entry(hook, &flowtable->hook_list, list) {
 		ops = nft_hook_find_ops(hook, dev);
-		match = !strcmp(hook->ifname, dev->name);
+		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
 
 		switch (event) {
 		case NETDEV_UNREGISTER:
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 89a53b7459a1..2a0c50f7c65d 100644
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
2.49.0

