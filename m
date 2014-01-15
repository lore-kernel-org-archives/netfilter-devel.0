From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] payload: fix crash when wrong ethernet protocol type is used
Date: Wed, 15 Jan 2014 21:30:22 +0100
Message-ID: <1389817823-7251-2-git-send-email-pablo@netfilter.org>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaAOUaf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:30:35 -0500
In-Reply-To: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule ip filter output meta protocol xyz counter
                                            ^^^

This fix is similar to 4097ad7 ("meta: fix crash when parsing
unresolvable mark values").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/payload.c b/src/payload.c
index 86d75fa..decfcd6 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -993,6 +993,7 @@ static struct error_record *ethertype_parse(const struct expr *sym,
 {
 	struct error_record *erec;
 
+	*res = NULL;
 	erec = sym->dtype->basetype->parse(sym, res);
 	if (erec != NULL)
 		return erec;
-- 
1.7.10.4

