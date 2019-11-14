Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95062C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 06:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0BE206CC
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 06:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfKNGC2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 01:02:28 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54126 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfKNGC2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 01:02:28 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 180503A22FD
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 17:02:13 +1100 (AEDT)
Received: (qmail 13530 invoked by uid 501); 14 Nov 2019 06:02:12 -0000
Date:   Thu, 14 Nov 2019 17:02:12 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: Make sure pktb_alloc() works for
 IPv6 over AF_BRIDGE
Message-ID: <20191114060212.GA24714@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191113230532.25178-1-duncan_roe@optusnet.com.au>
 <20191113231617.jcafbxgomhgfb3mt@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113231617.jcafbxgomhgfb3mt@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=Id7cGj7qYaGZZV57kh8A:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 14, 2019 at 12:16:17AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 14, 2019 at 10:05:32AM +1100, Duncan Roe wrote:
> > At least on the local interface, the MAC header of an IPv6 packet specifies
> > IPv6 protocol (rather than IP). This surprised me, since the first octet of
> > the IP datagram is the IP version, but I guess it's an efficiency thing.
> >
> > Without this patch, pktb_alloc() returns NULL when an IPv6 packet is
> > encountered.
> >
> > Updated:
> >
> >  src/extra/pktbuff.c: - Treat ETH_P_IPV6 the same as ETH_P_IP.
> >                       - Fix indenting around the affected code.
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  src/extra/pktbuff.c | 27 ++++++++++++++-------------
> >  1 file changed, 14 insertions(+), 13 deletions(-)
> >
> > diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> > index c52b674..c99a872 100644
> > --- a/src/extra/pktbuff.c
> > +++ b/src/extra/pktbuff.c
> > @@ -67,21 +67,22 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
> >  		pktb->network_header = pktb->data;
> >  		break;
> >  	case AF_BRIDGE: {
> > -		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> > -
> > -		pktb->mac_header = pktb->data;
> > -
> > -		switch(ethhdr->h_proto) {
> > -		case ETH_P_IP:
> > -			pktb->network_header = pktb->data + ETH_HLEN;
> > +			struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
>
> You can save one level of indentation here, right?

No, the patch introduced the new level because case AF_BRIDGE has a brace after
it, unlike e.g. case ETH_P_IP.
Without this extra indentation you get two consecutive brace lines with the
same indentation immediately before "return pktb;"
>
>   	case AF_BRIDGE: {
> 		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
>                 ...
>
> > +			pktb->mac_header = pktb->data;
> > +
> > +			switch(ethhdr->h_proto) {
> > +			case ETH_P_IP:
> > +			case ETH_P_IPV6:
> > +				pktb->network_header = pktb->data + ETH_HLEN;
> > +				break;
> > +			default:
> > +				/* This protocol is unsupported. */
> > +				free(pktb);
> > +				return NULL;
> > +			}
> >  			break;
> > -		default:
> > -			/* This protocol is unsupported. */
> > -			free(pktb);
> > -			return NULL;
> >  		}
> > -		break;
> > -	}
> >  	}
> >  	return pktb;
> >  }
> > --
> > 2.14.5
> >
