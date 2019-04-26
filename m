Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8788AC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA802077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VgHwK3GH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfDZQDJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:03:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57740 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfDZQDJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:03:09 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190426160307euoutp01f42f49d04bbba179eb798d6b1ab323d2~ZEa6Ab-yR2245722457euoutp01m;
        Fri, 26 Apr 2019 16:03:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190426160307euoutp01f42f49d04bbba179eb798d6b1ab323d2~ZEa6Ab-yR2245722457euoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556294587;
        bh=ZN1ne6zYzeV4xMzhI+8wt5wtWkCP73nFNfTGDdbJmII=;
        h=From:To:Cc:Subject:Date:References:From;
        b=VgHwK3GHB4CL+6YSf7CbMr/kidy741gEwt1qw0OzK9vU+5r/uDM6TKHV8xSpjexcH
         nvY+1K24wm+O+2BB3dO21WICDolEJeB6dQWE5gNoecPc4I/OfcWLZ/4ivw+kbZne8U
         I8Xi1akXHZrFoo0nRW8Jt6fjhjhZdOdlU5OnX6S0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190426160307eucas1p1e56ddbf741f75b948ef38cbbe42c5819~ZEa5pf3x10239702397eucas1p1Y;
        Fri, 26 Apr 2019 16:03:07 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 47.80.04325.ABB23CC5; Fri, 26
        Apr 2019 17:03:06 +0100 (BST)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10~ZEa4-7lW90477504775eucas1p1E;
        Fri, 26 Apr 2019 16:03:06 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-04-5cc32bba1b8a
Received: from eusync3.samsung.com ( [203.254.199.213]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 39.32.04140.ABB23CC5; Fri, 26
        Apr 2019 17:03:06 +0100 (BST)
Received: from amdc2143.DIGITAL.local ([106.120.51.59]) by
        eusync3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0 64bit
        (built May  5 2014)) with ESMTPA id <0PQK00MWQSL3LW10@eusync3.samsung.com>;
        Fri, 26 Apr 2019 17:03:06 +0100 (BST)
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH] extensions: libxt_owner: Add complementary groups option
Date:   Fri, 26 Apr 2019 18:02:57 +0200
Message-id: <20190426160257.4139-1-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 2.20.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7djP87q7tA/HGDyeqWvxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAldG65kZzAV/xSt+fCxv
        YFwm3MXIySEhYCLxevsili5GLg4hgRWMEmduzYNyPjNK9O89wghT9fPDcmYQW0hgGaPE5zOl
        EEX/GSW2fzkGVsQmYCDx/cJeZpCEiMB0Jok1Da/AEswCoRLnHq0HSnBwCAt4SvRtFQYxWQRU
        JbatEAMxeQWsJd7M4YBYJS9xvncdO4jNKyAo8WPyPRaIIfISB688B7tNQmANm8TXNzvZQHol
        BFwkujZqQvTKSFye3M0CEa6WOHmmAqK8g1Fi44vZUK9YS3yetIUZYiafxKRt05kh6nklOtqE
        IEo8JHpOHWCE+DZWoqf3CeMERslZSC6aheSiBYxMqxjFU0uLc9NTi43zUsv1ihNzi0vz0vWS
        83M3MQJj+vS/4193MO77k3SIUYCDUYmH9wb74Rgh1sSy4srcQ4wSHMxKIrzqpgdjhHhTEiur
        Uovy44tKc1KLDzFKc7AoifNWMzyIFhJITyxJzU5NLUgtgskycXBKNTCq3pIxL/8d5fNWXW/V
        foe0v8xJdXpsXy9oid+Qcds4f2v1mVjuRyFWD+pXMnPsm8eZf1f98jGjazPmG2wTE1iTt3rN
        CmkdnVTxiJ+2R38pa8t+WB+zqCOkSrGXncn9xcT8hL9bRTNf8m9NORLqULPhUuGNRd9O+aZM
        vv2ofcnm+9+Pb/+a8EJQiaU4I9FQi7moOBEA+V+X3uUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xq7q7tA/HGGz7wWzxd2c7s8Wc8y0s
        Ftt6VzNa/H+tY3G5bxqzxZlJC5ksLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo++LasYPQ59X8Dq8XmTXAB7FJdNSmpOZllqkb5dAldG65kZzAV/xSt+fCxv
        YFwm3MXIySEhYCLx88Ny5i5GLg4hgSWMEqtbLjGBJIQEGpkkjt6IALHZBAwkvl/YywxiiwhM
        Z5L4MwusmVkgVOLajOlAcQ4OYQFPib6twiAmi4CqxLYVYiAmr4C1xJs5HBCb5CXO965jB7F5
        BQQlfky+xwIxRF7i4JXnLBMYeWYhSc1CklrAyLSKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMj
        MCC3Hfu5ZQdj17vgQ4wCHIxKPLwXGA7HCLEmlhVX5h5ilOBgVhLhVTc9GCPEm5JYWZValB9f
        VJqTWnyIUZqDRUmct0MAKCWQnliSmp2aWpBaBJNl4uCUamBMtFTIfhp3US98xuRXh9Yde7Fi
        uanMQ+Vczys16Yf6z/wpTI5UM1RNyo/+Jls878njlU6F3XdfCAuHfgpKkHwww8Xz/lO/uIl5
        tn1PXu0XOX73xMR37hd/CDu0N82+tD/r4NwHW9qsVTiXFy7zbPiQnMT1xarb6jv/XTOtn0lH
        Wh8ZrDuiWbxYiaU4I9FQi7moOBEAXFXOx0QCAAA=
