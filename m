From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  09/17] xtables: Add support for registering nft translation function for target
Date: Thu, 25 Jul 2013 20:16:29 +0300
Message-ID: <1374772597-20548-10-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3GYRQz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:55 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the method which will be called by the core to register the xtables
target extensions into the nft translator. Through that method, the extension
will provide the combination of pattern/parser to the translation tree.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/GNUmakefile.in | 2 +-
 include/xtables.h         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index da2f38b..5a19008 100644
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
diff --git a/include/xtables.h b/include/xtables.h
index 5bd8a59..fe1f31c 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -19,6 +19,7 @@
 #include <linux/netfilter/x_tables.h>
 
 #include <libnftables/rule.h>
+#include <nft-translator.h>
 
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
@@ -353,6 +354,7 @@ struct xtables_target
 
 	/* NFT related */
 	int (*to_nft)(struct nft_rule *, struct xt_entry_target *);
+	int (*register_nft_instructions)(struct nft_trans_instruction_tree *);
 
 	size_t udata_size;
 
-- 
1.8.3.2

