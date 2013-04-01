From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Tue, 2 Apr 2013 01:29:47 +0200
Message-ID: <20130401232947.GA12381@localhost>
References: <20130323200402.209591997@eitzenberger.org>
 <20130323200608.668651644@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37935 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab3DAX3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:29:52 -0400
Content-Disposition: inline
In-Reply-To: <20130323200608.668651644@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Holger,

On Sat, Mar 23, 2013 at 09:04:05PM +0100, Holger Eitzenberger wrote:
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> Index: iptables/extensions/libxt_NFQUEUE.c
> ===================================================================
> --- iptables.orig/extensions/libxt_NFQUEUE.c	2013-03-23 19:43:11.000000000 +0100
> +++ iptables/extensions/libxt_NFQUEUE.c	2013-03-23 19:43:29.000000000 +0100
> @@ -13,8 +13,10 @@
>  	O_QUEUE_NUM = 0,
>  	O_QUEUE_BALANCE,
>  	O_QUEUE_BYPASS,
> +	O_QUEUE_CPU_FANOUT,
>  	F_QUEUE_NUM     = 1 << O_QUEUE_NUM,
>  	F_QUEUE_BALANCE = 1 << O_QUEUE_BALANCE,
> +	F_QUEUE_CPU_FANOUT = 1 << O_QUEUE_CPU_FANOUT,
>  };
>  
>  static void NFQUEUE_help(void)
> @@ -37,7 +39,15 @@
>  {
>  	NFQUEUE_help_v1();
>  	printf(
> -"  --queue-bypass		Bypass Queueing if no queue instance exists.\n");
> +"  --queue-bypass		Bypass Queueing if no queue instance exists.\n"
> +"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
> +}
> +
> +static void NFQUEUE_help_v3(void)
> +{
> +	NFQUEUE_help_v2();
> +	printf(
> +"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
>  }
>  
>  #define s struct xt_NFQ_info
> @@ -48,6 +58,8 @@
>  	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
>  	 .type = XTTYPE_UINT16RC, .excl = F_QUEUE_NUM},
>  	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
> +	{.name = "queue-cpu-fanout", .id = O_QUEUE_CPU_FANOUT,
> +	 .type = XTTYPE_NONE, .also = O_QUEUE_BALANCE},

I think we have to add O_QUEUE_CPU_FANOUT here to make sure both
queue-balance and queue-cpu-fanout are not used both incorrectly
together. That also needs some code a new .x6_fcheck function to
validate this.

Could you also send me the corresponding manpage update for this?

Thanks!
