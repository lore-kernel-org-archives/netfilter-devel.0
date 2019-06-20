Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A78C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 08:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 405452084A
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 08:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFTIBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:01:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9232 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfFTIBg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 04:01:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 50A5841B53;
        Thu, 20 Jun 2019 16:01:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] meta: add brvlan support
Date:   Thu, 20 Jun 2019 16:01:29 +0800
Message-Id: <1561017689-27603-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561017689-27603-1-git-send-email-wenxu@ucloud.cn>
References: <1561017689-27603-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJDS0tLS0xIT0hJQklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NlE6Fww5DDg3MhcVGTNPKD1J
        EUowCTZVSlVKTk1KS0pMTUJKT09IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhMTE03Bg++
X-HM-Tid: 0a6b73e7acd62086kuqy50a5841b53
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

meta brvlan can be used to the packet vlan tags

nft add rule bridge firewall zones counter meta brvlan set meta brpvid

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 doc/primary-expression.txt          | 7 ++++++-
 include/linux/netfilter/nf_tables.h | 2 ++
 src/meta.c                          | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index e33ea26..6bcfa5e 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -2,7 +2,7 @@ META EXPRESSIONS
 ~~~~~~~~~~~~~~~~
 [verse]
 *meta* {*length* | *nfproto* | *l4proto* | *protocol* | *priority*}
-[*meta*] {*mark* | *iif* | *iifname* | *iiftype* | *oif* | *oifname* | *oiftype* | *skuid* | *skgid* | *nftrace* | *rtclassid* | *ibrname* | *obrname* | *pkttype* | *cpu* | *iifgroup* | *oifgroup* | *cgroup* | *random* | *ipsec* | *iifkind* | *oifkind* | *brpvid*}
+[*meta*] {*mark* | *iif* | *iifname* | *iiftype* | *oif* | *oifname* | *oiftype* | *skuid* | *skgid* | *nftrace* | *rtclassid* | *ibrname* | *obrname* | *pkttype* | *cpu* | *iifgroup* | *oifgroup* | *cgroup* | *random* | *ipsec* | *iifkind* | *oifkind* | *brpvid* | *brvlan*}
 
 A meta expression refers to meta data associated with a packet.
 
@@ -119,6 +119,9 @@ Output interface kind|
 |brpvid|
 bridge port pvid|
 integer (16 bit)
+|brvlan|
+set packet vlan tag|
+integer (16 bit)
 |====================
 
 .Meta expression specific types
@@ -146,6 +149,8 @@ Packet type: *host* (addressed to local host), *broadcast* (to all),
 Interface kind (16 byte string). Does not have to exist.
 |brpvid|
 Bridge port pvid (16 bit number).
+|brpvlan|
+Set packet vlan tag (16 bit number).
 |=============================
 
 .Using meta expressions
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0715b6a..7afac26 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -794,6 +794,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_PVID: packet input bridge port pvid
+ * @NFT_META_BRI_VLAN: set vlan tag on packet
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -825,6 +826,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_BRI_VLAN,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index cef7b02..63b66dc 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -453,6 +453,9 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_BRI_PVID]	= META_TEMPLATE("brpvid",   &integer_type,
 						2 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_VLAN]	= META_TEMPLATE("brvlan",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
-- 
1.8.3.1

