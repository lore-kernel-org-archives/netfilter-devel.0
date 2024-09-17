Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243A6374EA
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 21:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607981; cv=none; b=s1TZxX/d5z2d66GPPirF+Rqmxh9RXGAYp0O+WhWpgKq/P39/fF5PaivdXTEA8vf3o97zTx2ZTQI8kITUJe2POEEsrzp8mgq7fiCT+PxJI3H74f0FZKwWm3i+dsI7R/lAqyyW3RjvJT9HASTGxiYn6Gt7zrWhwWxlRTCqJTVYEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607981; c=relaxed/simple;
	bh=FItsnoJyl+1ogkJk/uvDTkAjhjlATWjvBSdj0T6ya2M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tufXy6SfzWLvqhBjZ6Gl+GfhQrecmv+nbYDCSkE4R87Ss/1K5cWTGkQeDXymegsaCkJd7oMZzI9VOdzQUmJHqA8G3lMujYYtuOQbrKbAFxUCJvXP8cBt9a4Y/D1CEza4sNhr/SsM44BnvHUvGE/VBX9riqTyDQzlIHTxzyzK3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path
Date: Tue, 17 Sep 2024 23:19:34 +0200
Message-Id: <20240917211934.312403-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lockless iteration over the list of hooks is possible from the netlink
dump path while updates can occur. Use the rcu variant to iterate over
the hook list as is done for flow table hooks.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
As a result from discussing recent Phil's patch 1/16 to add dynamic hook
interface binding.

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 045ae805adbc..2e1063b58311 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1841,7 +1841,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
 
-		list_for_each_entry(hook, hook_list, list) {
+		list_for_each_entry_rcu(hook, hook_list, list) {
 			if (!first)
 				first = hook;
 
-- 
2.30.2

