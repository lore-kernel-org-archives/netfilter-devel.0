Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016B6C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 16:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C446E20700
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 16:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfBVQdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 11:33:15 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55820 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfBVQdP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 11:33:15 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1gxDlB-00010i-7W; Fri, 22 Feb 2019 17:33:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: update goto/jump help text
Date:   Fri, 22 Feb 2019 17:33:09 +0100
Message-Id: <20190222163309.11887-1-fw@strlen.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pointed out by redsh on #netfilter: uses "of" instead of "or".
While at it, explain continue and update return statement.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 51dd0b371f92..a5822cf0aeb7 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -6,16 +6,31 @@ The verdict statement alters control flow in the ruleset and issues policy decis
 {accept | drop | queue | continue | return}
 {jump | goto} 'chain'
 
+*accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
+
 [horizontal]
 *accept*:: Terminate ruleset evaluation and accept the packet.
+The packet can still be dropped later by another hook, for instance accept
+in the forward hook still allows to drop the packet later in the postrouting hook,
+or another forward base chain that has a higher priority number and is evaluated
+afterwards in the processing pipeline.
 *drop*:: Terminate ruleset evaluation and drop the packet.
+The drop occurs instantly, no further chains or hooks are evaluated.
+It is not possible to accept the packet in a later chain again, as those
+are not evaluated anymore for the packet.
 *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
-*continue*:: Continue ruleset evaluation with the next rule. FIXME
+Userspace must provide a drop or accept verdict.  In case of accept, processing
+resumes with the next base chain hook, not the rule following the queue verdict.
+*continue*:: Continue ruleset evaluation with the next rule. This
+ is the default behaviour in case a rule issues no verdict.
 *return*:: Return from the current chain and continue evaluation at the
- next rule in the last chain. If issued in a base chain, it is equivalent to *accept*.
+ next rule in the last chain. If issued in a base chain, it is equivalent to the
+ base chain policy.
 *jump* 'chain':: Continue evaluation at the first rule in 'chain'. The current
  position in the ruleset is pushed to a call stack and evaluation will continue
- there when the new chain is entirely evaluated of a *return* verdict is issued.
+ there when the new chain is entirely evaluated or a *return* verdict is issued.
+ In case an absolute verdict is issued by a rule in the chain, ruleset evaluation
+ terminates immediately and the specific action is taken.
 *goto* 'chain':: Similar to *jump*, but the current position is not pushed to the
  call stack, meaning that after the new chain evaluation will continue at the last
  chain instead of the one containing the goto statement.
-- 
2.20.1

