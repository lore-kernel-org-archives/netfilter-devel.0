From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] src/rule.c: don't print trailing statement
 whitespace
Date: Wed, 23 Mar 2016 13:51:33 +0100
Message-ID: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39989 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754010AbcCWMvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 08:51:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This trailing whitespace is annoying when working with the textual output
of nft.

Before:

table t {
	chain c {
		ct state new
			    ^
	}
}


After:

table t {
	chain c {
		ct state new
	}
}

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 85987b9..0ed7794 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -385,14 +385,15 @@ void rule_print(const struct rule *rule)
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt);
-		printf(" ");
+		if (!list_is_last(&stmt->list, &rule->stmts))
+			printf(" ");
 	}
 
 	if (rule->comment)
-		printf("comment \"%s\" ", rule->comment);
+		printf(" comment \"%s\"", rule->comment);
 
 	if (handle_output > 0)
-		printf("# handle %" PRIu64, rule->handle.handle);
+		printf(" # handle %" PRIu64, rule->handle.handle);
 }
 
 struct scope *scope_init(struct scope *scope, const struct scope *parent)

