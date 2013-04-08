From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: rule: fix compat XML output
Date: Mon, 08 Apr 2013 10:35:02 +0200
Message-ID: <20130408083502.9509.95918.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57387 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934645Ab3DHIfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:35:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compat struct was not printed in XML. So, I think give output format is the first step to parse it.
---
 src/rule.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 57b849d..e419b0a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -445,11 +445,18 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 		"<rule family=\"%u\" table=\"%s\" "
-			"chain=\"%s\" handle=\"%llu\"> ",
+			"chain=\"%s\" handle=\"%llu\">\n ",
 				r->family, r->table, r->chain,
 				(unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>"
+					"<compat_flags>%u</compat_flags>"
+					"<compat_proto>%u</compat_proto>",
+					r->rule_flags,
+					r->compat.flags, r->compat.proto);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret = snprintf(buf+offset, len,
 				"\n\t<expr type=\"%s\">\n", expr->ops->name);

