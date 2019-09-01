Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D85C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D18922CE9
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="oYvIhhNv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfIAUva (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:51:30 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53366 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfIAUva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 16:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BTIl0EoyRHNEFRA/OJw8NZfQ5PLrcGUmZ82iGsR9Kjc=; b=oYvIhhNvU/7Qt2pMtHnRvv4ujV
        jFMiI4N2tSkfF+22LPjybvQunOjOiYeFTK0UkCR3c4H4pbm8nH3nYEJ5nMv9pCtmjghpSVaVmNMXN
        Txczedrq+l/2VUmiKAx1Enpk+q6M5gOe3+Z1FYPWQAycyZkrYL3y6V5pdseOtG9t0D7HLkIIYtABx
        1bCTzP7MDvKzN043HdDMLIyw9c3VLZIZrn309SyoVy8YnYFJaTqqGCGP2Slz1bxU99emtu/PrlWC8
        j+p0jCfXcA142QW5z2BtQCS444tIAYtF5TUL0jhqendOOpxWOxfSC4rJIYggyupsqFdlgq8VC43qe
        NCfvqrkA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Woo-0002Uf-9N; Sun, 01 Sep 2019 21:51:26 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH nf-next 01/29] netfilter: add include guard to nf_conntrack_h323_types.h
Date:   Sun,  1 Sep 2019 21:50:57 +0100
Message-Id: <20190901205126.6935-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
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

