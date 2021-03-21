Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F6CC433C1
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Mar 2021 17:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF7F61946
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Mar 2021 17:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCURA2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Mar 2021 13:00:28 -0400
Received: from mxwww.masterlogin.de ([95.129.51.170]:52748 "EHLO
        mxwww.masterlogin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhCURAF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Mar 2021 13:00:05 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2021 13:00:05 EDT
Received: from mxout4.routing.net (unknown [192.168.10.112])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id 957DC2C498
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Mar 2021 16:49:26 +0000 (UTC)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout4.routing.net (Postfix) with ESMTP id 1E0FA1007D6;
        Sun, 21 Mar 2021 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1616345362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b2SEyY8kyoMnIwO+oDNV0U1ipxcf77e5/I2H3luPik0=;
        b=i0VI7dVHFLGZVKLAM3v1+9Qael99Zg/AsZkQEbZgaxIUfxFWGGOx8QKtX0YSYbgx0aj0aG
        CExjHqoXmt2r5pzX8PHTD3TxyDqsNm44cDB3MEwwsJhI/FzKGVcvQAaAAa4iG+Iq0gxQb0
        IJe7l3Li3DxqfUZ7+bQyEuoD8GxgXBA=
Received: from localhost.localdomain (unknown [80.245.79.88])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 9D6D41001AF;
        Sun, 21 Mar 2021 16:49:21 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH] nftables: add flags offload to flowtable
Date:   Sun, 21 Mar 2021 17:49:16 +0100
Message-Id: <20210321164916.62556-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: bf5edf39-c998-4324-9b08-9f6e5edda667
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

allow flags (currently only offload) in flowtables like it is stated
here: https://lwn.net/Articles/804384/

tested on mt7622/Bananapi-R64

table ip filter {
	flowtable f {
		hook ingress priority filter + 1
		devices = { lan3, lan0, wan }
		flags offload;
	}

	chain forward {
		type filter hook forward priority filter; policy accept;
		ip protocol { tcp, udp } flow add @f
	}
}

table ip nat {
	chain post {
		type nat hook postrouting priority filter; policy accept;
		oifname "wan" masquerade
	}
}

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 include/rule.h     | 8 ++++++++
 src/mnl.c          | 5 +++++
 src/netlink.c      | 2 ++
 src/parser_bison.y | 7 +++++++
 src/rule.c         | 4 ++++
 5 files changed, 26 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 523435f6f5d5..4ef24eb4ec63 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -187,6 +187,14 @@ enum chain_flags {
 	CHAIN_F_BINDING		= 0x4,
 };
 
+/**
+ * enum flowtable_flags - flowtable flags
+ *
+ */
+enum flowtable_flags {
+	FLOWTABLE_F_HW_OFFLOAD	= 0x1, /* NF_FLOWTABLE_HW_OFFLOAD in linux nf_flow_table.h */
+};
+
 /**
  * struct prio_spec - extendend priority specification for mixed
  *                    textual/numerical parsing.
diff --git a/src/mnl.c b/src/mnl.c
index deea586f9b00..ffbfe48158de 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1779,6 +1779,11 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
 	}
 
+	if (cmd->flowtable->flags & FLOWTABLE_F_HW_OFFLOAD) {
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FLAGS,
+				    NFT_FLOWTABLE_HW_OFFLOAD);
+	}
+
 	if (cmd->flowtable->dev_expr) {
 		dev_array = nft_flowtable_dev_array(cmd);
 		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
diff --git a/src/netlink.c b/src/netlink.c
index 8c86789b8369..103fdbd10690 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1598,6 +1598,8 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_NAME));
 	flowtable->handle.handle.id =
 		nftnl_flowtable_get_u64(nlo, NFTNL_FLOWTABLE_HANDLE);
+	if (nftnl_flowtable_is_set(nlo, NFTNL_FLOWTABLE_FLAGS))
+		flowtable->flags = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FLAGS);
 	dev_array = nftnl_flowtable_get(nlo, NFTNL_FLOWTABLE_DEVICES);
 	while (dev_array[len])
 		len++;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 08a2599e5374..6d69071b1c2d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1993,6 +1993,7 @@ flowtable_block_alloc	:	/* empty */
 flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			|	flowtable_block	common_block
 			|	flowtable_block	stmt_separator
+			|	flowtable_block	ft_flags_spec	stmt_separator
 			|	flowtable_block	HOOK		STRING	prio_spec	stmt_separator
 			{
 				$$->hook.loc = @3;
@@ -2375,6 +2376,12 @@ flags_spec		:	FLAGS		OFFLOAD
 			}
 			;
 
+ft_flags_spec		:	FLAGS		OFFLOAD
+			{
+				$<flowtable>0->flags |= FLOWTABLE_F_HW_OFFLOAD;
+			}
+			;
+
 policy_spec		:	POLICY		policy_expr
 			{
 				if ($<chain>0->policy) {
diff --git a/src/rule.c b/src/rule.c
index 1c6010c001c5..f7f905095cbe 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2223,6 +2223,10 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 		nft_print(octx, " }%s", opts->stmt_separator);
 	}
 
+	if (flowtable->flags & NFT_FLOWTABLE_HW_OFFLOAD)
+		nft_print(octx, "%s%sflags offload;%s", opts->tab, opts->tab,
+			  opts->stmt_separator);
+
 	if (flowtable->flags & NFT_FLOWTABLE_COUNTER)
 		nft_print(octx, "%s%scounter%s", opts->tab, opts->tab,
 			  opts->stmt_separator);
-- 
2.25.1

