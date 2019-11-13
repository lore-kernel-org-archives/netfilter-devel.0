Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EFBC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922B3206EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKMXQW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:16:22 -0500
Received: from correo.us.es ([193.147.175.20]:40446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfKMXQW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 18:16:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6327DC510B
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:16:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52745CF8A2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:16:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 480C2D1929; Thu, 14 Nov 2019 00:16:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3411ED1DBB;
        Thu, 14 Nov 2019 00:16:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Nov 2019 00:16:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0C90142EE38E;
        Thu, 14 Nov 2019 00:16:15 +0100 (CET)
Date:   Thu, 14 Nov 2019 00:16:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: Make sure pktb_alloc() works for
 IPv6 over AF_BRIDGE
Message-ID: <20191113231617.jcafbxgomhgfb3mt@salvia>
References: <20191113230532.25178-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113230532.25178-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 14, 2019 at 10:05:32AM +1100, Duncan Roe wrote:
> At least on the local interface, the MAC header of an IPv6 packet specifies
> IPv6 protocol (rather than IP). This surprised me, since the first octet of
> the IP datagram is the IP version, but I guess it's an efficiency thing.
> 
> Without this patch, pktb_alloc() returns NULL when an IPv6 packet is
> encountered.
> 
> Updated:
> 
>  src/extra/pktbuff.c: - Treat ETH_P_IPV6 the same as ETH_P_IP.
>                       - Fix indenting around the affected code.
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/extra/pktbuff.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
> index c52b674..c99a872 100644
> --- a/src/extra/pktbuff.c
> +++ b/src/extra/pktbuff.c
> @@ -67,21 +67,22 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
>  		pktb->network_header = pktb->data;
>  		break;
>  	case AF_BRIDGE: {
> -		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
> -
> -		pktb->mac_header = pktb->data;
> -
> -		switch(ethhdr->h_proto) {
> -		case ETH_P_IP:
> -			pktb->network_header = pktb->data + ETH_HLEN;
> +			struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;

You can save one level of indentation here, right?

  	case AF_BRIDGE: {
		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
                ...

> +			pktb->mac_header = pktb->data;
> +
> +			switch(ethhdr->h_proto) {
> +			case ETH_P_IP:
> +			case ETH_P_IPV6:
> +				pktb->network_header = pktb->data + ETH_HLEN;
> +				break;
> +			default:
> +				/* This protocol is unsupported. */
> +				free(pktb);
> +				return NULL;
> +			}
>  			break;
> -		default:
> -			/* This protocol is unsupported. */
> -			free(pktb);
> -			return NULL;
>  		}
> -		break;
> -	}
>  	}
>  	return pktb;
>  }
> -- 
> 2.14.5
> 
