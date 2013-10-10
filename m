From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables PATCH] src: error if listing nonexistent table
Date: Fri, 11 Oct 2013 00:21:30 +0200
Message-ID: <20131010222129.14092.99057.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52192 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755750Ab3JJWVl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:21:41 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 449A751ED45
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 22:21:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9IdGlWE3ZP4L for <netfilter-devel@vger.kernel.org>;
	Fri, 11 Oct 2013 00:21:34 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id DCEBC51ED6B
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 00:21:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here examples (foo table doesn't exist).

Before this patch:

# nft list table foo
table ip foo {
}

After:

# nft list table foo
<cmdline>:1:1-14: Error: Could not receive table from kernel: No such file or directory
list table foo
^^^^^^^^^^^^^^

BTW, netlink_get_table() seemed unused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/mnl.c  |    2 ++
 src/rule.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 27b181a..4490411 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -563,6 +563,8 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
 					nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 					NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
 }
 
diff --git a/src/rule.c b/src/rule.c
index 39a66d7..ff1193a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -610,6 +610,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			return 0;
 		}
 		/* List content of this table */
+		if (netlink_get_table(ctx, &cmd->handle, &cmd->location) < 0)
+			return -1;
 		if (do_list_sets(ctx, &cmd->location, table) < 0)
 			return -1;
 		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)

