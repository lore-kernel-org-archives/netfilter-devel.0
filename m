Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D6CC82E41
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E7E02072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgD0XMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 19:12:30 -0400
Received: from correo.us.es ([193.147.175.20]:44782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD0XM2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 19:12:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DDE0D2DA1C
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E031BAAB4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0331CBAAB1; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DD1DBAAA1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F38DA42EF9E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 7/9] mnl: restore --debug=netlink output with sets
Date:   Tue, 28 Apr 2020 01:12:15 +0200
Message-Id: <20200427231217.20274-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427231217.20274-1-pablo@netfilter.org>
References: <20200427231217.20274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(null) (null) b size 1

The debugging output displays table and set names as (null). This patch
sets the table and name before displaying the netlink debugging, then
unset them to not break the extended error support.

Fixes: 086ec6f30c96 ("mnl: extended error support for create command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index fb34ecb3dece..94e80261afb7 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -960,6 +960,8 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FAMILY, h->family);
+	nftnl_set_set_str(nls, NFTNL_SET_TABLE, h->table.name);
+	nftnl_set_set_str(nls, NFTNL_SET_NAME, h->set.name);
 	nftnl_set_set_u32(nls, NFTNL_SET_ID, h->set_id);
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
@@ -1036,6 +1038,9 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	netlink_dump_set(nls, ctx);
 
+	nftnl_set_unset(nls, NFTNL_SET_TABLE);
+	nftnl_set_unset(nls, NFTNL_SET_NAME);
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWSET,
 				    h->family,
-- 
2.20.1

