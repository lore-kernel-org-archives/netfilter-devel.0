Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB61CC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 22:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiGLWsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGLWsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 18:48:19 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32331C9978
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 15:48:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id DE937CC00F5;
        Wed, 13 Jul 2022 00:48:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 13 Jul 2022 00:48:09 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id A08C2CC00F3;
        Wed, 13 Jul 2022 00:48:09 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8DE253431DE; Wed, 13 Jul 2022 00:48:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 8BA89343155;
        Wed, 13 Jul 2022 00:48:09 +0200 (CEST)
Date:   Wed, 13 Jul 2022 00:48:09 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] netfilter: ipset: include linux/nf_inet_addr.h
In-Reply-To: <20220629211902.3045703-2-vpai@akamai.com>
Message-ID: <2671440-40b6-1789-25a5-9f16971595cd@netfilter.org>
References: <20220629211902.3045703-1-vpai@akamai.com> <20220629211902.3045703-2-vpai@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 29 Jun 2022, Vishwanath Pai wrote:

> We redefined a few things from nf_inet_addr.h, this will prevent others
> from including nf_inet_addr.h and ipset headers in the same file.
> 
> Remove the duplicate definitions and include nf_inet_addr.h instead.

Please don't do that or add the required compatibility stuff into 
configure.ac and ip_set_compat.h.in in order not to break support for 
older kernels.

Best regards,
Jozsef
 
> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
> Signed-off-by: Joshua Hunt <johunt@akamai.com>
> ---
>  include/libipset/nf_inet_addr.h |  9 +--------
>  include/libipset/nfproto.h      | 15 +--------------
>  2 files changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/include/libipset/nf_inet_addr.h b/include/libipset/nf_inet_addr.h
> index f3bdf01..e1e058c 100644
> --- a/include/libipset/nf_inet_addr.h
> +++ b/include/libipset/nf_inet_addr.h
> @@ -10,13 +10,6 @@
>  #include <stdint.h>				/* uint32_t */
>  #include <netinet/in.h>				/* struct in[6]_addr */
>  
> -/* The structure to hold IP addresses, same as in linux/netfilter.h */
> -union nf_inet_addr {
> -	uint32_t	all[4];
> -	uint32_t	ip;
> -	uint32_t	ip6[4];
> -	struct in_addr	in;
> -	struct in6_addr in6;
> -};
> +#include <linux/netfilter.h>
>  
>  #endif /* LIBIPSET_NF_INET_ADDR_H */
> diff --git a/include/libipset/nfproto.h b/include/libipset/nfproto.h
> index 800da11..5265176 100644
> --- a/include/libipset/nfproto.h
> +++ b/include/libipset/nfproto.h
> @@ -1,19 +1,6 @@
>  #ifndef LIBIPSET_NFPROTO_H
>  #define LIBIPSET_NFPROTO_H
>  
> -/*
> - * The constants to select, same as in linux/netfilter.h.
> - * Like nf_inet_addr.h, this is just here so that we need not to rely on
> - * the presence of a recent-enough netfilter.h.
> - */
> -enum {
> -	NFPROTO_UNSPEC =  0,
> -	NFPROTO_IPV4   =  2,
> -	NFPROTO_ARP    =  3,
> -	NFPROTO_BRIDGE =  7,
> -	NFPROTO_IPV6   = 10,
> -	NFPROTO_DECNET = 12,
> -	NFPROTO_NUMPROTO,
> -};
> +#include <linux/netfilter.h>
>  
>  #endif /* LIBIPSET_NFPROTO_H */
> -- 
> 2.25.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
