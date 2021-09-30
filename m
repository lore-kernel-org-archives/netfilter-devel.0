Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883D9C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA5D619EC
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351774AbhI3OHh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351633AbhI3OHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:07:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BEFC06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:05:54 -0700 (PDT)
Received: from localhost ([::1]:51750 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwh6-0007T8-Gz; Thu, 30 Sep 2021 16:05:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 14/17] xtables: arptables accepts but ignores '-m'
Date:   Thu, 30 Sep 2021 16:04:16 +0200
Message-Id: <20210930140419.6170-15-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this patch, arptables-nft would complain about an unknown
option.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-arp.c | 2 +-
 iptables/xtables.c     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index cca19438a877e..212b5f1347206 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -89,7 +89,7 @@ static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION,
-	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
+	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:m:nv",
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 5b5c875dc3a6c..b8c4e2737a96a 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -575,6 +575,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'm':
+			if (h->family == NFPROTO_ARP)
+				break;
 			command_match(cs, invert);
 			break;
 
-- 
2.33.0

