Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9843E2C6B4;
	Thu, 18 Jan 2024 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594664; cv=none; b=OEEk7nHIITFkgpxC3mWlwKi88R0HZM+FwnGEwBDyEOgdXOom/eSWZ3fr0pobFp+06ix+hmwTF3rvnE9ciJM2/+RoxjCSMrxk45REmw2T17JejTvj9UwYz+XEJzawGWP/PueH5nJ02G5rcAjNk5woyseIC+oJvrsQoyKqynzMUrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594664; c=relaxed/simple;
	bh=tGr+luaDgF7e2pLgh9DOzxCxy4MKxq6l0MI3qnlteSE=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=YBH4kA4m6eGuKHS31avLYrlhVSRuGxNwC7NYNT7AgHP9Yy1yjo9L5P7FrPpRuWU1Lq5ucm8mhSEpw3wnn8ZA8EaWVjRDK3SOc4GK/2NojKv8nY8TfF8UXE3GnTSm4RahveQNofyvp/FVR7qSoqDF/LwVDQ/+xn0r1hi0vKJZwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 09/13] netfilter: nf_tables: check if catch-all set element is active in next generation
Date: Thu, 18 Jan 2024 17:17:22 +0100
Message-Id: <20240118161726.14838-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240118161726.14838-1-pablo@netfilter.org>
References: <20240118161726.14838-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When deactivating the catch-all set element, check the state in the next
generation that represents this transaction.

This bug uncovered after the recent removal of the element busy mark
a2dd0233cbc4 ("netfilter: nf_tables: remove busy mark and gc batch API").

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b3db97440db1..50b595ef6389 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6578,7 +6578,7 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active(net, ext))
+		if (!nft_is_active_next(net, ext))
 			continue;
 
 		kfree(elem->priv);
-- 
2.30.2

