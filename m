From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] rule: delete extra space in rule indentation
Date: Tue, 17 Mar 2015 22:23:27 +0100
Message-ID: <20150317212327.20080.81689.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38449 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752392AbbCQVXi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 17:23:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Annoying extra space in rule indentation.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 8d76fd0..9403c1e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -237,11 +237,11 @@ void rule_print(const struct rule *rule)
 	const struct stmt *stmt;
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
-		printf(" ");
 		stmt->ops->print(stmt);
+		printf(" ");
 	}
 	if (handle_output > 0)
-		printf(" # handle %" PRIu64, rule->handle.handle);
+		printf("# handle %" PRIu64, rule->handle.handle);
 }
 
 struct scope *scope_init(struct scope *scope, const struct scope *parent)

