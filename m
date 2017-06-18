From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: merge nested set flags
Date: Sun, 18 Jun 2017 13:13:34 +0200
Message-ID: <1497784414-10028-1-git-send-email-pablo@netfilter.org>
Cc: ian.kumlien@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60660 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdFRLNm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2017 07:13:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5912217AE3F
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 13:13:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BCCDD191C
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 13:13:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05CD9202A2
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 13:13:30 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A set may contain a nested set element definition, merge the nested set
flags so we don't hit:

 BUG: invalid data expression type range
 nft: netlink.c:400: netlink_gen_data: Assertion `0' failed.
 Aborted

With the following example ruleset:

 define dnat_ports      = { 1234-1567 }
 define port_allow      = {
        53,             # dns
        $dnat_ports,    # dnat
 }

 add rule x y tcp dport $port_allow accept

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1145
Fixes: a6b75b837f5e ("evaluate: set: Allow for set elems to be sets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 04367cedc62e..736ee1b0ee21 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1150,6 +1150,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		    i->key->ops->type == EXPR_SET) {
 			struct expr *new = expr_clone(i->key);
 
+			set->set_flags |= i->key->set_flags;
 			list_replace(&i->list, &new->list);
 			expr_free(i);
 			i = new;
-- 
2.1.4

