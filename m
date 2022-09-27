Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3273AC07E9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiI0WP0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0WPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C19D85596
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EDJ7XW7kDAOo3E5FnuXyw5D+KBkvMqrJ/YG5eIGP+8E=; b=nyJMH/VHc7H21IqrdyF3mzfIiW
        hc1pMxBuXNruwxK3R5PNmEQcFBaAB3ljtpCM0Dt+6AIEJiIGS2quWXq4xLDwPleRe9rAUZKZULyzp
        bfvF1TEhsGkbSe42VF+LtYiM18AXFxWZv9DKFwxV2tvwh71Os1TAxclj4ZFFKvkQUOwqjthMN9Rbk
        G0SVhRQo6KmwZ7Wi5zU8uJRr/d6TACCcylPTRZqnu3hdBWCuV5ukITfiJwOauAygeYePoenpMQlkC
        PmNJgU0Agnl1BrkwpWwal4R8zxqtU3OZORNDGTmEoWhHrd6D04vLX6s963nuhQfml7baSNmh1ha8K
        U6YxrwXg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIrJ-00004z-3D
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/5] ebtables: Eliminate OPT_TABLE
Date:   Wed, 28 Sep 2022 00:15:09 +0200
Message-Id: <20220927221512.7400-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The flag is used for duplicate option checking only and there is a
boolean indicating the same already. So copy the error message from
EBT_CHECK_OPTION() in situ and just take care not to disturb restore
mode handling.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3887ea1a39f27..9aab35977396f 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -158,7 +158,6 @@ int ebt_get_current_chain(const char *chain)
 #define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
 
 #define OPT_COMMAND	0x01
-#define OPT_TABLE	0x02
 #define OPT_IN		0x04
 #define OPT_OUT		0x08
 #define OPT_JUMP	0x10
@@ -894,11 +893,13 @@ print_zero:
 			}
 			break;
 		case 't': /* Table */
-			ebt_check_option2(&flags, OPT_TABLE);
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option cannot be used in %s.\n",
 					      xt_params->program_name);
+			else if (table_set)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Multiple use of same option not allowed");
 			if (!nft_table_builtin_find(h, optarg))
 				xtables_error(VERSION_PROBLEM,
 					      "table '%s' does not exist",
-- 
2.34.1

