From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/4 RFC] payload: Carry template number around for internal use
Date: Mon, 22 May 2017 18:49:33 +0200
Message-ID: <20170522164936.28034-2-phil@nwl.cc>
References: <20170522164936.28034-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45125 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965079AbdEVQuT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 12:50:19 -0400
In-Reply-To: <20170522164936.28034-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h | 1 +
 src/payload.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 9ba87e8273a3a..1b31160713750 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -277,6 +277,7 @@ struct expr {
 			const struct proto_hdr_template	*tmpl;
 			enum proto_bases		base;
 			unsigned int			offset;
+			unsigned int			type;
 		} payload;
 		struct {
 			/* EXPR_EXTHDR */
diff --git a/src/payload.c b/src/payload.c
index 55128fee14986..4e353e8e5c8b0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -145,6 +145,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	expr->payload.tmpl   = tmpl;
 	expr->payload.base   = base;
 	expr->payload.offset = tmpl->offset;
+	expr->payload.type   = type;
 
 	return expr;
 }
-- 
2.11.0

