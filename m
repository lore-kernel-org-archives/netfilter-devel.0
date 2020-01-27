Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC294C35240
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 01:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CB62083E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 01:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgA0Bov (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jan 2020 20:44:51 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38599 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgA0Bov (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jan 2020 20:44:51 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 22FD33A14E5
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2020 12:44:32 +1100 (AEDT)
Received: (qmail 15939 invoked by uid 501); 27 Jan 2020 01:44:31 -0000
Date:   Mon, 27 Jan 2020 12:44:31 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 0/1] New pktb_make() function
Message-ID: <20200127014431.GA15669@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
 <20200106031714.12390-1-duncan_roe@optusnet.com.au>
 <20200108225323.io724vuxuzsydjzs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108225323.io724vuxuzsydjzs@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=RSmzAf-M6YYA:10 a=uRtfhzloAAAA:20 a=9oqYtoJOvI0Ql0IrzWkA:9
        a=CjuIK1q_8ugA:10 a=ubDO4clxTgye4MFiUn6k:22 a=pHzHmUro8NiASowvMSCR:22
        a=xoEH_sTeL_Rfw54TyV31:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Jan 08, 2020 at 11:53:23PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 06, 2020 at 02:17:13PM +1100, Duncan Roe wrote:
> > This patch offers a faster alternative / replacement function to pktb_alloc().
> > 
> > pktb_make() is a copy of the first part of pktb_alloc() modified to use a
> > supplied buffer rather than calloc() one. It then calls the second part of
> > pktb_alloc() which is modified to be a static function.
> > 
> > Can't think of a use case where one would choose to use pktb_alloc over
> > pktb_make.
> > In a furure documentation update, might relegate pktb_alloc and pktb_free to
> > "other functions".
> 
> This is very useful.
> 
> Would you explore something looking similar to what I'm attaching?
> 
> Warning: Compile tested only :-)
> 
> Thanks.

> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index 6250fbf3ac8b..985bb48ac986 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -29,6 +29,58 @@
>   * @{
>   */
>  
> +static struct pkt_buff *__pktb_alloc(int family, void *data, size_t len,
> +				     size_t extra)
> +{
> +	struct pkt_buff *pktb;
> +
> +	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
> +	if (pktb == NULL)
> +		return NULL;
> +
> +	return pktb;
> +}
> +
> +static int pktb_setup_family(struct pkt_buff *pktb, int family)
> +{
> +	switch(family) {
> +	case AF_INET:
> +	case AF_INET6:
> +		pktb->network_header = pktb->data;
> +		break;
> +	case AF_BRIDGE: {
> +		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> +
> +		pktb->mac_header = pktb->data;
> +
> +		switch(ethhdr->h_proto) {
> +		case ETH_P_IP:
> +		case ETH_P_IPV6:
> +			pktb->network_header = pktb->data + ETH_HLEN;
> +			break;
> +		default:
> +			/* This protocol is unsupported. */
> +			errno = EPROTONOSUPPORT;
> +			return -1;
> +		}
> +		break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
> +				size_t len, size_t extra)
> +{
> +	pktb->len = len;
> +	pktb->data_len = len + extra;
> +
> +	pktb->head = pkt_data;
> +	pktb->data = pkt_data;
> +	pktb->tail = pktb->head + len;
> +}
> +
>  /**
>   * pktb_alloc - allocate a new packet buffer
>   * \param family Indicate what family. Currently supported families are
> @@ -54,45 +106,41 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  	struct pkt_buff *pktb;
>  	void *pkt_data;
>  
> -	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
> -	if (pktb == NULL)
> +	pktb = __pktb_alloc(family, data, len, extra);
> +	if (!pktb)
>  		return NULL;
>  
>  	/* Better make sure alignment is correct. */
>  	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
>  	memcpy(pkt_data, data, len);
>  
> -	pktb->len = len;
> -	pktb->data_len = len + extra;
> +	pktb_setup_metadata(pktb, pkt_data, len, extra);
>  
> -	pktb->head = pkt_data;
> -	pktb->data = pkt_data;
> -	pktb->tail = pktb->head + len;
> +	if (pktb_setup_family(pktb, family) < 0) {
> +		free(pktb);
> +		return NULL;
> +	}
>  
> -	switch(family) {
> -	case AF_INET:
> -	case AF_INET6:
> -		pktb->network_header = pktb->data;
> -		break;
> -	case AF_BRIDGE: {
> -		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> +	return pktb;
> +}
>  
> -		pktb->mac_header = pktb->data;
> +EXPORT_SYMBOL
> +struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len)
> +{
> +	struct pkt_buff *pktb;
>  
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
> -	}
> +	pktb = __pktb_alloc(family, data, 0, 0);
> +	if (!pktb)
> +		return NULL;
> +
> +	pktb->data = data;
> +	pktb_setup_metadata(pktb, data, len, 0);
> +
> +	if (pktb_setup_family(pktb, family) < 0) {
> +		free(pktb);
> +		return NULL;
>  	}
> +
>  	return pktb;
>  }
>  

The results are in. The spreadsheet is available at
https://github.com/duncan-roe/nfq/blob/master/nfq6/nfq6_timings.ods, but I'll
summarise them here.

Four functions are compared: pktb_alloc(), pktb_alloc_data(), pktb_make() and
pktb_make_data(). The timings for pktb_alloc & pktb_alloc_data include a call to
pktb_free(). When using pktb_make, one must not call pktb_free.

The test is to time calling the function (pair) 100000000 (1e8) times. In all
cases, this takes < 60 seconds. Two series of tests: one with 50-byte packets
(udp/IPv6, 2 data chars) and the other with 1500-byte (max MTU) packets.

Part-way through testing, pktb_make was improved to not zeroise the area into
which packet data will be copied. This is actually a tiny performance hit at
50-byte, could determine a crossover point at which to zeroise in 1 go but
didn't consider the extra complexity to be warrantied.

Here's a table of percentages:

bytes|pktb_alloc|pktb_alloc_data|pktb_make|pktb_make_data
-----|----------|---------------|---------|--------------
   50|       100|           56.2|     50.8|          28.9
-----|----------|---------------|---------|--------------
 1500|       100|           22.9|     59.6|          11.5

I have yet to do the doxygen documentation for the _data variants, then can send
in the code.

Cheers ... Duncan.
