Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA3218047;
	Fri, 22 Dec 2023 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 1/8] netfilter: nf_tables: Pass const set to nft_get_set_elem
Date: Fri, 22 Dec 2023 12:57:07 +0100
Message-Id: <20231222115714.364393-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231222115714.364393-1-pablo@netfilter.org>
References: <20231222115714.364393-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

The function is not supposed to alter the set, passing the pointer as
const is fine and merely requires to adjust signatures of two called
functions as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5c17c6e80ed..775b70a62140 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5910,7 +5910,7 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 	return 0;
 }
 
-static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_setelem_parse_key(struct nft_ctx *ctx, const struct nft_set *set,
 				 struct nft_data *key, struct nlattr *attr)
 {
 	struct nft_data_desc desc = {
@@ -5963,7 +5963,7 @@ static void *nft_setelem_catchall_get(const struct net *net,
 	return priv;
 }
 
-static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_setelem_get(struct nft_ctx *ctx, const struct nft_set *set,
 			   struct nft_set_elem *elem, u32 flags)
 {
 	void *priv;
@@ -5982,7 +5982,7 @@ static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
+static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 			    const struct nlattr *attr, bool reset)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-- 
2.30.2

