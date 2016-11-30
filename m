From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] datatype: honor -nn option from inet_service_type_print()
Date: Wed, 30 Nov 2016 23:06:41 +0100
Message-ID: <1480543601-10228-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754862AbcK3WGy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 17:06:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8252B13C0D9
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 23:06:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75515DA7F6
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 23:06:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64C22DA804
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 23:06:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If -nn is passed, we have to display ports in numbers, not as a symbol.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: ccc5da470e76 ("datatype: Replace getnameinfo() by internal lookup table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/datatype.c b/src/datatype.c
index c92f9276f838..b5d73bc045e2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -559,6 +559,10 @@ const struct datatype inet_protocol_type = {
 
 static void inet_service_type_print(const struct expr *expr)
 {
+	if (numeric_output >= NUMERIC_PORT) {
+		integer_type_print(expr);
+		return;
+	}
 	symbolic_constant_print(&inet_service_tbl, expr, false);
 }
 
-- 
2.1.4

