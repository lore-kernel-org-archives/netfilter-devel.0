From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [RFC] x_tables: misuse of try_then_request_module
Date: Tue, 8 Mar 2011 17:23:18 -0800
Message-ID: <20110308172318.4992a3a6@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:43244 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1CIBXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:23:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since xt_find_match() returns ERR_PTR(xx) on error not NULL,
the macro try_then_request_module won't work correctly here.
The macro expects its first argument will be zero if condition
fails. But ERR_PTR(-ENOENT) is not zero.

The correct solution is to propagate the error value
back.

Found by inspection, and compile tested only.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/x_tables.c	2011-03-08 17:12:18.600071136 -0800
+++ b/net/netfilter/x_tables.c	2011-03-08 17:20:03.966631011 -0800
@@ -183,7 +183,7 @@ EXPORT_SYMBOL(xt_unregister_matches);
 /*
  * These are weird, but module loading must not be done with mutex
  * held (since they will register), and we have to have a single
- * function to use try_then_request_module().
+ * function to use.
  */
 
 /* Find match, grabs ref.  Returns ERR_PTR() on error. */
@@ -221,9 +221,13 @@ xt_request_find_match(uint8_t nfproto, c
 {
 	struct xt_match *match;
 
-	match = try_then_request_module(xt_find_match(nfproto, name, revision),
-					"%st_%s", xt_prefix[nfproto], name);
-	return (match != NULL) ? match : ERR_PTR(-ENOENT);
+	match = xt_find_match(nfproto, name, revision);
+	if (IS_ERR(match)) {
+		request_module("%st_%s", xt_prefix[nfproto], name);
+		match = xt_find_match(nfproto, name, revision);
+	}
+
+	return match;
 }
 EXPORT_SYMBOL_GPL(xt_request_find_match);
 
@@ -261,9 +265,13 @@ struct xt_target *xt_request_find_target
 {
 	struct xt_target *target;
 
-	target = try_then_request_module(xt_find_target(af, name, revision),
-					 "%st_%s", xt_prefix[af], name);
-	return (target != NULL) ? target : ERR_PTR(-ENOENT);
+	target = xt_find_target(af, name, revision);
+	if (IS_ERR(target)) {
+		request_module("%st_%s", xt_prefix[af], name);
+		target = xt_find_target(af, name, revision);
+	}
+
+	return target;
 }
 EXPORT_SYMBOL_GPL(xt_request_find_target);
 
