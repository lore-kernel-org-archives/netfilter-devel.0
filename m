Return-Path: <SRS0=4CCp=SI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E870C10F06
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Apr 2019 05:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1893A2173C
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Apr 2019 05:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kU5dV5wb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDFF1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Apr 2019 01:27:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42022 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfDFF1U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Apr 2019 01:27:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x365F3MD188295;
        Sat, 6 Apr 2019 05:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=Q2gYlnh069vO2f/dL2Z65Stz5BOFGSSFCPRM25/lNzQ=;
 b=kU5dV5wb+iMyv2vVUsGCHGMo8ELCS13seVTPOaG6SO3/kOuxhLlfEa83PRrFMknNOj0W
 +qCsgy5w85QQM7gSIh4cFcrgn6SujM0RD6qGr917REIKTouf7dLyH+bIbEtySOvKBoqR
 ZaBT9obpPBuL2RYJR5HY/1/oV0H3VnKt7BEJwQdxD7TvAG9DxYV92OPmrsuVD6OXsjFR
 aTH61FmkRF9hOFvSKppaf+AOqu469ZwJ7aEf+CrcZyW1Aa9Nw0ONi1miPkfqo1a7Gyjd
 RJAotQJvykaUgQMJar8tCARF3KmZwbvvWeR4FloSiNMojwEApyHf5a4MuvXXWTztqvXe iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkhsg4wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Apr 2019 05:27:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x365QJJv167608;
        Sat, 6 Apr 2019 05:27:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2rph7rb0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Apr 2019 05:27:03 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x365R0q2032003;
        Sat, 6 Apr 2019 05:27:01 GMT
Received: from kadam (/41.202.241.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Apr 2019 22:27:00 -0700
Date:   Sat, 6 Apr 2019 08:26:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] netfilter: nf_tables: prevent shift wrap in
 nft_chain_parse_hook()
Message-ID: <20190406052652.GA20963@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402133038.GA18575@kadam>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9218 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904060036
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9218 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904060036
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I believe that "hook->num" can be up to UINT_MAX.  Shifting more than
31 bits would is undefined in C but in practice it would lead to shift
wrapping.  That would lead to an array overflow in nf_tables_addchain():

	ops->hook       = hook.type->hooks[ops->hooknum];

Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  In my original fix I thought making shifts unsigned was defined in
C but it's not.  My original patch didn't fix or change runtime at all.

Thanks to Florian Westphal for his help on this.

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7772e976cc..1606eaa5ae0d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1545,7 +1545,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.17.1

