From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nft 2/3] parser_bison: duplicate string returned by chain_type_name_lookup()
Date: Tue, 15 Mar 2016 17:33:17 +0100
Message-ID: <1458059598-7470-2-git-send-email-pablo@netfilter.org>
References: <1458059598-7470-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33689 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934127AbcCOQdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:33:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1CE71114F49
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 072C3DA38C
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4CEA1DA38C
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:27 +0100 (CET)
In-Reply-To: <1458059598-7470-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This chain type string is released via chain_free() since b7cb6915a88f,
so duplicate it so we don't try to release statically allocated memory.

Fixes: b7cb6915a88f ("rule: Remove memory leak")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 24c0969..0592b68 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1101,7 +1101,7 @@ type_identifier		:	STRING	{ $$ = $1; }
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 			{
-				$<chain>0->type		= chain_type_name_lookup($2);
+				$<chain>0->type		= xstrdup(chain_type_name_lookup($2));
 				if ($<chain>0->type == NULL) {
 					erec_queue(error(&@2, "unknown chain type %s", $2),
 						   state->msgs);
-- 
2.1.4

