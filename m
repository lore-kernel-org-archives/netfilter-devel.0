Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE825C83F1B
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbjH3Sit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242390AbjH3IYD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 04:24:03 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0194DFB
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 01:24:00 -0700 (PDT)
Received: from [78.30.34.192] (port=51132 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbGUW-000zKN-EB; Wed, 30 Aug 2023 10:23:59 +0200
Date:   Wed, 30 Aug 2023 10:23:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/5] datatype: check against negative "type" argument
 in datatype_lookup()
Message-ID: <ZO78m/9YMRtk0oY/@calendula>
References: <20230829185509.374614-1-thaller@redhat.com>
 <20230829185509.374614-6-thaller@redhat.com>
 <ZO5Cnmck5tKCvVFE@calendula>
 <ZO5DsA4eCnYkEWxC@calendula>
 <c452805919f688f15a95e52139c8686e1a6571a1.camel@redhat.com>
 <ZO7zuKiWk3x7E5bS@calendula>
 <29aee24e1fb3e7b273b48ee3d735f182c62a0d92.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29aee24e1fb3e7b273b48ee3d735f182c62a0d92.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 30, 2023 at 10:08:50AM +0200, Thomas Haller wrote:
[...]
> I don't think it suffices. The following fail the assertion (or would
> access out of bounds).
> 
> 
> diff --git c/include/datatype.h i/include/datatype.h
> index 9ce7359cd340..7d3b6b20d27c 100644
> --- c/include/datatype.h
> +++ i/include/datatype.h
> @@ -98,7 +98,8 @@ enum datatypes {
>      TYPE_TIME_HOUR,
>      TYPE_TIME_DAY,
>      TYPE_CGROUPV2,
> -    __TYPE_MAX
> +    __TYPE_MAX,
> +    __TYPE_FORCE_SIGNED = -1,

I don't expect to ever have a negative defined here.

>  };
>  #define TYPE_MAX        (__TYPE_MAX - 1)
>  
> diff --git c/src/datatype.c i/src/datatype.c
> index ba1192c83595..1ff8a4a08551 100644
> --- c/src/datatype.c
> +++ i/src/datatype.c
> @@ -89,6 +89,7 @@ const struct datatype *datatype_lookup(enum datatypes
> type)
>  
>      if (type > TYPE_MAX)
>           return NULL;
> +    assert(type != (enum datatypes) -1);
>      return datatypes[type];
>  }
>  
> diff --git c/src/libnftables.c i/src/libnftables.c
> index 9c802ec95f27..7e60d1a18d39 100644
> --- c/src/libnftables.c
> +++ i/src/libnftables.c
> @@ -203,6 +203,8 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
>  #endif
>      }
>  
> +    datatype_lookup(-1);
> +
>      ctx = xzalloc(sizeof(struct nft_ctx));
>      nft_init(ctx);
>  
> 
> 
> 
> If you expect that "type" is always valid, then there is no need to
> check against >TYPE_MAX. If you expect that it might be invalid, it
> seems prudent to also check against negative values.
> 
> 
> 
> Thomas
> 
