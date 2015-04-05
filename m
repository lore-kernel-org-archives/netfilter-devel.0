From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sun, 5 Apr 2015 14:11:06 +0200
Message-ID: <20150405121104.GD23433@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
 <20150405113214.GA23433@acer.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Cc: Alexander Holler <holler@ahsoftware.de>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57573 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbDEMLN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 08:11:13 -0400
Content-Disposition: inline
In-Reply-To: <20150405113214.GA23433@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 05.04, Patrick McHardy wrote:
> On 04.04, Pablo Neira Ayuso wrote:
> > On Sat, Apr 04, 2015 at 01:13:06PM +0200, Alexander Holler wrote:
> > > Context sensitive handling of "param-problem" and "redirect" is necessary
> > > to allow usage of them as token or as string for icmp types.
> > [...]
> > 
> > I think we need some evaluation step at scanner level. This new
> > evaluation routine needs to understand the token semantics to set some
> > context information.
> > 
> > "redirect"		{ return scanner_evaluate(ctx, REDIRECT); }
> > 
> > We have to catch up more use cases such as sets and concatenations. I
> > started a patch here, a bit more generalized than this when you
> > reported this problem (we actually already knew about it).
> > 
> > @Patrick, any better idea?
> 
> This won't work because the grammar currently allows both cases.
> 
> The proper solution IMO is to change the grammar so we know where such
> keywords are keywords and where they are constants.
> 
> Basically this involves splitting the expression types into lhs (non-const)
> and rhs (const) parts. Keywords on the RHS side can be caught using an
> error statement and deferred to resolution during runtime.

Actually, it even seems to work without doing the splitting. This patch
shows the basic idea. We add a error token to symbol_expr, convert the
erroneous keyword to a symbolic expression and push it to the evaluation
step. Without the split to LHS/RHS it can't handle cases like "TCP",
but it does handle all keywords that are not the first one of an expression.

The redirect case seems to be working fine:

<cmdline>:1:15-23: Evaluate
filter output icmp type redirect
              ^^^^^^^^^
ip protocol

<cmdline>:1:15-23: Evaluate
filter output icmp type redirect
              ^^^^^^^^^
icmp

<cmdline>:1:25-32: Evaluate
filter output icmp type redirect
                        ^^^^^^^^
$redirect

<cmdline>:1:25-32: Evaluate
filter output icmp type redirect
                        ^^^^^^^^
redirect

ip filter output 
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 1b @ transport header + 0 => reg 1 ]
  [ cmp eq reg 1 0x00000005 ]

This needs a lot of testing though since it has the potential to break
things quite badly. Since I'm busy, maybe someone else wants to start by
running the testsuite with this patch applied.

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="x.diff"

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b86381d..8d39c67 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1583,6 +1583,30 @@ symbol_expr		:	string
 						       $2);
 				xfree($2);
 			}
+			|	error
+			{
+				struct error_record *erec;
+				char *tmp;
+
+				if (yytoken != TOKEN_EOF) {
+					tmp = xstrdup(yytname[yytoken] + 1);
+					tmp[strlen(tmp) - 1] = '\0';
+					$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+							       current_scope(state),
+							       tmp);
+					xfree(tmp);
+
+					erec = list_entry(state->msgs->prev,
+							  struct error_record, list);
+					list_del(&erec->list);
+					xfree(erec);
+
+					yyclearin;
+					yyerrok;
+				} else {
+					YYABORT;
+				}
+			}
 			;
 
 integer_expr		:	NUM

--W/nzBZO5zC0uMSeA--
