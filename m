From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Remove the duplicated word "see" in the
 comment when set the IPS_ASSURED_BIT in tcp_packet
Date: Wed, 19 Aug 2015 21:25:37 +0200
Message-ID: <20150819192537.GA4636@salvia>
References: <CA+6hz4o4TbcAhgnC8sbN6utxAR=wWOMkd_=k+hGVqW+tZZxuZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbHSTTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 15:19:23 -0400
Content-Disposition: inline
In-Reply-To: <CA+6hz4o4TbcAhgnC8sbN6utxAR=wWOMkd_=k+hGVqW+tZZxuZw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 13, 2015 at 04:22:28PM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> There is one duplicated word "see" in the comment when set the
> IPS_ASSURED_BIT in tcp_packet.
> 
> The attachment is the patch file.
> 
> The following is the change.
> 
> From d092aaa3dc847ed08b27081a467e39727d6627cb Mon Sep 17 00:00:00 2001
> From: Feng Gao <gfree.wind@gmail.com>
> Date: Thu, 13 Aug 2015 16:14:36 +0800
> Subject: [PATCH 1/1] netfilter: Remove the duplicated word "see" in the
>  comment when set the IPS_ASSURED_BIT in tcp_packet
> 
> Signed-off-by: Feng Gao <gfree.wind@gmail.com>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index 70383de..697210f 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1088,7 +1088,7 @@ static int tcp_packet(struct nf_conn *ct,
>            && (old_state == TCP_CONNTRACK_SYN_RECV
>                || old_state == TCP_CONNTRACK_ESTABLISHED)
>            && new_state == TCP_CONNTRACK_ESTABLISHED) {
> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
> +       /* Set ASSURED if we see valid ack in ESTABLISHED
>            after SYN_RECV or a valid answer for a picked up
>            connection. */

I think this is a good chance to fix the comment style, this should
be:

        /* Set ASSURED if we see valid ack in ESTABLISHED after
         * SYN_RECV or a valid answer for a picked up connection.
         */

Would you update the comment style in the same patch and resubmit,
please?

I'd also suggest a smaller patch title, eg.

netfilter: nf_ct_tcp: Remove the duplicated word in comment

Thanks!
