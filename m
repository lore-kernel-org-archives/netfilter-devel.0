From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: src: add redirect support
Date: Fri, 12 Dec 2014 19:33:17 +0100
Message-ID: <20141212183317.GA3129@salvia>
References: <20141212152929.GJ8013@acer.localdomain>
 <CAOkSjBg6GomwWz1z-9GK_Lw8ELTfXwrXkDTc7XsLrCwGSTAvRQ@mail.gmail.com>
 <DB870481-09D6-4A54-BC23-1D0045ADEB5C@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaLLSbG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:31:06 -0500
Content-Disposition: inline
In-Reply-To: <DB870481-09D6-4A54-BC23-1D0045ADEB5C@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 05:27:03PM +0000, Patrick McHardy wrote:
> Am 12. Dezember 2014 17:02:04 GMT+00:00, schrieb Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> >On 12 December 2014 at 16:29, Patrick McHardy <kaber@trash.net> wrote:
> >> Looking at the redir bug report on netfilter-devel, I noticed some
> >> odd syntax for the redir statement.
> >>
> >> The changelog states:
> >>
> >>   The syntax is:
> >>
> >>   % nft add rule nat prerouting redirect [port] [nat_flags]
> >>
> >> The actual syntax though is:
> >>
> >> redir_stmt_arg          :       COLON   expr
> >>
> >> What do we need that colon for? redirect by definition redirects to
> >> the local host, the argument is always only a port expression.
> >
> >Yes, there is a inconsistency between the commit message and the code.
> >My fault.
> >
> >I don't exactly remember where that syntax came from. I guess the
> >colon was used in consistency with other nat-like expressions.
> >Actually, I don't have a particular preference (the colon or not).
> >
> >Do you want me to change the syntax? I can do it this weekend. Just
> >let me know :-)
> 
> Well, I don't think the colon is really bad, however it suggests an
> address can be put in front of it. I guess the reason is an
> ambiguity in the grammar with following expressions otherwise. Even
> though redirect is terminal the grammar so far doesn't know about
> it. From a readability POV I like a simple "to".

I also like "to". Patch attached to address this.

> >If you are going to change it yourself, I would suggest to also update
> >regression tests [0], which BTW seems broken due to the
> >random-fully/fully-random change.
> 
> I missed that, will fix it up later.

No problem, just fixed it here, will push it now.

--9jxsPFA5p3P2qPhR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-parser-use-redirect-to-PORT-instead-of-redirect-PORT.patch"

>From 8f120b86b7165cc650fe8a73b65f0e204c068730 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 12 Dec 2014 19:26:46 +0100
Subject: [PATCH] parser: use 'redirect to PORT' instead of 'redirect :PORT'

Small syntax update suggested by Patrick.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y              |    5 +++--
 src/scanner.l                   |    1 +
 tests/regression/ip/redirect.t  |   24 ++++++++++++------------
 tests/regression/ip6/redirect.t |   18 +++++++++---------
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 515a11a..99dbd08 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -196,6 +196,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token JUMP			"jump"
 %token GOTO			"goto"
 %token RETURN			"return"
+%token TO			"to"
 
 %token CONSTANT			"constant"
 %token INTERVAL			"interval"
@@ -1439,7 +1440,7 @@ redir_stmt		:	redir_stmt_alloc	redir_stmt_arg
 redir_stmt_alloc	:	REDIRECT	{ $$ = redir_stmt_alloc(&@$); }
 			;
 
-redir_stmt_arg		:	COLON	expr
+redir_stmt_arg		:	TO	expr
 			{
 				$<stmt>0->redir.proto = $2;
 			}
@@ -1447,7 +1448,7 @@ redir_stmt_arg		:	COLON	expr
 			{
 				$<stmt>0->redir.flags = $1;
 			}
