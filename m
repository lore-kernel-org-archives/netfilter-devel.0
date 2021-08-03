Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE04FC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89CE60EC0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbhHCTax (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 15:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbhHCTax (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 15:30:53 -0400
X-Greylist: delayed 27953 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Aug 2021 12:30:42 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A04BC061757
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 12:30:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 613E7CC0101;
        Tue,  3 Aug 2021 21:30:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue,  3 Aug 2021 21:30:37 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id E13B9CC00FC;
        Tue,  3 Aug 2021 21:30:36 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D08AB340D60; Tue,  3 Aug 2021 21:30:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id CBB7B340D5D;
        Tue,  3 Aug 2021 21:30:36 +0200 (CEST)
Date:   Tue, 3 Aug 2021 21:30:36 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Nathan Chancellor <nathan@kernel.org>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] netfilter: ipset: Fix maximal range check in
 hash_ipportnet4_uadt()
In-Reply-To: <20210803191813.282980-1-nathan@kernel.org>
Message-ID: <df715f3-9a2a-5a88-5ab4-1f176ede79ed@netfilter.org>
References: <20210803191813.282980-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, 3 Aug 2021, Nathan Chancellor wrote:

> Clang warns:
> 
> net/netfilter/ipset/ip_set_hash_ipportnet.c:249:29: warning: variable
> 'port_to' is uninitialized when used here [-Wuninitialized]
>         if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
>                                    ^~~~~~~
> net/netfilter/ipset/ip_set_hash_ipportnet.c:167:45: note: initialize the
> variable 'port_to' to silence this warning
>         u32 ip = 0, ip_to = 0, p = 0, port, port_to;
>                                                    ^
>                                                     = 0
> net/netfilter/ipset/ip_set_hash_ipportnet.c:249:39: warning: variable
> 'port' is uninitialized when used here [-Wuninitialized]
>         if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
>                                              ^~~~
> net/netfilter/ipset/ip_set_hash_ipportnet.c:167:36: note: initialize the
> variable 'port' to silence this warning
>         u32 ip = 0, ip_to = 0, p = 0, port, port_to;
>                                           ^
>                                            = 0
> 2 warnings generated.
> 
> The range check was added before port and port_to are initialized.
> Shuffle the check after the initialization so that the check works
> properly.
> 
> Fixes: 7fb6c63025ff ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yes, good catch!

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
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
> 
> base-commit: 4d3fc8ead710a06c98d36f382777c6a843a83b7c
> -- 
> 2.33.0.rc0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary

