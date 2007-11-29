From: Patrick McHardy <kaber@trash.net>
Subject: [TEXTSEARCH 03/03]: Do not allow zero length patterns in the textsearch infrastructure
Date: Fri, 30 Nov 2007 00:57:16 +0100 (MET)
Message-ID: <20071129235707.10108.56037.sendpatchset@localhost.localdomain>
References: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60360 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763539AbXK2X5R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:57:17 -0500
In-Reply-To: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[TEXTSEARCH]: Do not allow zero length patterns in the textsearch infrastructure

If a zero length pattern is passed then return EINVAL.
Avoids infinite loops (bm) or invalid memory accesses (kmp).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d3161d25f17eca4f57ea85485f453a6209d0c919
tree d1ea696ac2fc68cd79d43975e5d56940c04a2342
parent 7f6c4730c53415caee7cb0ed4c1adad48de3bb07
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 30 Nov 2007 00:54:50 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 30 Nov 2007 00:54:50 +0100

 lib/textsearch.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/textsearch.c b/lib/textsearch.c
index 88c98a2..be8bda3 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -7,7 +7,7 @@
  *		2 of the License, or (at your option) any later version.
  *
  * Authors:	Thomas Graf <tgraf@suug.ch>
- * 		Pablo Neira Ayuso <pablo@eurodev.net>
+ * 		Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * ==========================================================================
  *
@@ -250,7 +250,8 @@ unsigned int textsearch_find_continuous(struct ts_config *conf,
  *       the various search algorithms.
  *
  * Returns a new textsearch configuration according to the specified
- *         parameters or a ERR_PTR().
+ * parameters or a ERR_PTR(). If a zero length pattern is passed, this
+ * function returns EINVAL.
  */
 struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 				     unsigned int len, gfp_t gfp_mask, int flags)
@@ -259,6 +260,9 @@ struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 	struct ts_config *conf;
 	struct ts_ops *ops;
 	
+	if (len == 0)
+		return ERR_PTR(-EINVAL);
+
 	ops = lookup_ts_algo(algo);
 #ifdef CONFIG_KMOD
 	/*
