Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86C2C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B886138F
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJEU5O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 16:57:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10784 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236136AbhJEU5N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 16:57:13 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195KIJne004475;
        Tue, 5 Oct 2021 20:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=muvHI4iXP5mXWGYr5Wm3GquW6uyy68Wl3o3On7C+zOY=;
 b=X6OhKGy+tCBpENBUmI7mzxUOhcrxnG/BYsZ6IAWpAMl+taOf28x+m8YuBtE/zZI4NETA
 IJF12IgiW/MC4GnYFOf9qekjQSvP4N7CvxhZ8TwV6gG7cT1HlRpntndxRMznZjM1w5IQ
 k0BTSlGDA0VSISkPHoQwxR8AF6zABTK9rpiP/QdNyso+PDJH2FKUFBUq8hkMZLxpW7Qw
 PQ/lVsRzOL5oGauid7VZpiauX8Uzk2IaTStyTHtPjT5/t7lr0b6YagBwPXD1HUufHBaR
 wBAaBwpXqPcZelKFnUQxlIrQbY0yGLcD8sCv0FPePQQq4OkYa9yuUjsHs1iVRrjijA41 qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43e21bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 20:55:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 195KnxZg070294;
        Tue, 5 Oct 2021 20:55:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bev7tun8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 20:55:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 195KtGRg093733;
        Tue, 5 Oct 2021 20:55:16 GMT
Received: from t460.home (dhcp-10-175-13-223.vpn.oracle.com [10.175.13.223])
        by aserp3030.oracle.com with ESMTP id 3bev7tun7r-1;
        Tue, 05 Oct 2021 20:55:15 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Vegard Nossum <vegard.nossum@gmail.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] net/netfilter/Kconfig: use 'default y' instead of 'm' for bool config option
Date:   Tue,  5 Oct 2021 22:54:54 +0200
Message-Id: <20211005205454.20244-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: JJEpgteRjA3JVEg9Q7eUncyhq6evmR2-
X-Proofpoint-ORIG-GUID: JJEpgteRjA3JVEg9Q7eUncyhq6evmR2-
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>

This option, NF_CONNTRACK_SECMARK, is a bool, so it can never be 'm'.

Fixes: 33b8e77605620 ("[NETFILTER]: Add CONFIG_NETFILTER_ADVANCED option")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 54395266339d7..92a747896f808 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -109,7 +109,7 @@ config NF_CONNTRACK_MARK
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
 	depends on NETWORK_SECMARK
-	default m if NETFILTER_ADVANCED=n
+	default y if NETFILTER_ADVANCED=n
 	help
 	  This option enables security markings to be applied to
 	  connections.  Typically they are copied to connections from
-- 
2.23.0.718.g5ad94255a8

