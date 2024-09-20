Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A339E184545
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863842; cv=none; b=QLmqWhq4j6ZMoHsLf3KAj11lCa4U66R7PJ7EwNQyTY1lYWN6OCRGSKTe66VimwD9aOjFxZP/Pod5idmTTr/IWCcsy5QtJVBIeCqCDCyehqnwZAW92B8sSm1JpJht2A3swhbJ8H62WKyFTrmgAs2sdDVg+CNoIcBPXjIo43KNuN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863842; c=relaxed/simple;
	bh=Kspm+z/jd1+laWBTH9r/G7GOSgcVd7uBEdiX+psk1XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChIP1xDdZ0wd1j51I7iEcvbw012RNd3wioQZSvN+cm4RLfzaN0Wu10gGFw+FVB1Rub0s79Pld9w43c9CVAn7/bt3dRDWDwIL/Rv0K4HsciO2JTRCPvOwk4fW8oJz3mPhA/jnFNBtYNLM8Lz0l9+FMrPFxYPsyErF5H8kWRRuW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WXxXXTiL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WXxXXTiL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=egBCYQe73KTa1fNKjCZpUX7sYNqrtb+QIvLPIbNh+dM=; b=WXxXXTiLBoDt2QxQeKJ7nEYTMb
	q1dSgQBwC9Z179c/JWgN0kkl/MeHsFyndT0hzOpK6Q/d2qodwVCYve14Y+TK+geGNcT7A0zfFgnwo
	q9ay/sE+PZmbzrij9GcBtNdnKL0GfK0k9nVd6dOc0eBPohQwvukAujjj5wMMBi9JTWE1UgffTWGK6
	Ed4226mi+0kSDqMIfgFKll+XEwPHxFHOxRVw911K/QGv5v1qO0O1y+vqrsosmlElQuCJZ96jiQqx5
	wjVsBaQCELC8AM4uEg3VBgBJ5SovrTDk5GlKh7OaevB9yWuzHhNkgLTJwVdoPvXZSyyyiYmErJEKu
	VPpRz2tg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAZ-000000006JT-11tw;
	Fri, 20 Sep 2024 22:23:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 04/16] netfilter: nf_tables: Compare netdev hooks based on stored name
Date: Fri, 20 Sep 2024 22:23:35 +0200
Message-ID: <20240920202347.28616-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240920202347.28616-1-phil@nwl.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 1:1 relationship between nft_hook and nf_hook_ops is about to break,
so choose the stored ifname to uniquely identify hooks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c53afdecef24..f6e28a6ac9b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2214,7 +2214,7 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (this->ops.dev == hook->ops.dev)
+		if (!strcmp(hook->ifname, this->ifname))
 			return hook;
 	}
 
-- 
2.43.0

