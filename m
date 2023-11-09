Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABF8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 15:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbjKIPYQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 10:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjKIPYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 10:24:16 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0440A30DC
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 07:24:14 -0800 (PST)
Received: from [78.30.43.141] (port=36150 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r16t8-00F80j-DH; Thu, 09 Nov 2023 16:24:12 +0100
Date:   Thu, 9 Nov 2023 16:24:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] utils: add memory_allocation_check() helper
Message-ID: <ZUz5mWjHQjXkU6If@calendula>
References: <20231108182431.4005745-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231108182431.4005745-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 08, 2023 at 07:24:24PM +0100, Thomas Haller wrote:
> libnftables kills the process on out of memory (xmalloc()), so
> when we use libraries that propagate ENOMEM to libnftables, we
> also abort the process.
> 
> For example:
> 
>      nlr = nftnl_rule_alloc();
>      if (!nlr)
>           memory_allocation_error();
> 
> Add memory_allocation_check() macro which can simplify this common
> check to:
> 
>      nlr = memory_allocation_check(nftnl_rule_alloc());
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/utils.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 36a28f893667..fcd7c598fe9f 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -142,6 +142,16 @@ extern void __memory_allocation_error(const char *filename, uint32_t line) __nor
>  #define memory_allocation_error()		\
>  	__memory_allocation_error(__FILE__, __LINE__);
>  
> +#define memory_allocation_check(cmd)               \
> +	({                                         \
> +		typeof((cmd)) _v = (cmd);          \
> +		const void *const _v2 = _v;        \
> +                                                   \
> +		if (!_v2)                          \

please don't hide a if branch inside a macro.

> +			memory_allocation_error(); \
> +		_v;                                \
> +	})
> +
>  extern void xfree(const void *ptr);
>  extern void *xmalloc(size_t size);
>  extern void *xmalloc_array(size_t nmemb, size_t size);
> -- 
> 2.41.0
> 
