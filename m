Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0F7C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 11:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbjKGLQm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 06:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjKGLQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 06:16:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214811726
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 03:16:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r0K43-0002Fa-My; Tue, 07 Nov 2023 12:16:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables 4/4] extensions: MARK: fix arptables support
Date:   Tue,  7 Nov 2023 12:15:40 +0100
Message-ID: <20231107111544.17166-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107111544.17166-1-fw@strlen.de>
References: <20231107111544.17166-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

arptables "--set-mark" is really just "--or-mark".
This bug is also in arptables-legacy.

Fix this and add test cases.
Note that the test for "16" vs. "0x16" is intentional,
arptables parser is buggy and always uses "%x".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_MARK.c      | 2 ++
 extensions/libxt_MARK.txlate | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 100f6a38996a..d6eacfcb33f6 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -290,6 +290,7 @@ mark_tg_arp_parse(int c, char **argv, int invert, unsigned int *flags,
 			return 0;
 		}
 		info->mark = i;
+		info->mask = 0xffffffffU;
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 				"MARK: Can't specify --set-mark twice");
@@ -430,6 +431,7 @@ static struct xtables_target mark_tg_reg[] = {
 		.save          = mark_tg_arp_save,
 		.parse         = mark_tg_arp_parse,
 		.extra_opts    = mark_tg_arp_opts,
+		.xlate	       = mark_tg_xlate,
 	},
 };
 
diff --git a/extensions/libxt_MARK.txlate b/extensions/libxt_MARK.txlate
index 36ee7a3b8f18..cef8239a599f 100644
--- a/extensions/libxt_MARK.txlate
+++ b/extensions/libxt_MARK.txlate
@@ -24,3 +24,12 @@ nft 'add rule ip mangle PREROUTING counter meta mark set mark and 0x64'
 
 iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
 nft 'add rule ip mangle PREROUTING counter meta mark set mark or 0x64'
+
+arptables-translate -A OUTPUT -j MARK --set-mark 0x4
+nft 'add rule arp filter OUTPUT arp htype 1 arp hlen 6 arp plen 4 counter meta mark set 0x4'
+
+arptables-translate -I OUTPUT -o odev -j MARK --and-mark 0x8
+nft 'insert rule arp filter OUTPUT oifname "odev" arp htype 1 arp hlen 6 arp plen 4 counter meta mark set mark and 0x8'
+
+arptables-translate -t mangle -A OUTPUT -o odev -j MARK --or-mark 16
+nft 'add rule arp mangle OUTPUT oifname "odev" arp htype 1 arp hlen 6 arp plen 4 counter meta mark set mark or 0x16'
-- 
2.41.0

