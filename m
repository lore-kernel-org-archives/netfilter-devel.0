Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7701CC896
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695465; cv=none; b=srmlkhsmlB7drZJ9rqdifTfzukXwjKiLuer6wX9KYZK0gytN4aRM2xq9mXODjo34N0ItlTJ56t6qe6AAUAKgdYa3l8nznlHokhJxR+/cOjp1kDwFJjO6hh3ujpWtdCizcx5rZQhya39rKkxnDe8FtCTNb3jHkqAgcPW19Aq5+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695465; c=relaxed/simple;
	bh=9K0ddLWj6MsaXnxqif9zAfTMR20sKNt3c7a8I+BvMpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0wtd88k4dBX3kALnQePBZYlDcFozQhPVwp9Du6Mu3jT58Q2+vU7DgW2Ozs2IQ8ISQAaJUMHUiF57EH2suYDoAQejWI6td6LpfRJZGximpDgj9xObmBcYpgI6IFnqZXQ1+TicsWR6EVkbIRd8tg93XwTjhjzRWR5XqTvZnK1exU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hlh1TeWN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hlh1TeWN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cXS5bCurHNwdG3VOHoRUTKKiNN8D1Ui9lv12QqKEJ3k=; b=hlh1TeWNVPsW0DJR3lys6redj7
	SO9Zfu7fB8lVvq6X25+OoCdwHFKe/En+0uRzsiefTch7TnMlKyOfdXmIjW2earTEM4QsPwtwUe6PJ
	2ZGasvRUq8rwNNAmSDWNPmZQJq4x9TFikoaeswd8dQMyEr3koL+6xj+nCPDGFJhXFbTvn8KDIYvUP
	Hk6PPlcqmU7t+YeHq2fZXe9GIavwcVJvpuDl2bx1fwdsb2qjAAd4Xt8pc4IJjfc5DTKMYe1i5loyM
	buDvTwspSAbijF/khXlu2axSiQb52WYV2DHentZZr2hRALed7w4HrwWE0pSybUCdV3uS1HWcRUbHL
	VE4qGhUA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3cno-000000003tF-17eU;
	Wed, 23 Oct 2024 16:57:36 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 4/7] netfilter: nf_tables: Compare netdev hooks based on stored name
Date: Wed, 23 Oct 2024 16:57:27 +0200
Message-ID: <20241023145730.16896-5-phil@nwl.cc>
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

The 1:1 relationship between nft_hook and nf_hook_ops is about to break,
so choose the stored ifname to uniquely identify hooks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ac25a7094093..edea65cc5e97 100644
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
2.47.0

