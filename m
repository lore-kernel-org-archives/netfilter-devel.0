From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: log: netns NULL ptr bug when calling from
 conntrack.
Date: Wed, 15 May 2013 14:00:13 +0200
Message-ID: <20130515120013.GA20074@localhost>
References: <1368617025-17375-1-git-send-email-hans@schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gaofeng@cn.fujitsu.com,
	fw@strlen.de, ronald645@gmail.com
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54692 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab3EOMAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 08:00:20 -0400
Content-Disposition: inline
In-Reply-To: <1368617025-17375-1-git-send-email-hans@schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Hans,

On Wed, May 15, 2013 at 01:23:45PM +0200, Hans Schillstrom wrote:
> When callling log functions from conntrack both in and out
> is NULL i.e. there exist no net pointer.
> 
> Adding struct net *net in call to nf_logfn() will secure that
> there always is a vaild net ptr.
> 
> Reported as bugzilla bug 818

This approach to fix it looks good. Thanks a lot!

Just resolved a minor nitpick:

> Reported-by: Ronald <ronald645@gmail.com>
> Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
> ---
>  include/net/netfilter/nf_log.h        |  3 ++-
>  include/net/netfilter/nfnetlink_log.h |  3 ++-
>  net/bridge/netfilter/ebt_log.c        |  5 ++---
>  net/bridge/netfilter/ebt_ulog.c       | 18 +++++++++++-------
>  net/ipv4/netfilter/ipt_ULOG.c         | 13 ++++++++-----
>  net/netfilter/nf_log.c                |  2 +-
>  net/netfilter/nfnetlink_log.c         |  4 ++--
>  net/netfilter/xt_LOG.c                | 13 +++++++------
>  net/netfilter/xt_NFLOG.c              |  3 ++-
>  9 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
> index 31f1fb9..99eac12 100644
> --- a/include/net/netfilter/nf_log.h
> +++ b/include/net/netfilter/nf_log.h
> @@ -30,7 +30,8 @@ struct nf_loginfo {
>  	} u;
>  };
>  
> -typedef void nf_logfn(u_int8_t pf,
> +typedef void nf_logfn(struct net *net,
> +		      u_int8_t pf,
>  		      unsigned int hooknum,
>  		      const struct sk_buff *skb,
>  		      const struct net_device *in,
> diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
> index e2dec42..5ca3f14 100644
> --- a/include/net/netfilter/nfnetlink_log.h
> +++ b/include/net/netfilter/nfnetlink_log.h
> @@ -2,7 +2,8 @@
>  #define _KER_NFNETLINK_LOG_H
>  
>  void
> -nfulnl_log_packet(u_int8_t pf,
> +nfulnl_log_packet(struct net *net,
> +		  u_int8_t pf,
>  		  unsigned int hooknum,
>  		  const struct sk_buff *skb,
>  		  const struct net_device *in,
> diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
> index 9878eb8..837612c 100644
> --- a/net/bridge/netfilter/ebt_log.c
> +++ b/net/bridge/netfilter/ebt_log.c
> @@ -72,13 +72,12 @@ print_ports(const struct sk_buff *skb, uint8_t protocol, int offset)
>  }
>  
>  static void
> -ebt_log_packet(u_int8_t pf, unsigned int hooknum,
> +ebt_log_packet(struct net *net, int8_t pf, unsigned int hooknum,

pf still has to be u_int8_t so I don't hit a compilation warning. No
need to resent I fixed it here.
