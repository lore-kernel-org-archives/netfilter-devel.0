Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0B114199C
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143122; cv=none; b=mVdgNqYqV3m3C5g4RPRldm3uwlKK87SH+HZxtW8rJVA0LLc2PvgNCTKrV0PZfLMfPJVYZ45/4e5eJVaVMgia+aioALbGL4f5eA1ktIYRB4htIritRBcUk+pn6rGhrYVXRlqMzZz6ybhiJWNo+wZ2p2k6LtREgzE2rZ54MPsPdzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143122; c=relaxed/simple;
	bh=ZzyG1gciZFzce2wDH6g7G0YzHshotoUnbp9f64Ej6k0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dA9Yv2MWu/7DVHEdbOa/JBxYvooTF120hZKOX1DIvJFPeGwviP0/2H5svi/a6eTr/Ik+dcwp4LHgNkEmqV55CJgA4yd90hZ8VVMakx0QkJRu/5rf9syVAxr8Io4M0Ju0qJLFo5LUH0rjjlBw8xTF9eNp5cNaIsN92nYOyzj1jBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 4/4] netfilter: nf_tables: reject new basechain after table flag update
Date: Wed,  3 Apr 2024 13:18:32 +0200
Message-Id: <20240403111832.234325-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240403111832.234325-1-pablo@netfilter.org>
References: <20240403111832.234325-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dormant flag is toggled, hooks are disabled in the commit phase by
iterating over current chains in table (existing and new).

The following configuration allows for an inconsistent state:

  add table x
  add chain x y { type filter hook input priority 0; }
  add table x { flags dormant; }
  add chain x w { type filter hook input priority 1; }

which triggers the following warning when trying to unregister chain w
which is already unregistered.

[  127.322252] WARNING: CPU: 7 PID: 1211 at net/netfilter/core.c:50                                                                     1 __nf_unregister_net_hook+0x21a/0x260
[...]
[  127.322519] Call Trace:
[  127.322521]  <TASK>
[  127.322524]  ? __warn+0x9f/0x1a0
[  127.322531]  ? __nf_unregister_net_hook+0x21a/0x260
[  127.322537]  ? report_bug+0x1b1/0x1e0
[  127.322545]  ? handle_bug+0x3c/0x70
[  127.322552]  ? exc_invalid_op+0x17/0x40
[  127.322556]  ? asm_exc_invalid_op+0x1a/0x20
[  127.322563]  ? kasan_save_free_info+0x3b/0x60
[  127.322570]  ? __nf_unregister_net_hook+0x6a/0x260
[  127.322577]  ? __nf_unregister_net_hook+0x21a/0x260
[  127.322583]  ? __nf_unregister_net_hook+0x6a/0x260
[  127.322590]  ? __nf_tables_unregister_hook+0x8a/0xe0 [nf_tables]
[  127.322655]  nft_table_disable+0x75/0xf0 [nf_tables]
[  127.322717]  nf_tables_commit+0x2571/0x2620 [nf_tables]

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 17bf53cd0e84..1eb51bf24fc2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2449,6 +2449,9 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook = {};
 
+		if (table->flags & __NFT_TABLE_F_UPDATE)
+			return -EINVAL;
+
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-- 
2.30.2

