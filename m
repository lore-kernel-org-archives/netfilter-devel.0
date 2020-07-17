Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DB8C433E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D855720717
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0ie1bOU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGQOLQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:11:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQOLQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 10:11:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HE2EFK055636;
        Fri, 17 Jul 2020 14:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Mv5dydH0r53hroQIradq8z6oy8JvVlHpZdHz/hKyd3A=;
 b=0ie1bOU7QvEoU/mGpDVdqzu7MmqJbqPFBT215/ITEkS5khJWLwgZ6tOWk1Yh1u2pzP3p
 UflvG7CDFEfaC+Hmrn/xOoGYNwdqGskK5ZjZGAtatexaB18yM8u3HQPDSl9sm9EyDl5d
 hrUH837hBd6Wvq3GFmNnIyzaFs/Cvoz66CQe5velV1/zir6458ZfkjTGNQCRsSKGw4tX
 737YqQns4WemWhXaRC0bhIsvmpEBt2aEq5O9NcZT+sCZBvNrtmX6hKvaxcpcpitBbmIv
 5WuJCL5MsBL6mHkOZ/CPsNaAmORF5gOPBGiyUV00cFHf39h1mVQcqUVyuwcVyv8o8hgs uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274urqgmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 14:10:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HE9cRq036498;
        Fri, 17 Jul 2020 14:10:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32bdaxrp9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:10:50 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06HEAcxh011239;
        Fri, 17 Jul 2020 14:10:38 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 07:10:37 -0700
Date:   Fri, 17 Jul 2020 17:10:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wensong Zhang <wensong@linux-vs.org>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Sy Kim <kim.andrewsy@gmail.com>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ipvs: missing unlock in
 ip_vs_expire_nodest_conn_flush()
Message-ID: <20200717141029.GA21445@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170103
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can't return without calling rcu_read_unlock().

Fixes: 04231e52d355 ("ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a5e9b2d55e57..a90b8eac16ac 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1422,7 +1422,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
 
 		/* netns clean up started, abort delayed work */
 		if (!ipvs->enable)
-			return;
+			break;
 	}
 	rcu_read_unlock();
 }
-- 
2.27.0

