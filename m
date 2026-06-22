Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FEF2BEC4E
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782156993; cv=none; b=m4KpT04Ueeq1eKuhPBvewwyk/2jeqEUn6TNyWResM0jQqZbo8cvRsxCPGJJArTe9BCo4eIdob4+xd3O/unPe6f+lWzoIbVLyFdQqo0z2JIulSlSNEXIbGMjrnECydaEDIGhIxH5XhgzPGtIsE0va7thQFz+KOqiTbTIY//wjgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782156993; c=relaxed/simple;
	bh=gcJ7r0Rk+emwSkMoID38ls+8+FMwhKsvBCZII3jWDcU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cchtYJiyX8ahu9UxVhwfeIClJjaHjuADyHKvbW3MRhnDrQtKspliSqcexxZrMiPpWxNCaLva+YeFiWmUo7ReCvbcZpoUk6EI1a7YpqtYGc6z31F2DvQlogJt1RDfd7NHnEnQ/6NTds0GWd/NnOjrHYIXQbd0MbeD2xUjR7Xwosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YIkmTQx5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YIkmTQx5"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 62F52600B9
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 21:36:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782156989;
	bh=3dBrP8MaA39eTKZ2h9cyivMwFirS08+AfOlg0FkjNvI=;
	h=From:To:Subject:Date:From;
	b=YIkmTQx5028TdmzZd9+EB2G9wo5yS2x1ckPKra1ujH84Cmbqa+kHBVp3HupRzRI8Z
	 eGPvPjOdek8+ndFdYYSy5o8YdluvzPlc4R6Gr0TzNcHbUGrRnGhbqLTVRxWivZOs39
	 jQCPo9+IEiOd00OfVdKFKWYZHHlqU9/nY+GxkGdERyXZIc/TlrhQHmZuFdUjihdVIU
	 VJ6L5JvT0YBgW8MzoOOssDXfwpP2IWi+ddF+SQD/9nEFOmkJSeM6NuVuzJ24yaUOe7
	 iVxgr3GlHk65gEbZ4ybJBKh3nZ57pOuttMWzNPC8jT4VfM3u7OkH38gBJkAxJts5AW
	 7GKfG3cwHf44A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack_expect: run expectation eviction with no helper
Date: Mon, 22 Jun 2026 21:36:25 +0200
Message-ID: <20260622193625.286478-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Run expectation eviction if no helper is specified to deal with the
nft_ct expectation support.

Cap the maximum expectation limit per master conntrack to
NF_CT_EXPECT_MAX_CNT (255).

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9454913e1b33..113bb1cb1683 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -499,6 +499,13 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
+	} else {
+		const struct nf_conntrack_expect_policy default_exp_policy = {
+			.max_expected = NF_CT_EXPECT_MAX_CNT,
+		};
+
+		if (master_help->expecting[expect->class] >= default_exp_policy.max_expected)
+			evict_oldest_expect(master_help, expect, &default_exp_policy);
 	}
 
 	cnet = nf_ct_pernet(net);
-- 
2.47.3

