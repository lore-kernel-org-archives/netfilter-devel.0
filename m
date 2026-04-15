Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B97372ECE
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292397; cv=none; b=P84Dt1RRD89ANj3PGA9zIh1AHRjXy0UqYlC2ftQOwZU929DCQcoOAyfap//wZo0xnXTQhOdRK/teCY2bLHnzTFRQH1HJZJLo739E8r6RmHhFN3cD8TZsibb6vzacxNgmrfDUQNrg0qbh60gZnecrH9i14FDMRBVMxTUngS9TtPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292397; c=relaxed/simple;
	bh=4tYmOZhIgjTd9rN6SlXR9AVLmm3LKvFe3eX0ghhnYe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXVBVoXJD3Py6AuWvONCOGVr3bSrtV9pAmEVOWMJaRp+cYrNJEQqHlTSkOIXsvH7IY4ZRvuhsahk8EYI8pMjN9tJagC/zdMm6/fELTcUEGqyfch1gItHlKF0ed9+9ZyUIESFRaypKnWbB9GiNAKnd08PNZFCu0+iJRgPCRsOx8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VLDd/6TO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VLDd/6TO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B00AD60179;
	Thu, 16 Apr 2026 00:33:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776292394;
	bh=GcCDADzyjXe/bJ3WxhEINXwtv3mlz/ElV6qeiv9x8m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLDd/6TOq+6QqhF0mU3Iw6cdloXbJMDM09CUpTzW37ldgo+VDOzcqcagZ8xEQgLkf
	 NQarOrs+uFNkwjS1i5KEjBI/quirQTYwchFPOOXs85lTVQtZA//xvplUzw4s+AJqNP
	 dxJhmpvnJ/tAHZcOkP34vH6OoWasKvUpsL/wwvoE8WCQyI1GPjITL8tD/DDXOakGpP
	 ydhaS5PLE7gir9O6zVpeFyfdjIwi42g7vYCt0xo17HrRHvubRYS5mRzv9aMrD80CmN
	 k96QyasIQJw50+TABvGpQS7M6rU6Ze2jBrZeckti0jqEBRkUXyYeq8Si/1V6K8uXda
	 PAZ7L3W5BUhtQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3 2/3] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Thu, 16 Apr 2026 00:33:08 +0200
Message-ID: <20260415223309.95527-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415223309.95527-1-pablo@netfilter.org>
References: <20260415223309.95527-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Publish new hooks in the list into the basechain/flowtable using
splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
while concurrent ruleset update is going on.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 090d4d688a33..8c0706d6d887 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10904,8 +10904,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				list_splice_rcu(&nft_trans_chain_hooks(trans),
+						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
@@ -11034,8 +11034,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&ctx,
-- 
2.47.3

