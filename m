Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8A110A1C
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722008456; cv=none; b=N96a7gIrFFcyHZpl75oThlhWjMZjG6T4IDI4YfT+YvAGmvvb9fu1e4dejfOEnnMNuaTRKKhtwwKQwBmK+5o9B/wPGO01BaOb9dRVqyeF9/InMq8yv+IkhLaGnF+JYFJP5Z99u9pbEE0Y3CsK47C8qqYC3nLZhXXLF/3Px6dIOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722008456; c=relaxed/simple;
	bh=Bm8yzhTz1w1ezTbv26TxQIGp6hnrL2kL8FOi3oT4/JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA4bavdxQv0EtdFEcgwD49pkSVGgSlHJroX2iwB3VZoiwg3ekdav6NyIr83Maqt5pLKCAPL+r30AmEt7eU50VJwdvBk5K7hM7yxpA05Q+ORiNsflQbTbTlwUU7hiFMWB3GWL2C6LmmOT89Ssy+w3g6vTPwxdpx3ITh8VHqFQXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYvmBpRO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYvmBpRO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722008453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lSqWN3jNFsx72kH3y+ST3WOVydYSi/qMl+4qIb+/cnw=;
	b=UYvmBpRO1IqZUyx32CzwtwJQcKrXhIc9ZTodf31SEpECwRj0W/iQgyevbaqrCzEK2IA3Nb
	QSl5wlx3TRaQPwQJrLR+7thNxJRMAcUWD4YhsxzB/ZaM77PmB1DM9NWLegOekRzTCsUVpb
	sq2BBRROEMKBruvVtV9Dz7zAg4h62Xg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562--d7WcUrKOlqm9McHMcj3oA-1; Fri, 26 Jul 2024 11:40:52 -0400
X-MC-Unique: -d7WcUrKOlqm9McHMcj3oA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3685e0df024so1363792f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 08:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722008451; x=1722613251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSqWN3jNFsx72kH3y+ST3WOVydYSi/qMl+4qIb+/cnw=;
        b=RtuyqXrQNkSxoUsizQ2Onbhzy2EcU2MGB+Myts3jzuaZS4ETtGYmpxfi6eaQsslpKT
         1CJh8Xx0DpAvjXBGPiI4wXdLrbFbDbEojRsd7v3EQWhpafL/qrIEKw98d6nkdVyYNKUH
         ry8X5YRvDUt0+Y5iH5nbX3iORAf8Mdr98YVYUaxeXdkzkav1QRMl2GYL8DxSSfQOZDYO
         OtM5JdXw1351mtegrzapO6XtEaq7aFgqQFohr5kmCZcjhszCcTagFOvhbvCWcAO8fgG5
         zmh/V3Fwb8shGOig4sIMj3dPyovQBzqsN1y6LXQDSfNuCaoHkg89ox52LScmMbRqdb8o
         n7kA==
X-Forwarded-Encrypted: i=1; AJvYcCVJep219hHkadYQCW7W0+yggVwrsKze7cyQ/WYdGfAvvSEiGAjGGFMjVni+XRUUIY7T1W9EAuNAtYBPjIr9qo32aoza2hOtr8FrqbQNxyjs
X-Gm-Message-State: AOJu0YzHN49iR2ml147ibGQGWnCGzmLu2fYWaFk5dbbBYHX54C5lA5lf
	S+Q1WQ8oWxIO972U9P37genP47PyM+SASZeB1PSlWwDlqCgW45ScJI4irIrdaXRfA58DoSsM6uI
	TOX9g+PNdTmZQbYG58DnbYbGIP6MO7qjI6/KZAXjhQ1Qgx5fj17nj8m34OwZwVZSFDg==
X-Received: by 2002:adf:f845:0:b0:367:9522:5e70 with SMTP id ffacd0b85a97d-36b5d08a21bmr50783f8f.52.1722008451154;
        Fri, 26 Jul 2024 08:40:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2ifAhPfu9FFnitDhFyuHy9MZxvX9eLv0CF2voHRwf4z6SvAD16PMUVKXlb5p6bMlk9X1BUw==
X-Received: by 2002:adf:f845:0:b0:367:9522:5e70 with SMTP id ffacd0b85a97d-36b5d08a21bmr50754f8f.52.1722008450501;
        Fri, 26 Jul 2024 08:40:50 -0700 (PDT)
Received: from debian ([2001:4649:f075:0:a45e:6b9:73fc:f9aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857ec5sm5460659f8f.74.2024.07.26.08.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 08:40:50 -0700 (PDT)
Date: Fri, 26 Jul 2024 17:40:47 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org
Subject: Re: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP
 bits before FIB lookup
Message-ID: <ZqPDf00MuoI677T/@debian>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-3-idosch@nvidia.com>
 <20240726133248.GA5302@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726133248.GA5302@breakpoint.cc>

On Fri, Jul 26, 2024 at 03:32:48PM +0200, Florian Westphal wrote:
> Ido Schimmel <idosch@nvidia.com> wrote:
> > @@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  	if (priv->flags & NFTA_FIB_F_MARK)
> >  		fl4.flowi4_mark = pkt->skb->mark;
> >  
> > -	fl4.flowi4_tos = iph->tos & DSCP_BITS;
> > +	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;
> 
> If this is supposed to get centralised, wouldn't it
> make more sense to not mask it, or will that happen later?

I think Ido prefers to have this behaviour introduced in a dedicated
patch, rather than as a side effect of the centralisation done in
patch 3/3.

Once patch 3/3 is applied, the next step would be to remove all those
redundant masks (including this new nft_fib4_eval() one), so that
fib4_rule_match(), fib_table_lookup() and fib_select_default() could
see the full DSCP.

This will allow the final step of allowing IPv4 routes and fib-rules to
be configured for matching either the DSCP bits or only the old TOS ones.

> I thought plan was to ditch RT_MASK...

That was my preference too. But Ido's affraid of potential users who
may depend on fib-rules with tos=0x1c matching packets with
dsfield=0xfc. Centralising the mask would allow us to configure this
behaviour upon route or fib-rule creation.

Here's the original thread that lead to this RFC, if anyone wants more
details on the current plan:
https://lore.kernel.org/netdev/ZnwCWejSuOTqriJc@shredder.mtl.com/

