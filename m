From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: REJECT: separate reusable code
Date: Fri, 20 Dec 2013 10:50:59 +0100
Message-ID: <20131220095059.GA13371@localhost>
References: <1386722554-4827-1-git-send-email-eric@regit.org>
 <1386834281-28347-1-git-send-email-eric@regit.org>
 <1386834281-28347-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52852 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3LTJvE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:51:04 -0500
Content-Disposition: inline
In-Reply-To: <1386834281-28347-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

Some comments on this patch.

On Thu, Dec 12, 2013 at 08:44:40AM +0100, Eric Leblond wrote:
> This patch prepares the addition of TCP reset support in
> the nft_reject module by moving reusable code into a header
> file.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/net/netfilter/nf_reject.h | 297 ++++++++++++++++++++++++++++++++++++++
>  net/ipv4/netfilter/ipt_REJECT.c   | 124 +---------------
>  net/ipv6/netfilter/ip6t_REJECT.c  | 177 +----------------------
>  3 files changed, 307 insertions(+), 291 deletions(-)
>  create mode 100644 include/net/netfilter/nf_reject.h
> 
> diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
> new file mode 100644
> index 0000000..0bb089a
> --- /dev/null
> +++ b/include/net/netfilter/nf_reject.h
> @@ -0,0 +1,297 @@
> +#ifndef _NF_REJECT_H
> +#define _NF_REJECT_H
> +
> +#include <net/ip.h>
> +#include <net/tcp.h>
> +#include <net/route.h>
> +#include <net/dst.h>
> +
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +#include <net/ipv6.h>
> +#include <net/ip6_route.h>
> +#include <linux/netfilter_ipv6.h>
> +#endif
> +
> +static inline void send_unreach(struct sk_buff *skb_in, int code)
> +{
> +	icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
> +}
> +
> +/* Send RST reply */
> +static inline void send_reset(struct sk_buff *oldskb, int hook)

I think that this function is too large to use the inline approach
that we have used in nft_queue. I've been considering moving this
common code to a different module and export these symbols but I
don't find a nice way to make it.

So my suggestion is to have two different include files:

include/net/netfilter/ipv4/nf_reject.h, that contains:

        static inline void send_unreach(...
        static void send_reset(...

that you can include from ipt_REJECT and nft_reject.

And include/net/netfilter/ipv6/nf_reject.h, that contains:

        static inline void send_unreach6(...
        static void send_reset6(...

that you can include from ip6t_REJECT and nft_reject.

While at it, it is probably good to prepend the prefix nf_ to those
functions.

Let me know if you have any concern with this approach.
