From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] rule: delete extra space in sets printing
Date: Wed, 13 Jan 2016 18:21:41 +0100
Message-ID: <145270561444.23138.11119007913809214107.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55687 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755193AbcAMRVt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 12:21:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The extra space is printed when sets are printed in tabulated format.

table inet test {
	set test {
		  ^
		type ipv4_addr
	}
}

However, the space is still required in printing in plain format (ie, monitor).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: use string test provided by Pablo and put an example of the problem
    in the patch description.

 src/rule.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 18ff592..2f03b98 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -267,7 +267,10 @@ static void set_print_declaration(const struct set *set,
 	if (opts->table != NULL)
 		printf(" %s", opts->table);
 
-	printf(" %s { %s", set->handle.set, opts->nl);
+	printf(" %s {%s", set->handle.set, opts->nl);
+
+	if (!opts->nl[0])
+		printf(" ");
 
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)

