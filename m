From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/15] netfilter: prefer nla_strlcpy for dealing with NLA_STRING attributes
Date: Mon, 14 May 2018 00:36:50 +0200
Message-ID: <20180513223656.10077-10-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

fixes these warnings:
'nfnl_cthelper_create' at net/netfilter/nfnetlink_cthelper.c:237:2,
'nfnl_cthelper_new' at net/netfilter/nfnetlink_cthelper.c:450:9:
./include/linux/string.h:246:9: warning: '__builtin_strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Moreover, strncpy assumes null-terminated source buffers, but thats
not the case here.
Unlike strlcpy, nla_strlcpy *does* pad the destination buffer
while also considering nla attribute size.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c     | 2 +-
 net/netfilter/nfnetlink_cthelper.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index b9505bcd3827..6ddf89183e7b 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -115,7 +115,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		nfacct->flags = flags;
 	}
 
-	strncpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
+	nla_strlcpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
 
 	if (tb[NFACCT_BYTES]) {
 		atomic64_set(&nfacct->bytes,
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 4a4b293fb2e5..fa026b269b36 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -149,8 +149,8 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 	    !tb[NFCTH_POLICY_EXPECT_TIMEOUT])
 		return -EINVAL;
 
-	strncpy(expect_policy->name,
-		nla_data(tb[NFCTH_POLICY_NAME]), NF_CT_HELPER_NAME_LEN);
+	nla_strlcpy(expect_policy->name,
+		    nla_data(tb[NFCTH_POLICY_NAME]), NF_CT_HELPER_NAME_LEN);
 	expect_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
 	if (expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
@@ -234,7 +234,8 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	if (ret < 0)
 		goto err1;
 
-	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
+	nla_strlcpy(helper->name,
+		    nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
 	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
 	if (size > FIELD_SIZEOF(struct nf_conn_help, data)) {
 		ret = -ENOMEM;
-- 
2.11.0
