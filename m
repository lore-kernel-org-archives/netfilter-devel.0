From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/33] netfilter: nf_tables: Support RULE_ID reference in new rule
Date: Tue, 29 Jan 2019 00:57:23 +0100
Message-ID: <20190128235750.18412-7-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

To allow for a batch to contain rules in arbitrary ordering, introduce
NFTA_RULE_POSITION_ID attribute which works just like NFTA_RULE_POSITION
but contains the ID of another rule within the same batch. This helps
iptables-nft-restore handling dumps with mixed insert/append commands
correctly.

Note that NFTA_RULE_POSITION takes precedence over
NFTA_RULE_POSITION_ID, so if the former is present, the latter is
ignored.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c            | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7de4f1bdaf06..99ca95b830b6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -219,6 +219,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
+ * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -231,6 +232,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_USERDATA,
 	NFTA_RULE_PAD,
 	NFTA_RULE_ID,
+	NFTA_RULE_POSITION_ID,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 621ff834d3a4..d88c86c5b433 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2610,6 +2610,9 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nlattr *nla);
+
 #define NFT_RULE_MAXEXPRS	128
 
 static int nf_tables_newrule(struct net *net, struct sock *nlsk,
@@ -2679,6 +2682,12 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
 				return PTR_ERR(old_rule);
 			}
+		} else if (nla[NFTA_RULE_POSITION_ID]) {
+			old_rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_POSITION_ID]);
+			if (IS_ERR(old_rule)) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION_ID]);
+				return PTR_ERR(old_rule);
+			}
 		}
 	}
 
-- 
2.11.0
