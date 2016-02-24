From: Phil Turnbull <phil.turnbull@oracle.com>
Subject: [PATCH nf] netfilter: nfnetlink_acct: validate NFACCT_FILTER parameters
Date: Wed, 24 Feb 2016 15:34:43 -0500
Message-ID: <1456346083-15562-1-git-send-email-phil.turnbull@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org, Phil Turnbull <phil.turnbull@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29661 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcBXUgs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2016 15:36:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfacct_filter_alloc doesn't validate the NFACCT_FILTER_MASK and
NFACCT_FILTER_VALUE parameters which can trigger a NULL pointer
dereference. CAP_NET_ADMIN is required to trigger the bug.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
---
 net/netfilter/nfnetlink_acct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 5274b04..4c2b4c0 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -242,6 +242,9 @@ nfacct_filter_alloc(const struct nlattr * const attr)
 	if (err < 0)
 		return ERR_PTR(err);
 
+	if (!tb[NFACCT_FILTER_MASK] || !tb[NFACCT_FILTER_VALUE])
+		return ERR_PTR(-EINVAL);
+
 	filter = kzalloc(sizeof(struct nfacct_filter), GFP_KERNEL);
 	if (!filter)
 		return ERR_PTR(-ENOMEM);
-- 
1.9.1

