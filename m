Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181C4C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBE612085A
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfGTQbN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 12:31:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40916 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfGTQbN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 12:31:13 -0400
Received: from localhost ([::1]:54006 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hosGN-0005Tz-VQ; Sat, 20 Jul 2019 18:31:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/12] ebtables: Fix error message for invalid parameters
Date:   Sat, 20 Jul 2019 18:30:15 +0200
Message-Id: <20190720163026.15410-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720163026.15410-1-phil@nwl.cc>
References: <20190720163026.15410-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With empty ruleset, ebtables-nft would report the wrong argv:

| % sudo ./install/sbin/ebtables-nft -vnL
| ebtables v1.8.3 (nf_tables): Unknown argument: './install/sbin/ebtables-nft'
| Try `ebtables -h' or 'ebtables --help' for more information.

After a (successful) call to 'ebtables-nft -L', this would even
segfault:

| % sudo ./install/sbin/ebtables-nft -vnL
| zsh: segmentation fault  sudo ./install/sbin/ebtables-nft -vnL

Fixes: acde6be32036f ("ebtables-translate: Fix segfault while parsing extension options")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 171f41b0f616e..b8d89ad974a42 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -1180,7 +1180,7 @@ print_zero:
 			if (ebt_command_default(&cs))
 				xtables_error(PARAMETER_PROBLEM,
 					      "Unknown argument: '%s'",
-					      argv[optind - 1]);
+					      argv[optind]);
 
 			if (command != 'A' && command != 'I' &&
 			    command != 'D' && command != 'C')
-- 
2.22.0

