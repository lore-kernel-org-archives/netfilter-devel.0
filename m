Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B18143889
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721999844; cv=none; b=VnrlyhEpbmJR5IDGCHfnXzMtAmPLMVN9456TIxCiPTa9PqPSNCFP8GDp30kivJBlioXubRMzpBwisQqbJwCqFUr70cAXbAZ9Em+SJCsM1Z0NquBSJOcCFBPdh8ZNcxCfxTQ6MUQdz6GElTYcd+T4bYKMunocvJDEXk6GGj9DudM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721999844; c=relaxed/simple;
	bh=4kVIQCChUbglyV+k+HOn1kW5CkgQE1FBgFEBC/jDQ10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCmaxJQCZul2TOqQrY/Ft6LbR9bPlAby3rCwxKOlOjWAECj7S8zeMm2RWpSpl11mHbJawWKA0kMsZ2OrVkw2+30kw8QNgvzQM+qXBBS8kLpz5+XhaLER49NTKQVz+D3uus6kAesFg0EwQwPBhIjUVNCfsiZeClUbP7ScWTSVKr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3qa3SIC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3qa3SIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721999841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l+6VpRCa0Q8GNnCtOBFwW2bwj7nkDDhJJ2rPfuFnhh0=;
	b=A3qa3SICogr8BKMZA11BtntV2FCKhv2Vcq6xERrq+Wk2tWHjfHG+Uxds9Ior1qkioJ5tHZ
	ztUCKaUHaKoxZ6BUPAhQbFFgRGldOoR+gtACrbO47d3YPXIFqsRRTI6LEMiB6vi9koMmwB
	C+w7gszklTd5hWJ0aQiLCyDhtOUaYKw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-JQGniIyaPSGGvkuV5p2dNQ-1; Fri, 26 Jul 2024 09:17:20 -0400
X-MC-Unique: JQGniIyaPSGGvkuV5p2dNQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3687eca5980so1119412f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 06:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721999839; x=1722604639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+6VpRCa0Q8GNnCtOBFwW2bwj7nkDDhJJ2rPfuFnhh0=;
        b=Lp38by2Oz4F2MauO9KjRqQAw1S4j+L6p+hlknQuF9eQw4hrPwhJ/+eVJDqNC5affCl
         aUqpNPpeIj0gzsqe0OxE/DuOsXhNYqgIAvQS09lF2Z/yKyHyR9TJRT7IsetF9S9gBV7b
         psIy2hiADpQixK/rA9Lwlk6wUpz8DFwXPkqDd69EnRyAZ17z1EOfIwL6MUbZ/gO4ldKl
         2sSH/h28mdxZDD/l1GP9aIo0OSAI68UlL98VRAdUOMNmH5YTdM6/x4/xs7KuB+mChrAe
         RDJarXtRUO406/aTwXLzVurwEOT6HCWIgnvZ1OPf6ZgMRwLFMfx05a+n5VjrqNqsi8KZ
         2uAg==
X-Forwarded-Encrypted: i=1; AJvYcCUZrcVqYevs5pCz8pNYlqriw2zBmOBx0sRcnJ2Vg37aizzt5o+GcsSLq4GejbquChk3jJAiM2u1vCV+jn6l9TRm9GsKfyq1N6BdUP+NUQaL
X-Gm-Message-State: AOJu0YwB0laFBMf2YjTmcrxi246x7YsdkfSIV2TJwLrgr0ayINwnnqis
	0ZBQVOg8bbEQXOzCQMw06Ro9vfZrZHxCJScgFnwmADuvHUEWrorwr34vfeFiGEpSEQGi7JXdbCO
	RSfnT203Fyl8O3s+ipSMVhwvGEj1IMSa0QlRzV2xmAGaiiIah4I02dnThbJpsfPB2wg==
X-Received: by 2002:a05:6000:4024:b0:366:e7aa:7fa5 with SMTP id ffacd0b85a97d-36b31ac772dmr5227801f8f.1.1721999839386;
        Fri, 26 Jul 2024 06:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjZr996e5XEt9Hw79Pp4nlOQdZe1bT3/CsiJZelgeZSjshKQhuswyopfmY8bYKVmR/lrvYyA==