X-CMS-MailID: 20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10
CMS-TYPE: 201P
X-CMS-RootMailID: 20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10
References: <CGME20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10@eucas1p1.samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The --compl-groups option causes GIDs specified with --gid-owner to be
also checked in the complementary groups of a process.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 extensions/libxt_owner.c           | 13 ++++++++++++-
 include/linux/netfilter/xt_owner.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 87e4df31..950d837c 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -56,6 +56,7 @@ enum {
 	O_PROCESS,
 	O_SESSION,
 	O_COMM,
+	O_COMPL_GROUPS,
 };
 
 static void owner_mt_help_v0(void)
@@ -87,7 +88,8 @@ static void owner_mt_help(void)
 "owner match options:\n"
 "[!] --uid-owner userid[-userid]      Match local UID\n"
 "[!] --gid-owner groupid[-groupid]    Match local GID\n"
-"[!] --socket-exists                  Match if socket exists\n");
+"[!] --socket-exists                  Match if socket exists\n"
+"    --compl-groups                   Also match complementary groups set with --gid-owner\n");
 }
 
 #define s struct ipt_owner_info
@@ -131,6 +133,8 @@ static const struct xt_option_entry owner_mt_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "socket-exists", .id = O_SOCK_EXISTS, .type = XTTYPE_NONE,
 	 .flags = XTOPT_INVERT},
+	{.name = "compl-groups", .id = O_COMPL_GROUPS, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
 
@@ -275,6 +279,11 @@ static void owner_mt_parse(struct xt_option_call *cb)
 			info->invert |= XT_OWNER_SOCKET;
 		info->match |= XT_OWNER_SOCKET;
 		break;
+	case O_COMPL_GROUPS:
+		if (!(info->match & XT_OWNER_GID))
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--compl-groups", "you need to use --gid-owner first");
+		info->match |= XT_COMPL_GROUPS;
+		break;
 	}
 }
 
@@ -458,6 +467,7 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
 	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
 	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
 	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
+	owner_mt_print_item(info, "incl. compl. groups", XT_COMPL_GROUPS, numeric);
 }
 
 static void
@@ -490,6 +500,7 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
 	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
+	owner_mt_print_item(info, "--compl-groups",   XT_COMPL_GROUPS, true);
 }
 
 static int
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index 20817617..80d49dfd 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -7,6 +7,7 @@ enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
+	XT_COMPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
-- 
2.20.1

