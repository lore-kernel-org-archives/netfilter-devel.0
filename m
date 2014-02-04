From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/8] parser: close scope when encountering an error in a table or chain block
Date: Tue,  4 Feb 2014 08:35:17 +0000
Message-ID: <1391502920-19186-6-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43628 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDIf2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:28 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Close the scopes when destroying a table_block/chain_block. Also add
assertions to open_scope()/close_scope() to catch memory corruption
early.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 24f022a..fa33b57 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -52,12 +52,14 @@ static struct scope *current_scope(const struct parser_state *state)
 
 static void open_scope(struct parser_state *state, struct scope *scope)
 {
+	assert(state->scope < array_size(state->scopes) - 1);
 	scope_init(scope, current_scope(state));
 	state->scopes[++state->scope] = scope;
 }
 
 static void close_scope(struct parser_state *state)
 {
+	assert(state->scope > 0);
 	state->scope--;
 }
 
@@ -367,9 +369,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			handle_spec family_spec position_spec
 
 %type <table>			table_block_alloc table_block
-%destructor { table_free($$); }	table_block_alloc
+%destructor { close_scope(state); table_free($$); }	table_block_alloc
 %type <chain>			chain_block_alloc chain_block
-%destructor { chain_free($$); }	chain_block_alloc
+%destructor { close_scope(state); chain_free($$); }	chain_block_alloc
 %type <rule>			rule
 %destructor { rule_free($$); }	rule
 
-- 
1.8.5.3

