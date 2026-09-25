Received: from mail-pj2-f30.google.com (mail-pj2-f30.google.com [74.125.227.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE67470E82
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322708; cv=none; b=nG37W9Bt9ouD8i4DzjmHFK4MaqF5OLS+3pDwudevDkr86M3ia+Kjn23Bcd+fU5TqgterrPn5av8vXVPQVAOSoYM2Rdv9+SFkzQcOXO0nmaN7kuMvy9xW6fCDLvh8o/v/IsyS0WPc5aqd1HcLnPYaCznzdWw8sNtbGDCVU15tpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322708; c=relaxed/simple;
	bh=Vuu4gwC8LcqdTJOz5nXgJvtS+rF338aW6f5mJicR3vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHzCqgmLS0mAnqj0IqO6FHIs+0vW9vuJPOJSZdVV/To9O/ZRAzxUyeu5IU3ma5OqZpieFjRZcKzWAKOwKSYV7xIU8n8cfb0Huc7jS4zU3Ur60bCGnbHiQG1gAsxb2zCaOP6buV115IPH/0uJSJrK4KgJ6oF3q2hO+nGqA6NF/V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njcvxe8q; arc=none smtp.client-ip=74.125.227.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njcvxe8q"
Received: by mail-pj2-f30.google.com with SMTP id d9443c01a7336-2d6ff2f2c4eso734575ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 00:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790322702; x=1790927502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/rsnguF0QWu+wCGviIn/1oOF3TR+Pdtv7G15y4cdufc=;
        b=njcvxe8qloYIJ6eVSdOHTXt1mHEvspLhjrJ7g9BLLO0sIGLIh8ubct2QInK8kb8wdx
         rtGmVnl5D1EujeaHW0BlAOpXZ8zi5cj8VRwKrYjOb/QVxOpK22JdxnVNdpWj7BAv4ufk
         yPc6NrqJq/Yzr2JYGmIiX5lySqya0qNuDhYih+JES7CV0U/DzwCOnuGE4gor6GUAcRuN
         cXls7/t5eVP9ozqo9oMfbJjH2G4zSM5aJpODbb6WTlFC5J26nmh8/7iXlyHBOKyyxQI7
         tZfxU+B2XV7ZIUopFbBj1KSlqFZsvYWAbbV7qa3U17auoXN/03+fUfXu2y3yBSpM6tPk
         WKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790322702; x=1790927502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/rsnguF0QWu+wCGviIn/1oOF3TR+Pdtv7G15y4cdufc=;
        b=NIBFUoJzErpvpwHmqkirdywseGq8I8ghIbPyl6mi0qgXdYnCGQH2qnEkxeibtSpBtW
         sxq2TbOnHanG1dXe6IGzZlfX8PhG0pI0dkFHcBdkJa0ZbUYDkO0OEAacl80rqV1Efpx0
         rdlcvmDhSwmFJxv4WL56OAriOEvXirAocUFpj/FGWZ//1YnFrCwDuRUtQ+XWTl0WxGTW
         yLN+mkbWQzwdl0JBWS8qc9ExDbcXKE+se+E+5ZRO5VVG2WFyR3xkwzsEZ48RlRl/hPmY
         xeT0cXgua2L1GIODllTZu8zlsw1WkeqGiF6gQ+bV0XRGOxPYp3I/3/hYeoAt659C+MOm
         btRw==
X-Forwarded-Encrypted: i=1; AKwUvBymFvQkO3M+dmfZKIkkxkK9W0LM1KdZQVEPzLt9fvsMgmaEbZlfMqqUWJwwmFu6M6IugbvUFNky0zjxkaMylNY=@vger.kernel.org
X-Gm-Message-State: AFuF++llAE4FO1FnWDMd8cf+ga83AZ+96jrU3q3ygfT1irMlIzmO6RQu
	MkzOYIgWoKlFbSQ1kYIe+aGiwpLMilEbg8t6lMO1SuHHWctGNaZ93Rxu
X-Gm-Gg: AYBFou39m89EvphWXzasefOq3kq5eQhQ8Cy3WSbHIg/ZUXCSchKVN5AEMC7+X6enesT
	IV/KBHoK8isYWZv5hdBsIlnJoaeyooy5BcWQSOSpO0rZBx767OYQIwdBlNxlws4EBARmqmxN5P4
	/q0jjVfzUon6SUDlJ7n0W8iOIgtrSRYbQ318X1FjJ+LLqlmfs+kuTUciBnAtfX/dEOOdCD5RtDN
	OWO8KUYh4nYsXfEJJBOYm7S3w/V3OLCNGmaR4MTSjPFkMBK2EF1QjozZ04mgwlcKd1HrLasBZsT
	t24Vc/1STo6nrX9oW4D5d24v0YxQi76+h1H+oTDez3WEAt4pnxlyE9cqemQI9lAHo5TW48LlYrt
	orw0jv9d1/dPoFrsrgMkyICeVTjEJ3O0nx6GMDIPNHTd6oWEwqnQdQaPbMQzd9NLwi0brIeTU18
	7s+trGpEgjbhjJfteM213EzlIrAcB5JHScGBIMGSQVxOGVGmnHVdBhKX0U9MViui/TWVHFhVjwM
	8prw8fzUk0j54Sc4/VUNg==
X-Received: by 2002:a17:90b:5804:b0:39e:b778:2b2e with SMTP id 98e67ed59e1d1-3a0b25d6920mr2965301a91.5.1790322701879;
        Fri, 25 Sep 2026 00:51:41 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm255962a12.28.2026.09.25.00.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:51:41 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 6.6 6.1 2/2] netfilter: nf_tables: Simplify chain netdev notifier
Date: Fri, 25 Sep 2026 07:51:28 +0000
Message-ID: <20260925075128.646-5-junzheyu1@gmail.com>
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
index e48de5a2b..867ff860c 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -319,9 +319,8 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 };
 
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
+			     struct nft_base_chain *basechain)
 {
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
 
 	if (event != NETDEV_UNREGISTER)
@@ -331,8 +330,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (hook->ops.dev != dev)
 			continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &hook->ops);
+		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
+			nf_unregister_net_hook(dev_net(dev), &hook->ops);
 
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
@@ -346,26 +345,21 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_chain *chain, *nr;
+	struct nft_chain *chain;
 	struct nft_table *table;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
 
 	if (event != NETDEV_UNREGISTER &&
 	    event != NETDEV_CHANGENAME)
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
 
@@ -374,8 +368,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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

