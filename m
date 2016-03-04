From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] rule: simplify ("rule: delete extra space in sets printing")
Date: Fri,  4 Mar 2016 10:25:32 +0100
Message-ID: <1457083532-1595-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbcCDJZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2016 04:25:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0F8273F9
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2016 10:25:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A65A0330FB
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2016 10:25:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ABA91CA0ED
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2016 10:25:34 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This simplifies bd23f7628570 ("rule: delete extra space in sets printing")
by passing the whitespace from set_print_plain() called from the monitoring
path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 2f03b98..0b78549 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -269,9 +269,6 @@ static void set_print_declaration(const struct set *set,
 
 	printf(" %s {%s", set->handle.set, opts->nl);
 
-	if (!opts->nl[0])
-		printf(" ");
-
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
@@ -352,7 +349,7 @@ void set_print_plain(const struct set *s)
 {
 	struct print_fmt_options opts = {
 		.tab		= "",
-		.nl		= "",
+		.nl		= " ",
 		.table		= s->handle.table,
 		.family		= family2str(s->handle.family),
 		.stmt_separator	= ";",
-- 
2.1.4

