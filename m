From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/13] netfilter: nf_tables: indicate family when dumping set elements
Date: Wed, 18 Jun 2014 11:44:35 +0200
Message-ID: <1403084679-11227-10-git-send-email-pablo@netfilter.org>
References: <1403084679-11227-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1403084679-11227-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Set the nfnetlink header that indicates the family of this element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 39369ea..ab4566c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2850,7 +2850,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family = NFPROTO_UNSPEC;
+	nfmsg->nfgen_family = ctx.afi->family;
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id       = 0;
 
-- 
1.7.10.4
