From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] ruleset: deconstify _get interface
Date: Mon, 20 Oct 2014 21:46:09 +0200
Message-ID: <20141020194515.3402.28281.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36388 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751524AbaJTTqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:46:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Having this interface returning a const pointer makes very hard to
modificate the content of a chain contained in a nft_ruleset.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---

Note: I ignore how this affects the current, already released API.

 include/libnftnl/ruleset.h |    2 +-
 src/ruleset.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index 6f89110..1a3e22f 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -28,7 +28,7 @@ enum {
 bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
-const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
+void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
 		      const char *data, struct nft_parse_err *err);
diff --git a/src/ruleset.c b/src/ruleset.c
index 4cfeee6..6bb7582 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -111,7 +111,7 @@ void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data)
 }
 EXPORT_SYMBOL(nft_ruleset_attr_set);
 
-const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
+void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 {
 	if (!(r->flags & (1 << attr)))
 		return NULL;

