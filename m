Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F535C0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 06:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 798F420843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 06:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfHNG7l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 02:59:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4728 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfHNG7k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 02:59:40 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 009CA4170C;
        Wed, 14 Aug 2019 14:59:36 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] meta: add ibrpvid and ibrvproto support
Date:   Wed, 14 Aug 2019 14:59:36 +0800
Message-Id: <1565765976-25657-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPTUpCQkJDQkhKQ0NPQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzI6FRw6FDg9ITkRDBEoVhQp
        N08aFB1VSlVKTk1OTE1OQkxMS0JMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpPQk83Bg++
X-HM-Tid: 0a6c8eecc3b72086kuqy009ca4170c
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This can match the the pvid and vlan_proto of ibr

nft add rule bridge firewall zones meta ibrvproto 0x8100
nft add rule bridge firewall zones meta ibrpvid 100

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 src/meta.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/meta.c b/src/meta.c
index 5901c99..d45d757 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -442,6 +442,12 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFVPROTO] = META_TEMPLATE("ibrvproto",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
-- 
2.15.1

