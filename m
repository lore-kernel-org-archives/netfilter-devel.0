From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 21:24:56 +0000
Message-ID: <20140112212454.GA15677@macbook.localnet>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es>
 <20140112201742.GC13545@macbook.localnet>
 <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaALVZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:25:12 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 09:28:21PM +0100, Arturo Borrero Gonzalez wrote:
> On 12 January 2014 21:17, Patrick McHardy <kaber@trash.net> wrote:
> > On Sun, Jan 12, 2014 at 08:41:33PM +0100, Arturo Borrero Gonzalez wrote:
> >> Almost all shell uses the '>' character as a key for redirecting
> >> stdout/stderr to a file.
> >> So, using it in the syntax means that the administrator is forced to scape the
> >> character, or look for other workaround.
> >>
> >> With this patch, '=>' is replaced with '=:', thus avoiding such situation.
> >
> > I'm not opposed to this, but I like (despite the shell problematic) the =>
> > syntax better, so I'd suggest to just add an alternative syntax.
> >
> > As further simplification, why not simply use ':'?
> 
> Well, I also like using just ':'
> 
> But maybe we clash with IPv6 addresses in some cases:
> 
> nft add rule ip6 filter input ip6 saddr vmap { ::1 : accept , ::2 : drop }
> nft add rule ip6 filter input ip6 saddr vmap { ::1:accept , ::2:drop }
> 
> nft add rule ip6 filter input meta dnat set tcp dport map { 80 : ::1,
> 8888 : ::2 }
> nft add rule ip6 filter input meta dnat set tcp dport map { 80:::1, 8888:::2 }
> 
> what do you think?

IPv6 addresses are recognized by the parser, so it should be fine. I just
compile tested this patch, at least bison doesn't report any errors.


diff --git a/src/netlink.c b/src/netlink.c
index 59bd8e4..0f8275c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -332,7 +332,7 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 					     ctx->seqnum);
 		if (err < 0)
 			netlink_io_error(ctx, &rule->location,
-					 "Could not add rule to batch: %s",
+					 "Could not add rule: %s",
 					 strerror(errno));
 	}
 	nft_rule_free(nlr);
diff --git a/src/parser.y b/src/parser.y
index 7c18875..f91746a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -149,7 +149,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token ASTERISK			"*"
 %token DASH			"-"
 %token AT			"@"
-%token ARROW			"=>"
 %token VMAP			"vmap"
 
 %token INCLUDE			"include"
@@ -764,7 +763,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_seperator
 			|	map_block	TYPE
-						identifier	ARROW	identifier
+						identifier	COLON	identifier
 						stmt_seperator
 			{
 				$1->keytype = datatype_lookup_byname($3);
@@ -1309,11 +1308,11 @@ set_list_member_expr	:	opt_newline	expr	opt_newline
 			{
 				$$ = $2;
 			}
-			|	opt_newline	map_lhs_expr	ARROW	concat_expr	opt_newline
+			|	opt_newline	map_lhs_expr	COLON	concat_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
-			|	opt_newline	map_lhs_expr	ARROW	verdict_expr	opt_newline
+			|	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
 			{
 				$$ = mapping_expr_alloc(&@$, $2, $4);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 0b8abac..9fa5471 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -209,7 +209,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "@"			{ return AT; }
 "$"			{ return '$'; }
 "="			{ return '='; }
-"=>"			{ return ARROW; }
 "vmap"			{ return VMAP; }
 
 "include"		{ return INCLUDE; }
