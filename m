From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] extra: fix wrong implementation in
 nfq_udp_get_payload
Date: Mon, 30 Jun 2014 12:02:29 +0200
Message-ID: <20140630100229.GB5038@localhost>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
 <1403260021-8732-2-git-send-email-lantw44@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: lantw44@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43381 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbaF3KCe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:02:34 -0400
Content-Disposition: inline
In-Reply-To: <1403260021-8732-2-git-send-email-lantw44@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 06:27:00PM +0800, lantw44@gmail.com wrote:
> From: Ting-Wei Lan <lantw44@gmail.com>
> 
> ---
>  src/extra/udp.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/src/extra/udp.c b/src/extra/udp.c
> index eee732e..2a17a2f 100644
> --- a/src/extra/udp.c
> +++ b/src/extra/udp.c
> @@ -56,13 +56,17 @@ EXPORT_SYMBOL(nfq_udp_get_hdr);
>   */
>  void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
>  {
> -	unsigned int doff = udph->len;
> +	uint16_t len = ntohs (udph->len);
                            ^

removed this space.

Applied, thanks.
