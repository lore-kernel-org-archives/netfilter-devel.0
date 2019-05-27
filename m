Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294B3C07542
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 20:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F190320883
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 20:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfE0UFU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 16:05:20 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37106 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbfE0UFU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 16:05:20 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hVLrx-00008c-IH; Mon, 27 May 2019 22:05:17 +0200
Date:   Mon, 27 May 2019 22:05:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 4/4] netfilter: add NF_SYNPROXY symbol
Message-ID: <20190527200517.ooiafr64q7fscfwv@breakpoint.cc>
References: <20190524170106.2686-1-ffmancera@riseup.net>
 <20190524170106.2686-5-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524170106.2686-5-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  net/ipv4/netfilter/Kconfig | 2 +-
>  net/ipv6/netfilter/Kconfig | 2 +-
>  net/netfilter/Kconfig      | 4 ++++
>  net/netfilter/Makefile     | 1 +
>  4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 1412b029f37f..87f6ec800e54 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -197,7 +197,7 @@ config IP_NF_TARGET_SYNPROXY
>  	tristate "SYNPROXY target support"
>  	depends on NF_CONNTRACK && NETFILTER_ADVANCED
>  	select NETFILTER_SYNPROXY
> -	select SYN_COOKIES
> +	select NF_SYNPROXY

What is the difference between NETFILTER_SYNPROXY and
NF_SYNPROXY?

Any chance we can ...

> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 72cca6b48960..7a6067513eee 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -67,6 +67,7 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
>  
>  # SYNPROXY
>  obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
> +obj-$(CONFIG_NF_SYNPROXY) += nf_synproxy.o

... make nf_synproxy.o and nf_synproxy_core.o be part
of same module?

(Or place it even in same .c file?)
