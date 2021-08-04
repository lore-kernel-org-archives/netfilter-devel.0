Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24826C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 08:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C1C60E97
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 08:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhHDImO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 04:42:14 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:53339 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhHDImN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 04:42:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 818FECC0109;
        Wed,  4 Aug 2021 10:42:00 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  4 Aug 2021 10:41:58 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 460A8CC0108;
        Wed,  4 Aug 2021 10:41:58 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id EDA7C340D60; Wed,  4 Aug 2021 10:41:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id E9301340D5D;
        Wed,  4 Aug 2021 10:41:57 +0200 (CEST)
Date:   Wed, 4 Aug 2021 10:41:57 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: fix uninitialized variable bug
In-Reply-To: <20210804083322.GB32730@kili>
Message-ID: <a832cb21-1fe-62c-9ba8-f867488efade@netfilter.org>
References: <20210804083322.GB32730@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Dan,

On Wed, 4 Aug 2021, Dan Carpenter wrote:

> This condition doesn't work because "port_to" is not initialized until
> the next line.  Move the condition down.

You are right - Nathan Chancellor already sent the same fix and I acked 
it. Thanks!

Best regards,
Jozsef
 
> Fixes: 7fb6c63025ff ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/netfilter/ipset/ip_set_hash_ipportnet.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
> index b293aa1ff258..7df94f437f60 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
> @@ -246,9 +246,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  		ip_set_mask_from_to(ip, ip_to, cidr);
>  	}
>  
> -	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
> -		return -ERANGE;
> -
>  	port_to = port = ntohs(e.port);
>  	if (tb[IPSET_ATTR_PORT_TO]) {
>  		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
> @@ -256,6 +253,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  			swap(port, port_to);
>  	}
>  
> +	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
> +		return -ERANGE;
> +
>  	ip2_to = ip2_from;
>  	if (tb[IPSET_ATTR_IP2_TO]) {
>  		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
> -- 
> 2.20.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
