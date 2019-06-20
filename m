Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2D2C48BE2
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 08:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0CEE2084A
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 08:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfFTIBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:01:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9242 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfFTIBg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 04:01:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2F12641B9F;
        Thu, 20 Jun 2019 16:01:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] meta: add brpvid support
Date:   Thu, 20 Jun 2019 16:01:28 +0800
Message-Id: <1561017689-27603-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0tCQkJDQkNCSktOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBQ6EDo6LTgrEBcNTjwOKDpN
        EjMKC0NVSlVKTk1KS0pMTUJKSUJJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhNTUk3Bg++
X-HM-Tid: 0a6b73e7ac4b2086kuqy2f12641b9f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This brpvid meta can be used to match the pvid of the brport.

nft add rule bridge firewall zones meta brpvid 10 accept

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 doc/primary-expression.txt          | 11 ++++++++---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          |  3 +++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 6eb9583..e33ea26 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -2,7 +2,7 @@ META EXPRESSIONS
 ~~~~~~~~~~~~~~~~
 [verse]
 *meta* {*length* | *nfproto* | *l4proto* | *protocol* | *priority*}
-[*meta*] {*mark* | *iif* | *iifname* | *iiftype* | *oif* | *oifname* | *oiftype* | *skuid* | *skgid* | *nftrace* | *rtclassid* | *ibrname* | *obrname* | *pkttype* | *cpu* | *iifgroup* | *oifgroup* | *cgroup* | *random* | *ipsec* | *iifkind* | *oifkind*}
+[*meta*] {*mark* | *iif* | *iifname* | *iiftype* | *oif* | *oifname* | *oiftype* | *skuid* | *skgid* | *nftrace* | *rtclassid* | *ibrname* | *obrname* | *pkttype* | *cpu* | *iifgroup* | *oifgroup* | *cgroup* | *random* | *ipsec* | *iifkind* | *oifkind* | *brpvid*}
 
 A meta expression refers to meta data associated with a packet.
 
@@ -113,9 +113,12 @@ integer (32 bit)
 boolean|
 boolean (1 bit)
 |iifkind|
-Input interface kind |
+Input interface kind|
 |oifkind|
-Output interface kind
+Output interface kind|
+|brpvid|
+bridge port pvid|
+integer (16 bit)
 |====================
 
 .Meta expression specific types
@@ -141,6 +144,8 @@ Packet type: *host* (addressed to local host), *broadcast* (to all),
 *multicast* (to group), *other* (addressed to another host).
 |ifkind|
 Interface kind (16 byte string). Does not have to exist.
+|brpvid|
+Bridge port pvid (16 bit number).
 |=============================
 
 .Using meta expressions
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 7bdb234..0715b6a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_BRI_PVID: packet input bridge port pvid
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -823,6 +824,7 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_BRI_PVID,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 1e8964e..cef7b02 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -450,6 +450,9 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_PVID]	= META_TEMPLATE("brpvid",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
-- 
1.8.3.1

