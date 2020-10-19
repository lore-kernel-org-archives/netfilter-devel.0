Return-Path: <SRS0=0udB=D2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE63C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 03:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBBD82224D
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 03:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VAYx4xzB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgJSDE2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 23:04:28 -0400
Received: from mail-m974.mail.163.com ([123.126.97.4]:47242 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729978AbgJSDE2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 23:04:28 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Oct 2020 23:04:27 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Ykvhb
        B0FduTIFU2H88Qvlxq6Xoq8/R3Ed6TaCDS62HM=; b=VAYx4xzB58ybEXeAQE37q
        qNqWECc+EtUfA+L98epvmxcHY1qUAMpKsOWn4gApqw0R7GTfclap0XdbQtx+NI2K
        RcDSFytI7AL99B425mCjCbEOHVZiXgZDVgqTWd1UZKDdXjtMRa2PXf6EMeYtzVEn
        FISIBv1A9UNPPtJ6FFKNNM=
Received: from yangyi0100.home.langchao.com (unknown [111.207.123.58])
        by smtp4 (Coremail) with SMTP id HNxpCgDH1y82Ao1fRfVXUw--.131S2;
        Mon, 19 Oct 2020 11:04:25 +0800 (CST)
From:   yang_y_yi@163.com
To:     netfilter-devel@vger.kernel.org
Cc:     yangyi01@inspur.com, yang_y_yi@163.com
Subject: [PATCH] conntrack: fix zone sync issue
Date:   Mon, 19 Oct 2020 11:04:22 +0800
Message-Id: <20201019030422.396340-1-yang_y_yi@163.com>
X-Mailer: git-send-email 2.19.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgDH1y82Ao1fRfVXUw--.131S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7urWUXryfKrW5Cw4kCF4kZwb_yoW8Xry7p3
        Z5Ary8GFZxtry2yF48Cryvg3WYgws5Wry3Wayru3sYva17tr10yr47K348urZxW39rAr4f
        CryDKa45AF48Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR4mhwUUUUU=
X-Originating-IP: [111.207.123.58]
X-CM-SenderInfo: 51dqwsp1b1xqqrwthudrp/1tbiFgTCi144NqzrtgABs7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yi Yang <yangyi01@inspur.com>

In some use cases, zone is used to differentiate different
conntrack state tables, so zone also should be synchronized
if it is set.

Signed-off-by: Yi Yang <yangyi01@inspur.com>
---
 include/network.h | 1 +
 src/build.c       | 3 +++
 src/parse.c       | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/include/network.h b/include/network.h
index 95aad82..20def34 100644
--- a/include/network.h
+++ b/include/network.h
@@ -232,6 +232,7 @@ enum nta_attr {
 	NTA_SNAT_IPV6,		/* uint32_t * 4 */
 	NTA_DNAT_IPV6,		/* uint32_t * 4 */
 	NTA_SYNPROXY,		/* struct nft_attr_synproxy */
+	NTA_ZONE,		/* uint16_t */
 	NTA_MAX
 };
 
diff --git a/src/build.c b/src/build.c
index 99ff230..4771997 100644
--- a/src/build.c
+++ b/src/build.c
@@ -315,6 +315,9 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
 	    nfct_attr_is_set(ct, ATTR_SYNPROXY_ITS) &&
 	    nfct_attr_is_set(ct, ATTR_SYNPROXY_TSOFF))
 		ct_build_synproxy(ct, n);
+
+	if (nfct_attr_is_set(ct, ATTR_ZONE))
+	    ct_build_u16(ct, ATTR_ZONE, n, NTA_ZONE);
 }
 
 static void
diff --git a/src/parse.c b/src/parse.c
index 7e524ed..e97a721 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -205,6 +205,11 @@ static struct ct_parser h[NTA_MAX] = {
 		.parse	= ct_parse_synproxy,
 		.size	= NTA_SIZE(sizeof(struct nta_attr_synproxy)),
 	},
+	[NTA_ZONE] = {
+		.parse	= ct_parse_u16,
+		.attr	= ATTR_ZONE,
+		.size	= NTA_SIZE(sizeof(uint16_t)),
+	},
 };
 
 static void
-- 
1.8.3.1

