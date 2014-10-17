From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4 v2] evaluate: fix a crash if we specify ether
 type or meta nfproto in reject
Date: Fri, 17 Oct 2014 15:38:17 +0200
Message-ID: <20141017133817.GA4163@salvia>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
 <20141017125538.GC3644@salvia>
 <5441134F.6020104@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44579 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaJQNhE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:37:04 -0400
Content-Disposition: inline
In-Reply-To: <5441134F.6020104@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 17, 2014 at 03:02:07PM +0200, Álvaro Neira Ayuso wrote:
> El 17/10/14 14:55, Pablo Neira Ayuso escribió:
> >On Fri, Oct 17, 2014 at 02:24:34PM +0200, Alvaro Neira Ayuso wrote:
> >>If we use a rule:
> >>nft add rule bridge filter input \
> >>	ether type ip reject with icmp type host-unreachable
> >>
> >>or this:
> >>
> >>nft add rule inet filter input \
> >>	meta nfproto ipv4 reject with icmp type host-unreachable
> >>
> >>we have a segfault because we add a network dependency when we already have
> >>network context.
> >>
> >>Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> >>---
> >>[changes in v2]
> >>* Fixed a incorrect refactor when we check the family in bridge
> >>
> >>  src/evaluate.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 56 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/src/evaluate.c b/src/evaluate.c
> >>index 83ef749..4b7bda9 100644
> >>--- a/src/evaluate.c
> >>+++ b/src/evaluate.c
> >>@@ -19,6 +19,7 @@
> >>  #include <linux/netfilter/nf_tables.h>
> >>  #include <netinet/ip_icmp.h>
> >>  #include <netinet/icmp6.h>
> >>+#include <net/ethernet.h>
> >>
> >>  #include <expression.h>
> >>  #include <statement.h>
> >>@@ -1193,6 +1194,8 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
> >>  		BUG("cannot generate reject dependency for type %d",
> >>  		    stmt->reject.type);
> >>  	}
> >>+	if (payload == NULL)
> >>+		return 0;
> >
> >Why this check?
> 
> If we already have context, the previously functions return a NULL
> payload. Therefore, if we try to create a dependency with this NULL
> payload, we have a crash.

I prefer if you can change the return value logic in
reject_payload_gen_dependency*() to:

  1: payload dependency was created
  0: no payload dependency needed
 -1: error

See patch attached.

--qMm9M+Fa2AknHoGS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index d61d76b..71dc767 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1140,9 +1140,10 @@ static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
 	desc = ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc;
 	if (desc != NULL)
 		return 0;
+
 	*payload = payload_expr_alloc(&stmt->location, &proto_tcp,
 				      TCPHDR_UNSPEC);
-	return 0;
+	return 1;
 }
 
 static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
@@ -1171,7 +1172,7 @@ static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
 	default:
 		BUG("unknown reject family");
 	}
-	return 0;
+	return 1;
 }
 
 static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
@@ -1179,21 +1180,21 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 {
 	struct expr *payload = NULL;
 	struct stmt *nstmt;
+	int ret;
 
 	switch (stmt->reject.type) {
 	case NFT_REJECT_TCP_RST:
-		if (reject_payload_gen_dependency_tcp(ctx, stmt, &payload) < 0)
-			return -1;
+		ret = reject_payload_gen_dependency_tcp(ctx, stmt, &payload);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
-		if (reject_payload_gen_dependency_family(ctx, stmt,
-							 &payload) < 0)
-			return -1;
+		ret = reject_payload_gen_dependency_family(ctx, stmt, &payload);
 		break;
 	default:
 		BUG("cannot generate reject dependency for type %d",
 		    stmt->reject.type);
 	}
+	if (ret <= 0)
+		return ret;
 
 	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 		return -1;

--qMm9M+Fa2AknHoGS--
