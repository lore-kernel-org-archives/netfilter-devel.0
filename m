From: Arturo Borrero Gonzalez <aborrero@cica.es>
Subject: [nft PATCH] rule: fix printing of rule comments
Date: Thu, 08 Oct 2015 11:27:24 +0200
Message-ID: <20151008092724.23737.63936.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42143 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755572AbbJHJsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 05:48:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Several fixes:
 * handles are printed last
 * simplify space games (an extra space was being printed)
 * comments are shown with `nft monitor' as well (missing before this patch)


Before this patch:

% nft list ruleset -a
[...]
chain test {
	iifname eth0 # handle 1 comment "test"

}
[...]

% nft list ruleset
[...]
chain test {
	iifname eth0  comment "test"
		    ^^
}
[...]

% nft monitor &
% nft add rule test test iifname eth0 comment "test"
add rule test test iifname eth0

After this patch:

% nft list ruleset -a
chain test {
	iifname eth0 comment "test" # handle 1
		    ^
}

% nft monitor -a &
% nft add rule test test iifname eth0 comment "test"
add rule test test iifname eth0 comment "test" # handle 1

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 92b83f0..1bf0e03 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -383,6 +383,10 @@ void rule_print(const struct rule *rule)
 		stmt->ops->print(stmt);
 		printf(" ");
 	}
+
+	if (rule->handle.comment)
+		printf("comment \"%s\" ", rule->handle.comment);
+
 	if (handle_output > 0)
 		printf("# handle %" PRIu64, rule->handle.handle);
 }
@@ -622,10 +626,7 @@ static void chain_print(const struct chain *chain)
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
 		rule_print(rule);
-		if (rule->handle.comment)
-			printf(" comment \"%s\"\n", rule->handle.comment);
-		else
-			printf("\n");
+		printf("\n");
 	}
 	printf("\t}\n");
 }

