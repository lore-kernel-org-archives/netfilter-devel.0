Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB4DC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0558E2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RPtdGICW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfDZQC4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:02:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43332 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfDZQCy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:02:54 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190426160251euoutp02380906e33bf18509b97d70f555ee09cf~ZEarLFtSW2576625766euoutp02B;
        Fri, 26 Apr 2019 16:02:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190426160251euoutp02380906e33bf18509b97d70f555ee09cf~ZEarLFtSW2576625766euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556294571;
        bh=XjXNsN0gEyJ3YEc5svWolLhZCxBWW0olWh2Pc/T70mE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RPtdGICW9E0apBvq9omyi1+nkGvtLoVulRvw+/7XmXbTGgMCoOM8oMqJ3Tvn2/NdO
         /iqh+Z0f8cmQlbfvOPL4ptwWtgdXoA4aPxh6cCHKE2yLBRs+++tbGNNv4BgnnHplUP
         8VJTZm1F5zMOKrGoUGL7mFLjR6Ev2wr9/seQ5qTI=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190426160250eucas1p14e269c70897ab9cf8b5e2233f0525119~ZEaqYHjj92089920899eucas1p1W;
        Fri, 26 Apr 2019 16:02:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 75.30.04298.AAB23CC5; Fri, 26
        Apr 2019 17:02:50 +0100 (BST)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190426160249eucas1p235dcc7c14e1a202c6c4defef6a13e40f~ZEapjd8_Q0227402274eucas1p2I;
        Fri, 26 Apr 2019 16:02:49 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-99-5cc32baacbe3
Received: from eusync1.samsung.com ( [203.254.199.211]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 45.32.04140.9AB23CC5; Fri, 26
        Apr 2019 17:02:49 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PQK00L1GSKM9830@eusync1.samsung.com>;
        Fri, 26 Apr 2019 17:02:49 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH] netfilter: xt_owner: Add complementary groups option
Date:   Fri, 26 Apr 2019 18:02:17 +0200
Message-id: <20190426160217.4056-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWy7djP87qrtA/HGMybK2bxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAldG+/Mp7AXf+Soa3zSz
        NjB+4O5i5OSQEDCROLC8kwnEFhJYwShx9k0JhP2ZUeL+AriankmXWCHiyxglvnwuhrD/M0p0
        zakFsdkEDCS+X9jL3MXIxSEiMJ1JYk3DK0aQBLNAqMS5R+uZQWxhAVeJzzeaWEBsFgFVid5Z
        zWA1vALWEnv3P2WBWCYvcb53HTtEXFDix+R7LBBz5CUOXnnOArJAQmAFm8SOnfeZIRpcJM4+
        WAVly0hcntwNVMQBZFdLnDxTAVHfwSix8cVsRogaa4nPk7YwQwzlk5i0bTozRD2vREebEESJ
        h8TuDdNYIJ6Mleh+dp5xAqPkLCQnzUJy0gJGplWM4qmlxbnpqcWGeanlesWJucWleel6yfm5
        mxiBcX363/FPOxi/Xko6xCjAwajEw3uD/XCMEGtiWXFl7iFGCQ5mJRFeddODMUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5qxkeRAsJpCeWpGanphakFsFkmTg4pRoY93NuuSIq37P1uqqglNpT
        89x9CReY8vfyy1e//HojsSbebaKFg4Ly2eh5dSuMJkjqPDg2edU29cWyIhK7AvaVG262X2JQ
        enB56YVHsau4O7//9PObkXV350vuDyfSzVZoVN67mXboyOpN8jO/yrz9o9PDc3XHlvUzfLd+
        jdh5MTX07Ef9x+xbspRYijMSDbWYi4oTAbGmYXjnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xy7ortQ/HGMxbKGfxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAldG+/Mp7AXf+Soa3zSz
        NjB+4O5i5OSQEDCR6Jl0ibWLkYtDSGAJo0TPqntMEE4jk0TvhG+MIFVsAgYS3y/sZQaxRQSm
        M0n8mSUMYjMLhEpcmzEdLC4s4Crx+UYTC4jNIqAq0TurGayXV8BaYu/+pywQ2+QlzveuY4eI
        C0r8mHyPBWKOvMTBK89ZJjDyzEKSmoUktYCRaRWjSGppcW56brGRXnFibnFpXrpecn7uJkZg
        aG479nPLDsaud8GHGAU4GJV4eC8wHI4RYk0sK67MPcQowcGsJMKrbnowRog3JbGyKrUoP76o
        NCe1+BCjNAeLkjhvhwBQSiA9sSQ1OzW1ILUIJsvEwSnVwHiUd91UZbkDhxzt2OLqS9nSX/Fe
        VGrqPN+wnpEnOvdErVePvPe91b8k/wY++rl+f5qsrcdr0xt3LV9fM3bS5v3sx95zPlZ4fr5s
        nM636O5SweCeecdT7myI37Dd9qiswzve/9tTezdt+8V5b9XTRV8asp5GMqQIz9l51jDLLGVn
        5nUHsx+1HEosxRmJhlrMRcWJAIyXa61JAgAA
X-CMS-MailID: 20190426160249eucas1p235dcc7c14e1a202c6c4defef6a13e40f
CMS-TYPE: 201P
X-CMS-RootMailID: 20190426160249eucas1p235dcc7c14e1a202c6c4defef6a13e40f
References: <CGME20190426160249eucas1p235dcc7c14e1a202c6c4defef6a13e40f@eucas1p2.samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The XT_COMPL_GROUPS flag causes GIDs specified with XT_OWNER_GID to
be also checked in the complementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 include/uapi/linux/netfilter/xt_owner.h |  1 +
 net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index fa3ad84957d5..67901269873d 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -8,6 +8,7 @@ enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
+	XT_COMPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784..1c581c14b2ab 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->match & XT_OWNER_GID) {
+		unsigned int i, match = false;
 		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
 		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
-		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
-		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
-		    !(info->invert & XT_OWNER_GID))
+		struct group_info *gi = filp->f_cred->group_info;
+
+		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
+		    gid_lte(filp->f_cred->fsgid, gid_max))
+			match = true;
+
+		if (!match && (info->match & XT_COMPL_GROUPS) && gi) {
+			for (i = 0; i < gi->ngroups; ++i) {
+				kgid_t group = gi->gid[i];
+
+				if (gid_gte(group, gid_min) &&
+				    gid_lte(group, gid_max)) {
+					match = true;
+					break;
+				}
+			}
+		}
+
+		if (match ^ !(info->invert & XT_OWNER_GID))
 			return false;
 	}
 
-- 
2.20.1

