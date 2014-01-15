From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] evaluate: allow to use string with binary operations
Date: Wed, 15 Jan 2014 16:05:55 +0000
Message-ID: <20140115160555.GB3250@macbook.localnet>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-3-git-send-email-pablo@netfilter.org>
 <20140114122251.GB27277@macbook.localnet>
 <20140114152532.GA9059@localhost>
 <20140114154859.GB2204@macbook.localnet>
 <20140115092943.GA4566@localhost>
 <20140115155849.GA1506@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46088 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAOQF7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:05:59 -0500
Content-Disposition: inline
In-Reply-To: <20140115155849.GA1506@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 04:58:49PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 15, 2014 at 10:29:43AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 14, 2014 at 03:49:00PM +0000, Patrick McHardy wrote:
> > > Well, I think the easiest approach would be to add some code to
> > > expr_evaluate_relational() for OP_EQ for convert the LHS of a
> > > relational meta expression to LHS & RHS:
> > > 
> > >      relational (==)
> > >     /               \
> > > meta oifname       string
> > > 
> > > =>
> > > 
> > >         relational (==)
> > >        /               \
> > >     binop (&)        string
> > >   /          \
> > > meta oifname  string
> > > 
> > > The attached patch uses '*' as a trigger (and obviously won't work
> > > because the '*' is also used in the mask, but you get the idea.
> > > netlink_delinarize adjustments are missing, but it should be pretty
> > > trivial to add the corresponding code to postprocessing of relational
> > > expressions.
> > 
> > Oh yes, with that wildcard trick the thing is simplified. There was
> > some discuss on the use of '+' that seems to be possible to be used in
> > a device name. I guess '*' is safe as udev is using it in their rules.
> 
> It seems we need to include the '*' into the string rule in flex for
> this. We already have a single '*' that is used in the parser for
> prefixes, I think that may lead to ambiguity problems.

We of course could use something different, but I think it should be fine.

The '*' for prefixes can be reasonable expected to follow some whitespace,
while in this case it would always be the final character of a string.

This *seems* to work in some very limited testing.

diff --git a/src/scanner.l b/src/scanner.l
index 6ff8846..abc46e1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -439,6 +439,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{string}\*		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
