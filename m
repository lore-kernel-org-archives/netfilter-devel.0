Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C11933DEFC;
	Fri,  1 May 2026 12:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638173; cv=none; b=Yh3JXW8kaKzZksh8yO8EpAg1J+3WqW7WYN2SIYJqxq6gXu5i9LCAHi6sY9JQfY7fh3oKMHp9k5r88SM/oAzayYlJZmbDyIJTQmwq0pwF0q7DAeftOoaQ+OXBhk++ru9T9Chrd3gz1ncMgd0WxXVxoDpKJu6W+RO2fjJrWaZ89SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638173; c=relaxed/simple;
	bh=YRm7S3lQnRkm9w9lpUqeXAReP3mewEujPX7HTKTY0Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haVnUbv4sg0qqWy9PrVmCCqjPiDZeO2ULJAxbBQzGeHBwWKxRdBaGUvuQGOJzTdLhRxRalSz1X9fQCPUP84K0lSzrXStTouVu5+r+MfzLhK7MhTM1s2Q2axdAimiSC8ZcP/GSG3lJ1xqCsz3DibNCFDhjlAwf79DaK9x4g0kziI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qA088Hgf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qA088Hgf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 41B7A6017E;
	Fri,  1 May 2026 14:22:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638170;
	bh=fZwSvvmeyQnZkScrJJgUoW+nORgPNsfW7+kVz6fkUWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qA088HgfoU7lFh81pRbSPJFRKmO45azBuQbj0CF9OIGuNA0vRDkdQuwt0JalTvRi5
	 sPGJ1+WdNbENGnyuOzbSvTF9DT9lwN+zt5hz+TPNpAiYF5zdgUWz4xCBFp+i2OaiR9
	 ZjnzNcfZbP2X/46/S9kSlmNHkt1SIj0YHQzly4M8+xqY2eCZkoCcuvEm7+PWmGh9by
	 nyNMmFbJ1c0m+0PBpyOw3RhR+V7W79LV4qCYH97jBrZP6LMOFx+OU8qGGtMJY0UbkZ
	 TCyCnMFPVZWdsfTjNT05RPILEoxsievHgdg2WqBjo4mMWWRDJB+9qFHt9RkdGuhG5r
	 XmPeolB1mKm9Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/14] netfilter: xt_CT: fix usersize for v1 and v2 revision
Date: Fri,  1 May 2026 14:22:29 +0200
Message-ID: <20260501122237.296262-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

While resurrecting the conntrack-tool test cases I found following bug:
In:
iptables -I OUTPUT -t raw -p 13 -j CT --timeout test-generic
Out:
[0:0] -A OUTPUT -p 13 -j CT --timeout test

Data after first four bytes of the timeout policy name is never
copied to userspace because its treated as kernel-only.

Fixes: ec2318904965 ("xtables: extend matches and targets with .usersize")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 498f5871c84a..d2aeacf94230 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -354,7 +354,7 @@ static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.targetsize	= sizeof(struct xt_ct_target_info_v1),
-		.usersize	= offsetof(struct xt_ct_target_info, ct),
+		.usersize	= offsetof(struct xt_ct_target_info_v1, ct),
 		.checkentry	= xt_ct_tg_check_v1,
 		.destroy	= xt_ct_tg_destroy_v1,
 		.target		= xt_ct_target_v1,
@@ -366,7 +366,7 @@ static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.revision	= 2,
 		.targetsize	= sizeof(struct xt_ct_target_info_v1),
-		.usersize	= offsetof(struct xt_ct_target_info, ct),
+		.usersize	= offsetof(struct xt_ct_target_info_v1, ct),
 		.checkentry	= xt_ct_tg_check_v2,
 		.destroy	= xt_ct_tg_destroy_v1,
 		.target		= xt_ct_target_v1,
@@ -398,7 +398,7 @@ static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.revision	= 1,
 		.targetsize	= sizeof(struct xt_ct_target_info_v1),
-		.usersize	= offsetof(struct xt_ct_target_info, ct),
+		.usersize	= offsetof(struct xt_ct_target_info_v1, ct),
 		.checkentry	= xt_ct_tg_check_v1,
 		.destroy	= xt_ct_tg_destroy_v1,
 		.target		= xt_ct_target_v1,
@@ -410,7 +410,7 @@ static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.revision	= 2,
 		.targetsize	= sizeof(struct xt_ct_target_info_v1),
-		.usersize	= offsetof(struct xt_ct_target_info, ct),
+		.usersize	= offsetof(struct xt_ct_target_info_v1, ct),
 		.checkentry	= xt_ct_tg_check_v2,
 		.destroy	= xt_ct_tg_destroy_v1,
 		.target		= xt_ct_target_v1,
-- 
2.47.3

