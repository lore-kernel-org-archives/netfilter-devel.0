Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB72C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391435AbiEFLpP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391440AbiEFLpO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4D060D88
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RG508lkmeHHxGkNHJ1E9IrGqI3O4MI51Y3+H9cFSNHo=; b=YVAF7vzuyYAnBg4QTNe7Xx+TEV
        iYvZTXOeWpkRq1XtDsycUVfxY0a5mQBMg4RJer/8WXzggRJTpTMpb651tQjvlmJPK+thOs94CPcoV
        h5/8O4zLXLNdz9EwCFwqwR2nFi+FwOnKkMHK7bZ5Rn1vdNa7/mOLr3yIKTcY5rtGBrpZdDq/zezqc
        zmjFVy9FTJoYkRkuTAcKKqwC8As1FR7SnbHVoVw8GsC/PbelhfA+M1ICD5gOCV63zLSME14iAqQ/b
        NMUgxXJJBr3lYPypaN7kibUZc+NgqyNfp9RxLw8OBiOP/L54zMLEFwiI8WS++PT4KiZQQoR30gg8H
        6chthGzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwKv-0005qH-HI; Fri, 06 May 2022 13:41:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/5] xshared: Move arp_opcodes into shared space
Date:   Fri,  6 May 2022 13:41:01 +0200
Message-Id: <20220506114104.7344-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506114104.7344-1-phil@nwl.cc>
References: <20220506114104.7344-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It will be referenced by xtables_printhelp() if printing for arptables
and therefore must be present in legacy as well even if unused.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_mangle.c |  1 -
 iptables/nft-arp.c          | 22 ++++------------------
 iptables/nft-arp.h          |  7 -------
 iptables/xshared.c          | 14 ++++++++++++++
 iptables/xshared.h          |  3 +++
 iptables/xtables-arp.c      |  1 -
 iptables/xtables-monitor.c  |  1 -
 iptables/xtables.c          |  1 -
 8 files changed, 21 insertions(+), 29 deletions(-)
 delete mode 100644 iptables/nft-arp.h

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index a2378a8ba6ccb..765edf34781f3 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -13,7 +13,6 @@
 #include <xtables.h>
 #include <linux/netfilter_arp/arpt_mangle.h>
 #include "iptables/nft.h"
-#include "iptables/nft-arp.h"
 
 static void arpmangle_print_help(void)
 {
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 65bd965eb69f6..e6e4d2d81e528 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -25,22 +25,8 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include "nft-shared.h"
-#include "nft-arp.h"
 #include "nft.h"
-
-/* a few names */
-char *arp_opcodes[] =
-{
-	"Request",
-	"Reply",
-	"Request_Reverse",
-	"Reply_Reverse",
-	"DRARP_Request",
-	"DRARP_Reply",
-	"DRARP_Error",
-	"InARP_Request",
-	"ARP_NAK",
-};
+#include "xshared.h"
 
 static bool need_devaddr(struct arpt_devaddr_info *info)
 {
@@ -429,7 +415,7 @@ after_devdst:
 
 		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPOP
 			? "! " : "");
-		if (tmp <= NUMOPCODES && !(format & FMT_NUMERIC))
+		if (tmp <= ARP_NUMOPCODES && !(format & FMT_NUMERIC))
 			printf("--opcode %s", arp_opcodes[tmp-1]);
 		else
 			printf("--opcode %d", tmp);
@@ -660,11 +646,11 @@ static void nft_arp_post_parse(int command,
 				   &cs->arp.arp.arpop_mask, 10)) {
 			int i;
 
-			for (i = 0; i < NUMOPCODES; i++)
+			for (i = 0; i < ARP_NUMOPCODES; i++)
 				if (!strcasecmp(arp_opcodes[i],
 						args->arp_opcode))
 					break;
-			if (i == NUMOPCODES)
+			if (i == ARP_NUMOPCODES)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Problem with specified opcode");
 			cs->arp.arp.arpop = htons(i+1);
diff --git a/iptables/nft-arp.h b/iptables/nft-arp.h
deleted file mode 100644
index 3411fc3d7c7b3..0000000000000
--- a/iptables/nft-arp.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _NFT_ARP_H_
-#define _NFT_ARP_H_
-
-extern char *arp_opcodes[];
-#define NUMOPCODES 9
-
-#endif
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 00828c8ae87d9..674b49cb72798 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -20,6 +20,20 @@
 #include <signal.h>
 #include "xshared.h"
 
+/* a few arp opcode names */
+char *arp_opcodes[] =
+{
+	"Request",
+	"Reply",
+	"Request_Reverse",
+	"Reply_Reverse",
+	"DRARP_Request",
+	"DRARP_Reply",
+	"DRARP_Error",
+	"InARP_Request",
+	"ARP_NAK",
+};
+
 /*
  * Print out any special helps. A user might like to be able to add a --help
  * to the commandline, and see expected results. So we call help for all
diff --git a/iptables/xshared.h b/iptables/xshared.h
index ca761ee7246ad..2fdebc326a6d6 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -330,4 +330,7 @@ void ipv4_post_parse(int command, struct iptables_command_state *cs,
 void ipv6_post_parse(int command, struct iptables_command_state *cs,
 		     struct xtables_args *args);
 
+extern char *arp_opcodes[];
+#define ARP_NUMOPCODES 9
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 68514297f381f..f1a128fc55647 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -37,7 +37,6 @@
 #include "xshared.h"
 
 #include "nft.h"
-#include "nft-arp.h"
 
 static struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 8a04f4d1490c1..905bb7fed6309 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -37,7 +37,6 @@
 #include "iptables.h" /* for xtables_globals */
 #include "xtables-multi.h"
 #include "nft.h"
-#include "nft-arp.h"
 
 struct cb_arg {
 	uint32_t nfproto;
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c44b39acdcd97..c65c3fce5cfbe 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -42,7 +42,6 @@
 #include <fcntl.h>
 #include "xshared.h"
 #include "nft-shared.h"
-#include "nft-arp.h"
 #include "nft.h"
 
 static struct option original_opts[] = {
-- 
2.34.1

