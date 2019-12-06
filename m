Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442E6C43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2184021823
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfLFLrc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 06:47:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34900 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfLFLrc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 06:47:32 -0500
Received: from localhost ([::1]:47990 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1idC55-0002kw-62; Fri, 06 Dec 2019 12:47:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/6] xtables-translate: Guard strcpy() call in xlate_ifname()
Date:   Fri,  6 Dec 2019 12:47:10 +0100
Message-Id: <20191206114711.6015-6-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206114711.6015-1-phil@nwl.cc>
References: <20191206114711.6015-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function potentially fed overlong strings to strcpy(). Given that
everything needed to avoid this is there, reorder code a bit to prevent
those inputs, too.

Fixes: 0ddd663e9c167 ("iptables-translate: add in/out ifname wildcard match translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index a42c60a3b64c6..77a186b905d73 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -32,14 +32,13 @@
 void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 		  bool invert)
 {
+	int ifaclen = strlen(ifname);
 	char iface[IFNAMSIZ];
-	int ifaclen;
 
-	if (ifname[0] == '\0')
+	if (ifaclen < 1 || ifaclen >= IFNAMSIZ)
 		return;
 
 	strcpy(iface, ifname);
-	ifaclen = strlen(iface);
 	if (iface[ifaclen - 1] == '+')
 		iface[ifaclen - 1] = '*';
 
-- 
2.24.0

