From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] net: netfilter: combine ipt_REDIRECT and
 ip6t_REDIRECT
Date: Fri, 21 Sep 2012 12:11:32 +0200
Message-ID: <20120921101132.GB24612@1984>
References: <1347586832-6190-1-git-send-email-jengelh@inai.de>
 <1347586832-6190-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999Ab2IUKLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:11:43 -0400
Content-Disposition: inline
In-Reply-To: <1347586832-6190-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 14, 2012 at 03:40:32AM +0200, Jan Engelhardt wrote:
> (Same rationale as previous commit.)

Please, even if the changelog is very similar, I prefer if you
duplicate. This is good later on in case you want to check the
history, in that case we may not see the previous commit.

And more thing regarding this patch:

> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  net/ipv4/netfilter/Kconfig         |   12 +--
>  net/ipv4/netfilter/Makefile        |    1 -
>  net/ipv6/netfilter/Kconfig         |   11 ---
>  net/ipv6/netfilter/Makefile        |    1 -
>  net/ipv6/netfilter/ip6t_REDIRECT.c |   98 -------------------
>  net/netfilter/Kconfig              |   11 +++
>  net/netfilter/Makefile             |    1 +
>  net/netfilter/xt_REDIRECT.c        |  190 ++++++++++++++++++++++++++++++++++++

It seems you forgot to delete ipt_REDIRECT.c, I've done it myself.

So this patch applied as well.
