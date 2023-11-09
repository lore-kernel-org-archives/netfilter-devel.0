Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E1AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjKIPOW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjKIPOV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:14:21 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AC62D62
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:14:19 -0800 (PST)
Received: from [78.30.43.141] (port=53640 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r16jU-00F5HF-Dt; Thu, 09 Nov 2023 16:14:14 +0100
Date:   Thu, 9 Nov 2023 16:14:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] netlink: add and use _nftnl_udata_buf_alloc()
 helper
Message-ID: <ZUz3Q5MNVxsXo0Wy@calendula>
References: <20231108182431.4005745-1-thaller@redhat.com>
 <20231108182431.4005745-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231108182431.4005745-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 08, 2023 at 07:24:25PM +0100, Thomas Haller wrote:
> We don't want to handle allocation errors, but crash via memory_allocation_error().
> Also, we usually just allocate NFT_USERDATA_MAXLEN buffers.
> 
> Add a helper for that and use it.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/netlink.h       |  3 +++
>  src/mnl.c               | 16 ++++------------
>  src/netlink.c           |  7 ++-----
>  src/netlink_linearize.c |  4 +---
>  4 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/include/netlink.h b/include/netlink.h
> index 6766d7e8563f..15cbb332c8dd 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -260,4 +260,7 @@ struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
>  
>  struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx);
>  
> +#define _nftnl_udata_buf_alloc() \
> +	memory_allocation_check(nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN))

Add a wrapper function, no macro.
