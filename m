From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 6/9] src: simplify unsetters
Date: Tue, 14 Jun 2016 15:18:42 +0200
Message-ID: <1465910325-13286-6-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55947 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbcFNNS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:18:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2D89EE7DC0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C8439EBAB
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DBD2E9EBAB
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:54 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the attribute is set as we already check at the beginning of this
function, then we can release the object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c    | 15 +++------------
 src/rule.c     | 10 ++--------
 src/ruleset.c  |  4 ----
 src/set.c      | 15 +++++----------
 src/set_elem.c | 15 +++++----------
 src/table.c    |  5 +----
 6 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 0c79dd5..e0f548c 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -119,18 +119,12 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 
 	switch (attr) {
 	case NFTNL_CHAIN_TABLE:
-		if (c->table) {
-			xfree(c->table);
-			c->table = NULL;
-		}
+		xfree(c->table);
 		break;
 	case NFTNL_CHAIN_USE:
 		break;
 	case NFTNL_CHAIN_TYPE:
-		if (c->type) {
-			xfree(c->type);
-			c->type = NULL;
-		}
+		xfree(c->type);
 		break;
 	case NFTNL_CHAIN_NAME:
 	case NFTNL_CHAIN_HOOKNUM:
@@ -142,10 +136,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 	case NFTNL_CHAIN_FAMILY:
 		break;
 	case NFTNL_CHAIN_DEV:
-		if (c->dev) {
-			xfree(c->dev);
-			c->dev = NULL;
-		}
+		xfree(c->dev);
 		break;
 	default:
 		return;
diff --git a/src/rule.c b/src/rule.c
index 293c0cf..375552e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -95,16 +95,10 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 
 	switch (attr) {
 	case NFTNL_RULE_TABLE:
-		if (r->table) {
-			xfree(r->table);
-			r->table = NULL;
-		}
+		xfree(r->table);
 		break;
 	case NFTNL_RULE_CHAIN:
-		if (r->chain) {
-			xfree(r->chain);
-			r->chain = NULL;
-		}
+		xfree(r->chain);
 		break;
 	case NFTNL_RULE_HANDLE:
 	case NFTNL_RULE_COMPAT_PROTO:
diff --git a/src/ruleset.c b/src/ruleset.c
index cbe1438..971f531 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -92,19 +92,15 @@ void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr)
 	switch (attr) {
 	case NFTNL_RULESET_TABLELIST:
 		nftnl_table_list_free(r->table_list);
-		r->table_list = NULL;
 		break;
 	case NFTNL_RULESET_CHAINLIST:
 		nftnl_chain_list_free(r->chain_list);
-		r->chain_list = NULL;
 		break;
 	case NFTNL_RULESET_SETLIST:
 		nftnl_set_list_free(r->set_list);
-		r->set_list = NULL;
 		break;
 	case NFTNL_RULESET_RULELIST:
 		nftnl_rule_list_free(r->rule_list);
-		r->rule_list = NULL;
 		break;
 	}
 	r->flags &= ~(1 << attr);
diff --git a/src/set.c b/src/set.c
index a35c4ec..ccea313 100644
--- a/src/set.c
+++ b/src/set.c
@@ -65,20 +65,15 @@ EXPORT_SYMBOL(nftnl_set_is_set);
 
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 {
+	if (!(s->flags & (1 << attr)))
+		return;
+
 	switch (attr) {
 	case NFTNL_SET_TABLE:
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			if (s->table) {
-				xfree(s->table);
-				s->table = NULL;
-			}
+		xfree(s->table);
 		break;
 	case NFTNL_SET_NAME:
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			if (s->name) {
-				xfree(s->name);
-				s->name = NULL;
-			}
+		xfree(s->name);
 		break;
 	case NFTNL_SET_FLAGS:
 	case NFTNL_SET_KEY_TYPE:
diff --git a/src/set_elem.c b/src/set_elem.c
index ec0a4b7..dbf4176 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -66,14 +66,12 @@ EXPORT_SYMBOL(nftnl_set_elem_is_set);
 
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 {
+	if (!(s->flags & (1 << attr)))
+		return;
+
 	switch (attr) {
 	case NFTNL_SET_ELEM_CHAIN:
-		if (s->flags & (1 << NFTNL_SET_ELEM_CHAIN)) {
-			if (s->data.chain) {
-				xfree(s->data.chain);
-				s->data.chain = NULL;
-			}
-		}
+		xfree(s->data.chain);
 		break;
 	case NFTNL_SET_ELEM_FLAGS:
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
@@ -84,10 +82,7 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
 		break;
 	case NFTNL_SET_ELEM_EXPR:
-		if (s->flags & (1 << NFTNL_SET_ELEM_EXPR)) {
-			nftnl_expr_free(s->expr);
-			s->expr = NULL;
-		}
+		nftnl_expr_free(s->expr);
 		break;
 	default:
 		return;
diff --git a/src/table.c b/src/table.c
index 4f86426..03b618f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -64,10 +64,7 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 
 	switch (attr) {
 	case NFTNL_TABLE_NAME:
-		if (t->name) {
-			xfree(t->name);
-			t->name = NULL;
-		}
+		xfree(t->name);
 		break;
 	case NFTNL_TABLE_FLAGS:
 	case NFTNL_TABLE_FAMILY:
-- 
2.1.4

