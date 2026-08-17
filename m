Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A594E3F4139;
	Mon, 17 Aug 2026 23:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009413; cv=none; b=L9GKlJ8fXSYRQ27qwMKCeesY7IhwLmirPsRrIDznvgtgwJ6zItKhIXbDqIS05L1Xl4fTKtvq/kA/14de1cQvq4wCSH4vJvFOXXKamBLB+z6rh7mdrM7xvgVgWU7sZclA5V5DA9vgHAKFrbbX3UjpRrOcYsE1wSNZ8DHwaAIiJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009413; c=relaxed/simple;
	bh=rQv/xpUVbRdBvCLI2pUDuZxmR8uOEPenE3JtWp5/Sl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAPVeawAYuIgCmn/ZsHu4bZVAvffN8McdwdXWqYgNZ3xX2yrag19a0vrox3RzC2zxpucUIkXyf3EV8QfLaH9//nkw5tZZEvH0mqU/XgTroEX/OrjqVU6BIQuPAItfjLpB4d0mkWaU5KuBDOnzvPu1e8KnWSKdqPBvm626StrlYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EpII/EqT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EpII/EqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009409;
	bh=0memJEDLw1LtCrMTHsDfAbMRKtjERZIfOqRkKphTksQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpII/EqTtT809v1B99flTwAm5f140RqgRw/U14EEPJlor2f18j0MTH+8j1QuPQ8g1
	 6E1FAWmsMmsn51vyLTClUj8G91iOrwF+Xw/NDAGxcC7ylvocXquaN8uPQM73pv6TsE
	 EKhKPi8DRWdYTTvMzd7Kkf7w9xKwJ+E7YXl3r72OHE/VU47HkN5W0kP7JfAPYClppJ
	 7F2oO1O+Cw4wv/198PP2hhvV9kMZYnYTjepVKOELp4eZ2bDixCYKDQW1WmwG24Xb3L
	 8hnuBOswD7x3i9KUjzhmI/jibFcscnH88fPujPHDnSS8mNloZVTL5Z9Acs74qzAuHu
	 G0Yk+Le/JRZww==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2807C6008F;
	Tue, 18 Aug 2026 01:30:09 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 4/8] netfilter: nf_conntrack_expect: consolidate check for insertion of dead expectation
Date: Tue, 18 Aug 2026 01:29:53 +0200
Message-ID: <20260817232957.1281637-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate the check for buggy expectations with DEAD flag on
insertion, which is called both by nf_ct_expect_related() and
nf_ct_expect_related_pair().

Fixes: e765c95faa10 ("netfilter: nf_conntrack_expect: bail out on insert dead expectations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f1f0c582db5d..06242c86e1dc 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -477,6 +477,11 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 
 	lockdep_nfct_expect_lock_held();
 
+	if (expect->flags & NF_CT_EXPECT_DEAD) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (nf_ct_exp_is_expired(i)) {
@@ -528,12 +533,6 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	if (expect->flags & NF_CT_EXPECT_DEAD) {
-		DEBUG_NET_WARN_ON_ONCE(1);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	master_help = nfct_help(expect->master);
 	if (!master_help) {
 		ret = -ESHUTDOWN;
-- 
2.47.3

