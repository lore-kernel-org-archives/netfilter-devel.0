From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter fixes for 2.6.37 (one leftover patch)
Date: Wed, 12 Jan 2011 20:40:06 +0100
Message-ID: <4D2E0396.2010205@netfilter.org>
References: <1294860598-15843-1-git-send-email-hidden@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42757 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab1ALTkL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:40:11 -0500
In-Reply-To: <1294860598-15843-1-git-send-email-hidden@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm sorry for impersonating Krisztian's identity, I used the wrong
script and it resulted in this error.

Sorry for the inconvenience.

On 12/01/11 20:29, KOVACS Krisztian wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi David,
> 
> I found one leftover patch from November 22th that was applied
> to Patrick's tree (nf-next-2.6) but it didn't ever take its way
> to reach net-2.6.
> 
> Can you still pass it to Linus?
> 
> You can pull it from:
> 
> git://1984.lsi.us.es/net-2.6 master
> 
> KOVACS Krisztian (1):
>   netfilter: fix compilation when conntrack is disabled but tproxy is
>     enabled
> 
>  include/linux/skbuff.h                         |   15 +++++++++++++++
>  include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   10 ----------
>  include/net/netfilter/ipv6/nf_defrag_ipv6.h    |   10 ++++++++++
>  net/core/skbuff.c                              |    2 ++
>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    8 +++++++-
>  5 files changed, 34 insertions(+), 11 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

