Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915E1C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 12:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704E5208E3
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 12:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfFGMW2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 08:22:28 -0400
Received: from mail.us.es ([193.147.175.20]:54762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbfFGMW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 08:22:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA5E4C1A0E
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:22:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD60FDA704
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:22:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2EF7DA702; Fri,  7 Jun 2019 14:22:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2E0ADA704
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:22:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 14:22:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0F764265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 14:22:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: check for errors after evaluations
Date:   Fri,  7 Jun 2019 14:22:20 +0200
Message-Id: <20190607122220.17538-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for state->nerrs after evaluation to restore error reporting when
evaluation fails.

Fixes: df2f746fb4cf ("libnftables: keep evaluating until parser_max_errors")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Sorry! I pushed out df2f746fb4cf too fast.

 src/libnftables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index e9dc03cf2909..abd133bee127 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -398,6 +398,9 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			return -1;
 	}
 
+	if (nft->state->nerrs)
+		return -1;
+
 	list_for_each_entry(cmd, cmds, list)
 		nft_cmd_expand(cmd);
 
-- 
2.11.0

