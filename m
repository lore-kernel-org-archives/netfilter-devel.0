Return-Path: <SRS0=H+Om=WU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2874EC3A59E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 14:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B4621670
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 14:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sTFBVQu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfHXOwo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Aug 2019 10:52:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfHXOwo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Aug 2019 10:52:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7OEoOdN153917;
        Sat, 24 Aug 2019 14:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=9gEBh5hBjKJ+MOqY3FTrvGUSrzu+006X4b+ShrMVEis=;
 b=sTFBVQu3Tk5F3ONJTtcrR+wbb9r6J0ufR9kT/6tEZXlK/WXn6XhaUqpgE94CAX6twakK
 kUQWbveej5Y/JZdoC4MAgNtj5BuGGIcdHLbf7N0tqomMF2/0Pvhgf1kQBN8SvnxqGY/U
 Y1DsxjcAqvyAUiOVCs0TkNmaeSuOJaMuVn1mNRqt/lccsqkjkwF8Q2DdHj4RdebMyBSS
 GDShxXMela4EaK91zuT714Fl4r/MWuw+geKyCXxg3xXG3XcS7bi0bXxykPh2NBGvdBqP
 oJ2oX/I6Jg5p/qk+ut6IM/csaSuhXUUxsEgHdUnFBq8/qiZYwsr6PKOPmIrkiGQcOOVA +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ujw6ysase-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 14:52:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7OEm8Me154446;
        Sat, 24 Aug 2019 14:50:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ujw6ak81k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 14:50:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7OEo311030765;
        Sat, 24 Aug 2019 14:50:03 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Aug 2019 07:50:03 -0700
Date:   Sat, 24 Aug 2019 17:49:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] netfilter: ipset: Fix an error code in ip_set_sockfn_get()
Message-ID: <20190824144955.GA5337@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1908221109390.11879@blackhole.kfki.hu>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9359 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908240163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9359 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908240163
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to be
copied.  In this code, that positive return is checked at the end of the
function and we return zero/success.  What we should do instead is
return -EFAULT.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: I missed the other instance of this issue

 net/netfilter/ipset/ip_set_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e64d5f9a89dd..e7288eab7512 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2069,8 +2069,9 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 		}
 
 		req_version->version = IPSET_PROTOCOL;
-		ret = copy_to_user(user, req_version,
-				   sizeof(struct ip_set_req_version));
+		if (copy_to_user(user, req_version,
+				 sizeof(struct ip_set_req_version)))
+			ret = -EFAULT;
 		goto done;
 	}
 	case IP_SET_OP_GET_BYNAME: {
@@ -2129,7 +2130,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 	}	/* end of switch(op) */
 
 copy:
-	ret = copy_to_user(user, data, copylen);
+	if (copy_to_user(user, data, copylen))
+		ret = -EFAULT;
 
 done:
 	vfree(data);
-- 
2.11.0

