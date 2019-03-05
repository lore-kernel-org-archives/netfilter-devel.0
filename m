Return-Path: <SRS0=Q+IM=RI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FE5C43381
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 10:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F28820848
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 10:55:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p67Fyugt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfCEKzu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:55:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45506 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfCEKzu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 05:55:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x25AmePV044400;
        Tue, 5 Mar 2019 10:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=c+to2beudaEL27df/Da43TrmlmUgtXfxV6TWG6y9QhM=;
 b=p67FyugtEfOcQ1a3wzpax44PCuGejfNNzCG5bKGSNJWM/8Ai+EpArbTsVRHohlsH7+G7
 tzVz2JhDZbomXSMJ3XzENGHx6RmHvKWzrqlqMWuRzDABLLpOWQT/qQI9plh3t369v3s0
 8EFxCC4UvsdIdvufxlSsjg/XbBx9Qfqh0QEW5Y4hVWcRRJ6Fhcx3yg/diH9QdhAE6BTk
 qgqFxPWixwi/ylfXFvSWDYImEb+h4biCWJQwIJ3OSRTrEUdoSgqBFvIe5iPIvjLKPPpG
 HPNM3HJgN4fm0vQgbaVrFAo6M05U1I97PZo6MVHrXd+hqxS2EUZq+j/F2rblzZKjZm7A zg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qyfbe4v1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Mar 2019 10:55:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x25AtiBb023786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Mar 2019 10:55:45 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x25AtfdP006487;
        Tue, 5 Mar 2019 10:55:41 GMT
Received: from kadam (/197.157.34.180)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Mar 2019 02:55:40 -0800
Date:   Tue, 5 Mar 2019 13:55:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nft_compat: use .release_ops and remove list
 of extension
Message-ID: <20190305105527.GA9714@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9185 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=857 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903050076
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo Neira Ayuso,

The patch b8e204006340: "netfilter: nft_compat: use .release_ops and
remove list of extension" from Feb 13, 2019, leads to the following
static checker warning:

	net/netfilter/nf_tables_api.c:2167 nf_tables_expr_destroy()
	error: dereferencing freed memory 'expr->ops'

net/netfilter/nf_tables_api.c
    2162 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
    2163 				   struct nft_expr *expr)
    2164 {
    2165 	if (expr->ops->destroy)
    2166 		expr->ops->destroy(ctx, expr);
                                                ^^^^
--> 2167 	module_put(expr->ops->type->owner);
                           ^^^^^^^^^
    2168 }

Smatch says there are three functions which free expr->ops.

net/netfilter/nft_compat.c | nft_match_destroy 	     | 121 | PARAM_FREED | 1 | $->ops |
net/netfilter/nft_compat.c | nft_match_large_destroy | 124 | PARAM_FREED | 1 | $->ops |
net/netfilter/nft_compat.c | nft_target_destroy      | 56  | PARAM_FREED | 1 | $->ops |

regards,
dan carpenter
