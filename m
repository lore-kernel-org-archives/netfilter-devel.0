Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AC7C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53BA721852
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfBZVNl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:13:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47992 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZVNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 16:13:41 -0500
Received: from localhost ([::1]:32850 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gyk2l-0006mk-VD; Tue, 26 Feb 2019 22:13:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/5] libnftables: Print errors before freeing commands
Date:   Tue, 26 Feb 2019 22:13:38 +0100
Message-Id: <20190226211342.15125-2-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226211342.15125-1-phil@nwl.cc>
References: <20190226211342.15125-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commands may contain data printed by an error record, so make sure
cmd_free() is not called before erec_print_list() has returned.

Fixes: 778de37d82e7b ("libnftables: Keep cmds list outside of parser_state")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index bd79cd6091d25..2271d270fd574 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -398,11 +398,11 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	list_for_each_entry_safe(cmd, next, &cmds, list) {
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft->scanner);
@@ -442,11 +442,11 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
 		rc = -1;
 err:
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	list_for_each_entry_safe(cmd, next, &cmds, list) {
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft->scanner);
-- 
2.20.1

