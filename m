Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9750CC43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 00:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631CA205ED
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 00:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfLGAX3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 19:23:29 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52828 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726374AbfLGAX3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 19:23:29 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 5381A3A2415
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 11:23:12 +1100 (AEDT)
Received: (qmail 9074 invoked by uid 501); 7 Dec 2019 00:23:11 -0000
Date:   Sat, 7 Dec 2019 11:23:11 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: Fix test for IPv6 header
Message-ID: <20191207002311.GA5579@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191124023310.18200-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124023310.18200-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=cXhL2gqTqaYtY7s1JlIA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Nov 24, 2019 at 01:33:10PM +1100, Duncan Roe wrote:
> Updated:
>
>  src/extra/ipv6.c: Only test the first 4 bits of the putative IPv6 header to be
>                    6, since all the other bits are up for grabs.
>                    (I have seen nonzero Flow Control on the local interface and
>                    RFC2474 & RFC3168 document Traffic Class use).
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/extra/ipv6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
> index af307d6..f685b3b 100644
> --- a/src/extra/ipv6.c
> +++ b/src/extra/ipv6.c
> @@ -45,7 +45,7 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
>  	ip6h = (struct ip6_hdr *)pktb->network_header;
>
>  	/* Not IPv6 packet. */
> -	if (ip6h->ip6_flow != 0x60)
> +	if ((*(uint8_t *)ip6h & 0xf0) != 0x60)
>  		return NULL;
>
>  	return ip6h;
> --
> 2.14.5
>
This patch is uncontroversial surely?

Cheers ... Duncan.
