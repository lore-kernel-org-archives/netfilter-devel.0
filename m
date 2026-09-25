Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4062147140A
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322704; cv=none; b=DGEmjVLBW5doQqILH3TweF101HNkGNvmH70Q/7OLM4PftMHDTU1oLSSHoYLxq9e82frpiVrtrhOsnyueYcYIN8NaL7eKYSbBcMhauBpsVQ8jPmBk9uCxSBOW2DGN5MYKbQyeRP/UK4i7HwDWmb/HRr+q2UaXpA3poYk16AFt194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322704; c=relaxed/simple;
	bh=5VFamt//9IVay154N9o/SJYnH/x0AOoQEJpP7Z5jksY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Obtuv0Hpsz/7GKTnybvkCrH9rH1F9GPRQPIEXWaXgQ7DhYTbjUcMwb34zXHzLxfXSB/gEXfebivqeEajOaPzS7cw7tapvPiNDpR+kmdFNs7y2leBCzOCAMR0Yx8VIVjBWr2tpR9tEJRX6/5uCNQd71+VmDRldefVqzK2+bNYF6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oe/00XKr; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oe/00XKr"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2dd89b59dccso517025ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 00:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790322697; x=1790927497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vV2liFOZgZ0xQDnBn10ckAcfKSt1UF7Me/i23FVAaN8=;
        b=Oe/00XKrZPBdBPJXvJAgL4BsMQmhPdcl+7R5S+ofIwk2E2fsFXhqdXbWz+UhM0mp3T
         BcViYMlNOc3KMMgtkSmv/sYOqcw4X+cbsz2je2fPQgyk+SgzSDBC8jJ4Hsg13Czpa25p
         eX52gfK0P7RCbc3KxBYGhwYj/uuUM9cJ6FdvYyLB7z+E9cv9M0ct3hdcLliwO+h1Fv9P
         ISPM3w3At5lOuKT3jJt78pMGjpAedPIKTMlFxpAAkooNNL2MbRZKeFu7BL8+/0rPe0DD
         FAIVYRtsn1E4hW/xHZxWp65JALHZKs2fVlxY8pYU3BM1togo2V+8EUw8YoNx7ORdFMFG
         5lcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790322697; x=1790927497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vV2liFOZgZ0xQDnBn10ckAcfKSt1UF7Me/i23FVAaN8=;
        b=J1zKeR8pkmK5moPpbu0pVtxm1skzR3rrFTzYqsaDGJlGzPVm7HBaMRP6Qv89n6OlB7
         2V5c/VgB32H1LlyFmSQDRpLOZfqgGyX8U5fjc1iApOjGPHihnlh+pjlf327a1cSM38Eq
         TIKghC9S/0n2oLsXbfXxAUpl4a7mMUkwcmCGUB4eeWgC9sQzWj916z8K59gm9rSGYYq9
         No4kQQ2zGK0PVM0IffVXqFncuqRn5htAMSIHjzpm9/IQ8j4FErcLJ7S5WWWRqjW3iyVI
         wlZql1ibCeUt2yc3rwoCDxyGqLQYOs+Wc2H5B1Zulybopg6I4YJdw7SZE1c4FFz0Pir7
         DWDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYkcMEBYF7V90TXFmsMmrGn53cezox1omDMMeqjXu7iRT7/dwHNNq2R++QL+2iSQv7BrEJCWpVyaTrDOzL0Y0=@vger.kernel.org
X-Gm-Message-State: AFuF++m25KvH6dFKWFWtRNpyUBZIpZo8HEm+gGG+VKQ8BEBhQC24c15v
	L9lXXdmwPa3LpSlmyED5ZCwyY4axMR8mEwGVGC94MGLdAJSsczkA50kz
X-Gm-Gg: AYBFou1GM8XZeNSDHtyeXcBlRIPuo+oII9S7MSi4xjQi7Vm1yopKXJv4k+pkPCA7V2n
	Z+1G1EsyCz2h3/N6guSDw1Hqq+Ts/ehbiWC8/Ktt7hFUz6dYg5Qr7Xqh9Or119CevnI3yKABQPI
	Hx+gv1eGI3MR3er+Mr0Wzis2pl7DcMjEq4isbUpBsXs0n8bjoJh2nN3Su8f3XyXbu8byt46E+8C
	aM362XmALmKFBUJKGMOK71p6IysLEJEpm09lsqwtLVa4eO0JY+qg6aLXet0axICaEWpUADVHkkr
	CzEiAq62W71Vy1dhym1rq4rSFoOmIQg/7u+QFJynwbemhI/CYcxfl6HlrfkqOn084LUbc7hS2c4
	ZD5F0RbZ1eqPqD0VFaUsQ+JLBI7r7bA10+0AnGL+1Z8E9PjMB6DnK91qXIRHJEvRM3cuN0wzNip
	JWEg+ePCp3WU996XIFOdCHd1CIE8PL+WN5dLnh5X3ZhuWq9KzAQYvIdeuL+3xM+MvtH8SuDBKmg
	eeTn7y0UYI=
X-Received: by 2002:a17:90b:3c8d:b0:3a0:8001:7d11 with SMTP id 98e67ed59e1d1-3a0b2617800mr3241918a91.6.1790322697387;
        Fri, 25 Sep 2026 00:51:37 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm255962a12.28.2026.09.25.00.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:51:36 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 6.12 2/2] netfilter: nf_tables: Simplify chain netdev notifier
Date: Fri, 25 Sep 2026 07:51:26 +0000
Message-ID: <20260925075128.646-3-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925075128.646-1-junzheyu1@gmail.com>
References: <20260925020025.616-1-junzheyu1@gmail.com> <2026092558-grime-yahoo-6b34@gregkh>
 <20260925075128.646-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

commit 375f222800bc001bb9cbd2baa1daec006430aeba upstream.

With conditional chain deletion gone, callback code simplifies: Instead
of filling an nft_ctx object, just pass basechain to the per-chain
function. Also plain list_for_each_entry() is safe now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 543f258b7..19a553550 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -319,17 +319,16 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 };
 
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
+			     struct nft_base_chain *basechain)
 {
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		if (hook->ops.dev != dev)
 			continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &hook->ops);
+		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
+			nf_unregister_net_hook(dev_net(dev), &hook->ops);
 
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
@@ -343,25 +342,20 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_chain *chain, *nr;
+	struct nft_chain *chain;
 	struct nft_table *table;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
 
 	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
-	nft_net = nft_pernet(ctx.net);
+	nft_net = nft_pernet(dev_net(dev));
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV &&
 		    table->family != NFPROTO_INET)
 			continue;
 
-		ctx.family = table->family;
-		ctx.table = table;
-		list_for_each_entry_safe(chain, nr, &table->chains, list) {
+		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_base_chain(chain))
 				continue;
 
@@ -370,8 +364,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
+			nft_netdev_event(event, dev, basechain);
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.53.0

