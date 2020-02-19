Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6786FC34056
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 18:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4716E206DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 18:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgBSSEP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:04:15 -0500
Received: from correo.us.es ([193.147.175.20]:54836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbgBSSEO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 13:04:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6069BF23AC
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 19:04:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 524C3DA3C2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 19:04:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51A61DA840; Wed, 19 Feb 2020 19:04:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 490F6DA3AE;
        Wed, 19 Feb 2020 19:04:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 19:04:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2B13042EF52A;
        Wed, 19 Feb 2020 19:04:10 +0100 (CET)
Date:   Wed, 19 Feb 2020 19:04:10 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2] src: Add faster alternatives to
 pktb_alloc()
Message-ID: <20200219180410.e56psjovne3y43rc@salvia>
References: <20200108225323.io724vuxuzsydjzs@salvia>
 <20200201062127.4729-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201062127.4729-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 01, 2020 at 05:21:27PM +1100, Duncan Roe wrote:
> Functions pktb_alloc_data, pktb_make and pktb_make_data are defined.
> The pktb_make pair are syggested as replacements for the pktb_alloc (now) pair
> because they are always faster.
> 
> - Add prototypes to include/libnetfilter_queue/pktbuff.h
> - Add pktb_alloc_data much as per Pablo's email of Wed, 8 Jan 2020
>   speedup: point to packet data in netlink receive buffer rather than copy to
>            area immediately following pktb struct
> - Add pktb_make much like pktb_usebuf proposed on 10 Dec 2019
>   2 sppedups: 1. Use an existing buffer rather than calloc and (later) free one.
>               2. Only zero struct and extra parts of pktb - the rest is
>                  overwritten by copy (calloc has to zero the lot).
> - Add pktb_make_data
>   3 speedups: All of the above
> - Document the new functions
> - Move pktb_alloc and pktb_alloc_data into the "other functions" group since
>   they are slower than the "make" equivalent functions
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  include/libnetfilter_queue/pktbuff.h |   3 +
>  src/extra/pktbuff.c                  | 296 ++++++++++++++++++++++++++++++-----
>  2 files changed, 261 insertions(+), 38 deletions(-)
> 
> diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
> index 42bc153..fc6bf01 100644
> --- a/include/libnetfilter_queue/pktbuff.h
> +++ b/include/libnetfilter_queue/pktbuff.h
> @@ -4,6 +4,9 @@
>  struct pkt_buff;
>  
>  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
> +struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len);
> +struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
> +struct pkt_buff *pktb_make_data(int family, void *data, size_t len, void *buf, size_t bufsize);

Hm, when I delivered the patch to you, I forgot that you main point
was that you wanted to skip the memory allocation.

I wonder if all these new functions can be consolidated into one
single function, something like:

        struct pkt_buff *pktb_alloc2(int family, void *head, size_t head_size, void *data, size_t len, size_t extra);

The idea is that:

* head is the memory area that is large enough for the struct pkt_buff
  (metadata). You can add a new pktb_head_size() function that returns
  the size of opaque struct pkt_buff structure (whose layout is not
  exposed to the user). I think you can this void *buf in your pktb_make
  function.

* data is the memory area to store the network packet itself.

Then, you can allocate head and data in the stack and skip
malloc/calloc.

Would this work for you? I would prefer if there is just one single
advanced function to do this.

Thanks for your patience.
