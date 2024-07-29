Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2181AD2
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2024 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722269148; cv=none; b=LgGQAtb2Hs950pLD8tFeYpozXexvk9+yzCfZMNDIVAm2dfsTcCbknGgjELD/ABhasTs7btwtM61+OX7ZwRVJMd8N5CsjuHCusdj6/k612tLZ2SA5WuFswKZYUVX2SdA7FUwSm+KJgFzSRJYtnBTL7xYVgE+k8plphDGCuUobAeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722269148; c=relaxed/simple;
	bh=MsOWdSBOx56ptdjoqaZXVz6kcxRdM5T/8IcA9Y1Dnko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7L/j4YJjAp6tlEHDeiGoeLVFalaF3u4iyxcubsaRDw6fkGvkaDrrxvTJc5sb3BKi9USKaCfKBQHZZ/oqWBTiEMlUoxdiS7POpbLCf5f6B7MfWMTcwGBhwXaAFcz6cWJf1Y5F9nH3NAIi6eSHU83hxDha1zi1YusDU0CkXs+/7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pr3i31Ap; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pr3i31Ap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722269145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lVXhebfLKQ1qVAZhgnufBwBYTzf46N8GHu+5vhKidxE=;
	b=Pr3i31Apa5Nj4kQN5/X5X0nw56e6ltYMF2N82sIif70EWKdQZCc7tef3ZwL5Feini6I9CO
	7BZs4rIQRPAfgzSz9A/qfWoNV+feI21CwmKd0Mxdeb+sfGCcmtev0oVBaQu75/XpT2ipIY
	04hM2bqRC+lvcOpBt7j9WjdWE7c8dGk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-tfpphiwFOtOyCt11mP_LAg-1; Mon, 29 Jul 2024 12:05:44 -0400
X-MC-Unique: tfpphiwFOtOyCt11mP_LAg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4281ca9f4dbso10918475e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2024 09:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722269143; x=1722873943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVXhebfLKQ1qVAZhgnufBwBYTzf46N8GHu+5vhKidxE=;
        b=sWU5HoS5wS4FC+XRZ33SHrp4OooYDPXaCT0xAEURg/ncRSpHoX/Q3NXHxTc30l3zUb
         upEGFuZ2zL5Vk7l9L9REWq5yBBM9fdqPi6uGJrhShV8fIOh/2NhQEagPXR502j7eVsdH
         ocLYngQ0v3U89mTx8PgoNFC3RvlrHMqOSiZtTUuHrUWyc/lO7Tet/WTkK+CJ+fmGcHJq
         gvUE7Z5t3er8ZyTJI8JfBThC9FD7R6A+mRUse0z+dAmufJ81AUkukKTrxp/msN9Rpqc3
         UadNPAHKSkTvMs0KSzxOJjfggnQM0WB+OiymuZ15iKNZafTDBZcvfhabt7ddDn0BA3ok
         eTNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8UnDtghRLDhsXW/4CBc9ngIIU7bE3zz2Z+k1GKYo9rHiTz4DKi/MXD9dUWrQiseqQeOBbnI1PKPQFfRa26qpp1Dz4D8rYr5AUMtl7fYsB
X-Gm-Message-State: AOJu0Yy7OXM4zueThE61BwysxLkSMndWrK94g1mU6QrP08UETfFgauP/
	OFkObecXunckA8vMgHWORvdD0KWokNLGCiv+GdIXEyrmJio3VtFWzvihiXZkcYDpVUXwcUyKsNt
	48PIT2crQsEKlBxI2P6sryYbjmMApmUnNbg47rdQoveoeGg16SBIz3oytPe4NTxe6Rg==
X-Received: by 2002:a05:600c:45cb:b0:426:6455:f124 with SMTP id 5b1f17b1804b1-42811aa99femr61919715e9.0.1722269142561;
        Mon, 29 Jul 2024 09:05:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqKbY2OIof3gK3KJKMX93Wm8kZD3yMiqyPvZH52DuqqXNIf98EwIa872LfC+4Tf/NlfLBwRQ==
X-Received: by 2002:a05:600c:45cb:b0:426:6455:f124 with SMTP id 5b1f17b1804b1-42811aa99femr61919365e9.0.1722269141783;
        Mon, 29 Jul 2024 09:05:41 -0700 (PDT)
Received: from debian ([2001:4649:f075:0:a45e:6b9:73fc:f9aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42819d9a007sm60564415e9.1.2024.07.29.09.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 09:05:41 -0700 (PDT)
Date: Mon, 29 Jul 2024 18:05:38 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 3/3] ipv4: Centralize TOS matching
Message-ID: <Zqe90nCtknOUnDEG@debian>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-4-idosch@nvidia.com>
 <ZqOh24k4UQUqYLoN@debian>
 <ZqYsrgnWwdQb1zgp@shredder.mtl.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqYsrgnWwdQb1zgp@shredder.mtl.com>

On Sun, Jul 28, 2024 at 02:34:06PM +0300, Ido Schimmel wrote:
> On Fri, Jul 26, 2024 at 03:17:15PM +0200, Guillaume Nault wrote:
> > On Thu, Jul 25, 2024 at 04:17:29PM +0300, Ido Schimmel wrote:
> > > diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> > > index 72af2f223e59..967e4dc555fa 100644
> > > --- a/include/net/ip_fib.h
> > > +++ b/include/net/ip_fib.h
> > > @@ -22,6 +22,8 @@
> > >  #include <linux/percpu.h>
> > >  #include <linux/notifier.h>
> > >  #include <linux/refcount.h>
> > > +#include <linux/ip.h>
> > 
> > Why including linux/ip.h? That doesn't seem necessary for this change.
> 
> RT_TOS() is defined in linux/in_route.h as ((tos)&IPTOS_TOS_MASK), but
> IPTOS_TOS_MASK is defined in liunx/ip.h which is not included by
> linux/in_route.h for some reason.
> 
> This also works:
> 
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 967e4dc555fa..269ec10f63e4 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -22,7 +22,6 @@
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
>  #include <linux/refcount.h>
> -#include <linux/ip.h>
>  #include <linux/in_route.h>
>  
>  struct fib_config {
> diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> index 0cc2c23b47f8..10bdd7e7107f 100644
> --- a/include/uapi/linux/in_route.h
> +++ b/include/uapi/linux/in_route.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_IN_ROUTE_H
>  #define _LINUX_IN_ROUTE_H
>  
> +#include <linux/ip.h>
> +

Thanks, I prefer this solution, which I find cleaner.

