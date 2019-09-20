Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BD3C4CECD
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 13:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 744232054F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 13:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbfITNuw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:50:52 -0400
Received: from correo.us.es ([193.147.175.20]:47654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfITNuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 09:50:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6014D508CCD
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52F65DA4D0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 489BFDA72F; Fri, 20 Sep 2019 15:50:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E518DA801
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 15:50:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [5.182.56.138])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F259E4265A5A
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools,v2 2/2] conntrackd: incorrect filtering of Address with cidr /0
Date:   Fri, 20 Sep 2019 15:50:43 +0200
Message-Id: <20190920135043.12594-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190920135043.12594-1-pablo@netfilter.org>
References: <20190920135043.12594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set an all zero mask when cidr /0 is specified.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 src/cidr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/cidr.c b/src/cidr.c
index 91025b6091ed..6ef85c74a626 100644
--- a/src/cidr.c
+++ b/src/cidr.c
@@ -24,6 +24,9 @@
 /* returns the netmask in host byte order */
 uint32_t ipv4_cidr2mask_host(uint8_t cidr)
 {
+	if (cidr == 0)
+		return 0;
+
 	return 0xFFFFFFFF << (32 - cidr);
 }
 
@@ -42,10 +45,13 @@ void ipv6_cidr2mask_host(uint8_t cidr, uint32_t *res)
 		res[i] = 0xFFFFFFFF;
 		cidr -= 32;
 	}
-	res[i] = 0xFFFFFFFF << (32 - cidr);
-	for (j = i+1; j < 4; j++) {
+	if (cidr == 0)
+		res[i] = 0;
+	else
+		res[i] = 0xFFFFFFFF << (32 - cidr);
+
+	for (j = i + 1; j < 4; j++)
 		res[j] = 0;
-	}
 }
 
 void ipv6_cidr2mask_net(uint8_t cidr, uint32_t *res)
-- 
2.11.0

