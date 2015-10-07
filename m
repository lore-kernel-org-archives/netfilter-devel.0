From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_conntrack_netlink: fix nf-nat module
 loaded checking
Date: Wed, 7 Oct 2015 13:27:27 +0900
Message-ID: <20151007042727.GD23203@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35811 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbJGE1c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Oct 2015 00:27:32 -0400
Received: by pacfv12 with SMTP id fv12so8478675pac.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 21:27:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151007042016.GA23203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9f52729..dd13596 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1389,7 +1389,7 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 		}
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		rcu_read_lock();
-		if (nfnetlink_parse_nat_setup_hook)
+		if (rcu_dereference(nfnetlink_parse_nat_setup_hook))
 			return -EAGAIN;
 #endif
 		return -EOPNOTSUPP;
-- 
1.7.10.4

