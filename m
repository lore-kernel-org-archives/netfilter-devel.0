From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Tue, 14 Jan 2014 09:00:09 +0000
Message-ID: <20140114090009.GB23920@macbook.localnet>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
 <20140113124202.GA17951@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65123 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaANJAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:00:13 -0500
Content-Disposition: inline
In-Reply-To: <20140113124202.GA17951@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 12:42:03PM +0000, Patrick McHardy wrote:
> On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> > % nft list table filter
> > table ip filter {
> > 	...
> > 	chain output {
> > 		...
> > 		ip saddr map { 1.1.1.1 => accept}
> > 	}
> > }
> > 
> > It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> > type in map_expr_print().
> 
> The fix is fine of course, but even better would be to get rid of the
> vmap keyword IMO. IIRC it only exists because I couldn't manage to get
> a conflict free grammar together, but it would be worth another try.

Actually this works fine. Is there agreement on removing the VMAP keyword?
If so we should do it before the 0.099 release.

diff --git a/src/parser.y b/src/parser.y
index 7c18875..e5610e5 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -150,7 +150,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DASH			"-"
 %token AT			"@"
 %token ARROW			"=>"
-%token VMAP			"vmap"
 
 %token INCLUDE			"include"
 %token DEFINE			"define"
@@ -1273,7 +1272,7 @@ map_expr		:	concat_expr	MAP	expr
 			}
 			;
 
-verdict_map_expr	:	concat_expr	VMAP	expr
+verdict_map_expr	:	concat_expr	MAP	expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 0b8abac..5a5ec72 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -210,7 +210,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "$"			{ return '$'; }
 "="			{ return '='; }
 "=>"			{ return ARROW; }
-"vmap"			{ return VMAP; }
 
 "include"		{ return INCLUDE; }
 "define"		{ return DEFINE; }
