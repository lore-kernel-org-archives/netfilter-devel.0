Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591F06DCFF
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 21:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: validate chain type update if available
Date: Thu, 14 Dec 2023 22:43:22 +0100
Message-Id: <20231214214322.137555-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse netlink attribute containing the chain type in this update, to
bail out if this is different from the existing type.

Otherwise, it is possible to define a chain with the same name, hook and
priority but different type, which is silently ignored.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is catch this sequence:

table ip x {
	chain y {
		type filter hook output priority 0;
	}
}

then:

table ip x {
	chain y {
		type route hook output priority 0;
	}
}

this is currently ignored, bail out instead if user tries to redefine
an existing chain with different type.

 net/netfilter/nf_tables_api.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5c17c6e80ed..ec092f2f0b64 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2261,7 +2261,16 @@ static int nft_chain_parse_hook(struct net *net,
 				return -EOPNOTSUPP;
 		}
 
-		type = basechain->type;
+		if (nla[NFTA_CHAIN_TYPE]) {
+			type = __nf_tables_chain_type_lookup(nla[NFTA_CHAIN_TYPE],
+							     family);
+			if (!type) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
+				return -ENOENT;
+			}
+		} else {
+			type = basechain->type;
+		}
 	}
 
 	if (!try_module_get(type->owner)) {
-- 
2.30.2

