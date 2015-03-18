From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] rule: delete extra space in rule indentation
Date: Wed, 18 Mar 2015 11:43:24 +0100
Message-ID: <20150318104252.25344.59683.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44466 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755457AbbCRKnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 06:43:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Annoying extra space in rule indentation:

Example before this patch:

table ip6 test_table {
	chain test_chain {
		 counter tcp dport { 22, 80, 443} accept # handle 1
		^
	}
}

Example after this patch:

table ip6 test_table {
	chain test_chain {
		counter tcp dport { 22, 80, 443} accept # handle 1
	}
}

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: include examples in patch description.

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

