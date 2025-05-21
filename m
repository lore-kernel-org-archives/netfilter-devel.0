Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01BC29C35B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860285; cv=none; b=RD52Pzv7K8NBOBhInZz4Idnb6y1XyfZGuchFQ5V1io7TjVjEmWqN3pnI044w6DbpXNGNpsRGPZ/l4fuccwqSMkNEWLeHhW7XcuHVPxrFpcmdv6uB4ZTlChm42oIisQNm6r4/7E9PFnQQzYk2QhI3oWzSFjKIYLtUC89mJ16Ftis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860285; c=relaxed/simple;
	bh=hQliIPmg6HPfdDbLMqU4iGoOASqkF7lhgSX+9C9Umn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txrrl9yKGSpZ8arHhcj2u+Nd6rA/SxMavuQZlEXtarwiEQz34iaTY7Oy8ArxNJZZKUJFaowabk2DLSBZm1uTTxIkeCtScOZjXOtZ6wJh4Dep4Ubl3oLkb2aN/U5y9buODN+66f3eurJTHMRFQj1R6GrhJ3/dMvFaFbBah0dgnR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ohg+gxeL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ohg+gxeL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bPMkdXSI3XVSkPuVVt9aUOMy4BsRx+mTgEJhvnF2wiA=; b=Ohg+gxeLYONmIdnmLksOs7PpBC
	lyToRU+BoOk+xBXzDwUC33N03FyoNK7ltlLUu06I1NFP3CPaOY4PB2Q5g1v4KZ5YDSxEnJkkjc1F1
	4GmhVmEjs9g7j1sGhz7/wWUOAFDKHCsGMKqXzF56nX/7DWXW9YKW010MGbPqD1m8A+ehzbWdrT9BR
	R10yxCHVfIYSAYprbHThpFzlQgfT1wZDkvjggzrKa6XJZpb6nE+gnB9ksQ2l1r2hPdsHerHTM5Rrr
	l1evO8oj0Gfm4M2S5JqfDl7fTgpURVF19cI6tnex+NosKpTSyRJLrxTHMVYFZwtB9Ixe6rrDuTy5R
	TuneLdsA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIs-000000007Qr-0J1B;
	Wed, 21 May 2025 22:44:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 10/13] netfilter: nf_tables: Sort labels in nft_netdev_hook_alloc()
Date: Wed, 21 May 2025 22:44:31 +0200
Message-ID: <20250521204434.13210-11-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521204434.13210-1-phil@nwl.cc>
References: <20250521204434.13210-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No point in having err_hook_alloc, just call return directly. Also
rename err_hook_dev - it's not about the hook's device but freeing the
hook itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 452f8a42d5e6..fabc82c98871 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2315,15 +2315,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	int err;
 
 	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
-	if (!hook) {
-		err = -ENOMEM;
-		goto err_hook_alloc;
-	}
+	if (!hook)
+		return ERR_PTR(-ENOMEM);
+
 	INIT_LIST_HEAD(&hook->ops_list);
 
 	err = nla_strscpy(hook->ifname, attr, IFNAMSIZ);
 	if (err < 0)
-		goto err_hook_dev;
+		goto err_hook_free;
 
 	hook->ifnamelen = nla_len(attr);
 
@@ -2334,22 +2333,21 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	dev = __dev_get_by_name(net, hook->ifname);
 	if (!dev) {
 		err = -ENOENT;
-		goto err_hook_dev;
+		goto err_hook_free;
 	}
 
 	ops = kzalloc(sizeof(struct nf_hook_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
-		goto err_hook_dev;
+		goto err_hook_free;
 	}
 	ops->dev = dev;
 	list_add_tail(&ops->list, &hook->ops_list);
 
 	return hook;
 
-err_hook_dev:
+err_hook_free:
 	kfree(hook);
-err_hook_alloc:
 	return ERR_PTR(err);
 }
 
-- 
2.49.0

