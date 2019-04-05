Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA63C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 08:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8167217D7
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 08:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p4H5OXdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfDEIfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 04:35:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfDEIfK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 04:35:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x358Y6H6040484;
        Fri, 5 Apr 2019 08:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=aZA6nXEd1NSlJuXKjQ1Lm+rqqEs/N+GfF0azZRtkylM=;
 b=p4H5OXdSgNiG9WNifpk2YyhVJMF4S6+70wn0G+0K0Kb/v7uzdkIm5xHd5/0maJwQjviB
 rakiUFVEib9f/wOlPpO4ctamok9nSAO82ZsufwD+x5yzqvMzkupoGExPTkHvp2xD/Qcf
 yoXqW34Q1SFl6p0cskWvLBaISvWV3sCfNCD1hTrPXLsWvEMq9B1rQkrI8H7v+WEIvGyr
 RoZ+Sfytare78KY+fJwyKRCMaYzkaPcVTf8+s3DNsrpwiEdj1/x9ej/AdO9han1/th48
 1r9AZ8kCjN9y2SVMmbFweMXfmhKKwhP3ax/iU8/gX5mKiZBLTiUfry7UwPR8eS+KSfOe gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rhyvtkhhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Apr 2019 08:34:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x358Xe6s156966;
        Fri, 5 Apr 2019 08:34:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rp3698c44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Apr 2019 08:34:50 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x358YjPx027118;
        Fri, 5 Apr 2019 08:34:49 GMT
Received: from kadam (/41.202.241.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Apr 2019 01:34:45 -0700
Date:   Fri, 5 Apr 2019 11:34:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: prevent shift wrap in
 nft_chain_parse_hook()
Message-ID: <20190405083436.GT32613@kadam>
References: <20190402133038.GA18575@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402133038.GA18575@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9217 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904050064
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9217 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904050064
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 02, 2019 at 04:30:38PM +0300, Dan Carpenter wrote:
> I believe that "hook->num" can be up to UINT_MAX so the shift has to
> be unsigned or shifting more than 31 is undefined.  It's possible that
> this leads to array overflow in nf_tables_addchain():
> 
> 	ops->hook	= hook.type->hooks[ops->hooknum];
> 
> Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index ef7772e976cc..b6e48fe7c776 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1545,7 +1545,7 @@ static int nft_chain_parse_hook(struct net *net,
>  		if (IS_ERR(type))
>  			return PTR_ERR(type);
>  	}
> -	if (!(type->hook_mask & (1 << hook->num)))
> +	if (!(type->hook_mask & (1U << hook->num)))

Ugh...  No this doesn't work.  It's still undefined behavoir even if we
make it unsigned.  It has to be:

	if (hook->num > 31 || !(type->hook_mask & (1 << hook->num)))

which seems like a slightly ugly magic number but it fixes the buffer
overflow.

regards,
dan carpenter

