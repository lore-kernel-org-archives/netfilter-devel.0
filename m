Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503C3330305;
	Thu,  7 May 2026 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197536; cv=none; b=YTWi1sRh5pMuz6+1uX+Co1nl6rFSm+zJ0pAg9TZqJjWLCamlfbD7k0u5IyU66Yk+BwYhWXmrSANlUl139O/yUmpKC5rv/g6wLxoXEEzsXCgJpDOhiANqdLbZ6+VIXOjWuUEA+SjbkvrEoXu6rQJ5vhB/AztTYxAzfRHrlIEEMuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197536; c=relaxed/simple;
	bh=CM8PF4glXhSIUUFov2JRwRrYLQD4FIGt4Ki8AIzCf1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdLHbXZ9IgzvWIgJbqq0lbo6p+nGLBNqn5YHRwEzcjKbaGSYGFaYW7b7f4pjxLRIFls5qSDMmCs/RkQV0EieQ9KK5vy30Skl0ppt/zdsfBbV054tsbtSav4xs9fhgBVLX3nWbDecMd5GDuscq/iY6PzZVIKhfKKIHldKnUvTV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pE3sxC+G; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pE3sxC+G"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5B13860263;
	Fri,  8 May 2026 01:45:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197532;
	bh=a5lOgFJcNBDO0z7vBkeJmy4xfYqzSaHzCX4uD4W3SVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE3sxC+GV87sIVe77UalmJrPFiFdqck8pfjtdU5sv+9uMKoY2r81xUbT/9dhU3T2h
	 9vmEMOQNLQvW+ravM/RBgxzw8dqtL4VZspAuIt/Hmb5ud9jEv+JlLfzLXsfWMDqFya
	 1KvYYK9EpM7BVMO6gjeWAVDjzQ8NeM8s3Bwsw7HRH9LC5AL3xbU50M2t90FM01HM9x
	 P4UXSjzJVdoh2PJ/8SCfmRGgDcnGHw5QBlkrFuNevrLrjSUOceKeiAQxIDN5TAjuWx
	 aWTEVAaFAUG95+oH/zZ7RYD7EV/A9jVwwzRlQEnR1sM2a7D1yDz2aYZ+qD/7/bleOu
	 ymMw/qcXmcTbg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 13/13] netfilter: nft_ct: fix missing expect put in obj eval
Date: Fri,  8 May 2026 01:45:09 +0200
Message-ID: <20260507234509.603182-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507234509.603182-1-pablo@netfilter.org>
References: <20260507234509.603182-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Xiasong <lixiasong1@huawei.com>

nft_ct_expect_obj_eval() allocates an expectation and may call
nf_ct_expect_related(), but never drops its local reference.

Add nf_ct_expect_put(exp) before return to balance allocation.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 60ee8d932fcb..fa2cc556331c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1334,6 +1334,8 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
-- 
2.47.3

