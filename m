Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A03C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 06:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07744206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 06:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfI0Gm7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 02:42:59 -0400
Received: from correo.us.es ([193.147.175.20]:57762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfI0Gm7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 02:42:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C9661878A7
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2019 08:42:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D48AB7FFE
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2019 08:42:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62F3EB7FF9; Fri, 27 Sep 2019 08:42:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C77DDA72F;
        Fri, 27 Sep 2019 08:42:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Sep 2019 08:42:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4121C4265A5A;
        Fri, 27 Sep 2019 08:42:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net
Subject: [PATCH nft,v2] libnftables: memleak when list of commands is empty
Date:   Fri, 27 Sep 2019 08:42:51 +0200
Message-Id: <20190927064251.10604-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==9946== 200,807 (40 direct, 200,767 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
==9946==    at 0x4837B65: calloc (vg_replace_malloc.c:762)
==9946==    by 0x4F28216: nftnl_batch_alloc (batch.c:66)
==9946==    by 0x48A33E8: mnl_batch_init (mnl.c:164)
==9946==    by 0x48A736F: nft_netlink.isra.0 (libnftables.c:29)
==9946==    by 0x48A7D03: nft_run_cmd_from_filename (libnftables.c:508)
==9946==    by 0x10A621: main (main.c:328)

Fixes: fc6d0f8b0cb1 ("libnftables: get rid of repeated initialization of netlink_ctx")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: better commit description and title.

 src/libnftables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index a19636b22683..e20372438db6 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -34,7 +34,7 @@ static int nft_netlink(struct nft_ctx *nft,
 	int ret = 0;
 
 	if (list_empty(cmds))
-		return 0;
+		goto out;
 
 	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
-- 
2.11.0

