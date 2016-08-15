From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnftnl] expr: Improve bound checking in stringification functions
Date: Mon, 15 Aug 2016 12:27:36 +0200
Message-ID: <20160815102737.11955-1-carlosfg@riseup.net>
References: <20160815091239.GC3905@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:40263 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbcHOK1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:27:55 -0400
In-Reply-To: <20160815091239.GC3905@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In stringification functions that uses string tables it is convenient to
check the array bounds and if the element is not null. Due use of
designated initializers string tables can have gaps set to null.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/byteorder.c | 2 +-
 src/expr/cmp.c       | 2 +-
 src/expr/ct.c        | 2 +-
 src/expr/dynset.c    | 2 +-
 src/expr/meta.c      | 2 +-
 src/utils.c          | 3 ++-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index ca697cf..020d876 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -179,7 +179,7 @@ static char *expr_byteorder_str[] = {
 
 static const char *bo2str(uint32_t type)
 {
-	if (type > NFT_BYTEORDER_HTON)
+	if (type > NFT_BYTEORDER_HTON || !expr_byteorder_str[type])
 		return "unknown";
 
 	return expr_byteorder_str[type];
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f3dd62c..92c7364 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -150,7 +150,7 @@ static char *expr_cmp_str[] = {
 
 static const char *cmp2str(uint32_t op)
 {
-	if (op > NFT_CMP_GTE)
+	if (op > NFT_CMP_GTE || !expr_cmp_str[op])
 		return "unknown";
 
 	return expr_cmp_str[op];
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 1a53b49..d515302 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -173,7 +173,7 @@ static const char *ctkey2str_array[NFT_CT_MAX] = {
 
 static const char *ctkey2str(uint32_t ctkey)
 {
-	if (ctkey >= NFT_CT_MAX)
+	if (ctkey >= NFT_CT_MAX || !ctkey2str_array[ctkey])
 		return "unknown";
 
 	return ctkey2str_array[ctkey];
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 6fc5bc1..90737a2 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -302,7 +302,7 @@ static char *op2str_array[] = {
 
 static const char *op2str(enum nft_dynset_ops op)
 {
-	if (op > NFT_DYNSET_OP_UPDATE)
+	if (op > NFT_DYNSET_OP_UPDATE || !op2str_array[op])
 		return "unknown";
 	return op2str_array[op];
 }
diff --git a/src/expr/meta.c b/src/expr/meta.c
index a478a89..e6b9b06 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -162,7 +162,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 
 static const char *meta_key2str(uint8_t key)
 {
-	if (key < NFT_META_MAX)
+	if (key < NFT_META_MAX && meta_key2str_array[key])
 		return meta_key2str_array[key];
 
 	return "unknown";
diff --git a/src/utils.c b/src/utils.c
index e2715a2..7264d1f 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -23,6 +23,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
+	[NFPROTO_UNSPEC]	= "unknown",
 	[NFPROTO_INET]		= "inet",
 	[NFPROTO_IPV4]		= "ip",
 	[NFPROTO_ARP]		= "arp",
@@ -33,7 +34,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
 
 const char *nftnl_family2str(uint32_t family)
 {
-	if (nftnl_family_str[family] == NULL)
+	if (family >= NFPROTO_NUMPROTO || !nftnl_family_str[family])
 		return "unknown";
 
 	return nftnl_family_str[family];
-- 
2.8.3

