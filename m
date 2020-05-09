Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D51C28CBC
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 09:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689ED217BA
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 09:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgEIJgJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 05:36:09 -0400
Received: from correo.us.es ([193.147.175.20]:36150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgEIJgJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 05:36:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CABF12084B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C03811540B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:36:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31A8D115406; Sat,  9 May 2020 11:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9272115406;
        Sat,  9 May 2020 11:36:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 09 May 2020 11:36:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AB99142EF4E0;
        Sat,  9 May 2020 11:36:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, jengelh@inai.de
Subject: [PATCH nft,v2] mnl: fix error rule reporting with missing table/chain and anonymous sets
Date:   Sat,  9 May 2020 11:36:01 +0200
Message-Id: <20200509093601.14671-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

handle_merge() skips handle location initialization because set name != NULL.

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7f64f1e in erec_print (octx=0x55555555d2c0, erec=0x55555555fcf0, debug_mask=0) at erec.c:95
95              switch (indesc->type) {
(gdb) bt
    buf=0x55555555db20 "add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept") at libnftables.c:459
(gdb) p indesc
$1 = (const struct input_descriptor *) 0x0

Closes: http://bugzilla.opensuse.org/show_bug.cgi?id=1171321
Fixes: 086ec6f30c96 ("mnl: extended error support for create command")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix this from evaluation phas which does not initialize location.

 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index de5f60ec1f4d..a057be5e553a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -101,6 +101,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		handle_merge(&set->handle, &ctx->cmd->handle);
 		memset(&h, 0, sizeof(h));
 		handle_merge(&h, &set->handle);
+		h.set.location = expr->location;
 		cmd = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &h, &expr->location, set);
 		cmd->location = set->location;
 		list_add_tail(&cmd->list, &ctx->cmd->list);
-- 
2.20.1

