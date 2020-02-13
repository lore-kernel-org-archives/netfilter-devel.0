Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F30C2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 13:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954A924650
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 13:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgBMNEl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:04:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37944 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 08:04:41 -0500
Received: from localhost ([::1]:51034 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j2EAZ-0003d1-Vy; Thu, 13 Feb 2020 14:04:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-translate: Fix for iface++
Date:   Thu, 13 Feb 2020 14:04:36 +0100
Message-Id: <20200213130436.26755-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In legacy iptables, only the last plus sign remains special, any
previous ones are taken literally. Therefore xtables-translate must not
replace all of them with asterisk but just the last one.

Fixes: e179e87a1179e ("xtables-translate: Fix for interface name corner-cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate    | 4 ++++
 iptables/xtables-translate.c | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index c92d082abea78..0e256c3727559 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -23,6 +23,10 @@ nft insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:
 iptables-translate -A FORWARD -i '*' -o 'eth*foo'
 nft add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter
 
+# escape all asterisks but translate only the first plus character
+iptables-translate -A FORWARD -i 'eth*foo*+' -o 'eth++'
+nft add rule ip filter FORWARD iifname "eth\*foo\**" oifname "eth+*" counter
+
 # skip for always matching interface names
 iptables-translate -A FORWARD -i '+'
 nft add rule ip filter FORWARD counter
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index c4e177c0d63ba..0f95855b41aa4 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -40,9 +40,6 @@ void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 
 	for (i = 0, j = 0; i < ifaclen + 1; i++, j++) {
 		switch (ifname[i]) {
-		case '+':
-			iface[j] = '*';
-			break;
 		case '*':
 			iface[j++] = '\\';
 			/* fall through */
@@ -65,6 +62,9 @@ void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 		invert = false;
 	}
 
+	if (iface[j - 2] == '+')
+		iface[j - 2] = '*';
+
 	xt_xlate_add(xl, "%s %s\"%s\" ", nftmeta, invert ? "!= " : "", iface);
 }
 
-- 
2.24.1

