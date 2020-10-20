Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED56C4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 19:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E2521481
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 19:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438400AbgJTTuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 15:50:15 -0400
Received: from correo.us.es ([193.147.175.20]:42838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438397AbgJTTuP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 15:50:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5997E2C4E
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7ED6F7336
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:50:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD952F7332; Tue, 20 Oct 2020 21:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91AC1207D3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:50:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 21:50:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 72D954301DE1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:50:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] monitor: do not print generation ID with --echo
Date:   Tue, 20 Oct 2020 21:50:07 +0200
Message-Id: <20201020195007.22631-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fixes testcases/sets/0036add_set_element_expiration_0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/monitor.c b/src/monitor.c
index 3872ebcfbdaf..9e508f8f7574 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -849,7 +849,7 @@ static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
 			break;
 		}
 	}
-	if (genid >= 0) {
+	if (!nft_output_echo(&monh->ctx->nft->output) && genid >= 0) {
 		nft_mon_print(monh, "# new generation %d", genid);
 		if (pid >= 0)
 			nft_mon_print(monh, " by process %d (%s)", pid, name);
-- 
2.20.1

