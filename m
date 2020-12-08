Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C468C4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 17:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDE023B00
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 17:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgLHRJE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 12:09:04 -0500
Received: from correo.us.es ([193.147.175.20]:48304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgLHRJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 12:09:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 870531228C5
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 18:08:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76362E1515
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 18:08:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6BB68E1506; Tue,  8 Dec 2020 18:08:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03915E150B
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 18:08:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 18:08:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E6BF34265A5A
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 18:08:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: double close_scope() call for implicit chains
Date:   Tue,  8 Dec 2020 18:08:11 +0100
Message-Id: <20201208170811.30139-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call close_scope() from chain_block_alloc only.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1485
Fixes: c330152b7f77 ("src: support for implicit chain bindings")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index fb329919ea95..e8aa5bb8eb3d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -605,7 +605,7 @@ int nft_lex(void *, void *, void *);
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
 %type <chain>			chain_block_alloc chain_block subchain_block
-%destructor { close_scope(state); chain_free($$); }	chain_block_alloc subchain_block
+%destructor { close_scope(state); chain_free($$); }	chain_block_alloc
 %type <rule>			rule rule_alloc
 %destructor { rule_free($$); }	rule
 
-- 
2.20.1

