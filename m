Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F92C32771
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 02:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79BF20673
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 02:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgAJC2S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 21:28:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52816 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730858AbgAJC2S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 21:28:18 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 943533A1CD8
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 13:27:58 +1100 (AEDT)
Received: (qmail 22473 invoked by uid 501); 10 Jan 2020 02:27:57 -0000
Date:   Fri, 10 Jan 2020 13:27:57 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 0/1] New pktb_make() function
Message-ID: <20200110022757.GA15290@dimstar.local.net>
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
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=RSmzAf-M6YYA:10 a=6B67lDsGwmQYY0UB8a8A:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

GRR! I just wasted 20 minutes looking at these last 3 lines. Fix the indentation

> +	}
> +
> +	return 0;
> +}
> +
> +static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
> +				size_t len, size_t extra)
> +{
> +	pktb->len = len;

You know, we only need any 2 of len, data and tail. This has caused bugs in the
past, e.g. commit 8a4316f31. In the code, len seems to be the least used - will
see if I can't get rid of it.

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

Ok, so this is another approach to reducing CPU time: avoid memcpy of data.

That's great if you're not mangling content.

But if you are mangling, beware. pktb now has pointers into the buffer you used
for receiving from Netlink so you must use a different buffer when sending.

I'll be updating my performance testing regime to get results more quickly, so
will be reporting back at some stage. It remains the case that malloc / free
were taking at least 5% of overall CPU with short packets (and btw most of that
is free(): as a rule of thumb I have found free cpu = 3 * malloc cpu)
