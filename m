Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49ABDCD8C8E
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjJJO1Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjJJO1P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:27:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1AAB91
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 07:27:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, phil@nwl.cc
Subject: [PATCH nft] doc: remove references to timeout in reset command
Date:   Tue, 10 Oct 2023 16:27:04 +0200
Message-Id: <20231010142704.54741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After Linux kernel's patch ("netfilter: nf_tables: do not refresh
timeout when resetting element") timers are not reset anymore, update
documentation to keep this in sync.

Fixes: 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 7e47ca39aa93..5e6a2bb7b0b4 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -524,7 +524,7 @@ beginning of the chain or before the specified rule.
 *replace*:: Similar to *add*, but the rule replaces the specified rule.
 *delete*:: Delete the specified rule.
 *destroy*:: Delete the specified rule, it does not fail if it does not exist.
-*reset*:: Reset rule-contained state, i.e. counter and quota statement values.
+*reset*:: Reset rule-contained state, i.e. counter, limit and quota statement values.
 
 .*add a rule to ip table output chain*
 -------------
@@ -590,7 +590,7 @@ be tuned with the flags that can be specified at set creation time.
 *destroy*:: Delete the specified set, it does not fail if it does not exist.
 *list*:: Display the elements in the specified set.
 *flush*:: Remove all elements from the specified set.
-*reset*:: Reset timeout and other state in all contained elements.
+*reset*:: Reset state in all contained elements, eg. counter, limit and quota statement values.
 
 .Set specifications
 [options="header"]
@@ -640,7 +640,7 @@ Maps store data based on some specific key used as input. They are uniquely iden
 *destroy*:: Delete the specified map, it does not fail if it does not exist.
 *list*:: Display the elements in the specified map.
 *flush*:: Remove all elements from the specified map.
-*reset*:: Reset timeout and other state in all contained elements.
+*reset*:: Reset state in all contained elements, eg. counter, limit and quota statement values.
 
 .Map specifications
 [options="header"]
@@ -707,8 +707,8 @@ listed elements may already exist.
 be non-trivial in very large and/or interval sets. In the latter case, the
 containing interval is returned instead of just the element itself.
 
-*reset* command resets timeout or other state attached to the given
-element(s).
+*reset* command resets state attached to the given element(s), i.e. counter,
+limit and quota statement values.
 
 .Element options
 [options="header"]
-- 
2.30.2

