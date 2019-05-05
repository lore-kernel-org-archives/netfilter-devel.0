Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53ACC004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A99A206DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfEEXdY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 19:33:24 -0400
Received: from mail.us.es ([193.147.175.20]:34102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbfEEXdW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 19:33:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E355B11ED86
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D46E7DA707
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA234DA706; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2204DA701;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9F7754265A31;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/12] netfilter: slightly optimize nf_inet_addr_mask
Date:   Mon,  6 May 2019 01:33:05 +0200
Message-Id: <20190505233305.13650-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

using 64bit computation to slightly optimize nf_inet_addr_mask

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a7252f3baeb0..996bc247ef6e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -41,10 +41,19 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 				     union nf_inet_addr *result,
 				     const union nf_inet_addr *mask)
 {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	const unsigned long *ua = (const unsigned long *)a1;
+	unsigned long *ur = (unsigned long *)result;
+	const unsigned long *um = (const unsigned long *)mask;
+
+	ur[0] = ua[0] & um[0];
+	ur[1] = ua[1] & um[1];
+#else
 	result->all[0] = a1->all[0] & mask->all[0];
 	result->all[1] = a1->all[1] & mask->all[1];
 	result->all[2] = a1->all[2] & mask->all[2];
 	result->all[3] = a1->all[3] & mask->all[3];
+#endif
 }
 
 int netfilter_init(void);
-- 
2.11.0

