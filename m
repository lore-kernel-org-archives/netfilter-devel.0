From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] rule: fix chain details align indentations
Date: Thu, 19 Mar 2015 13:37:59 +0100
Message-ID: <20150319123759.28211.63107.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35725 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbbCSMiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2015 08:38:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

f.i:
	 type filter hook output priority 0; policy accept;
	ip daddr @test counter packets 14 bytes 1176

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 0400dec..7114380 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -444,7 +444,7 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s priority %d; policy %s;\n",
+		printf("\t\ttype %s hook %s priority %d; policy %s;\n",
 		       chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
 		       chain->priority, chain_policy2str(chain->policy));

