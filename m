Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E832C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F4C64D9D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhBIQbg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:31:36 -0500
Received: from correo.us.es ([193.147.175.20]:41658 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBIQbZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 11:31:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0AB732AB08B
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 17:30:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F034FDA7B6
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 17:30:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5734DA794; Tue,  9 Feb 2021 17:30:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C19CEDA78F;
        Tue,  9 Feb 2021 17:30:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 17:30:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A167C42DC6DF;
        Tue,  9 Feb 2021 17:30:42 +0100 (CET)
Date:   Tue, 9 Feb 2021 17:30:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Etan Kissling <etan_kissling@apple.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: fix IPv6 header handling
Message-ID: <20210209163042.GA6746@salvia>
References: <28947A39-55C4-4C68-8421-DEC950CF7963@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <28947A39-55C4-4C68-8421-DEC950CF7963@apple.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Etan,

On Wed, Jan 13, 2021 at 10:58:52AM +0100, Etan Kissling wrote:
> diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
> index 42c5e25..1eb822f 100644
> --- a/src/extra/ipv6.c
> +++ b/src/extra/ipv6.c
> @@ -72,7 +72,8 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,

Note: nfq_ip6_set_transport_header() is very much similar to
ipv6_skip_exthdr() in the Linux kernel, see net/ipv6/exthdrs_core.c

>  		uint32_t hdrlen;
>  
>  		/* No more extensions, we're done. */
> -		if (nexthdr == IPPROTO_NONE) {
> +		if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP || nexthdr == IPPROTO_ESP ||
> +		        nexthdr == IPPROTO_ICMPV6 || nexthdr == IPPROTO_NONE) {
>  			cur = NULL;
>  			break;
>  		}
> @@ -107,7 +108,7 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
>  		} else if (nexthdr == IPPROTO_AH)
>  			hdrlen = (ip6_ext->ip6e_len + 2) << 2;
>  		else
> -			hdrlen = ip6_ext->ip6e_len;
> +			hdrlen = (ip6_ext->ip6e_len + 1) << 3;

This looks correct, IPv6 optlen is miscalculated.

The chunk above to stop the iteration, so I think the chunk that fixes
optlen is sufficient to fix the bug.

Thanks.
