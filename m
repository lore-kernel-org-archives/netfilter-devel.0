Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABA0C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 17:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354ED611BD
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 17:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIJReB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 13:34:01 -0400
Received: from mg.ssi.bg ([178.16.128.9]:50810 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhIJReA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 13:34:00 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 92A832D410;
        Fri, 10 Sep 2021 20:32:47 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id E96DD2D483;
        Fri, 10 Sep 2021 20:32:45 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C372F3C09B7;
        Fri, 10 Sep 2021 20:32:44 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 18AHWeww021693;
        Fri, 10 Sep 2021 20:32:42 +0300
Date:   Fri, 10 Sep 2021 20:32:40 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Andrea Claudi <aclaudi@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] ipvs: check that ip_vs_conn_tab_bits is between 8
 and 20
In-Reply-To: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
Message-ID: <b328e7e8-973-b4dc-d912-81d8d7661681@ssi.bg>
References: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Fri, 10 Sep 2021, Andrea Claudi wrote:

> ip_vs_conn_tab_bits may be provided by the user through the
> conn_tab_bits module parameter. If this value is greater than 31, or
> less than 0, the shift operator used to derive tab_size causes undefined
> behaviour.
> 
> Fix this checking ip_vs_conn_tab_bits value to be in the range specified
> in ipvs Kconfig. If not, simply use default value.
> 
> Fixes: 6f7edb4881bf ("IPVS: Allow boot time change of hash size")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index c100c6b112c8..2c467c422dc6 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1468,6 +1468,10 @@ int __init ip_vs_conn_init(void)
>  	int idx;
>  
>  	/* Compute size and mask */
> +	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
> +		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
> +		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
> +	}
>  	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
>  	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
>  
> -- 
> 2.31.1

Regards

--
Julian Anastasov <ja@ssi.bg>

