From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables/libnftnl release plan?
Date: Fri, 22 Sep 2017 19:15:13 +0200
Message-ID: <20170922171513.GA8746@salvia>
References: <20170918161835.GF30364@orbyte.nwl.cc>
 <20170918162453.GA6000@salvia>
 <20170918163240.GA24836@breakpoint.cc>
 <20170918172153.GA8945@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:49783 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbdIVRPT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2017 13:15:19 -0400
Content-Disposition: inline
In-Reply-To: <20170918172153.GA8945@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 18, 2017 at 07:21:53PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 18, 2017 at 06:32:40PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Mon, Sep 18, 2017 at 06:18:35PM +0200, Phil Sutter wrote:
> > > > Hi Pablo,
> > > > 
> > > > What are your plans regarding release of libnftnl-1.0.8 and
> > > > nftables-0.8?
> > > 
> > > As soon as I can integrate Florian's changes to support
> > > 
> > >         xyz set x,y
> > >
> > > comma-separated values in with an assignment statement.
> > 
> > Is there anything you need from my side?
> 
> I wanted to find a little slice of time to hack on the grammar, make
> some sketch basically on it only on the parser side. My concern is the
> fact that | & and such will not work anymore.
> 
> The patchset is large and I remember changes in the grammar were
> happening in a way that I was having a hard time to follow track.
> 
> Let me have a look in the next days, if no news from before weekend,
> let's take what you send as is, OK?

I'm looking into this. I'm attaching what I have by now, it's breaking
lots of tests. It's removing ct_stmt_expr and update code to use
stmt_expr, instead of having a recursion on the 'expr' production
which allows very crazy things we don't support in
{ct,meta,payload}_stmt.

At this stage it doesn't allow to use ct_expr, there's a conflict in
primary_rhs_expr, this may be related to the too compact ct_expr
representation. We need tokens to given bison, I understand we should
aim to deliver a compact grammar, but that's just problems.

There is not tcp option statement either, which is suspect. I should
have look into this more closely when this was applied.

Have to stop now, I need time to look into this. I think we need a bit
of plumbing on the grammar side.

We can either push your patches as it is, breaking the scenario you
mentioned, and make a release. Or spend time on this fix it now.

Housekeeping is required on this, the kind of work that doesn't result
in shiny new features, but that get things right.

--GvXjxJ+pjyke8COw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-parser_bison-restrict-expression-types-in-meta-ct-pa.patch"

>From 52ad83103dc4ea98a92ff62c4b8e6a044acd7da9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 22 Sep 2017 18:01:18 +0200
Subject: [PATCH] parser_bison: restrict expression types in meta/ct/payload
 statements

Restrict type of expressions that we can find in statements to what
we're aware that is well supported. Other than that, it just adds more
complexity to the grammar, specifically when extending it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6489556788db..3f65fe6e296a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -648,8 +648,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			list_stmt_expr
 %destructor { expr_free($$); }	list_stmt_expr
 
-%type <expr>			ct_expr		ct_stmt_expr
-%destructor { expr_free($$); }	ct_expr		ct_stmt_expr
+%type <expr>			ct_expr
+%destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key		ct_key_dir	ct_key_dir_optional
 
 %type <expr>			fib_expr
@@ -2235,7 +2235,8 @@ map_stmt_expr		:	concat_stmt_expr	MAP	rhs_expr
 
 stmt_expr		:	map_stmt_expr
 			|	multiton_rhs_expr
-			|	primary_rhs_expr
+			|	basic_rhs_expr
+			|	list_stmt_expr
 			;
 
 nat_stmt_args		:	stmt_expr
@@ -2983,6 +2984,8 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
 			|	keyword_rhs_expr	{ $$ = $1; }
+			|	meta_expr		{ $$ = $1; }
+			|	rt_expr			{ $$ = $1; }
 			|	TCP
 			{
 				uint8_t data = IPPROTO_TCP;
@@ -3149,15 +3152,15 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       CGROUP		{ $$ = NFT_META_CGROUP; }
 			;
 
-meta_stmt		:	META	meta_key	SET	expr
+meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = meta_stmt_alloc(&@$, $2, $4);
 			}
-			|	meta_key_unqualified	SET	expr
+			|	meta_key_unqualified	SET	stmt_expr
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
-			|	META	STRING	SET	expr
+			|	META	STRING	SET	stmt_expr
 			{
 				struct error_record *erec;
 				unsigned int key;
@@ -3290,15 +3293,11 @@ list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
 			}
 			;
 
-ct_stmt_expr		:	expr
-			|	list_stmt_expr
-			;
-
-ct_stmt			:	CT	ct_key		SET	expr
+ct_stmt			:	CT	ct_key		SET	stmt_expr
 			{
 				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 			}
-			|	CT	STRING		SET	ct_stmt_expr
+			|	CT	STRING		SET	stmt_expr
 			{
 				struct error_record *erec;
 				unsigned int key;
@@ -3321,7 +3320,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 					break;
 				}
 			}
-			|	CT	STRING	ct_key_dir_optional SET	expr
+			|	CT	STRING	ct_key_dir_optional SET	stmt_expr
 			{
 				struct error_record *erec;
 				int8_t direction;
@@ -3337,7 +3336,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 			}
 			;
 
-payload_stmt		:	payload_expr		SET	expr
+payload_stmt		:	payload_expr		SET	stmt_expr
 			{
 				if ($1->ops->type == EXPR_EXTHDR)
 					$$ = exthdr_stmt_alloc(&@$, $1, $3);
-- 
2.1.4


--GvXjxJ+pjyke8COw--