X-Received: by 2002:a05:6000:4024:b0:366:e7aa:7fa5 with SMTP id ffacd0b85a97d-36b31ac772dmr5227747f8f.1.1721999838623;
        Fri, 26 Jul 2024 06:17:18 -0700 (PDT)
Received: from debian ([2001:4649:f075:0:a45e:6b9:73fc:f9aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42807246ca4sm71526235e9.11.2024.07.26.06.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 06:17:18 -0700 (PDT)
Date: Fri, 26 Jul 2024 15:17:15 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 3/3] ipv4: Centralize TOS matching
Message-ID: <ZqOh24k4UQUqYLoN@debian>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-4-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725131729.1729103-4-idosch@nvidia.com>

On Thu, Jul 25, 2024 at 04:17:29PM +0300, Ido Schimmel wrote:
> The TOS field in the IPv4 flow information structure ('flowi4_tos') is
> matched by the kernel against the TOS selector in IPv4 rules and routes.
> The field is initialized differently by different call sites. Some treat
> it as DSCP (RFC 2474) and initialize all six DSCP bits, some treat it as
> RFC 1349 TOS and initialize it using RT_TOS() and some treat it as RFC
> 791 TOS and initialize it using IPTOS_RT_MASK.
> 
> What is common to all these call sites is that they all initialize the
> lower three DSCP bits, which fits the TOS definition in the initial IPv4
> specification (RFC 791).
> 
> Therefore, the kernel only allows configuring IPv4 FIB rules that match
> on the lower three DSCP bits which are always guaranteed to be
> initialized by all call sites:
> 
>  # ip -4 rule add tos 0x1c table 100
>  # ip -4 rule add tos 0x3c table 100
>  Error: Invalid tos.
> 
> While this works, it is unlikely to be very useful. RFC 791 that
> initially defined the TOS and IP precedence fields was updated by RFC
> 2474 over twenty five years ago where these fields were replaced by a
> single six bits DSCP field.
> 
> Extending FIB rules to match on DSCP can be done by adding a new DSCP
> selector while maintaining the existing semantics of the TOS selector
> for applications that rely on that.
> 
> A prerequisite for allowing FIB rules to match on DSCP is to adjust all
> the call sites to initialize the high order DSCP bits and remove their
> masking along the path to the core where the field is matched on.
> 
> However, making this change alone will result in a behavior change. For
> example, a forwarded IPv4 packet with a DS field of 0xfc will no longer
> match a FIB rule that was configured with 'tos 0x1c'.
> 
> This behavior change can be avoided by masking the upper three DSCP bits
> in 'flowi4_tos' before comparing it against the TOS selectors in FIB
> rules and routes.
> 
> Implement the above by adding a new function that checks whether a given
> DSCP value matches the one specified in the IPv4 flow information
> structure and invoke it from the three places that currently match on
> 'flowi4_tos'.
> 
> Use RT_TOS() for the masking of 'flowi4_tos' instead of IPTOS_RT_MASK
> since the latter is not uAPI and we should be able to remove it at some
> point.
> 
> No regressions in FIB tests:
> 
>  # ./fib_tests.sh
>  [...]
>  Tests passed: 218
>  Tests failed:   0
> 
> And FIB rule tests:
> 
>  # ./fib_rule_tests.sh
>  [...]
>  Tests passed: 116
>  Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/ip_fib.h     | 7 +++++++
>  net/ipv4/fib_rules.c     | 2 +-
>  net/ipv4/fib_semantics.c | 3 +--
>  net/ipv4/fib_trie.c      | 3 +--
>  4 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 72af2f223e59..967e4dc555fa 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -22,6 +22,8 @@
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
>  #include <linux/refcount.h>
> +#include <linux/ip.h>

Why including linux/ip.h? That doesn't seem necessary for this change.

Appart from that,

Reviewed-by: Guillaume Nault <gnault@redhat.com>

Thanks a lot!

