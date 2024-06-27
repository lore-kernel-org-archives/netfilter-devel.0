Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74116AC0;
	Thu, 27 Jun 2024 00:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719448888; cv=none; b=Kz6ZFf5x6qaaulrWXaATxsCYD7yjKv9u/ck1IdMJeNedSV5YeBq9HsUYD6l0o4un+CtzFGxBfWeKB+G5WsGbFwssspjT1w6C3I/NvLJ+klYSl0Dz/eAxqc+PZhsCqPZHL0XDpnf6zH4oaTL3ioncCq5HWSt+cA3sunNBibX5poY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719448888; c=relaxed/simple;
	bh=JzsYOL0ybgf+0CY3HWHMKuGZ7mWJ/knzollqOs3aFMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TI/MiRgk9joe6Q8/3xrw6uZtWoQn/O/xiO6ToNwW/Or1nZtK2fGl87e3Irmg/AyctHkrWbk+jfi++THhTtM1h6pe3kzRvtzRwRPlaa1HE3WNGvPW/pUtccIBBWDQCwIq6KShZQp2KR75usMUAvylRL5a5QNTR/9Swzffv3x0UQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	torvalds@linuxfoundation.org
Subject: [PATCH -stable,5.10.x] netfilter: nf_tables: validate family when identifying table via handle
Date: Thu, 27 Jun 2024 02:41:13 +0200
Message-Id: <20240627004113.150349-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627004113.150349-1-pablo@netfilter.org>
References: <20240627004113.150349-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Upstream commit f6e1532a2697b81da00bfb184e99d15e01e9d98c ]

Validate table family when looking up for it via NFTA_TABLE_HANDLE.

Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3cb5c920276..754278b85706 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -713,7 +713,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
-						   u8 genmask)
+						   int family, u8 genmask)
 {
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
@@ -721,6 +721,7 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 	nft_net = net_generic(net, nf_tables_net_id);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
+		    table->family == family &&
 		    nft_active_genmask(table, genmask))
 			return table;
 	}
@@ -1440,7 +1441,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_HANDLE]) {
 		attr = nla[NFTA_TABLE_HANDLE];
-		table = nft_table_lookup_byhandle(net, attr, genmask);
+		table = nft_table_lookup_byhandle(net, attr, family, genmask);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
 		table = nft_table_lookup(net, attr, family, genmask);
-- 
2.30.2

