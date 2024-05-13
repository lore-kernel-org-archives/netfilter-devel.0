Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCDB1509B5
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605781; cv=none; b=Y5ywByIEQutiw+X3qJ5v6PMpK+16de416UPlhwTG8yWICYABZ7deRQJcFxWw18v2rnamewcrRv7X7ur6x9epwlSdE5p2jfqPBozH2gzqwAqAb08Y6tTPXuLIqL5V83v/+7MiwCcRIj1yn6cGn0Yb5uJBQZT+FI2TR0iXejdgHYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605781; c=relaxed/simple;
	bh=/a/vFrK0xQQ+AiXLPlZO9jcz/VXY75l0/HQxeV6X11A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFfT16aMzNScCu/u8zt7Dqb4QDG4TiJb9MK7EZBWh/N1s5Et6JItzMUaSNcx0YyTMpHO1DhN4OraR0rBMcVPkkqSsBALG71ZzVG7FIfr4KZl0KPzmLQqKT7PGmEoz2EfvXCmXtj3xtybZSeZlHf7KnQfIUOmTDuv+C//nf7TSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VQv-0001P6-Ot; Mon, 13 May 2024 15:09:37 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 03/11] netfilter: nf_tables: compact chain+ft transaction objects
Date: Mon, 13 May 2024 15:00:43 +0200
Message-ID: <20240513130057.11014-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240513130057.11014-1-fw@strlen.de>
References: <20240513130057.11014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cover holes to reduce both structures by 8 byte.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f914cace0241..1f82b9ea8d5d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1685,10 +1685,10 @@ struct nft_trans_set {
 struct nft_trans_chain {
 	struct nft_trans_binding	nft_trans_binding;
 	struct nft_chain		*chain;
-	bool				update;
 	char				*name;
 	struct nft_stats __percpu	*stats;
 	u8				policy;
+	bool				update;
 	bool				bound;
 	u32				chain_id;
 	struct nft_base_chain		*basechain;
@@ -1757,9 +1757,9 @@ struct nft_trans_obj {
 struct nft_trans_flowtable {
 	struct nft_trans		nft_trans;
 	struct nft_flowtable		*flowtable;
-	bool				update;
 	struct list_head		hook_list;
 	u32				flags;
+	bool				update;
 };
 
 #define nft_trans_flowtable(trans)	\
-- 
2.43.2

