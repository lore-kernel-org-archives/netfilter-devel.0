Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A413815B99D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695463; cv=none; b=pfUz55Z/oaKSTZ0p5aZ2sSWDnQ3boHRRKvlB7r/xLD5uTWpM8SprZXTNhaHROe2QornUThOXvKeVCksx1kNJ39qkEmSZRmdV/Atl/msgV0JOhlFrdMsdcINd35C9AyHQ5Nlb3BIrhvHK3yOjrkTMecOdt9IvFnhasdxncx5IOWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695463; c=relaxed/simple;
	bh=BORdh8ZhWKZ3/xZ7LPhe6fSux9SI+cPvTYXQxLAjTnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO9jZwb7QEfUh44q4kFjuZb8923lp0H+oC9XtJq2FNZhmyP46O3r+DSBtEwc8WblUpKGLcHY04udPnTMZ3qQWPKnHeoZvoxEH5f//8Tqc6sqM8M0ZUI9jYByIRnNlCsiaCkNJlujFRzZ4P8R3s+SfWlDsQwC7tEaI9wG+52oz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=COzOykgi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="COzOykgi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1FyTMvcf0lAYejdUM5VbVDdyBsfOZCzlzUsd/l0c7uI=; b=COzOykgitmfBJW5gXUb/9gV7UW
	m2eVHDZuRZQOMVVSMsaRz0IBWGzEF0qZ35wU13MfjJIpPv/XW2bDHTUYihyNwhBYAJXBkT3qVyLp8
	y/bzmHv3WSOCNYiQFvQ4BXRJprgoR9zusYSGwmYkJXl6Kmn9X6DmbBOhVoPvlqsgTGPX5ZaYBaamO
	Lr7I32m5nKukhSwxZjZA0UUNrj1aP1b6AxzFb0/caX7Ml2mfI/clMOjt7jF432IJmDnsC+KG138fe
	JmNPJlu6i7zGlO3cv3vQYbK0ygoStlkCgwW66BZ2eXYCXp9rEmcYklyHy6NxWPMp/GK3REaA0XpsE
	fCwnSRwg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3cnk-000000003sQ-1pw3;
	Wed, 23 Oct 2024 16:57:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 1/7] netfilter: nf_tables: Flowtable hook's pf value never varies
Date: Wed, 23 Oct 2024 16:57:24 +0200
Message-ID: <20241023145730.16896-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241023145730.16896-1-phil@nwl.cc>
References: <20241023145730.16896-1-phil@nwl.cc>
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
index 30331688301e..d4563313d5e0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8569,7 +8569,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *hook2, *next;
+	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
@@ -8578,12 +8578,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
2.47.0

