Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB2BC282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923422067C
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfFDRct (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56504 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfFDRct (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:49 -0400
Received: from localhost ([::1]:41360 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDIl-0000p8-Lt; Tue, 04 Jun 2019 19:32:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 03/10] libnftables: Drop cache in error case
Date:   Tue,  4 Jun 2019 19:31:51 +0200
Message-Id: <20190604173158.1184-4-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
References: <20190604173158.1184-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a transaction is rejected by the kernel (for instance due to a
semantic error), cache contents are potentially invalid. Release the
cache in that case to avoid the inconsistency.

The problem is easy to reproduce in an interactive session:

| nft> list ruleset
| table ip t {
| 	chain c {
| 	}
| }
| nft> flush ruleset; add rule ip t c accept
| Error: No such file or directory
| flush ruleset; add rule ip t c accept
|                            ^
| nft> list ruleset
| nft>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index d8de89ca509cd..e928ce476a90f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -423,6 +423,8 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
+	if (rc)
+		cache_release(&nft->cache);
 	return rc;
 }
 
@@ -466,6 +468,8 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
+	if (rc)
+		cache_release(&nft->cache);
 	return rc;
 }
 
-- 
2.21.0

