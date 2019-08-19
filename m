Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B70C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA456214DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfHSS7h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:59:37 -0400
Received: from correo.us.es ([193.147.175.20]:37886 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfHSS7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DBFDF2630
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:50:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30492B8001
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:50:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24BF4B7FF9; Mon, 19 Aug 2019 20:50:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0D8CFB362;
        Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 752EF4265A32;
        Mon, 19 Aug 2019 20:50:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/5] netfilter: add include guard to nf_conntrack_h323_types.h
Date:   Mon, 19 Aug 2019 20:49:11 +0200
Message-Id: <20190819184911.15263-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_h323_types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/netfilter/nf_conntrack_h323_types.h b/include/linux/netfilter/nf_conntrack_h323_types.h
index 7a6871ac8784..74c6f9241944 100644
--- a/include/linux/netfilter/nf_conntrack_h323_types.h
+++ b/include/linux/netfilter/nf_conntrack_h323_types.h
@@ -4,6 +4,9 @@
  * Copyright (c) 2006 Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  */
 
+#ifndef _NF_CONNTRACK_H323_TYPES_H
+#define _NF_CONNTRACK_H323_TYPES_H
+
 typedef struct TransportAddress_ipAddress {	/* SEQUENCE */
 	int options;		/* No use */
 	unsigned int ip;
@@ -931,3 +934,5 @@ typedef struct RasMessage {	/* CHOICE */
 		InfoRequestResponse infoRequestResponse;
 	};
 } RasMessage;
+
+#endif /* _NF_CONNTRACK_H323_TYPES_H */
-- 
2.11.0


