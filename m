From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  08/15] xtables: Add support for registering nft translation function for target
Date: Fri, 19 Jul 2013 18:17:37 +0300
Message-ID: <1374247064-3361-9-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab3GSPSG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:06 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/GNUmakefile.in | 2 +-
 include/xtables.h.in      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index efb5502..8f8d775 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -16,7 +16,7 @@ CCLD               = ${CC}
 CFLAGS             = @CFLAGS@
 CPPFLAGS           = @CPPFLAGS@
 LDFLAGS            = @LDFLAGS@
-@ENABLE_NFTABLES_TRUE@ LDFLAGS += @EXTENSION_NFT_LDFLAGS@
+@ENABLE_NFTABLES_TRUE@ LDFLAGS += @EXTENSION_NFT_LDFLAGS@ -L../libnfttrans/.libs -lnfttrans
 regular_CFLAGS     = @regular_CFLAGS@
 regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
diff --git a/include/xtables.h.in b/include/xtables.h.in
index f2b2a23..1658842 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -19,6 +19,7 @@
 #include <linux/netfilter/x_tables.h>
 
 #include <libnftables/rule.h>
+#include <nft-translator.h>
 
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
@@ -334,6 +335,7 @@ struct xtables_target
 
 	/* NFT related */
 	int (*to_nft)(struct nft_rule *, struct xt_entry_target *);
+	int (*register_nft_instructions)(struct nft_trans_instruction_tree *);
 
 	size_t udata_size;
 
-- 
1.8.3.2

