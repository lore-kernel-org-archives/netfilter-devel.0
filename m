Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AA19D2
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 05:46:19 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: bail out on mismatching dynset and set expressions
Date: Mon,  4 Dec 2023 14:46:15 +0100
Message-Id: <20231204134615.2406-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If dynset expressions provided by userspace is larger than the declared
set expressions, then bail out.

Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index b18a79039125..c09dba57354c 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -280,10 +280,15 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			priv->expr_array[i] = dynset_expr;
 			priv->num_exprs++;
 
-			if (set->num_exprs &&
-			    dynset_expr->ops != set->exprs[i]->ops) {
-				err = -EOPNOTSUPP;
-				goto err_expr_free;
+			if (set->num_exprs) {
+				if (i >= set->num_exprs) {
+					err = -EINVAL;
+					goto err_expr_free;
+				}
+				if (dynset_expr->ops != set->exprs[i]->ops) {
+					err = -EOPNOTSUPP;
+					goto err_expr_free;
+				}
 			}
 			i++;
 		}
-- 
2.30.2

