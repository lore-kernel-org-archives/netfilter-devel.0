Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2823009D5;
	Wed, 24 Dec 2025 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766580518; cv=none; b=LoqliBhtcVF73YArKv9hMRsApabm6BWxcF0s8zFcSWcuX6Gx75OlKGqExv6tAhO5YmbrlkIml2ks+Xg0Z/UaExyFKwjF2VgMa86qj937RcNpnalskdPSEkFw6tYbzUTaic1s4LrQOX8NIq2RiFX24hjsCf8RfelWDZdumw6howw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766580518; c=relaxed/simple;
	bh=w1MsahNeldZSYoPAbTysQRvTX7LmWZs0cinJHsaJzno=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lp6LGRqXC03aXTkQ9EDm7e5NbBUt9PiseO+R8gdMOJ2diudxlDFPu0GQlDf9c0iS+m8LLOw9stzn+qENrT9n2wh61lN15NGDozW+E0hlrN49KWC0dgeAtreZ4zxdpSfS5UAl2EKdUx4LTJdUAUZVh9cwvYpQQ91GlqW0MorDTmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=cO0OgwE8; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="cO0OgwE8"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2e6e9595d;
	Wed, 24 Dec 2025 20:48:30 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH net] netfilter: nf_tables: Fix memory leak in nf_tables_newrule()
Date: Wed, 24 Dec 2025 12:48:26 +0000
Message-Id: <20251224124826.189013-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b50675e3303a1kunm546f569e478a65
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGh1NVkxMGBgZHx5OGEoZH1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=cO0OgwE8jCWeDhDd83r+HgI5rVUkGmumfHeLWOa7JH8qMtN1Q/G7+j8H+m/Hs/S1dYjTWP3oc0I5ag4yYOVFYeTTTfCIi8uVUgdBHJW3OfFzOPcYvjvq/AexVQdyh4eh6dmmmtCo6A6NTJwc5+Wn4TuOBkXlIuRLMBTHGf9pmaQ=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=CfvI3IV0oysFSUb0upEpTp8BctE4XeqjY7RJtDILwuY=;
	h=date:mime-version:subject:message-id:from;

In nf_tables_newrule(), if nft_use_inc() fails, the function jumps to
the err_release_rule label without freeing the allocated flow, leading
to a memory leak.

Fix this by adding a new label err_destroy_flow and jumping to it when
nft_use_inc() fails. This ensures that the flow is properly released
in this error case.

Fixes: 1689f25924ada ("netfilter: nf_tables: report use refcount overflow")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 618af6e90773..729a92781a1a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4439,7 +4439,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (!nft_use_inc(&chain->use)) {
 		err = -EMFILE;
-		goto err_release_rule;
+		goto err_destroy_flow;
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
@@ -4489,6 +4489,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
+err_destroy_flow:
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-- 
2.34.1

