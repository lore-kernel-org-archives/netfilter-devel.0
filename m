From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] netfilter: nf_tables: validate NFTA_SET_TABLE parameter
Date: Wed,  1 Jun 2016 14:03:23 +0200
Message-ID: <1464782604-19346-7-git-send-email-pablo@netfilter.org>
References: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Turnbull <phil.turnbull@oracle.com>

If the NFTA_SET_TABLE parameter is missing and the NLM_F_DUMP flag is
not set, then a NULL pointer dereference is triggered in
nf_tables_set_lookup because ctx.table is NULL.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2011977..6947e25 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2641,6 +2641,8 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	/* Only accept unspec with dump */
 	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
+	if (!nla[NFTA_SET_TABLE])
+		return -EINVAL;
 
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
-- 
2.1.4
