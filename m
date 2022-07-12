Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC59CCA47F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 21:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiGLVmc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 17:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGLVmb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 17:42:31 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08695CE382
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 14:42:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 84E09CC00F5;
        Tue, 12 Jul 2022 23:42:29 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 12 Jul 2022 23:42:27 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 3F30ECC00D8;
        Tue, 12 Jul 2022 23:42:27 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2E0E13431DE; Tue, 12 Jul 2022 23:42:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 2BF6D343155;
        Tue, 12 Jul 2022 23:42:27 +0200 (CEST)
Date:   Tue, 12 Jul 2022 23:42:27 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: regression in ip_set_hash_ip.c
In-Reply-To: <20220629212109.3045794-2-vpai@akamai.com>
Message-ID: <e394ba75-afe1-c50-54eb-dfceee45bd7a@netfilter.org>
References: <20220629212109.3045794-1-vpai@akamai.com> <20220629212109.3045794-2-vpai@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Vishwanath,

On Wed, 29 Jun 2022, Vishwanath Pai wrote:

> This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
> ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
> 
> The variable e.ip is passed to adtfn() function which finally adds the
> ip address to the set. The patch above refactored the for loop and moved
> e.ip = htonl(ip) to the end of the for loop.
> 
> What this means is that if the value of "ip" changes between the first
> assignement of e.ip and the forloop, then e.ip is pointing to a
> different ip address than "ip".
> 
> Test case:
> $ ipset create jdtest_tmp hash:ip family inet hashsize 2048 maxelem 100000
> $ ipset add jdtest_tmp 10.0.1.1/31
> ipset v6.21.1: Element cannot be added to the set: it's already added
> 
> The value of ip gets updated inside the  "else if (tb[IPSET_ATTR_CIDR])"
> block but e.ip is still pointing to the old value.
>
> Reviewed-by: Joshua Hunt <johunt@akamai.com>
> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
> ---
>  net/netfilter/ipset/ip_set_hash_ip.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
> index dd30c03d5a23..258aeb324483 100644
> --- a/net/netfilter/ipset/ip_set_hash_ip.c
> +++ b/net/netfilter/ipset/ip_set_hash_ip.c
> @@ -120,12 +120,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>  		return ret;
>  
>  	ip &= ip_set_hostmask(h->netmask);
> -	e.ip = htonl(ip);
> -	if (e.ip == 0)
> +
> +	if (ip == 0)
>  		return -IPSET_ERR_HASH_ELEM;
>  
> -	if (adt == IPSET_TEST)
> +	if (adt == IPSET_TEST) {
> +		e.ip = htonl(ip);
>  		return adtfn(set, &e, &ext, &ext, flags);
> +	}
>  
>  	ip_to = ip;
>  	if (tb[IPSET_ATTR_IP_TO]) {
> @@ -145,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>  		ip_set_mask_from_to(ip, ip_to, cidr);
>  	}
>  
> +	e.ip = htonl(ip);
> +	if (e.ip == 0)
> +		return -IPSET_ERR_HASH_ELEM;
> +
>  	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
>  
>  	/* 64bit division is not allowed on 32bit */

You are right, however the patch can be made much smaller if the e.ip 
conversion is simply moved from

        if (retried) {
                ip = ntohl(h->next.ip);
                e.ip = htonl(ip);
        }

into the next for loop as the first instruction. Could you resend 
your patch that way?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
