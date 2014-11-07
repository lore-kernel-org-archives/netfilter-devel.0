From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/3] parser: allow both nat_flags and port specification
 in redirect
Date: Fri, 07 Nov 2014 12:39:35 +0100
Message-ID: <20141107113935.8480.16834.stgit@nfdev.cica.es>
References: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60518 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222AbaKGLjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:39:44 -0500
In-Reply-To: <20141107113924.8480.80701.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the parser to permit both nat_flags and port specification
in the redirect expression.

The resulting syntax is:
 % nft add rule nat prerouting redirect [port] [nat_flags]

The port specification requires a bit of context regardin the transport
protocol. Some examples:
 % nft add rule nat prerouting tcp dport 22 redirect :23
 % nft add rule add prerouting udp dport 53 redirect :5353

The nat_flags argument is the last argument:
 % nft add rule nat prerouting tdp dport 80 redirect :8080 random

The port specification can be a range:
 % nft add rule nat prerouting tcp dport 80 redirect :8080-8090 random

While at it, the regression tests files are updated.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/parser.y                    |    5 +++++
 tests/regression/ip/redirect.t  |   14 +++++++++-----
 tests/regression/ip6/redirect.t |    8 +++++---
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 6209e9e..3992c6a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1437,6 +1437,11 @@ redir_stmt_arg		:	COLON	expr
 			{
 				$<stmt>0->redir.flags = $1;
 			}
+			|	COLON	expr	nf_nat_flags
+			{
+				$<stmt>0->redir.proto = $2;
+				$<stmt>0->redir.flags = $3;
+			}
 			;
 
 nf_nat_flags		:	nf_nat_flag
diff --git a/tests/regression/ip/redirect.t b/tests/regression/ip/redirect.t
index f69fd07..cb230e2 100644
--- a/tests/regression/ip/redirect.t
+++ b/tests/regression/ip/redirect.t
@@ -24,11 +24,15 @@ tcp dport 39128 redirect :993;ok
 redirect :1234;fail
 redirect :12341111;fail
 
-# invalid arguments
-tcp dport 9128 redirect :993 random;fail
-tcp dport 9128 redirect :993 random-fully;fail
-tcp dport 9128 redirect persistent :123;fail
-tcp dport 9128 redirect random,persistent :123;fail
+# both port and nf_nat flags
+tcp dport 9128 redirect :993 random;ok
+tcp dport 9128 redirect :993 random-fully;ok
+tcp dport 9128 redirect :123 persistent;ok
+tcp dport 9128 redirect :123 random,persistent;ok
+
+# nf_nat flags is the last argument
+udp dport 1234 redirect random :123;fail
+udp dport 21234 redirect persistent,random-fully :431;fail
 
 # redirect is a terminal statement
 tcp dport 22 redirect counter packets 0 bytes 0 accept;fail
diff --git a/tests/regression/ip6/redirect.t b/tests/regression/ip6/redirect.t
index d972871..dce4794 100644
--- a/tests/regression/ip6/redirect.t
+++ b/tests/regression/ip6/redirect.t
@@ -25,9 +25,11 @@ tcp dport 39128 redirect :993;ok
 redirect :1234;fail
 redirect :12341111;fail
 
-# invalid arguments
-tcp dport 9128 redirect :993 random;fail
-tcp dport 9128 redirect :993 random-fully;fail
+# both port and nf_nat flags
+tcp dport 9128 redirect :993 random;ok
+tcp dport 9128 redirect :993 random-fully,persistent;ok
+
+# nf_nat flags are the last argument
 tcp dport 9128 redirect persistent :123;fail
 tcp dport 9128 redirect random,persistent :123;fail
 

