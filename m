Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573A1F7552
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729864487; cv=none; b=NKCX+WjWnffKbv9CDjFF68onkkNke28tbbgIOz+nGpQWlz+ioZa+19F6s4TkqiQmoiXK0IEwDV/sYNKa1oG3gRuo4SdIyfsSZMJJ8gdZQSvYvtEPho9K5rjqsWyLCKxYe3EFC0gE3vwNSdZ2L05GVAZKT/C6ghOYulX7KyZWZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729864487; c=relaxed/simple;
	bh=ExSLpnX/J1+JLDV6tP/zV2ges0YT42GfXqtBZXBhDW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZwWrbyg9Rlm7kzoAZlpIpxlD5Sl9ZQoKDVcGXGTQ6eCgUmZ94YJuxm0ZH3TbTKZwZT1sFPgjmYLoFjJzbx6d39FXEz0EuuMv/ANiiiCVGYuXnbDnvddjVgkTIsF8H8sAPwLhLPYSp7egY/oS57BC6hgvXGgiiGMp5QDXfTwtN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t4Km4-0005yo-6K; Fri, 25 Oct 2024 15:54:44 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/7] netfilter: nf_tables: avoid false-positive lockdep splats with basechain hook
Date: Fri, 25 Oct 2024 15:32:22 +0200
Message-ID: <20241025133230.22491-6-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025133230.22491-1-fw@strlen.de>
References: <20241025133230.22491-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like previous patches: iteration is ok if the lost cannot be altered in
parallel.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9e367e134691..3b5154f2dd79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1824,7 +1824,8 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
-static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
+static int nft_dump_basechain_hook(struct sk_buff *skb,
+				   const struct net *net, int family,
 				   const struct nft_base_chain *basechain,
 				   const struct list_head *hook_list)
 {
@@ -1849,7 +1850,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
 
-		list_for_each_entry_rcu(hook, hook_list, list) {
+		list_for_each_entry_rcu(hook, hook_list, list,
+					lockdep_commit_lock_is_held(net)) {
 			if (!first)
 				first = hook;
 
@@ -1900,7 +1902,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, family, basechain, hook_list))
+		if (nft_dump_basechain_hook(skb, net, family, basechain, hook_list))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
-- 
2.45.2

