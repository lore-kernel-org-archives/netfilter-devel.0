Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681C7ECAAA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 15:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbiHZPDM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbiHZPC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 11:02:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6468D9E92
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 08:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=14sm39l4uZS//Ca/kVP3LkSebp1i3vrLf29uclm/zZ0=; b=JBqIADST+gu+7U87VIvLdAdW9G
        L7I4UE4qzHs2SAZqUldx9WCJB+I2HJaBXQyoHyW2Aq1b2eA1R6sC6EVF3yZ3f0KgA406T4aaD34OK
        +3tnLVQUCcyNv1w/sTv8lR/A5ZmXcGNxvRdsBUndIns2tyEUxvpjyLXat/Bv1Iq/u1+euvpBR3PMj
        SvSBL+dakDZ4HlADsg1z1+M5NHBqZWm5HWKPkQexm31ovZaf1D1ARSWfG982cgnSBgjYjAl4c8MHv
        Q7ovzlZqX4kOusE0CT83uDOzvpcLAJ7S++RFgLMAUHCxOpklfOWqhN/YJxuk28BItB9VQ3oPa534z
        e6O5NXQg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oRarH-00005j-4s
        for netfilter-devel@vger.kernel.org; Fri, 26 Aug 2022 17:02:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Expand extended error reporting to nft_cmd, too
Date:   Fri, 26 Aug 2022 17:02:50 +0200
Message-Id: <20220826150250.27008-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce the same embedded 'error' struct in nft_cmd and initialize it
with the current value from nft_handle. Then in preparation phase,
update nft_handle's error.lineno with the value from the current
nft_cmd.

This serves two purposes:

* Allocated batch objects (obj_update) get the right lineno value
  instead of the COMMIT one.

* Any error during preparation may be reported with line number. Do this
  and change the relevant fprintf() call to use nft_handle's lineno
  instead of the global 'line' variable.

With this change, cryptic iptables-nft-restore error messages should
finally be gone:

| # iptables-nft-restore <<EOF
| *filter
| -A nonexist
| COMMIT
| EOF
| iptables-nft-restore: line 2 failed: No chain/target/match by that name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c         | 1 +
 iptables/nft-cmd.h         | 3 +++
 iptables/nft.c             | 2 ++
 iptables/xtables-restore.c | 2 +-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index fcd01bd02831c..f16ea0e6eaf8b 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -24,6 +24,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 	struct nft_cmd *cmd;
 
 	cmd = xtables_calloc(1, sizeof(struct nft_cmd));
+	cmd->error.lineno = h->error.lineno;
 	cmd->command = command;
 	cmd->table = xtables_strdup(table);
 	if (chain)
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index b5a99ef74ad9c..c0f8463657cdd 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -24,6 +24,9 @@ struct nft_cmd {
 	struct xt_counters		counters;
 	const char			*rename;
 	int				counters_save;
+	struct {
+		unsigned int		lineno;
+	} error;
 };
 
 struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
diff --git a/iptables/nft.c b/iptables/nft.c
index ee003511ab7f3..fd55250697916 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3360,6 +3360,8 @@ static int nft_prepare(struct nft_handle *h)
 	nft_cache_build(h);
 
 	list_for_each_entry_safe(cmd, next, &h->cmd_list, head) {
+		h->error.lineno = cmd->error.lineno;
+
 		switch (cmd->command) {
 		case NFT_COMPAT_TABLE_FLUSH:
 			ret = nft_table_flush(h, cmd->table);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 052a80c2b9586..c9d4ffbf8405d 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -250,7 +250,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		return;
 	if (!ret) {
 		fprintf(stderr, "%s: line %u failed",
-				xt_params->program_name, line);
+				xt_params->program_name, h->error.lineno);
 		if (errno)
 			fprintf(stderr,	": %s.", nft_strerror(errno));
 		fprintf(stderr, "\n");
-- 
2.34.1

