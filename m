Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE71F0E56
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 12:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743511057; cv=none; b=uYuI/HBs1UtpTzOOJ6HsNMOwqvZsZtI1B93WXKp01RZz/+79fgdNWeAznWeZtho+weozhjnpWQH54uyLpWqrysHEz/UHEuTGVhSN2muIke5IbFvB5Vp9kAg9oPXhxhQa7anwIl1WPqhT+hO85f03CtYgtmVJYDRM/LygF+7huUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743511057; c=relaxed/simple;
	bh=S7uCprw/HlNueaMM7uKNB/PD8BjghObdsrX2gmIhe6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KiLztlwezxXOyrN9CejU/J99udMr2nZ5bUHbbvAd93DgZhVr6ySFMt0S0ob77IHg4FnEPTr0vp8SfLr9RvQH3zP7OART6o4gXS10cYhFoLUMdcmF5h0wW91h01arWmpO0evoM7oWt5m3S+yGShovn6ilkJqlokx35LkJ/Hg0YQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzaru-00075c-Ck; Tue, 01 Apr 2025 14:37:26 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: don't unregister hook when table is dormant
Date: Tue,  1 Apr 2025 14:36:47 +0200
Message-ID: <20250401123651.29379-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When nf_tables_updchain encounters an error, hook registration needs to
be rolled back.

This should only be done if the hook has been registered, which won't
happen when the table is flagged as dormant (inactive).

Just move the assignment into the registration block.

Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e950..567cea329e1f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2840,9 +2840,9 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			if (err < 0)
 				goto err_hooks;
 		}
-	}
 
-	unregister = true;
+		unregister = true;
+	}
 
 	if (nla[NFTA_CHAIN_COUNTERS]) {
 		if (!nft_is_base_chain(chain)) {
-- 
2.49.0

