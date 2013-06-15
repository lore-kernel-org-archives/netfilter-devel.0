From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/3] rule: xml: delete trailing space
Date: Sat, 15 Jun 2013 03:16:15 +0200
Message-ID: <20130615011615.3778.76826.stgit@nfdev.cica.es>
References: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54371 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753023Ab3FOBQR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:16:17 -0400
In-Reply-To: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix a trailing space in rule xml_snprintf.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 99ad50c..1609cc3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -654,7 +654,7 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 		"<rule family=\"%u\" table=\"%s\" "
-			"chain=\"%s\" handle=\"%llu\" version=\"%d\"> ",
+			"chain=\"%s\" handle=\"%llu\" version=\"%d\">",
 				r->family, r->table, r->chain,
 				(unsigned long long)r->handle,
 				NFT_RULE_XML_VERSION);

