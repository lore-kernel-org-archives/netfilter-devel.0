From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/20] netfilter: nf_tables: fix endian mismatch in return type
Date: Sat,  2 Jun 2018 02:22:47 +0200
Message-ID: <20180602002259.4024-9-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

harmless, but it avoids sparse warnings:

nf_tables_api.c:2813:16: warning: incorrect type in return expression (different base types)
nf_tables_api.c:2863:47: warning: incorrect type in argument 3 (different base types)
nf_tables_api.c:3524:47: warning: incorrect type in argument 3 (different base types)
nf_tables_api.c:3538:55: warning: incorrect type in argument 3 (different base types)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 583673743648..8f04bfc41bf9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2830,7 +2830,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 	return 0;
 }
 
-static u64 nf_jiffies64_to_msecs(u64 input)
+static __be64 nf_jiffies64_to_msecs(u64 input)
 {
 	u64 ms = jiffies64_to_nsecs(input);
 
-- 
2.11.0