-			|	COLON	expr	nf_nat_flags
+			|	TO	expr	nf_nat_flags
 			{
 				$<stmt>0->redir.proto = $2;
 				$<stmt>0->redir.flags = $3;
diff --git a/src/scanner.l b/src/scanner.l
index 1723159..ed87da6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -250,6 +250,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "jump"			{ return JUMP; }
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
+"to"			{ return TO; }
 
 "inet"			{ return INET; }
 
diff --git a/tests/regression/ip/redirect.t b/tests/regression/ip/redirect.t
index ec88db1..bbf440d 100644
--- a/tests/regression/ip/redirect.t
+++ b/tests/regression/ip/redirect.t
@@ -17,22 +17,22 @@ udp dport 53 redirect persistent,fully-random;ok;udp dport 53 redirect fully-ran
 udp dport 53 redirect persistent,fully-random,random;ok;udp dport 53 redirect random,fully-random,persistent
 
 # port specification
-tcp dport 22 redirect :22;ok
-udp dport 1234 redirect :4321;ok
-ip daddr 172.16.0.1 udp dport 9998 redirect :6515;ok
-tcp dport 39128 redirect :993;ok
-redirect :1234;fail
-redirect :12341111;fail
+tcp dport 22 redirect to 22;ok
+udp dport 1234 redirect to 4321;ok
+ip daddr 172.16.0.1 udp dport 9998 redirect to 6515;ok
+tcp dport 39128 redirect to 993;ok
+redirect to 1234;fail
+redirect to 12341111;fail
 
 # both port and nf_nat flags
-tcp dport 9128 redirect :993 random;ok
-tcp dport 9128 redirect :993 fully-random;ok
-tcp dport 9128 redirect :123 persistent;ok
-tcp dport 9128 redirect :123 random,persistent;ok
+tcp dport 9128 redirect to 993 random;ok
+tcp dport 9128 redirect to 993 fully-random;ok
+tcp dport 9128 redirect to 123 persistent;ok
+tcp dport 9128 redirect to 123 random,persistent;ok
 
 # nf_nat flags is the last argument
-udp dport 1234 redirect random :123;fail
-udp dport 21234 redirect persistent,fully-random :431;fail
+udp dport 1234 redirect random to 123;fail
+udp dport 21234 redirect persistent,fully-random to 431;fail
 
 # redirect is a terminal statement
 tcp dport 22 redirect counter packets 0 bytes 0 accept;fail
diff --git a/tests/regression/ip6/redirect.t b/tests/regression/ip6/redirect.t
index f6c98c0..730d733 100644
--- a/tests/regression/ip6/redirect.t
+++ b/tests/regression/ip6/redirect.t
@@ -19,19 +19,19 @@ udp dport 53 redirect persistent,fully-random;ok;udp dport 53 redirect fully-ran
 udp dport 53 redirect persistent,fully-random,random;ok;udp dport 53 redirect random,fully-random,persistent
 
 # port specification
-udp dport 1234 redirect :1234;ok
-ip6 daddr fe00::cafe udp dport 9998 redirect :6515;ok
-tcp dport 39128 redirect :993;ok
-redirect :1234;fail
-redirect :12341111;fail
+udp dport 1234 redirect to 1234;ok
+ip6 daddr fe00::cafe udp dport 9998 redirect to 6515;ok
+tcp dport 39128 redirect to 993;ok
+redirect to 1234;fail
+redirect to 12341111;fail
 
 # both port and nf_nat flags
-tcp dport 9128 redirect :993 random;ok
-tcp dport 9128 redirect :993 fully-random,persistent;ok
+tcp dport 9128 redirect to 993 random;ok
+tcp dport 9128 redirect to 993 fully-random,persistent;ok
 
 # nf_nat flags are the last argument
-tcp dport 9128 redirect persistent :123;fail
-tcp dport 9128 redirect random,persistent :123;fail
+tcp dport 9128 redirect persistent to 123;fail
+tcp dport 9128 redirect random,persistent to 123;fail
 
 # redirect is a terminal statement
 tcp dport 22 redirect counter packets 0 bytes 0 accept;fail
-- 
1.7.10.4


--9jxsPFA5p3P2qPhR--
