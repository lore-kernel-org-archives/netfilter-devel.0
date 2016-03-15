From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/18] netfilter: nfnetlink_acct: validate NFACCT_FILTER parameters
Date: Tue, 15 Mar 2016 02:27:46 +0100
Message-ID: <1458005282-24665-3-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188AbcCOB2b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:28:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9BE3A114F57
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DA72DA383
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2C6FBDA388
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:20 +0100 (CET)
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Turnbull <phil.turnbull@oracle.com>

nfacct_filter_alloc doesn't validate the NFACCT_FILTER_MASK and
NFACCT_FILTER_VALUE parameters which can trigger a NULL pointer
dereference. CAP_NET_ADMIN is required to trigger the bug.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

