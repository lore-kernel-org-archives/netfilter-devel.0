Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A7280A21
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770401; cv=none; b=dH22X8fXvs0V8Z/+2P7T5QHKJEpEStHhSm77i/yQ7Dac+t41VAxQLPM8aiR1H6IGSwut7oH4nLXO/9ZzC0TbaCeU/XgkXXoMzK34wVNBBSUFKy3+ilS8OyeKOcCblHWZNKxL1rjscOYUrkSQr7If3Db37L4v0LhjbI/jVubQf4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770401; c=relaxed/simple;
	bh=Zim4YGOYguFhcdXcXxB0SVSeweFLJb9n13ZzBtTFYm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XNORb/yFjkqpZ+NvcQ+m+tgRJPao50lL0whmNCz7QS3D0nAsdtnvAEHSxu0TgkpkQZkyQXg5eeEXbH0hW51W2mU0z8RZmByLv7fUc6PdYi6297DDGfejOMwn/bGfqr9lirdzmrZAFfjsyJ8OLE+bYi+56fwuBRvqrmMfrezrmwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PvgICUya; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PvgICUya"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 73CC860181;
	Tue, 17 Mar 2026 18:59:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773770397;
	bh=20QBDk7GS2VauOEIshKP0wImPPT39WrR2EEe34G5Sl4=;
	h=From:To:Cc:Subject:Date:From;
	b=PvgICUyamKVL8kapBK/svHIZVUGgqmqVA4fkrPPL1A3oZXPBnRjxffR9TXsFPcK3t
	 q2HmyhC1J3V9KK8YNNNMvs+1CI1JHZD2v74cp6QbCSifChHV47KPhAyC+84ObqYoc3
	 qarH0xkINY+XPuNsKH9DUXEGVMWWAsL1idQW1o12KABsPzzIE6ycBR6q46H+p2xv0p
	 DpTHQMMqLHh9c+El2+f1cOPsrQ8u6F+/40UCCkF4e3S2eg71ZBAGMMPcWBO1rfFsRq
	 0eaFu2xvgTbNnCscAjed/gqvmLQ9BCPyHf4urgdWs0SktIQokQ7OCdzyvZmSQysFV4
	 8yH78UideVjWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: mingqian591@gmail.com
Subject: [PATCH nf] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Tue, 17 Mar 2026 18:59:52 +0100
Message-ID: <20260317175952.26821-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use kfree_rcu() to release flowtable from error path, since a hook that
already refers to this flowtable can be already registered, exposing
this flowtable to packet path and nfnetlink_hook control plane.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

The number of flowtable objects in a ruleset are expected to be small,
the increment is memory consumption should be negligible. In older
kernels, users could mistype device names leading to this error path,
I prefer struct rcu_head here instead of explicit synchronize_rcu()
call.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3c8a60ec1cc4..ae9905b5ba72 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1483,6 +1483,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type);
  *	@genmask: generation mask
  *	@use: number of references to this flow table
  * 	@handle: unique object handle
+ *	@rcu_head: deferred release for error path
  *	@hook_list: hook list for hooks per net_device in flowtables
  *	@data: rhashtable and garbage collector
  */
@@ -1495,6 +1496,7 @@ struct nft_flowtable {
 	u32				genmask:2;
 	u32				use;
 	u64				handle;
+	struct rcu_head			rcu_head;
 	/* runtime data below here */
 	struct list_head		hook_list ____cacheline_aligned;
 	struct nf_flowtable		data;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f19c155069e..16b80e17247f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9229,7 +9229,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 err2:
 	kfree(flowtable->name);
 err1:
-	kfree(flowtable);
+	kfree_rcu(flowtable, rcu_head);
 flowtable_alloc:
 	nft_use_dec_restore(&table->use);
 
-- 
2.47.3

