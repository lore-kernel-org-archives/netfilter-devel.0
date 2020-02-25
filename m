Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C50FC35DF2
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 06:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4082721556
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 06:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xAVWNr5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgBYGmx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:42:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgBYGmw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 01:42:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P6XPql062356;
        Tue, 25 Feb 2020 06:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=34NUe7/tuMM5XkS7YeXLr+/Kr3j+pRIAm29dcfakx+8=;
 b=xAVWNr5MP5jY8TUIUeHcePePJCXF1HhNFAY7osKl3tzjYck0fCk/qPP7xuBDgdbYU8Yn
 IlSHlwvDUbAvhojHV2++4zczHuYPaInQEhVui+I1i5HLuoXRaSR/kUWIDn+I+xxroP5O
 aXILNf60DSXxptUOfI7K78MlmEsBAsMwWTuGT3oistA0s0Fspaue1SrZiRTG2hzSyo4i
 chZlsjiIFFai+y41AtrG+ecXHiBsP/2jnn5MBrc8mAVaMVq9aiVxpNLJnBTyXEEKhm0Q
 A4FkSN3kbR0wH0EBju46iDnjtKob8T2o00VPSf5R1SM6MFCNddwIQGxkPliEaltC7g9r nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ycppr9qg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 06:42:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P6g8mA092996;
        Tue, 25 Feb 2020 06:42:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yby5fk1hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 06:42:42 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P6galn013830;
        Tue, 25 Feb 2020 06:42:36 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 22:42:35 -0800
Date:   Tue, 25 Feb 2020 09:42:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Manoj Basapathi <manojbm@codeaurora.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: clean up some indenting
Message-ID: <20200225064150.hwewi26uc2yfwh2u@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250052
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These lines were indented wrong so Smatch complained.
net/netfilter/xt_IDLETIMER.c:81 idletimer_tg_show() warn: inconsistent indenting

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/xt_IDLETIMER.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index d620bbf13b30..75bd0e5dd312 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -77,9 +77,8 @@ static ssize_t idletimer_tg_show(struct device *dev,
 			ktimespec = ktime_to_timespec64(expires_alarm);
 			time_diff = ktimespec.tv_sec;
 		} else {
-		expires = timer->timer.expires;
-			time_diff = jiffies_to_msecs(
-						expires - jiffies) / 1000;
+			expires = timer->timer.expires;
+			time_diff = jiffies_to_msecs(expires - jiffies) / 1000;
 		}
 	}
 
@@ -216,7 +215,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
 
 	list_add(&info->timer->entry, &idletimer_tg_list);
-		pr_debug("timer type value is %u", info->timer_type);
+	pr_debug("timer type value is %u", info->timer_type);
 	info->timer->timer_type = info->timer_type;
 	info->timer->refcnt = 1;
 
-- 
2.11.0

