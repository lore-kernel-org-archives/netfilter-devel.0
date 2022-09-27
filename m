Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4099C07E9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiI0WPl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0WPk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BB6127C86
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x6xM+fJbd5aUL6apUIn92PdRQ841SrLgcZam/sZoa6A=; b=Gbp3rDju01K6syfQ5LI7OrDylg
        v1omeK81DuDSJX+3ZBdvpivEehkH/ycswahwGzioojCquilNmdxZiGcPe0xuzWGu9H0jDNLE0ltBD
        oQHBvAa1ipzGLqjoNlzlUg/jlOcljXvB4a04xINY7XLdO+bNJcw5Ot8PncnDyabdyIFBihytixHhU
        yRaaTqUKAvW0znXXeLvtWfQ4+vTWV6kDK9n/0bV7wqQrl8FMl2wFvrqmMcoc0Vx5YO7Rk0XeMx+oj
        76obnODXoh8IZCxYBGCn4mcbYDgdE4rJ7ujSJMVih/w35ohsnraOmfDfjsuzN+u+GUl4+xiOCj+u9
        sX/OEeFg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIrY-00005i-VT
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] ebtables: Merge OPT_* flags with xshared ones
Date:   Wed, 28 Sep 2022 00:15:10 +0200
Message-Id: <20220927221512.7400-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Despite also including xshared.h, xtables-eb.c defined its own OPT_*
flags with clashing values. Albeit ugly, this wasn't a problem in
practice until commit 51d9d9e081344 ("ebtables: Support verbose mode")
which introduced use of OPT_VERBOSE from xshared - with same value as
the local OPT_PROTOCOL define.

Eliminate the clash by appending ebtables-specific flags to the xshared
enum and adjust for the different names of some others.

Fixes: 51d9d9e081344 ("ebtables: Support verbose mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h    |  5 +++++
 iptables/xtables-eb.c | 20 ++++----------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 1a019a7c04882..f43c28f519a9c 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -37,6 +37,11 @@ enum {
 	OPT_OPCODE	= 1 << 15,
 	OPT_H_TYPE	= 1 << 16,
 	OPT_P_TYPE	= 1 << 17,
+	/* below are for ebtables only */
+	OPT_LOGICALIN	= 1 << 18,
+	OPT_LOGICALOUT	= 1 << 19,
+	OPT_COMMAND	= 1 << 20,
+	OPT_ZERO	= 1 << 21,
 };
 
 enum {
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 9aab35977396f..631a3cebf11a7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -157,18 +157,6 @@ int ebt_get_current_chain(const char *chain)
 /* Checks whether a command has already been specified */
 #define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
 
-#define OPT_COMMAND	0x01
-#define OPT_IN		0x04
-#define OPT_OUT		0x08
-#define OPT_JUMP	0x10
-#define OPT_PROTOCOL	0x20
-#define OPT_SOURCE	0x40
-#define OPT_DEST	0x80
-#define OPT_ZERO	0x100
-#define OPT_LOGICALIN	0x200
-#define OPT_LOGICALOUT	0x400
-#define OPT_COUNT	0x1000 /* This value is also defined in libebtc.c */
-
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
 struct option ebt_original_options[] =
@@ -923,7 +911,7 @@ print_zero:
 				xtables_error(PARAMETER_PROBLEM,
 					      "Command and option do not match");
 			if (c == 'i') {
-				ebt_check_option2(&flags, OPT_IN);
+				ebt_check_option2(&flags, OPT_VIANAMEIN);
 				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
 						      "Use -i only in INPUT, FORWARD, PREROUTING and BROUTING chains");
@@ -943,7 +931,7 @@ print_zero:
 				ebtables_parse_interface(optarg, cs.eb.logical_in);
 				break;
 			} else if (c == 'o') {
-				ebt_check_option2(&flags, OPT_OUT);
+				ebt_check_option2(&flags, OPT_VIANAMEOUT);
 				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
 						      "Use -o only in OUTPUT, FORWARD and POSTROUTING chains");
@@ -980,7 +968,7 @@ print_zero:
 				cs.eb.bitmask |= EBT_SOURCEMAC;
 				break;
 			} else if (c == 'd') {
-				ebt_check_option2(&flags, OPT_DEST);
+				ebt_check_option2(&flags, OPT_DESTINATION);
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_IDEST;
 
@@ -991,7 +979,7 @@ print_zero:
 				cs.eb.bitmask |= EBT_DESTMAC;
 				break;
 			} else if (c == 'c') {
-				ebt_check_option2(&flags, OPT_COUNT);
+				ebt_check_option2(&flags, OPT_COUNTERS);
 				if (ebt_check_inverse2(optarg, argc, argv))
 					xtables_error(PARAMETER_PROBLEM,
 						      "Unexpected '!' after -c");
-- 
2.34.1

