From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nftables: fix nf_trace always-on with
 XT_TRACE=n
Date: Sun, 16 Feb 2014 11:20:03 +0100
Message-ID: <20140216102003.GA4981@localhost>
References: <1392504525-21134-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45219 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaBPKUK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 05:20:10 -0500
Content-Disposition: inline
In-Reply-To: <1392504525-21134-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sat, Feb 15, 2014 at 11:48:45PM +0100, Florian Westphal wrote:
> When using nftables with CONFIG_NETFILTER_XT_TARGET_TRACE=n, we get
> lots of "TRACE: filter:output:policy:1 IN=..." warnings as several
> places will leave skb->nf_trace uninitialised.

Good catch.

> Unlike iptables tracing functionality is not conditional in nftables,
> so always copy/zero nf_trace setting when nftables is enabled.
> 
> Move this into __nf_copy() helper.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/skbuff.h | 5 ++++-
>  net/core/skbuff.c      | 3 ---
>  net/ipv4/ip_output.c   | 3 ---
>  net/ipv6/ip6_output.c  | 3 ---
>  4 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 1f689e6..99fc8b3 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2724,7 +2724,7 @@ static inline void nf_reset(struct sk_buff *skb)
>  
>  static inline void nf_reset_trace(struct sk_buff *skb)
>  {
> -#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
> +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)

Perhaps you can add a generic CONFIG_NF_TRACE that is set by xt_trace
and nf_tables?
