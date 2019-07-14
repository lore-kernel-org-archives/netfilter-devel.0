Return-Path: <SRS0=dbJk=VL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F88C73C66
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 08:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD2D20820
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 08:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfGNI4c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jul 2019 04:56:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbfGNI4c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jul 2019 04:56:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hmaJ4-0006n4-FC; Sun, 14 Jul 2019 10:56:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Amish <anon.amish@gmail.com>
Subject: [PATCH xtables] nft: exit in case we can't fetch current genid
Date:   Sun, 14 Jul 2019 10:49:28 +0200
Message-Id: <20190714084928.31369-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <584d388e-9d90-11be-ea48-ba51464d8495@gmail.com>
References: <584d388e-9d90-11be-ea48-ba51464d8495@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running iptables -nL as non-root user, iptables would loop indefinitely.

With this change, it will fail with
iptables v1.8.3 (nf_tables): Could not fetch rule set generation id: Permission denied (you must be root)

Reported-by: Amish <anon.amish@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e927d1db2b42..8f0d5e664eca 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -82,13 +82,19 @@ out:
 	return MNL_CB_ERROR;
 }
 
-static int mnl_genid_get(struct nft_handle *h, uint32_t *genid)
+static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	int ret;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, 0, 0, h->seq);
-	return mnl_talk(h, nlh, genid_cb, genid);
+	ret = mnl_talk(h, nlh, genid_cb, genid);
+	if (ret == 0)
+		return;
+
+	xtables_error(RESOURCE_PROBLEM,
+		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
 }
 
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
-- 
2.21.0

