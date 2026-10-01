Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF712459E1;
	Thu,  1 Oct 2026 03:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790826804; cv=none; b=hViulU6GVxS1aPlPwzJWu2FMOed9WzUECztP2h1YROuWZzy1ZY6BMwkI9egGk9O8j+V1i5s1mfFi+0mRkK4poi2PJ8GnVUyCrYZJpqnFo008jDKIRH1DXw1KWUkdhVnG2Jv6noVH2blAfMKCNZbF6/P386Tz+hRbr2zC5CdRIxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790826804; c=relaxed/simple;
	bh=9d0ymZB119zdJ/ME8/sBGP7ek/f55wQE7jG2gHR817g=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SHkY/ndav8UJGBBpby4JuHXUAy260e0FDyE0XkeWVtnRdQVqEefBW3aGIM0+xjBuuVzlgfleZ4lser7bVW6ib3XcpXGTbSy8/ziaFlohJDee8+Et8IBUtRraIdPM+q9Flu04edM7qBZVBnF691jym2AawngtxeKylArN2xz8rCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Ygo6YwQT; arc=none smtp.client-ip=43.163.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Ygo6YwQT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790826791; bh=tDncEQpuKd8Z+mn7h3Cb2heMt2upVurhUi+ifnbHFrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygo6YwQT+Po2r0wwxQj5rYpNZGa2dH+/WKrPnO3kQ/cVC7CKrZHTnd9SdU6369fBY
	 SNkZIZPSHdTTGV2Jn2Oye1bgvczNp6L2q4cLKDYRAYN9X9/9BB6M0yVlt+fBwkrm3Q
	 fbFYesbr5ZVT6NteHF58zFjqYCkJoZukYXIYOErM=
Received: from localhost.localdomain ([182.239.119.212])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id CEE0A295; Thu, 01 Oct 2026 11:51:46 +0800
X-QQ-mid: xmsmtpt1790826706t8fs0d3dz
Message-ID: <tencent_CD037FFEEB8CA462C8403FB30F50EEC6DF06@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5em8y5N5Y4wo1phFZS8eLkcCtZIXr8tEQ270FIlzuyT3uXNBE7Z
	 HqkZKIS9/jzr/3KtMK1cslxrfvBeByDaorcUs+DrI7VqVfuGHRjiGC7dyT8o2ga+l1rKFsj460qW
	 NsL7528xyEcwvIwBHyYqgJyFXo/9kgnk+cF04ZlB/z3Ja0ThzYMH2rET/LS1kcTs895pzDUfUF5H
	 gvkCcpEbdFKoLF0Z2MQ36C/cKQj2lV3ogp6T4nQb3/MvcLsj3VT3lYDxOLsgNPuxHVkhlwy0gPuv
	 1vWIBdzpDhbd1o99dpqLpbJ479nVwdjSbH8DH2zVTdeGdUohHKoMmfKPsdUdv/lK/yPtanjaFeLk
	 Y4HlA7wQYgAIasHcs7JrYtS0gfyK+6qNo3Qpols/9IOMjYiL+nNK/QeAOVRlE8L6kSE30RbICLAr
	 hOd8Y8YDn5eW0xYJLJ75JGrbn7iB7Q5KvNUodyVYdCqnxm+qDVEvZFklP6rgawc1MCavq+rkUNJF
	 c5mZEyQ58pw7B1gC5KiRIqn3zqPDdUtuT0V/GInF0RMbr57I0lJ7UP4jd9mEh9s380rgRD1xaFss
	 biprEMx6YCu65ufJ/c43f0ny4k6NBB9+LhFVAe1FBvoQWMypeyWK0dZxieDMObpXTIwW5fe0WqeE
	 a4WckTH5KIfcgXNZHlqmudlCUs+vpxl+HdSkF4PFaCs2gBHNnQuV0goE7H+ZXVuj+55Sxo2zQIlJ
	 2qCZ80aOtCofMv47aoWa+K5GTdKHVepVFOSrCr2Lka81NN5oEk48t2wsSuqxWKaIyGSsc8kf3BSh
	 jkqo4+V4QNKK83402VcBKC34HxIV0tvfzuNVrYcUZA4ZMgihb8ilcffsjpx+LH26uXQSw2rjGrS0
	 UtYVLK6tefsyVAp386Uoxg+Y28ocFtEZEU2BKTc4yOueIymWr5CB6FR9pAWAwpOjbiy8cuBhEmc8
	 liOhKTSIkIGE7ojMQ18eWwQIbm90325n2VM+cpWVt21MzkrKeEXj87+2MGMZLROyI1A9rujRLVcW
	 dFz2t64q2nITsvogMu7LEm7PIDv7V1iEDlUZucN479qbZzCXvC3XOdUzT+7jc=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1] netfilter: nf_tables: fix UAF in nf_tables_netdev_event walker
Date: Thu,  1 Oct 2026 11:51:30 +0800
X-OQ-MSGID: <20261001035130.1349-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <2026-09-25-daily-reply-0003-re-nf-tables-netdev-event-uaf@kernel.org>
References: <2026-09-25-daily-reply-0003-re-nf-tables-netdev-event-uaf@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a 6.1-only fix. Mainline already fixed this bug in fc0133428e7a
("netfilter: nf_tables: Tolerate chains with no remaining hooks"), which
6.1 cannot take because it lacks 207296f1a03b ("netfilter: nf_tables:
allow to create netdev chain without device") and b9703ed44ffb
("netfilter: nf_tables: support for adding new devices to an existing
netdev chain"). So 6.1 keeps dropping the chain on the last
NETDEV_UNREGISTER, and this patch only makes the walker safe.

nf_tables_netdev_event() walks table->chains with
list_for_each_entry_safe(). On the last NETDEV_UNREGISTER for a base
chain, nft_netdev_event() calls __nft_release_basechain(), which removes
that base chain (nft_chain_del()) and destroys its rules. A JUMP/GOTO rule
targeting an NFT_CHAIN_BINDING chain deactivates and frees that successor
(nft_immediate_destroy() -> nf_tables_chain_destroy()), so the walker's
saved "nr" iterator can point at freed memory, triggering a
slab-use-after-free.

Fix it by restarting the table->chains walk whenever nft_netdev_event()
released a chain. __nft_release_basechain() removes the base chain from
the list before returning, so a restart cannot revisit the freed chain and
the walk terminates.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 net/netfilter/nft_chain_filter.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d170758..ca6450a 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -318,7 +318,7 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	},
 };
 
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
+static bool nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
@@ -326,7 +326,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	int n = 0;
 
 	if (event != NETDEV_UNREGISTER)
-		return;
+		return false;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		if (hook->ops.dev == dev)
@@ -335,7 +335,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		n++;
 	}
 	if (!found)
-		return;
+		return false;
 
 	if (n > 1) {
 		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
@@ -343,7 +343,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 
 		list_del_rcu(&found->list);
 		kfree_rcu(found, rcu);
-		return;
+		return false;
 	}
 
 	/* UNREGISTER events are also happening on netns exit.
@@ -353,6 +353,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	 * so we cannot skip exiting net namespaces.
 	 */
 	__nft_release_basechain(ctx);
+
+	return true;
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
@@ -380,6 +382,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 
 		ctx.family = table->family;
 		ctx.table = table;
+restart:
 		list_for_each_entry_safe(chain, nr, &table->chains, list) {
 			if (!nft_is_base_chain(chain))
 				continue;
@@ -390,7 +393,8 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 				continue;
 
 			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
+			if (nft_netdev_event(event, dev, &ctx))
+				goto restart;
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.49.0.windows.1

