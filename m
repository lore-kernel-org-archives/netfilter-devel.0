From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/4 RFC] exthdr: Align max templates count with payload expr
Date: Mon, 22 May 2017 18:49:34 +0200
Message-ID: <20170522164936.28034-3-phil@nwl.cc>
References: <20170522164936.28034-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44165 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935199AbdEVQtz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 12:49:55 -0400
In-Reply-To: <20170522164936.28034-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is for convenience only, so that when translating a payload
expression into an exthdr one we can't accidentally address data out of
bounds.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/exthdr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index a2647ee142dcd..a5522ea5b5e5d 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -14,7 +14,7 @@
 struct exthdr_desc {
 	const char			*name;
 	uint8_t				type;
-	struct proto_hdr_template	templates[10];
+	struct proto_hdr_template	templates[PROTO_HDRS_MAX];
 };
 
 extern struct expr *exthdr_expr_alloc(const struct location *loc,
-- 
2.11.0

