Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7CEC04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77FD20673
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 21:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfE0VeI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 17:34:08 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37368 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbfE0VeI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 17:34:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hVNFu-0000W8-Gs; Mon, 27 May 2019 23:34:06 +0200
Date:   Mon, 27 May 2019 23:34:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 4/4] netfilter: add NF_SYNPROXY symbol
Message-ID: <20190527213406.4v7ctawdoxf5tyeb@breakpoint.cc>
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

Careful.  This means I can now create a kernel config with
IP_NF_TARGET_SYNPROXY=y
SYN_COOKIES=n

... and that will fail to build.
