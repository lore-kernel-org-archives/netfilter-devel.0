From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/4] scanner: Fix for wrong parameter type of scanner_destroy()
Date: Thu, 24 Aug 2017 19:14:11 +0200
Message-ID: <20170824171413.31737-3-phil@nwl.cc>
References: <20170824171413.31737-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50681 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdHXROo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:14:44 -0400
In-Reply-To: <20170824171413.31737-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function takes the scanner as argument, not the state. This wasn't a
real issue since scanner is a void pointer, which means it's only casted
around without need. So this fix is a rather cosmetic one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h | 2 +-
 src/scanner.l    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0e266d60b8a31..431edfb3d4e34 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -37,7 +37,7 @@ extern void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
-extern void scanner_destroy(struct parser_state *state);
+extern void scanner_destroy(void *scanner);
 
 extern int scanner_read_file(void *scanner, const char *filename,
 			     const struct location *loc);
diff --git a/src/scanner.l b/src/scanner.l
index 25e4eb1c70ec1..7d57cc1465d3a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -856,7 +856,7 @@ void *scanner_init(struct parser_state *state)
 	return scanner;
 }
 
-void scanner_destroy(struct parser_state *scanner)
+void scanner_destroy(void *scanner)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
-- 
2.13.1

