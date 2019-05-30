Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E6AC28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D7225B56
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfE3Ong (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 10:43:36 -0400
Received: from mail.us.es ([193.147.175.20]:42880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727622AbfE3Onf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:43:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 383F21B840C
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 16:43:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 291B2DA704
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 16:43:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1EC50DA701; Thu, 30 May 2019 16:43:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D34C3DA709;
        Thu, 30 May 2019 16:43:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 16:43:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AEE7D4265A32;
        Thu, 30 May 2019 16:43:29 +0200 (CEST)
Date:   Thu, 30 May 2019 16:43:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Robin Geuze <robing@transip.nl>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] conntrackd: Fix "Address Accept" filter case
Message-ID: <20190530144329.76owimclaqyzqkmv@salvia>
References: <AM0PR02MB5492D0F9BEB5814637C7D5C3AA1E0@AM0PR02MB5492.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR02MB5492D0F9BEB5814637C7D5C3AA1E0@AM0PR02MB5492.eurprd02.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 07:03:59AM +0000, Robin Geuze wrote:
> This fixes a bug in the Address Accept filter case where if you only
> specify either addresses or masks it would never match.

Thanks Robin.

Would you post an example configuration that is broken? I would like
to place it in the commit message.

> Signed-off-by: Robin Geuze <robing@transip.nl>
> ---
>   src/filter.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/src/filter.c b/src/filter.c
> index 00a5e96..07b2e1d 100644
> --- a/src/filter.c
> +++ b/src/filter.c
> @@ -335,16 +335,22 @@ ct_filter_check(struct ct_filter *f, const struct nf_conntrack *ct)
>  		switch(nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
>  		case AF_INET:
>  			ret = vector_iterate(f->v, ct, __ct_filter_test_mask4);
> -			if (ret ^ f->logic[CT_FILTER_ADDRESS])
> +			if (ret && f->logic[CT_FILTER_ADDRESS]) {
> +				break;
> +			} else if (ret && !f->logic[CT_FILTER_ADDRESS]) {
>  				return 0;
> +			}
>  			ret = __ct_filter_test_ipv4(f, ct);
>  			if (ret ^ f->logic[CT_FILTER_ADDRESS])
>  				return 0;
>  			break;
>  		case AF_INET6:
>  			ret = vector_iterate(f->v6, ct, __ct_filter_test_mask6);
> -			if (ret ^ f->logic[CT_FILTER_ADDRESS])
> +			if (ret && f->logic[CT_FILTER_ADDRESS]) {
> +				break;
> +			} else if (ret && !f->logic[CT_FILTER_ADDRESS]) {
>  				return 0;
> +			}
>  			ret = __ct_filter_test_ipv6(f, ct);
>  			if (ret ^ f->logic[CT_FILTER_ADDRESS])
>  				return 0;
> -- 
> 2.20.1
