Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6749AC433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB7B2067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgGPR1J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:27:09 -0400
Received: from ja.ssi.bg ([178.16.129.10]:57964 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbgGPR1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 13:27:08 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06GHQrsa007472;
        Thu, 16 Jul 2020 20:26:55 +0300
Date:   Thu, 16 Jul 2020 20:26:53 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Andrew Sy Kim <kim.andrewsy@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] ipvs: ensure RCU read unlock when connection
 flushing and ipvs is disabled
In-Reply-To: <20200716170314.9617-1-kim.andrewsy@gmail.com>
Message-ID: <alpine.LFD.2.23.451.2007162025220.5182@ja.home.ssi.bg>
References: <20200716170314.9617-1-kim.andrewsy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 16 Jul 2020, Andrew Sy Kim wrote:

> When ipvs is disabled in ip_vs_expire_nodest_conn_flush,
> we should break instead of return so that rcu_read_unlock()
> is run.
> 
> Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index a5e9b2d55e57..a90b8eac16ac 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1422,7 +1422,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
>  
>  		/* netns clean up started, abort delayed work */
>  		if (!ipvs->enable)
> -			return;
> +			break;
>  	}
>  	rcu_read_unlock();
>  }
> -- 
> 2.20.1

Regards

--
Julian Anastasov <ja@ssi.bg>
