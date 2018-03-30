From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/47] netfilter: nf_tables: nf_tables_obj_lookup_byhandle() can be static
Date: Fri, 30 Mar 2018 13:36:43 +0200
Message-ID: <20180330113729.18335-2-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: kbuild test robot <fengguang.wu@intel.com>

Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b9fe30de0cd..8cc7fc970f0c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4328,9 +4328,9 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
 
-struct nft_object *nf_tables_obj_lookup_byhandle(const struct nft_table *table,
-						 const struct nlattr *nla,
-						 u32 objtype, u8 genmask)
+static struct nft_object *nf_tables_obj_lookup_byhandle(const struct nft_table *table,
+							const struct nlattr *nla,
+							u32 objtype, u8 genmask)
 {
 	struct nft_object *obj;
 
@@ -4850,7 +4850,7 @@ struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nf_tables_flowtable_lookup);
 
-struct nft_flowtable *
+static struct nft_flowtable *
 nf_tables_flowtable_lookup_byhandle(const struct nft_table *table,
 				    const struct nlattr *nla, u8 genmask)
 {
-- 
2.11.0
