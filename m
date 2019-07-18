Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9386AC7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 21:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EF82173B
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 21:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="L4JMBM4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfGRVF4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 17:05:56 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33838 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRVF4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 17:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3PY7012T2qOBDorU2puIHz8w0UYPhoK3T6PtPUxhSgI=; b=L4JMBM4xBOo8Bfxl/m5DklWYHh
        uAbJ8fe4SFrFsgCZ/MwroeYaJ6YP+wHu+1a+6JzyhI1nrxRNO7hXvyUIwtCpZpetI0Qca0tl/hPBJ
        unZNgkqXUF7sP4ULmMPyXRSTER0oJGjNfdpHSSapieETDrzaJTOHTDntT6e9Vqxx5MIdJmySMgFN0
        +9+3RZSjuBZ2OHPavWfwHtuHTBms5Qc/8Gb0dLAivz7l5Gy+NEnvA05rYf9QRjdgQ14GOwPNZr0ke
        kyqeChUroxOaktjH582tDspVH/7CgJIx+BsEBgXQAcLjETtr/LtFmKyABofzz6/76Y93UZHHyfXfc
        +1j8b9Aw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hoDb6-0008LM-RP; Thu, 18 Jul 2019 22:05:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] libnftables: got rid of repeated initialization of netlink_ctx variable in loop.
Date:   Thu, 18 Jul 2019 22:05:52 +0100
Message-Id: <20190718210552.16890-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718145722.k5nnznt753cunnca@salvia>
References: <20190718145722.k5nnznt753cunnca@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most members in the context doesn't change, so there is no need to
memset it and reassign most of its members on every iteration.  Moved
that code out of the loop.

Fixes: 49900d448ac9 ("libnftables: Move library stuff out of main.c")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libnftables.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 2f77a7709e2c..834ea661a146 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -23,7 +23,7 @@ static int nft_netlink(struct nft_ctx *nft,
 {
 	uint32_t batch_seqnum, seqnum = 0, num_cmds = 0;
 	struct nftnl_batch *batch;
-	struct netlink_ctx ctx;
+	struct netlink_ctx ctx = { .msgs = msgs, .nft = nft };
 	struct cmd *cmd;
 	struct mnl_err *err, *tmp;
 	LIST_HEAD(err_list);
@@ -32,16 +32,13 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (list_empty(cmds))
 		return 0;
 
-	batch = mnl_batch_init();
+	init_list_head(&ctx.list);
+
+	ctx.batch = batch = mnl_batch_init();
 
 	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
-		memset(&ctx, 0, sizeof(ctx));
-		ctx.msgs = msgs;
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
-		ctx.batch = batch;
-		ctx.nft = nft;
-		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0) {
 			netlink_io_error(&ctx, &cmd->location,
-- 
2.20.1

