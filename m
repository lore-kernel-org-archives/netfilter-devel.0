Return-Path: <SRS0=UyK1=SE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A60C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A8220883
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HGjiOMYT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbfDBNbO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:31:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40960 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDBNbO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:31:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x32DO2dG110169;
        Tue, 2 Apr 2019 13:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=G0A1yw+YwNVkHSN009lEqeanQ/vBDaF5c9+DYG+/LfE=;
 b=HGjiOMYTO+3u3dcjBO4SZJrWJ5LtWiyhfOYpbvzeklHR+xd1d2/IHx/a6DlGwcsEtz5J
 peRHZjDsGwp0NE3t7IwFZorj4iuxJfRKdlZ88AMqeIgOV7ZHdGIDPI5bkwwziDf0mGzH
 WymGJjkHn+TbPaOkGE9VnWFQGjdnhCK+OessX8nXFID4c3vCEmFt3fKfj74Se8lhYSXl
 6l3WAIsC/LSP8SzJx2bVHol2Z7FitRyeTXbH3ypCPG1pnpgR5N6+WzHLGQeq7woXpc6V
 vWO7aKiVJpTiJtoLVdEkpAN9CMXh5JHcQmKsCy8C4OiQCwZztptdOEtWdmtl8OetzppE hw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2rhwyd5b6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 13:30:51 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x32DUok9000632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Apr 2019 13:30:50 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32DUlJc026412;
        Tue, 2 Apr 2019 13:30:48 GMT
Received: from kadam (/41.202.241.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 06:30:46 -0700
Date:   Tue, 2 Apr 2019 16:30:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: nf_tables: prevent shift wrap in
 nft_chain_parse_hook()
Message-ID: <20190402133038.GA18575@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020091
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I believe that "hook->num" can be up to UINT_MAX so the shift has to
be unsigned or shifting more than 31 is undefined.  It's possible that
this leads to array overflow in nf_tables_addchain():

	ops->hook	= hook.type->hooks[ops->hooknum];

Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7772e976cc..b6e48fe7c776 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1545,7 +1545,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (!(type->hook_mask & (1U << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.17.1

