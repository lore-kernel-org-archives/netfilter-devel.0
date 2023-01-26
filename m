Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70143C05027
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbjAZMZC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbjAZMZB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:25:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9710062274
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sHzEBmUIUQZmgPEMkgYbrWn1Kprh1idG7BB+g0oag08=; b=bkrjCztle4qwpVSeKcz6vNQ84G
        D11ePNdw6vPw6zGC/Ir7u7OTP2px76GZHfs/X0KQiBfb3VCptxelwoFd825LxUWSGTHfuHQDqd3om
        AjLDUT9tBGlqOKTZ4M4fWFtAMOLMMhozrZ78BKq/lU4mf5BCsHj9JQQJpjjEb4gFCY6yPjaN5+KSj
        LKGXjxjzSywEZJIDmUjOjCvRl//lQZEucGHpKVBVrh7M9i2w7f9wNnjWq8WbHMk21xhTxa7j3OkoW
        jBkjn/xvi/WQTqOgUvhZP8e4f/GCAAuvn0B3xjBZWzja6BtWwYcvU5/icIZ58I+newGMGG6cnPq2o
        IBKSR+hw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1J7-00058W-0Q
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/7] ebtables-translate: Drop exec_style
Date:   Thu, 26 Jan 2023 13:24:02 +0100
Message-Id: <20230126122406.23288-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apply the changes from commit 816bd1fdecb63 ("ebtables-nft: remove
exec_style") to ebtables-translate, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 0c35272051752..4db10ae6706a1 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -24,9 +24,6 @@
 /*
  * From include/ebtables_u.h
  */
-#define EXEC_STYLE_PRG    0
-#define EXEC_STYLE_DAEMON 1
-
 #define ebt_check_option2(flags, mask) EBT_CHECK_OPTION(flags, mask)
 
 extern int ebt_invert;
@@ -172,7 +169,6 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
 	return ret;
 }
 
-/* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
 static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char **table)
 {
 	char *buffer;
@@ -187,7 +183,6 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 	};
 	char command = 'h';
 	const char *chain = NULL;
-	int exec_style = EXEC_STYLE_PRG;
 	int selected_chain = -1;
 	struct xtables_rule_match *xtrm_i;
 	struct ebt_match *match;
@@ -292,9 +287,6 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Multiple commands are not allowed");
-			if (exec_style == EXEC_STYLE_DAEMON)
-				xtables_error(PARAMETER_PROBLEM,
-					      "%s %s", prog_name, prog_vers);
 			printf("%s %s\n", prog_name, prog_vers);
 			exit(0);
 		case 'h':
-- 
2.38.0

