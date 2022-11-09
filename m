Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AF9C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 10:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiKIKTv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 05:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiKIKTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 05:19:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A5A024BF0
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 02:19:49 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] doc: document a few reset commands supported by the parser
Date:   Wed,  9 Nov 2022 11:19:45 +0100
Message-Id: <20221109101945.183081-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following are missing in the manpage:

 *reset counters* ['family']
 *reset quotas* ['family']
 *reset counters* ['family'] *table* 'table'
 *reset quotas* ['family'] *table* 'table'

While at it, expand type to the supported stateful objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 02cf13a57c2e..4f2af5e5548f 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -732,11 +732,19 @@ kernel modules, such as nf_conntrack.
 STATEFUL OBJECTS
 ----------------
 [verse]
-{*add* | *delete* | *list* | *reset*} 'type' ['family'] 'table' 'object'
-*delete* 'type' ['family'] 'table' *handle* 'handle'
+{*add* | *delete* | *list* | *reset*} *counter* ['family'] 'table' 'object'
+{*add* | *delete* | *list* | *reset*} *quota* ['family'] 'table' 'object'
+{*add* | *delete* | *list* | *reset*} *limit* ['family'] 'table' 'object'
+*delete* 'counter' ['family'] 'table' *handle* 'handle'
+*delete* 'quota' ['family'] 'table' *handle* 'handle'
+*delete* 'limit' ['family'] 'table' *handle* 'handle'
 *list counters* ['family']
 *list quotas* ['family']
 *list limits* ['family']
+*reset counters* ['family']
+*reset quotas* ['family']
+*reset counters* ['family'] *table* 'table'
+*reset quotas* ['family'] *table* 'table'
 
 Stateful objects are attached to tables and are identified by a unique name.
 They group stateful information from rules, to reference them in rules the
-- 
2.30.2

