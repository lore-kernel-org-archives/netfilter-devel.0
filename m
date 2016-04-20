From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] evaluate: better error reporting in too long sets names
Date: Wed, 20 Apr 2016 15:43:00 +0200
Message-ID: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53091 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751369AbcDTNnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2016 09:43:14 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B1FB351F238
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 13:43:06 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k2_fg13lpbOd for <netfilter-devel@vger.kernel.org>;
	Wed, 20 Apr 2016 15:43:01 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id 5D1CD51F15F
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 15:43:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, if we choose a set name larger than allowed, the error message is:
 Error: Could not process rule: Numerical result out of range

Let's inform the user with a better error message.

We can discuss later if length of set names should be increased, but I think
this better error reporting is necessary right now to avoid headaches to users.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/evaluate.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 346e34f..b86e5b6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2123,6 +2123,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
+	size_t namelen = IFNAMSIZ - 1;
 	struct table *table;
 	const char *type;
 
@@ -2136,6 +2137,10 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
 
+	if (strlen(set->handle.set) > namelen)
+		return cmd_error(ctx, "%s maximum allowed name length is %lu",
+				 type, namelen);
+
 	if (set->keytype == NULL)
 		return set_error(ctx, set, "%s definition does not specify "
 				 "key data type", type);

