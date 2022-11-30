Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E771C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiK3TOC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiK3TOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28525803C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2vhSk1GNY4CVVA2Ll9QvL8F0T6hpfweB8UpiTk5LHHA=; b=Uf36i+AdWy8TBNCi9wud6/ijHh
        g7ScWUNjx6CFZpDHH3zOgNpy1qZvsgXz3ZXL1+HSn/BY2cyvg9kUYCcdJTBU6Uu2Ksxsr7Cr3rg8B
        duGczBA2JY0SB9ZjBEZfuYAWwi5pDyIioa23sbTat6/TZdi60WFBmquBtTgmnfN9WPGcGYsHBH/il
        A566FkHFnWvCAjl4974G74aj5OWPE9B0sOknk/+c+QSS/LRfygluKH3dpqqeJak9SxFaCEYXnKOzu
        thxiAgJk4uolIlH8c6X7AILhNmRk62/oFU51gA+avCX2jh+YE9/o3dvnhfrLNDRov2D10rtnffNAA
        gunh6GrA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SWs-00019Y-A5
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:13:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 7/9] iptables: Properly clear iptables_command_state object
Date:   Wed, 30 Nov 2022 20:13:43 +0100
Message-Id: <20221130191345.14543-8-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding a rule with a target which defines a udata_size, valgrind
prints:

8 bytes in 1 blocks are definitely lost in loss record 1 of 1
   at 0x484659F: calloc (vg_replace_malloc.c:1328)
   by 0x486B128: xtables_calloc (xtables.c:434)
   by 0x1128B4: xs_init_target (xshared.c:238)
   by 0x113CD3: command_jump (xshared.c:877)
   by 0x114969: do_parse (xshared.c:1644)
   by 0x10EEB9: do_command4 (iptables.c:691)
   by 0x10E45B: iptables_main (iptables-standalone.c:59)
   by 0x49A2349: (below main) (in /lib64/libc.so.6)

It is not sufficient to free cs.target->t, so call
xtables_clear_iptables_command_state() which takes care of all the
details.

Fixes: 2dba676b68ef8 ("extensions: support for per-extension instance "global" variable space")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 3 +--
 iptables/iptables.c  | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 1d2326570a71d..345af4519bfe7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -778,7 +778,6 @@ int do_command6(int argc, char *argv[], char **table,
 			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&cs.fw6, cs.matches, cs.target->t);
-			free(cs.target->t);
 		}
 	}
 
@@ -880,7 +879,7 @@ int do_command6(int argc, char *argv[], char **table,
 	if (verbose > 1)
 		dump_entries6(*handle);
 
-	xtables_rule_matches_free(&cs.matches);
+	xtables_clear_iptables_command_state(&cs);
 
 	if (e != NULL) {
 		free(e);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index d246198f49d27..6f7b34762ea40 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -773,7 +773,6 @@ int do_command4(int argc, char *argv[], char **table,
 			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&cs.fw, cs.matches, cs.target->t);
-			free(cs.target->t);
 		}
 	}
 
@@ -875,7 +874,7 @@ int do_command4(int argc, char *argv[], char **table,
 	if (verbose > 1)
 		dump_entries(*handle);
 
-	xtables_rule_matches_free(&cs.matches);
+	xtables_clear_iptables_command_state(&cs);
 
 	if (e != NULL) {
 		free(e);
-- 
2.38.0

