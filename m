From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] extra: fix wrong implementation in
 nfq_udp_get_payload_len
Date: Mon, 30 Jun 2014 12:11:08 +0200
Message-ID: <20140630101108.GC5038@localhost>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
 <1403260021-8732-3-git-send-email-lantw44@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: lantw44@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46167 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbaF3KLQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:11:16 -0400
Content-Disposition: inline
In-Reply-To: <1403260021-8732-3-git-send-email-lantw44@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 06:27:01PM +0800, lantw44@gmail.com wrote:
> From: Ting-Wei Lan <lantw44@gmail.com>
> 
> ---
>  src/extra/udp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/extra/udp.c b/src/extra/udp.c
> index 2a17a2f..64d3db4 100644
> --- a/src/extra/udp.c
> +++ b/src/extra/udp.c
> @@ -76,7 +76,7 @@ EXPORT_SYMBOL(nfq_udp_get_payload);
>   */
>  unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
>  {
> -	return pktb->tail - pktb->transport_header;
> +	return pktb->tail - pktb->transport_header - sizeof(struct udphdr);

I agree that this should substract the UDP header size, but:

1) This underflows the unsigned int if the UDP header is truncated.
2) This breaks the current behaviour, but we don't have any client in
   the tree for this code yet though.

Let's do it well, deprecate this interface and introduce a new one:

int nfq_udp_get_payload_length(struct udphdr *udph, struct pkt_buff *pktb)

Same thing for the tcp variant.

The deprecation can be achieved through this:

in __attribute__((deprecated) nfq_udp_get_payload_len(...)

in the header file.

Would you send me a patch for that, please?

BTW, please Signed-off-by your userspace patches too. Thanks.
