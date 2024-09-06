Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50581CBE89
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725623886; cv=none; b=ZaXh8pBfIfGXIaqvYuHbtbfL5C4n56ypdtXSCqGSfVes4cRorIGH3bfsXddZ05MsPQqk5euerXCPZnRRjAztFPQp/arxq2RaXpRPBpkfCzhU8fq1kK0aE0ccYdzy+hq9cWFaRJWqOZxzoIwc5LGHcpHosLgqF3tTVUfoY45g4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725623886; c=relaxed/simple;
	bh=gwhd6YSUYn0QtaTSPyGtnWCa/URckQRSKwJmnGcYxmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCEr98DEwFrhI6PNIOLZ7Glan68PEv0ApHt2hePd/LYKgZtvpJqGfrWzdXZxv4y3IqxpQ3nOEJefg1JxyuIu1qJ6wUraOji87LuVJ/vt33XhDqfKoYpiVlXhJ3nMn+PWpoeevyCEOoxq22cmAa060uy8PuX8HwRaingP9dbwPSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DoX4tc6j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoX4tc6j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725623883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwhd6YSUYn0QtaTSPyGtnWCa/URckQRSKwJmnGcYxmQ=;
	b=DoX4tc6jNvq1Z3TvK5Aw585LPe3zWgvlgPgSUy315GKI+fUNeD6Vuih0/eKdaIJSNvdpT9
	g7ROwvCgpFT12oLqg3gokVnupB5rcEdAQTJiYm3kQnmB1iMAMr1WHPrbBc2gEQ0wd/JGGy
	P8FdwL+HKGcGjEIn8Jsui5PNG8Xz7os=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-r1VP01OaMJ2GsFjy4f263w-1; Fri, 06 Sep 2024 07:58:02 -0400
X-MC-Unique: r1VP01OaMJ2GsFjy4f263w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42c883c8cf7so16176985e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:58:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725623881; x=1726228681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwhd6YSUYn0QtaTSPyGtnWCa/URckQRSKwJmnGcYxmQ=;
        b=NWQNxeErlzEbTLI/4Qrjoy/Zf754+J7fwgS4V/Tdpd/mGXsodMyLly1ZyHTOIdUK1x
         RFb+nUgc6Jq1H4d3aTquuzI8tmqkMPyYxlFjKlCfJuKCABkmwMKLTIfqCC/SpBQloViO
         mCCGYUZ5u08dngxCGlfblBcijfzz8IkgReDDvSZANxKmumhBuqf+pW96hqfJx7IwIuAq
         QyrpX99VXuNA9qh6zVyjEqg4lG4oA8WbnWKnI7cZnLITFwAHdOyP1/wb5zbYeJ8DKutD
         Q+tkl+zKFW4ABVxYoeyAenhxocH0GNWU0b6WUnKpkALg5/m3nGmfRtqeOEEgPXPkDEYb
         JT9w==
X-Forwarded-Encrypted: i=1; AJvYcCW8Q2a17u/GV4KAWFkyfN1tBXswcAggzgVU6nvP4D9sk6w2/wb2oJAAn3M8EvqJ6Az4+okL07tTZafLz02ehsE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/tat2N+HisR9UCgJFkRP52R0kIbb+tGZxLqVgiN3v5ay8cxJI
	A4FeGlWiLoYYPn7GLAAp6HG1Pt5GK6owMn2DXb+nrL9XSjbt1H3gXBg85VlqMIxP748GC6biQhv
	Q+t3OS/BZsXv4XyZhMgpFGIJxXMzVhlnW97HQn8ewLDGZlarx8yEeyezuPh+loMVU8A==
X-Received: by 2002:a05:600c:1911:b0:426:5c9b:dee6 with SMTP id 5b1f17b1804b1-42c9f9d2fb3mr17165765e9.26.1725623881173;
        Fri, 06 Sep 2024 04:58:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyiezqnLnx60jEifhUTR30wzAxyOM3WxR1xMKMuwhfruZ0dS+mmwcm4hHOxDzegTtb9NCsoQ==
X-Received: by 2002:a05:600c:1911:b0:426:5c9b:dee6 with SMTP id 5b1f17b1804b1-42c9f9d2fb3mr17165555e9.26.1725623880591;
        Fri, 06 Sep 2024 04:58:00 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42c9bb7d3c6sm31634815e9.1.2024.09.06.04.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:58:00 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:57:58 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] netfilter: nft_flow_offload: Unmask upper
 DSCP bits in nft_flow_route()
Message-ID: <ZtruRrAazfhcwHJs@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-10-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-10-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:37PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling nf_route() which eventually
> calls ip_route_output_key() so that in the future it could perform the
> FIB lookup according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

