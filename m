Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18660C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 11:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C4C610E8
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 11:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhDBLqI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 07:46:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBLqH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 07:46:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132BeRFT086294;
        Fri, 2 Apr 2021 11:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=IBu6CtTlgX23CvvLbWSZBj+Tly9tn8YitrdK5e6QIOM=;
 b=fwLou4jO8E/sUd8UCSTaPgXUbt6Ws3BYuOXUcF6g9f2S1QtHatIR342/EtS4y+xzwgRz
 CHC28GExNt28GRAm5RnlsTrWdgcIeLcd919ZMkoXq100y11cxGyDszV4OEUpszEuGzAP
 j5AOnKzlsZLhUQTNEBEu9zzMplNTwr3QpoEQkZYuKD8pZ2lMczcnm5lrPYdSUjwcybsp
 EWPj1QlbwUT/L1mYTN2YgxiIQih62ZAbKQA0Vr+3yxGPh2riY9Fab6H1yuvldFSR+VrS
 61uBhOK24lUEUeg/O0M5Sm86+g9huIvMljjCcD6gFYFO4prfdglZVOXtuGMD/ghEAKxQ hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37n2a04fv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 11:45:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132BdkAJ093241;
        Fri, 2 Apr 2021 11:45:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 37n2atbxtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 11:45:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 132BjqCI012987;
        Fri, 2 Apr 2021 11:45:54 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Apr 2021 04:45:52 -0700
Date:   Fri, 2 Apr 2021 14:45:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Paul Moore <paul@paul-moore.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: nftables: fix a warning message in
 nf_tables_commit_audit_collect()
Message-ID: <YGcD6HO8tiX7G4OJ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020086
X-Proofpoint-GUID: 0F_j57_lT8qN6nvgh5RkKh9r_L3mQxn_
X-Proofpoint-ORIG-GUID: 0F_j57_lT8qN6nvgh5RkKh9r_L3mQxn_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1011 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020086
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first argument of a WARN_ONCE() is a condition.  This WARN_ONCE()
will only print the table name, and is potentially problematic if the
table name has a %s in it.

Fixes: bb4052e57b5b ("audit: log nftables configuration change events once per table")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42bf3e15065a..2fb2ccf87011 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8022,7 +8022,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
 		if (adp->table == table)
 			goto found;
 	}
-	WARN_ONCE("table=%s not expected in commit list", table->name);
+	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
 	adp->entries++;
-- 
2.30.2

