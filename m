Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAC0C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCAF5206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfL3Ldu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:33:50 -0500
Received: from correo.us.es ([193.147.175.20]:37958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbfL3Ldu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:33:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44692A1A32B
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:33:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 358EEDA70F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:33:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B578DA703; Mon, 30 Dec 2019 12:33:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33FDFDA720;
        Mon, 30 Dec 2019 12:33:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:33:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [185.124.28.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E142542EE38E;
        Mon, 30 Dec 2019 12:33:45 +0100 (CET)
Date:   Mon, 30 Dec 2019 12:33:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/2] src: more IPv6 checksum fixes
Message-ID: <20191230113345.olr3yifqqmytv3ce@salvia>
References: <20191220055348.24113-1-duncan_roe@optusnet.com.au>
 <20191220055348.24113-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220055348.24113-2-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied, thanks for fixing up this. Comment below.

On Fri, Dec 20, 2019 at 04:53:47PM +1100, Duncan Roe wrote:
> diff --git a/src/extra/checksum.c b/src/extra/checksum.c
> index 42389aa..8b23997 100644
> --- a/src/extra/checksum.c
> +++ b/src/extra/checksum.c
> @@ -62,21 +62,21 @@ uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
>  				  uint16_t protonum)
>  {
>  	uint32_t sum = 0;
> -	uint32_t hdr_len = (uint32_t *)transport_hdr - (uint32_t *)ip6h;
> -	uint32_t len = ip6h->ip6_plen - hdr_len;
> +	uint32_t hdr_len = (uint8_t *)transport_hdr - (uint8_t *)ip6h;
> +	/* Allow for extra headers before the UDP header */
> +	/* TODO: Deal with routing headers */
> +	uint32_t len = ntohs(ip6h->ip6_plen) - (hdr_len - sizeof *ip6h);
>  	uint8_t *payload = (uint8_t *)ip6h + hdr_len;
>  	int i;
>  
>  	for (i=0; i<8; i++) {
> -		sum += (ip6h->ip6_src.s6_addr16[i] >> 16) & 0xFFFF;
>  		sum += (ip6h->ip6_src.s6_addr16[i]) & 0xFFFF;

I think you can also send a follow up to clean up this: Remove the 0xFFFF.
