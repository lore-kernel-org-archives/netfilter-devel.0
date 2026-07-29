Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C64756A3
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324958; cv=none; b=HbtRR3MP/8xn6n0vvq5GJr603ldWHcS6GS13ABonITvM4Xha6bbAckAl5V1l1HK228aKA3Zr/y3q97XAE+jvN7E+fIH/mgw3EF9SmJ3RmGC/dViMkUxAeu59n8vtCQnnk0uO5l03AZHxiqD5KsKKlZ+d2tpFAktLL7Pg93gTiD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324958; c=relaxed/simple;
	bh=6TRG0/vHHzG3hLT7fjJb44Q/Cvynh+BiqoLLAXG2Rtg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oRvOkwUYypRbzCbhwxEHCcNQxflZkNAsPpdvGqdOQzUAKmwW/mrJKl7VTzTT0v2PFCVGDdx0Ugl14LfZbelFaK1m+eHpgdNhOB6MufgrYNFKOauyA2l+GaEDOw4sbQBWWZId7JpodbvPg4T0IbHm1fUZWyY1cCs7RmE1aq+Zk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jIEBrujP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jIEBrujP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D0C51601A6
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:35:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785324953;
	bh=0MA4MfnDN6iVgwGP/5tQD06WiT/6qKic4GdTwfwBGV0=;
	h=From:To:Subject:Date:From;
	b=jIEBrujPLwa70HgDsLSbmuAWzi0kKsT0HF3r8IDOB9hm3zlkbt5mdJ6f5/cEGTAhQ
	 V2fhl2Sgsfxs5vpKd4rJdvMp6SXMIDpbbL9jAAhtjB8tliNgS277yjAjAEX9TabgNQ
	 bnENk1bmtZGudGD4fZPBoTA3V/O1Zh4FffyG2VoXqilRamOqdH1iQ1w7ETP5zPthrq
	 bn3xG6MmVOoRuLhB5IBIOKu3X6qvJebyHCIdsG9Pbjeai5ca67sCrB218XL/64JJoK
	 pZ6YkB7tadgWtktUvzcGDSsa/xAlfJjfARl3EGtPoEgiuDsN1BUK5jMgmtsbQxXWBr
	 YlLMxLJ3pQSlQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: ctnetlink: reject expectation deletions on unconfirmed conntrack
Date: Wed, 29 Jul 2026 13:35:47 +0200
Message-ID: <20260729113548.389791-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink allows to reach expectations that refer to unconfirmed
conntrack. The ct extension area of unconfirmed conntrack could be
reallocated while the packet is in transit.

While holding the spinlock, check if the master conntrack is
unconfirmed. The existing expectation spinlock ensures that the master
conntrack is still alive because nf_ct_remove_expectations() tears down
all expectations on conntrack removal. So, while holding the spinlock,
the lifetime of the expectations is attached to the master conntrack.

Fixes: ecfab2c9fe55 [NETFILTER]: nf_conntrack: introduce extension infrastructure
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series, to address sashiko report.

 net/netfilter/nf_conntrack_expect.c  | 3 +++
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8a3b9e33e94f..7694deaa5b12 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -620,6 +620,9 @@ void nf_ct_expect_iterate_net(struct net *net,
 			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
+			if (!nf_ct_is_confirmed(exp->master))
+				continue;
+
 			if (iter(exp, data))
 				nf_ct_unlink_expect_report(exp, portid, report);
 		}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31cbb1b55b9e..b58f51372849 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3442,6 +3442,12 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 			}
 		}
 
+		if (!nf_ct_is_confirmed(exp->master)) {
+			nf_ct_expect_put(exp);
+			spin_unlock_bh(&nf_conntrack_expect_lock);
+			return -EBUSY;
+		}
+
 		/* after list removal, usage count == 1 */
 		nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
 					   nlmsg_report(info->nlh));
-- 
2.47.3

