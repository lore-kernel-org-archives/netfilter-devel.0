Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7D3A1BF
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Feb 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708358347; cv=none; b=plYeIlnKyGBlqbUTmGpZum0m7LAHpTAl8XRG51KstDVwfNgG8x/m8IB2wo/ss388PrD78+ez7HYcbrDAahSA92HFts5TMQVuyOcGpbhs6l5cbfey8gZW4dATcYIqJUmX9K6/lOaGPMs4Z64Fjfr2OUTWiZzvJHBdIo20S7LwItI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708358347; c=relaxed/simple;
	bh=tJpknELIUjGb3hTlK4222744anHl+ML3H/CQqxdtIso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iousil1Izu/3gpB0FwOV89o5ONcEwkgFbmfVzcUw33lf11ZEF+9NbQybCXybd5Cl1okXT19s1du9a0LUWc6qUXWKkQBEEwrZ0Cmij523ZKn/WO0ZmKU3yhotpdhjukUs2i/Wx2ts/SFi+W+BeqtcIImK7kjLo8foriFCa97n9tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rc62k-0005iI-C4; Mon, 19 Feb 2024 16:58:58 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: set dormant flag on hook register failure
Date: Mon, 19 Feb 2024 16:58:04 +0100
Message-ID: <20240219155809.9651-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to set the dormant flag again if we fail to register
the hooks.

During memory pressure hook registration can fail and we end up
with a table marked as active but no registered hooks.

On table/base chain deletion, nf_tables will attempt to unregister
the hook again which yields a warn splat from the nftables core.

Reported-and-tested-by: syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f8e3f70c35bd..90038d778f37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1251,6 +1251,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0

