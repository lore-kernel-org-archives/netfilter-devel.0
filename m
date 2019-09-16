Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8BCC4CEC4
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 00:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79E142053B
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 00:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfIPAFg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Sep 2019 20:05:36 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:46714 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfIPAFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Sep 2019 20:05:36 -0400
Received: from [2a02:a31c:853f:a300::4] (helo=valinor.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1i9eWB-0003hj-CY; Mon, 16 Sep 2019 02:05:25 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.92.2)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1i9eWB-000MEv-3e; Mon, 16 Sep 2019 02:05:23 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Mon, 16 Sep 2019 02:05:16 +0200
Message-Id: <20190916000517.45028-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:a31c:853f:a300::4
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH] netfilter: bridge: drop a broken include
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This caused a build failure if CONFIG_NF_CONNTRACK_BRIDGE is set but
CONFIG_NF_TABLES=n -- and appears to be unused anyway.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 4f5444d2a526..844ef5a53f87 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -18,7 +18,6 @@
 
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
-#include <net/netfilter/nf_tables.h>
 
 #include "../br_private.h"
 
-- 
2.23.0

