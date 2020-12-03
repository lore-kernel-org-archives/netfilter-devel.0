Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64D1C6369E
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 00:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58D6F221FB
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 00:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgLCA0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 19:26:21 -0500
Received: from correo.us.es ([193.147.175.20]:60618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCA0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 19:26:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06B4BFB361
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 01:25:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBDD9DA722
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 01:25:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E16C1DA72F; Thu,  3 Dec 2020 01:25:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB829DA722
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 01:25:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Dec 2020 01:25:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A9C1A4265A5A
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 01:25:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: reply netlink error message might be larger than MNL_SOCKET_BUFFER_SIZE
Date:   Thu,  3 Dec 2020 01:25:33 +0100
Message-Id: <20201203002533.32615-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Netlink attribute maximum size is 65536 bytes (given nla_len is
16-bits). NFTA_SET_ELEM_LIST_ELEMENTS stores as many set elements as
possible that can fit into this netlink attribute.

Netlink messages with NLMSG_ERROR type originating from the kernel
contain the original netlink message as payload, they might be larger
than 65536 bytes.

Add NFT_MNL_ACK_MAXSIZE which estimates the maximum Netlink header
coming as (error) reply from the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index ffa1e140a59d..cd12309b6ef8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -359,6 +359,9 @@ static int mnl_batch_extack_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 #define NFT_MNL_ECHO_RCVBUFF_DEFAULT	(MNL_SOCKET_BUFFER_SIZE * 1024)
+#define NFT_MNL_ACK_MAXSIZE		((sizeof(struct nlmsghdr) + \
+					  sizeof(struct nfgenmsg) + (1 << 16)) + \
+					  MNL_SOCKET_BUFFER_SIZE)
 
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		   uint32_t num_cmds)
@@ -366,7 +369,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	struct mnl_socket *nl = ctx->nft->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
-	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	char rcv_buf[NFT_MNL_ACK_MAXSIZE];
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
-- 
2.20.1

