From: Phil Turnbull <phil.turnbull@oracle.com>
Subject: [PATCH nf] netfilter: nf_tables: validate NFTA_SET_TABLE parameter
Date: Fri, 27 May 2016 13:34:04 -0400
Message-ID: <1464370444-28312-1-git-send-email-phil.turnbull@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org, Phil Turnbull <phil.turnbull@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbcE0RfL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2016 13:35:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the NFTA_SET_TABLE parameter is missing and the NLM_F_DUMP flag is
not set, then a NULL pointer dereference is triggered in
nf_tables_set_lookup because ctx.table is NULL.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c444929..569ba6a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2647,6 +2647,8 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	/* Only accept unspec with dump */
 	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
+	if (!nla[NFTA_SET_TABLE])
+		return -EINVAL;
 
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
-- 
2.8.0

