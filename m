Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6E8C282DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F0D2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfDORBd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:01:33 -0400
Received: from mail.us.es ([193.147.175.20]:50470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbfDORAl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E3FF1C4433
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 296B4DA718
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 277BADA715; Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21351DA707;
        Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E409A4265A31;
        Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/22] netfilter: optimize nf_inet_addr_cmp
Date:   Mon, 15 Apr 2019 19:00:12 +0200
Message-Id: <20190415170028.3470-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

optimize nf_inet_addr_cmp by 64bit xor computation
similar to ipv6_addr_equal()

Signed-off-by: Yuan Linsi <yuanlinsi01@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 72cb19c3db6a..4e0145ea033e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -24,10 +24,17 @@ static inline int NF_DROP_GETERR(int verdict)
 static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
 				   const union nf_inet_addr *a2)
 {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	const unsigned long *ul1 = (const unsigned long *)a1;
+	const unsigned long *ul2 = (const unsigned long *)a2;
+
+	return ((ul1[0] ^ ul2[0]) | (ul1[1] ^ ul2[1])) == 0UL;
+#else
 	return a1->all[0] == a2->all[0] &&
 	       a1->all[1] == a2->all[1] &&
 	       a1->all[2] == a2->all[2] &&
 	       a1->all[3] == a2->all[3];
+#endif
 }
 
 static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
-- 
2.11.0

