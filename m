From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/16] netfilter: nf_tables: don't use position attribute on rule replacement
Date: Wed, 28 Nov 2018 11:17:31 +0100
Message-ID: <20181128101741.20924-7-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its possible to set both HANDLE and POSITION when replacing a rule.
In this case, the rule at POSITION gets replaced using the
userspace-provided handle.  Rule handles are supposed to be generated
by the kernel only.

Duplicate handles should be harmless, however better disable this "feature"
by only checking for the POSITION attribute on insert operations.

Fixes: 5e94846686d0 ("netfilter: nf_tables: add insert operation")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dd577e7d100c..e496030fdc3b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2589,17 +2589,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 		if (chain->use == UINT_MAX)
 			return -EOVERFLOW;
-	}
-
-	if (nla[NFTA_RULE_POSITION]) {
-		if (!(nlh->nlmsg_flags & NLM_F_CREATE))
-			return -EOPNOTSUPP;
 
-		pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
-		old_rule = __nft_rule_lookup(chain, pos_handle);
-		if (IS_ERR(old_rule)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
-			return PTR_ERR(old_rule);
+		if (nla[NFTA_RULE_POSITION]) {
+			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
+			old_rule = __nft_rule_lookup(chain, pos_handle);
+			if (IS_ERR(old_rule)) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
+				return PTR_ERR(old_rule);
+			}
 		}
 	}
 
-- 
2.11.0
