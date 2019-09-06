Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEFEC43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2805D207FC
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bou/6IBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfIFITW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:19:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFITW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 04:19:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x868IiiT136450;
        Fri, 6 Sep 2019 08:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=KJlykhMXVgefAJtBiJB4NoFLZlCX7rOkq7+lBXeiC/E=;
 b=bou/6IBvt7u9APWBe1yNaTjSyj6tkv0Y9Vc0CyVTwXL8z/S9QFH4+aP9AVPd70fM+Gdu
 8yc9DK1mBDxepu340Av3lUvbQplwzCwMhBviKOdc9ccU+s2HI9jmTQOxfZQFXFowhYzK
 bXnwBeIp7lNThKp/FXz3a78GK9OxdAX5bGzOfBE4lVvVWnWzhlhQFoRtbeK0i7H7/BHH
 0WHICgQyjeH5UvVjABXigOrOdCNGnftJPw6I8E/55fWmQgg2KRu2ASNt3HOOJwqCx52p
 VbBQT1yJ2XYJH6NkOt1dSaL2szfWBarOZLP5xLZgeqt/LryYvOEImMuHC9Q+fdCobm5H 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uukq7819f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 08:19:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x868IosJ117409;
        Fri, 6 Sep 2019 08:18:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b9gcbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 08:18:57 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x868IFCF030194;
        Fri, 6 Sep 2019 08:18:19 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 01:18:15 -0700
Date:   Fri, 6 Sep 2019 11:18:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: nf_tables: Fix an Oops in nf_tables_updobj()
 error handling
Message-ID: <20190906081808.GA8281@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060087
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "newobj" is an error pointer so we can't pass it to kfree().  It
doesn't need to be freed so we can remove that and I also renamed the
error label.

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf767bc58e18..6f66898d63b4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5148,7 +5148,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
 		err = PTR_ERR(newobj);
-		goto err1;
+		goto err_free_trans;
 	}
 
 	nft_trans_obj(trans) = obj;
@@ -5157,9 +5157,9 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
-err1:
+
+err_free_trans:
 	kfree(trans);
-	kfree(newobj);
 	return err;
 }
 
-- 
2.20.1

