Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1630CC3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 15:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65262133F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 15:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfHPPHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:07:42 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:59704 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfHPPHm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 11:07:42 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 11:07:40 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 373FB100137;
        Fri, 16 Aug 2019 17:02:25 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 0D4132FE;
        Fri, 16 Aug 2019 17:02:25 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.21.30)
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id 256602DF;
        Fri, 16 Aug 2019 17:02:23 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, pablo@netfilter.org
Subject: [PATCH v2] netfilter: nfacct: Fix alignment mismatch in xt_nfacct_match_info
Date:   Fri, 16 Aug 2019 17:02:22 +0200
Message-ID: <7899070.tJGA48rBTd@rocinante.m.i2n>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running a 64-bit kernel with a 32-bit iptables binary, the size of
the xt_nfacct_match_info struct diverges.

    kernel: sizeof(struct xt_nfacct_match_info) : 40
    iptables: sizeof(struct xt_nfacct_match_info)) : 36

Trying to append nfacct related rules results in an unhelpful message.
Although it is suggested to look for more information in dmesg, nothing
can be found there.

    # iptables -A <chain> -m nfacct --nfacct-name <acct-object>
    iptables: Invalid argument. Run `dmesg' for more information.

This patch fixes the memory misalignment by enforcing 8-byte alignment
within the struct's first revision. This solution is often used in many
other uapi netfilter headers.

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
---
Changes in v2:
    - Keep ABI by creating a v1 of the match struct.

 include/uapi/linux/netfilter/xt_nfacct.h |  5 ++++
 net/netfilter/xt_nfacct.c                | 36 ++++++++++++++++--------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
index 5c8a4d760ee3..b5123ab8d54a 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -11,4 +11,9 @@ struct xt_nfacct_match_info {
 	struct nf_acct	*nfacct;
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct __attribute__((aligned(8)));
+};
+
 #endif /* _XT_NFACCT_MATCH_H */
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 6b56f4170860..3241fee9f2a1 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -57,25 +57,39 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 	nfnl_acct_put(info->nfacct);
 }
 
-static struct xt_match nfacct_mt_reg __read_mostly = {
-	.name       = "nfacct",
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nfacct_mt_checkentry,
-	.match      = nfacct_mt,
-	.destroy    = nfacct_mt_destroy,
-	.matchsize  = sizeof(struct xt_nfacct_match_info),
-	.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
-	.me         = THIS_MODULE,
+static struct xt_match nfacct_mt_reg[] __read_mostly = {
+	{
+		.name       = "nfacct",
+		.revision   = 0,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info),
+		.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "nfacct",
+		.revision   = 1,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info_v1),
+		.usersize   = offsetof(struct xt_nfacct_match_info_v1, nfacct),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init nfacct_mt_init(void)
 {
-	return xt_register_match(&nfacct_mt_reg);
+	return xt_register_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 static void __exit nfacct_mt_exit(void)
 {
-	xt_unregister_match(&nfacct_mt_reg);
+	xt_unregister_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 module_init(nfacct_mt_init);
-- 
2.20.1




