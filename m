From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] proto: initialize result expression in ethertype_parse()
Date: Tue,  1 Jul 2014 19:49:27 +0200
Message-ID: <1404236967-19943-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47197 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbaGARtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:49:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise, you may crash in:

nft add rule bridge filter input ether type ip

Reported-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/proto.c b/src/proto.c
index 0a37a65..e5f49cb 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -754,6 +754,7 @@ static struct error_record *ethertype_parse(const struct expr *sym,
 {
 	struct error_record *erec;
 
+	*res = NULL;
 	erec = sym->dtype->basetype->parse(sym, res);
 	if (erec != NULL)
 		return erec;
-- 
1.7.10.4

