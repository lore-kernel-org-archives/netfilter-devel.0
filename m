From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] netfilter: nf_tables: set names cannot be larger than 15 bytes
Date: Sat,  5 Apr 2014 18:03:48 +0200
Message-ID: <1396713830-4009-7-git-send-email-pablo@netfilter.org>
References: <1396713830-4009-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1396713830-4009-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently, nf_tables trims off the set name if it exceeeds 15
bytes, so explicitly reject set names that are too large.

Reported-by: Giuseppe Longo <giuseppelng@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 33045a5..43ae487 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1946,7 +1946,8 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
 
 static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
-	[NFTA_SET_NAME]			= { .type = NLA_STRING },
+	[NFTA_SET_NAME]			= { .type = NLA_STRING,
+					    .len = IFNAMSIZ - 1 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
-- 
1.7.10.4
