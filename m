Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F55C4361B
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 895F8238EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLPUdT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:33:19 -0500
Received: from smtp.sysclose.org ([69.164.214.230]:43118 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgLPUdS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:33:18 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2020 15:33:18 EST
Received: from localhost (unknown [45.71.105.177])
        by sysclose.org (Postfix) with ESMTPSA id CB52C30A8;
        Wed, 16 Dec 2020 20:26:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org CB52C30A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1608150376;
        bh=YhPOG24tSm5uH2ZUREgPDvOK/3FwMevREJ9YeQX4JqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KjXlCP6cMzRkWw445lP4LY/bvGFmR2rEgE50ufpySxiYsl1qa6TAbq42yXm8h4eBO
         vX+0PmUhE+AQAFgisyDVpyiVTW/EdyEcfOq0Hcu+X2aD+xfezTpbLzEMwpLBqVTLnE
         1l7DqpuBaM5tcmtnAGYVjjYkxz5scO4dYaOCoFVu9mPIryjcKVXWeQyF1zIxR4h+ai
         u+GIN7sChoXd8J5nb6r8rh/otRdZmRa8AU0J4S/eqp/iyfLdzzUXUI5Aw3uaIVok9j
         5v1Vl8sOFbiuvyyJbWsPGp3p7QPa7bQJexHwRQdWM05WSq3vh/sbLC1vtuwOxamZFl
         v+L7KY1aGHyHw==
Date:   Wed, 16 Dec 2020 17:25:46 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     yang_y_yi@163.com
Cc:     ovs-dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH] conntrack: fix zone sync issue
Message-ID: <20201216202546.GD10866@p50.lan>
References: <20201019025313.407244-1-yang_y_yi@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019025313.407244-1-yang_y_yi@163.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


This email has 'To' field pointing to ovs-dev, but the patch
seems to fix another code other than OVS.

You might have realized by now, but in case you're still waiting... :)

Thanks,
fbl

On Mon, Oct 19, 2020 at 10:53:13AM +0800, yang_y_yi@163.com wrote:
> From: Yi Yang <yangyi01@inspur.com>
> 
> In some use cases, zone is used to differentiate different
> conntrack state tables, so zone also should be synchronized
> if it is set.
> 
> Signed-off-by: Yi Yang <yangyi01@inspur.com>
> ---
>  include/network.h | 1 +
>  src/build.c       | 3 +++
>  src/parse.c       | 5 +++++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/include/network.h b/include/network.h
> index 95aad82..20def34 100644
> --- a/include/network.h
> +++ b/include/network.h
> @@ -232,6 +232,7 @@ enum nta_attr {
>  	NTA_SNAT_IPV6,		/* uint32_t * 4 */
>  	NTA_DNAT_IPV6,		/* uint32_t * 4 */
>  	NTA_SYNPROXY,		/* struct nft_attr_synproxy */
> +	NTA_ZONE,		/* uint16_t */
>  	NTA_MAX
>  };
>  
> diff --git a/src/build.c b/src/build.c
> index 99ff230..4771997 100644
> --- a/src/build.c
> +++ b/src/build.c
> @@ -315,6 +315,9 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
>  	    nfct_attr_is_set(ct, ATTR_SYNPROXY_ITS) &&
>  	    nfct_attr_is_set(ct, ATTR_SYNPROXY_TSOFF))
>  		ct_build_synproxy(ct, n);
> +
> +	if (nfct_attr_is_set(ct, ATTR_ZONE))
> +	    ct_build_u16(ct, ATTR_ZONE, n, NTA_ZONE);
>  }
>  
>  static void
> diff --git a/src/parse.c b/src/parse.c
> index 7e524ed..e97a721 100644
> --- a/src/parse.c
> +++ b/src/parse.c
> @@ -205,6 +205,11 @@ static struct ct_parser h[NTA_MAX] = {
>  		.parse	= ct_parse_synproxy,
>  		.size	= NTA_SIZE(sizeof(struct nta_attr_synproxy)),
>  	},
> +	[NTA_ZONE] = {
> +		.parse	= ct_parse_u16,
> +		.attr	= ATTR_ZONE,
> +		.size	= NTA_SIZE(sizeof(uint16_t)),
> +	},
>  };
>  
>  static void
> -- 
> 1.8.3.1
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

-- 
fbl
