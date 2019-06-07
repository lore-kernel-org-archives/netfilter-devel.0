Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6488C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 14:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C32A920657
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 14:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfFGOhi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 10:37:38 -0400
Received: from mail.us.es ([193.147.175.20]:49336 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbfFGOhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 10:37:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 624B2BAE8E
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 16:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54E20DA702
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 16:37:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4A7ABDA705; Fri,  7 Jun 2019 16:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48560DA702;
        Fri,  7 Jun 2019 16:37:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 16:37:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2764A4265A2F;
        Fri,  7 Jun 2019 16:37:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     l.pawelczyk@samsung.com
Subject: [PATCH nf-next] netfilter: xt_owner: bail out with EINVAL in case of unsupported flags
Date:   Fri,  7 Jun 2019 16:37:30 +0200
Message-Id: <20190607143730.18661-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reject flags that are not supported with EINVAL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
A bit late for ea6cc2fd8a2b ("netfilter: xt_owner: Add supplementary
groups option"). Old kernel will ignore this new flag, so better bail
out for future flags. We can also request a backport to be send to
-stable kernels to deal with this new supplementary group support.
Otherwise, we have to go for a new revision.

 include/uapi/linux/netfilter/xt_owner.h | 5 +++++
 net/netfilter/xt_owner.c                | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index 9e98c09eda32..5108df4d0313 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -11,6 +11,11 @@ enum {
 	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
+#define XT_OWNER_MASK	(XT_OWNER_UID | 	\
+			 XT_OWNER_GID | 	\
+			 XT_OWNER_SOCKET |	\
+			 XT_OWNER_SUPPL_GROUPS)
+
 struct xt_owner_match_info {
 	__u32 uid_min, uid_max;
 	__u32 gid_min, gid_max;
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index a8784502aca6..ee597fdc5db7 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -25,6 +25,9 @@ static int owner_check(const struct xt_mtchk_param *par)
 	struct xt_owner_match_info *info = par->matchinfo;
 	struct net *net = par->net;
 
+	if (info->match & ~XT_OWNER_MASK)
+		return -EINVAL;
+
 	/* Only allow the common case where the userns of the writer
 	 * matches the userns of the network namespace.
 	 */
-- 
2.11.0

