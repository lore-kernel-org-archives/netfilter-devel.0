Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94974C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 638D7216C8
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eCbsYqI/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfIBXGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:55 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43562 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfIBXGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BTIl0EoyRHNEFRA/OJw8NZfQ5PLrcGUmZ82iGsR9Kjc=; b=eCbsYqI/FGCYlRn31G2+CtiCYO
        xcidIKo5rgHJrW045VjH+K2haH3Z8fZnsnXfIzlKiCfFFbo2NhbGucridsAhi3LpIA3EQEQSsd8jN
        /JWsWLE4el/UgXiTLCBwdWZs4FvH/SBoQlG5tAAg8N4dXSlyX54mfkXuEKVwxo/mRKgwIF+DbJnCg
        2KYKPMu7lf3+8aP4KFIJT5i9qszDFLxoY4PYkp1XzgrCiKrhRNlhx5EX6yP4z+Gwzra6Erfmoo9Of
        yUYy6UH1XYUfo7H6GmMafbQGDVXr7ftdaFucwNkJBsutRhDnCgfDSYZdayXs2+Zt+KQsrjv4/h177
        VS+FzzTg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPO-0004la-KF; Tue, 03 Sep 2019 00:06:50 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH nf-next v2 01/30] netfilter: add include guard to nf_conntrack_h323_types.h
Date:   Tue,  3 Sep 2019 00:06:21 +0100
Message-Id: <20190902230650.14621-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
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
2.23.0.rc1

