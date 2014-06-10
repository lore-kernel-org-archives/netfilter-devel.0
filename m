From: Hendrik Schwartke <hendrik@os-t.de>
Subject: [PATCH 2/2] Enhanced error message which is displayed if an error occured while creating a chain.
Date: Tue, 10 Jun 2014 16:54:47 +0200
Message-ID: <1402412087-9825-2-git-send-email-hendrik@os-t.de>
References: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
Cc: Hendrik Schwartke <hendrik@os-t.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63195 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFJOzM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:55:12 -0400
In-Reply-To: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Creating a base chain which depends on unsupported kernel features
(e.g. creating a chain with a nat hook without loading the nat
kernel module) results in a confusing error message.
This patch added a meaningful hint.
---
 src/netlink.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 1b174bd..d4a71b8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -480,10 +480,11 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 
         struct nft_chain *nlc;
         int err;
+        int is_basechain = chain != NULL && chain->flags & CHAIN_F_BASECHAIN;
         unsigned int flags = excl ? NLM_F_EXCL : 0;
 
         nlc = alloc_nft_chain(h);
-        if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
+        if (is_basechain) {
                 nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
                                        chain->hooknum);
                 nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
@@ -500,8 +501,13 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
         nft_chain_free(nlc);
 
         if (err < 0) {
-                netlink_io_error(ctx, loc, "Could not add chain: %s",
-                                 strerror(errno));
+                const char *expl="";
+                if(is_basechain && errno==ENOENT)
+                        expl=" - perhaps some kernel modules are not"
+                             " loaded or the kernel doesn't include"
+                             " necessary features.";
+                netlink_io_error(ctx, loc, "Could not add chain: %s%s",
+                                 strerror(errno), expl);
         }
         return err;
 }
-- 
1.7.10.4

