Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC63074AE
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 12:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772712113; cv=none; b=lb3F8OXZQGwyc/nsRJ+QrkrN1wxBXdhHo0MZpJKGWYfbaIXa38jOrvCE6z0SyoV+kORPjcQjSo16q6DuPS/NnXNikKhvnYso7dx2woawuO0IsRs4HCb0MBlRFESZs1pX7cgHryVV3oRpzGw+H2xwrmTM6sCp9njM4Psq0BYcbHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772712113; c=relaxed/simple;
	bh=/OYRhvMf4HXN9ML+7REUXCWvFxcnwKeDEG+SwSk6rZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BxNs6KjtsJLaluJGE+DNkYYYWfCh3czxTGsb2EYhoa4GLwKQ2X8QjFTsWJflnant09adRRyB2c2TsOSsz6eTgvNWcz5dU3MlJwSUH5c/oy+bPX5gPYZddH4KQyDUCAWN1m9Xo+3CotczKU/b3zf+UUwIuEhFxd0Nv3OUfH4CKoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WQ7zualv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WQ7zualv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s3NWwx/n1fDrEqa8feqVnpuHz0P2xZbrwnRaFVOWjPQ=; b=WQ7zualva2iRGFxc1o0eySPKxp
	k0DJfOecLknwm898VzZYE2hoMcRhS3lw8ZXhB+y9uCUS/dQ6jAcOZXr5TJ+iLZZUNRUsoZoah/iiw
	LaqF8Tp9Uo0XTk+7bZm3AqOw1UI7yieCajnasR1rpBgEJdPayS0C5zxbxZwLLTqKGxh7nWsqx2vsv
	4GPo5x+IhFfEBFi9Ew9FKgAy6Jq+kBO2rH291yLK7G9nIST71fjWf7IucfBUt3CBpF1kCrZV2uWLy
	Mhch9b8GPYKBTpZNuxqwoZFd8Co57yxJ+yaUPlgM8WxTEEyl7QtI3VoAEliUI+sO2nReTaw+vnjhD
	r8jjCFNQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vy7On-000000007pw-1zXB;
	Thu, 05 Mar 2026 13:01:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Helen Koike <koike@igalia.com>,
	Florian Westphal <fw@strlen.de>,
	syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Subject: [nf PATCH] netfilter: nf_tables: Fix for duplicate device in netdev hooks
Date: Thu,  5 Mar 2026 13:01:44 +0100
Message-ID: <20260305120144.26350-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When handling NETDEV_REGISTER notification, duplicate device
registration must be avoided since the device may have been added by
nft_netdev_hook_alloc() already when creating the hook.

Cc: Helen Koike <koike@igalia.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c    | 2 +-
 net/netfilter/nft_chain_filter.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c5a4855b97d..29f54998a637 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9679,7 +9679,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
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
2.51.0

