Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC943C33CA9
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79788207E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAMSv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:51:56 -0500
Received: from correo.us.es ([193.147.175.20]:48586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgAMSvz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 13:51:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0CD218D004
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:51:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFE01DA702
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:51:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A555FDA71A; Mon, 13 Jan 2020 19:51:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 688C9DA709
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:51:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 19:51:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 448BD42EF52A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:51:51 +0100 (CET)
Date:   Mon, 13 Jan 2020 19:51:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 0/1] New pktb_make() function
Message-ID: <20200113185150.xkxyys3psvddq2g5@salvia>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
 <20200106031714.12390-1-duncan_roe@optusnet.com.au>
 <20200108225323.io724vuxuzsydjzs@salvia>
 <20200110022757.GA15290@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110022757.GA15290@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 10, 2020 at 01:27:57PM +1100, Duncan Roe wrote:
> On Wed, Jan 08, 2020 at 11:53:23PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Jan 06, 2020 at 02:17:13PM +1100, Duncan Roe wrote:
> > > This patch offers a faster alternative / replacement function to pktb_alloc().
> > >
> > > pktb_make() is a copy of the first part of pktb_alloc() modified to use a
> > > supplied buffer rather than calloc() one. It then calls the second part of
> > > pktb_alloc() which is modified to be a static function.
> > >
> > > Can't think of a use case where one would choose to use pktb_alloc over
> > > pktb_make.
> > > In a furure documentation update, might relegate pktb_alloc and pktb_free to
> > > "other functions".
> >
> > This is very useful.
> >
> > Would you explore something looking similar to what I'm attaching?
> >
> > Warning: Compile tested only :-)
> >
> > Thanks.
> 
> > diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> > index 6250fbf3ac8b..985bb48ac986 100644
> > --- a/src/extra/pktbuff.c
> > +++ b/src/extra/pktbuff.c
> > @@ -29,6 +29,58 @@
> >   * @{
> >   */
> >
> > +static struct pkt_buff *__pktb_alloc(int family, void *data, size_t len,
> > +				     size_t extra)
> > +{
> > +	struct pkt_buff *pktb;
> > +
> > +	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
> > +	if (pktb == NULL)
> > +		return NULL;
> > +
> > +	return pktb;
> > +}
> > +
> > +static int pktb_setup_family(struct pkt_buff *pktb, int family)
> > +{
> > +	switch(family) {
> > +	case AF_INET:
> > +	case AF_INET6:
> > +		pktb->network_header = pktb->data;
> > +		break;
> > +	case AF_BRIDGE: {
> > +		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> > +
> > +		pktb->mac_header = pktb->data;
> > +
> > +		switch(ethhdr->h_proto) {
> > +		case ETH_P_IP:
> > +		case ETH_P_IPV6:
> > +			pktb->network_header = pktb->data + ETH_HLEN;
> > +			break;
> > +		default:
> > +			/* This protocol is unsupported. */
> > +			errno = EPROTONOSUPPORT;
> > +			return -1;
> > +		}
> > +		break;
> > +		}
> 
> GRR! I just wasted 20 minutes looking at these last 3 lines. Fix the indentation
> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
> > +				size_t len, size_t extra)
> > +{
> > +	pktb->len = len;
> 
> You know, we only need any 2 of len, data and tail. This has caused bugs in the
> past, e.g. commit 8a4316f31. In the code, len seems to be the least used - will
> see if I can't get rid of it.
> 
> > +	pktb->data_len = len + extra;
> > +
> > +	pktb->head = pkt_data;
> > +	pktb->data = pkt_data;
> > +	pktb->tail = pktb->head + len;
> > +}
> > +
> >  /**
> >   * pktb_alloc - allocate a new packet buffer
> >   * \param family Indicate what family. Currently supported families are
> > @@ -54,45 +106,41 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
> >  	struct pkt_buff *pktb;
> >  	void *pkt_data;
> >
> > -	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
> > -	if (pktb == NULL)
> > +	pktb = __pktb_alloc(family, data, len, extra);
> > +	if (!pktb)
> >  		return NULL;
> >
> >  	/* Better make sure alignment is correct. */
> >  	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
> >  	memcpy(pkt_data, data, len);
> >
> > -	pktb->len = len;
> > -	pktb->data_len = len + extra;
> > +	pktb_setup_metadata(pktb, pkt_data, len, extra);
> >
> > -	pktb->head = pkt_data;
> > -	pktb->data = pkt_data;
> > -	pktb->tail = pktb->head + len;
> > +	if (pktb_setup_family(pktb, family) < 0) {
> > +		free(pktb);
> > +		return NULL;
> > +	}
> >
> > -	switch(family) {
> > -	case AF_INET:
> > -	case AF_INET6:
> > -		pktb->network_header = pktb->data;
> > -		break;
> > -	case AF_BRIDGE: {
> > -		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> > +	return pktb;
> > +}
> >
> > -		pktb->mac_header = pktb->data;
> > +EXPORT_SYMBOL
> > +struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len)
> > +{
> > +	struct pkt_buff *pktb;
> >
> > -		switch(ethhdr->h_proto) {
> > -		case ETH_P_IP:
> > -		case ETH_P_IPV6:
> > -			pktb->network_header = pktb->data + ETH_HLEN;
> > -			break;
> > -		default:
> > -			/* This protocol is unsupported. */
> > -			errno = EPROTONOSUPPORT;
> > -			free(pktb);
> > -			return NULL;
> > -		}
> > -		break;
> > -	}
> > +	pktb = __pktb_alloc(family, data, 0, 0);
> > +	if (!pktb)
> > +		return NULL;
> > +
> > +	pktb->data = data;
> > +	pktb_setup_metadata(pktb, data, len, 0);
> > +
> > +	if (pktb_setup_family(pktb, family) < 0) {
> > +		free(pktb);
> > +		return NULL;
> >  	}
> > +
> >  	return pktb;
> >  }
> >
> 
> Ok, so this is another approach to reducing CPU time: avoid memcpy of data.
> 
> That's great if you're not mangling content.
> 
> But if you are mangling, beware. pktb now has pointers into the buffer you used
> for receiving from Netlink so you must use a different buffer when sending.

Probably we can store a flag in the pkt_buff structure to say "this
buffer is now ours" so mangling can just trigger a clone via malloc()
+ memcpy() only for that path.

Or you can just document this, although handling this case for the
library would be make it easier to user for users.

Thanks.
