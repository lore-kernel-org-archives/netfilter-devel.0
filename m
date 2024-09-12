Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B0A1A2C04
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143725; cv=none; b=GpBVPG6vze9CmeqYzqL25J6zQZfouNRIjm1PnScKG5UjNn+f5c24cAZtfQ6x8FBr6K0nniuTAUf9qgupaBECSMfZLD0kXrQIc3cuKxpgc16APy0Xy/PqNjjslMr8LByID8wFt/aZf76fWi9sRbhXOex4n26RhzpykNKEUbRUvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143725; c=relaxed/simple;
	bh=3cpSYypN2KJO3P8D84SoU1p+GivrQnLO0F7OLzu7uBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PShilh9idldD8SgASFGR9ix3/bTnkEiA1rrP8vHBeLoGRxAb38DDBR0B52Fa8HIIW0aJzJ7UrYmoyB+kYYeabWptedUTWP1UCw/7dKG/iLK7iEqPKCU2/J8+AuYXIl5oqbkrY0GhWK94i7kaBAY/+1A1pREidZEN1MfSan2Sxb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UN6aA2R4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UN6aA2R4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4A6IFX5iIOVX2WzyRxTIVS8kTvcU5JYQlY6tAvgX/qA=; b=UN6aA2R4H308leMaiH6SsDPrFi
	hv8FZ0SQQ4eyKAUDLgu2qUBCY/lluBwQaNvMtS/yJTl79eg9pghDHDwW8RCrP6kF2YKE0DeOZSd3U
	12YEd8+Gnu9zGDlivbRLNdKsUGYyovAHHBfrGb+k4foov9RwLylsNLFfeNKrMgU32U1rjHND7qgWJ
	ms1hJnqV7e+6GGe8/EOF9yfpCJtlsnaDlgfCwjPJdQnCqcShyah3hNsiZdCRj8cLGbgpKmkiaIUTo
	0VZdlNGKZfO2/3/6QOxxtD/7g5OPuZaf2PvcBuG7vCvFnuTJj3V2tZlvxegW+GeZbSnuRbvv3GGNR
	lOtSnuxQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipl-000000004Ew-3N4Q;
	Thu, 12 Sep 2024 14:22:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 02/16] netfilter: nf_tables: Flowtable hook's pf value never varies
Date: Thu, 12 Sep 2024 14:21:34 +0200
Message-ID: <20240912122148.12159-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
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

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2982f49b6d55..3ffb728309af 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8544,7 +8544,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *hook2, *next;
+	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
@@ -8553,12 +8553,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
2.43.0

