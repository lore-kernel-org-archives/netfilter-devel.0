From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH nf-next] netfilter: nf_tables:
 nf_tables_obj_lookup_byhandle() can be static
Date: Sat, 20 Jan 2018 04:27:58 +0800
Message-ID: <20180119202757.GA84608@cairo>
References: <201801200422.IyzwLs87%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47188 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756160AbeASU2h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 15:28:37 -0500
Content-Disposition: inline
In-Reply-To: <201801200422.IyzwLs87%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nf_tables_api.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1addc401..b0129a0 100644
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
