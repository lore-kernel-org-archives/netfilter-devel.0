Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B234D40FD92;
	Mon,  9 Mar 2026 21:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090537; cv=none; b=nMXmLK4gKBlNWAYW4w9ITEwrsQlmjDJvaKxGO1sYXrscY7T9aJO3oXMx5R0XY49Oa1rLWAlV2gq7CLYdSz0OBKctTEg+v98OzF33QllUX9NNCRB5K2R/LrxO0eeExzbK+EDDuWrVLAgbk7wA8ruRB2TukEppL5qrr7nIi874TxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090537; c=relaxed/simple;
	bh=vpDW84VkZZPvlCCoOnVRCQ9HyLV3eJ3laKNPkd02lzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yywg5uAQQ7tIPinZGIXmr2kLNU5rpwWpYbavjHKM43McRsz+5qTVHS2PwDvOESuCfp84n71GPtFx1uYlVqMsVCS9XXmWm84vyqN6llhRCWszqqSSUaxq9Uxmq1JOiclIKtvtq8nGBRaW7FfT+zXOS3EyCibvZTgcDWPw101Q4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E6E8B60D2E; Mon, 09 Mar 2026 22:08:53 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 01/10] netfilter: nf_tables: Fix for duplicate device in netdev hooks
Date: Mon,  9 Mar 2026 22:08:36 +0100
Message-ID: <20260309210845.15657-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260309210845.15657-1-fw@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

When handling NETDEV_REGISTER notification, duplicate device
registration must be avoided since the device may have been added by
nft_netdev_hook_alloc() already when creating the hook.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
Tested-by: Helen Koike <koike@igalia.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c    | 2 +-
 net/netfilter/nft_chain_filter.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1862bd7fe804..710f0ee21a34 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9688,7 +9688,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kzalloc_obj(struct nf_hook_ops,
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..041426e3bdbf 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -344,7 +344,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kmemdup(&basechain->ops,
-- 
2.52.0

