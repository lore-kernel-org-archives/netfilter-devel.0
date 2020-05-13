Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF28C2D0F8
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 07:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95A4C206F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 07:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgEMHAc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 03:00:32 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:54977 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgEMHAc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 03:00:32 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id BC8701033ED
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 16:41:57 +1000 (AEST)
Received: (qmail 28373 invoked by uid 501); 13 May 2020 06:41:56 -0000
Date:   Wed, 13 May 2020 16:41:56 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/2] pktbuff: add __pktb_setup()
Message-ID: <20200513064156.GA23132@dimstar.local.net>
Mail-Followup-To: netfilter-devel@vger.kernel.org
References: <20200509091141.10619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509091141.10619-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=3HDBlxybAAAA:8
        a=OLL_FvSJAAAA:8 a=FP02F9W6yDWWtxF3HUgA:9 a=CjuIK1q_8ugA:10
        a=OVJnjtlDKZIA:10 a=AH0NCSqBHYIA:10 a=laEoCiVfU_Unz3mSdgXN:22
        a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 09, 2020 at 11:11:40AM +0200, Pablo Neira Ayuso wrote:
> Add private helper function to set up the pkt_buff object.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/extra/pktbuff.c | 54 +++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 22 deletions(-)
>
> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index 6dd0ca98aff2..118ad898f63b 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -29,6 +29,34 @@
>   * @{
>   */
>
> +static int __pktb_setup(int family, struct pkt_buff *pktb)

Apart from breakage, this is pktb_setup_family() as I posted in
https://www.spinics.net/lists/netfilter-devel/msg66710.html, with args reversed.

I also added pktb_setup_metadata() to capture 3 other duplicate code lines,
you may not think that worth doing: personal choice I guess.

> +{
> +	struct ethhdr *ethhdr;
> +
> +	switch (family) {
> +	case AF_INET:
> +	case AF_INET6:
> +		pktb->network_header = pktb->data;
> +		break;
> +	case AF_BRIDGE:
> +		ethhdr = (struct ethhdr *)pktb->data;
> +		pktb->mac_header = pktb->data;
> +
> +		switch(ethhdr->h_proto) {
> +		case ETH_P_IP:
> +		case ETH_P_IPV6:
> +			pktb->network_header = pktb->data + ETH_HLEN;
> +			break;
> +		default:
> +			/* This protocol is unsupported. */

Should have moved 'errno = EPROTONOSUPPORT;' here rather than leaving it in
pktb_alloc(). As things stand, pktb_setup() will leave errno unaltered when
this error occurs.

> +			return -1;
> +		}
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * pktb_alloc - allocate a new packet buffer
>   * \param family Indicate what family. Currently supported families are
> @@ -52,7 +80,6 @@ EXPORT_SYMBOL
>  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  {
>  	struct pkt_buff *pktb;
> -	struct ethhdr *ethhdr;
>  	void *pkt_data;
>
>  	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
> @@ -68,28 +95,11 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>
>  	pktb->data = pkt_data;
>
> -	switch(family) {
> -	case AF_INET:
> -	case AF_INET6:
> -		pktb->network_header = pktb->data;
> -		break;
> -	case AF_BRIDGE:
> -		ethhdr = (struct ethhdr *)pktb->data;
> -		pktb->mac_header = pktb->data;
> -
> -		switch(ethhdr->h_proto) {
> -		case ETH_P_IP:
> -		case ETH_P_IPV6:
> -			pktb->network_header = pktb->data + ETH_HLEN;
> -			break;
> -		default:
> -			/* This protocol is unsupported. */
> -			errno = EPROTONOSUPPORT;
> -			free(pktb);
> -			return NULL;
> -		}
> -		break;
> +	if (__pktb_setup(family, pktb) < 0) {
> +		errno = EPROTONOSUPPORT;

As before, above line belongs in __pktb_setup()

> +		free(pktb);

You need 'return NULL;' here, as in the original code.

>  	}
> +
>  	return pktb;
>  }
>
> --
> 2.20.1
>
