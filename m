Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266B199EB7;
	Mon, 25 Nov 2024 12:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=58.251.27.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732538126; cv=none; b=A5ivhiAXa5Lz8Yo9+gC3eEx2bYza5/ZXIZV0S5s+X+EBcYUIHrD5Ojj4zOtG9OhcvMLTGxz8qqkCpGq54fUeC68ok0awcDh7u22h2zfLoqyyc3y5zMLUXlN9vtMCBU1ROMCQsFy7P/IHGQwIAceK5wo5WftYb7k91Gx4xPznvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732538126; c=relaxed/simple;
	bh=781+yCySlpYE5vvfbpkHr67FCJbGg137ey0HVLO6iso=;
	h=Date:Message-ID:Mime-Version:From:To:Cc:Subject:Content-Type; b=euopgg0XqrgLPmoTUMTxY4+JspS9pLi7XzeTD7B0eK8t6Q9JnhuJcKXfaonJs5Fnlt0V4JtV9xDz2M/UEyQpTru7oHSeZVPMIvBmo9dL1m6Ukm7o2HSCFl8w4hu80COznZcsDXKXPhq6CmRr5bF6zN79qSu3LvAK39Unr/Lnuak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=58.251.27.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mxde.zte.com.cn (unknown [10.35.20.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4XxlM40LMYzkYR;
	Mon, 25 Nov 2024 20:26:56 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mxde.zte.com.cn (FangMail) with ESMTPS id 4XxlLy2YMwz54Bgm;
	Mon, 25 Nov 2024 20:26:50 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4XxlLm6nsZz5B1Kr;
	Mon, 25 Nov 2024 20:26:40 +0800 (CST)
Received: from njy2app02.zte.com.cn ([10.40.13.116])
	by mse-fl1.zte.com.cn with SMTP id 4APCQUXA001900;
	Mon, 25 Nov 2024 20:26:30 +0800 (+08)
	(envelope-from jiang.kun2@zte.com.cn)
Received: from mapi (njy2app03[null])
	by mapi (Zmail) with MAPI id mid204;
	Mon, 25 Nov 2024 20:26:34 +0800 (CST)
Date: Mon, 25 Nov 2024 20:26:34 +0800 (CST)
X-Zmail-TransId: 2afb67446cfaffffffffd2a-58291
X-Mailer: Zmail v1.0
Message-ID: <20241125202634242hoMPn5q_ViCvJA9BygRYX@zte.com.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <jiang.kun2@zte.com.cn>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <horms@kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <tu.qiang35@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG5ldGZpbHRlcjogbmZfdGFibGVzOiByZW1vdmUgdGhlIGdlbm1hc2sgcGFyYW1ldGVy?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 4APCQUXA001900
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 67446D0E.003/4XxlM40LMYzkYR

From: tuqiang <tu.qiang35@zte.com.cn>

The genmask parameter is not used within the nf_tables_addchain function
 body. It should be removed to simplify the function parameter list.

Signed-off-by: tuqiang <tu.qiang35@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 588a2757986c..e9925473c34a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2496,9 +2496,8 @@ int nft_chain_add(struct nft_table *table, struct nft_chain *chain)

 static u64 chain_id;

-static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
-			      u8 policy, u32 flags,
-			      struct netlink_ext_ack *extack)
+static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
+			      u32 flags, struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -2936,7 +2935,7 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 					  extack);
 	}

-	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
+	return nf_tables_addchain(&ctx, family, policy, flags, extack);
 }

 static int nft_delchain_hook(struct nft_ctx *ctx,
-- 
2.18.4
