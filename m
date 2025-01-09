Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1768118BC36
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443907; cv=none; b=hhQN1X0l/uFVg7jKzRZW7/LB7y+7UskgQeOhGLVfs3fgukfOqwUdclo+/mdOFEY10FJBY8kU7dUNf6wlzJmv9plopje1jJuNWW+o9a/+Z+n0gg4fwRD1/C8p7uZ1OgNdzwXiN70MWIQEXndM2aXn2PnISMdNpw4QG9yqOz4sW9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443907; c=relaxed/simple;
	bh=0AkIo5CfcF+YBNNl9ElmEos27vEy3neemOAUoPkoQks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR/94arfKhqNM/KAZ9Pw5mSsPJyWwpHkbhg+COiOhDXELDwhnpAi7Jx4vGJJ3B3yzwBlEaW00NDdkp3lUQW/1L9Xw2ncSfu0jY6qFpk8MEiOvVa2NMqPuRjVRq6/REYQnYd6iiu5hjSYD+P+InvG1UmtuhFJOjGMCjFXWkQnNFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HT3wtaMB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HT3wtaMB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bkvhzrO48NqtMknEOP12TnfQwUKYg1koFona/prZKQ8=; b=HT3wtaMB57NF4ZBhcEPDE/O06W
	UR4+TsxN5wRqjDSqfW4svlAOVam1rjD4JOC967AqMwj/t8G9X+gHzgvTysPW6hxec0DH+i9Pf4yiq
	FBVFHUNwEE3cNvlw95Tdf0omlncTkGGftWo3pWluRH8eJT3sxiayGDz67yfGPQR3C/PXNxzfjRoSi
	IakhInYitEss91WuvkOF9DZZwjQJGjHJdlEIzYzh4UX71DIFA7rWMWpd6q5T4Z1bbXM4DyCjYyshl
	g45em5hGDf9wcc8oUNwsbJiWTtI6UOS81EMHs+NxVA/vHNo+u9P3+ZrcE06ZxxtxjUp3gBcGjeFxX
	h6m/sD2A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVwNj-000000006Mt-1xNI;
	Thu, 09 Jan 2025 18:31:43 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 1/6] netfilter: nf_tables: Flowtable hook's pf value never varies
Date: Thu,  9 Jan 2025 18:31:32 +0100
Message-ID: <20250109173137.17954-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109173137.17954-1-phil@nwl.cc>
References: <20250109173137.17954-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When checking for duplicate hooks in nft_register_flowtable_net_hooks(),
comparing ops.pf value is pointless as it is always NFPROTO_NETDEV with
flowtable hooks.

Dropping the check leaves the search identical to the one in
nft_hook_list_find() so call that function instead of open coding.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c4af283356e7..1357238bb64d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8851,7 +8851,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *hook2, *next;
+	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
@@ -8860,12 +8860,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			list_for_each_entry(hook2, &ft->hook_list, list) {
-				if (hook->ops.dev == hook2->ops.dev &&
-				    hook->ops.pf == hook2->ops.pf) {
-					err = -EEXIST;
-					goto err_unregister_net_hooks;
-				}
+			if (nft_hook_list_find(&ft->hook_list, hook)) {
+				err = -EEXIST;
+				goto err_unregister_net_hooks;
 			}
 		}
 
-- 
2.47.1

