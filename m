Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0492C14F9F3
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724258684; cv=none; b=Z91DmCRn5inCAEA+tIb772C4ZjHCO36R3k36IOredZjCzelcpHrXgHnj6+u/LJI3M87WwQvk8/jyXPpNzla0U8sw+BLocGBn6kGx+HKk9UcM6REvlb5z0vcprFceGW2XNHTk3BwvwicB625TKePgPLoeeqdy1DxrnUyBXGWlq+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724258684; c=relaxed/simple;
	bh=igLeopOXXKG/WrUm1cDFc/eyUdqdZtlb0F/mFOpWYuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aihA+zZ389rfia81On7K69ehfniwrpLKMZZbiOF+T7kq9P+eJ2ky7y0VFV066QLFH8FlFL43oGLOKpUVN4UBls/Qr7KLyX49rqYlLyYzu3qb6eUbRDGDZLYaetnzzU55KjRn/nxPWnbvLP1PZqK0nk7ezX05btNYWf04YHtwwy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=egrgdty/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="egrgdty/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724258681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=igLeopOXXKG/WrUm1cDFc/eyUdqdZtlb0F/mFOpWYuQ=;
	b=egrgdty/C99RVki9buS5Db/ROgUB5CN900EJWHuL5ilG2uzToOsOXZBpXkbme0bcTUTGUm
	YwpdHqFqYs4vqzSPQgPmXquT+73H0CbEjkEDlAhx38TDGGwcX5PDgpLYsRQLL75PGt+Gn4
	hOxig/qpPv61Q313vNSnydKWr4+YcL0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-GEaaurgqOXey7jZULIA8Fg-1; Wed, 21 Aug 2024 12:44:40 -0400
X-MC-Unique: GEaaurgqOXey7jZULIA8Fg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-371b28fc739so553511f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 09:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724258679; x=1724863479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igLeopOXXKG/WrUm1cDFc/eyUdqdZtlb0F/mFOpWYuQ=;
        b=uQ0y1Skm9fW2pnG6fFWQaVJXJcmu24KDShZwFYitz14F9qRFMtYl9x1iPQt/jPqnYM
         e6wtnUhtsVFqD9h8OoeaMfg/hZMHDuIchjrq7IN2QdK9jN7DJkAn0RmVsdkR91Vr1Oxs
         o3SjVaCaQC3sgJlOG3CAUAxxyZay9UjWJf5+JllEjlFUfFbn/eqXOYKVqJwD/RENWXhA
         BFzbLQsMpl5vdwgWa1JwEFRXrgwnaypBeGRzTUg+Tq9jwOzoYzm3i3pnObMnYhEb7omn
         KfC4cf0VTRy7LQBFuzzsiBsxgXs/XzGYCSbKptXNQde1d++sWKRA/Cbm6QUNAsUkLmFO
         6nUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPLYMHEtuGmz3re4h7mpuDMRgQGM4inAFHS3fOWc2t8/m7h1k1LUfx+jpN95PZ7arVygwxVzketmqbluIyYrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypzorvIGQVA9+An0Tm4pgbrEmP0HucmCUvcog0M1+k/xj4AxuS
	YX9PvgUq89qjpqBmYrpi4ZMDFpeoAISco3L4RHtjPoHmlnPCf1CYz3RkBJ3+Qj50dWmv9rBv8IC
	nnPcHChCPOheA16LuUI9f8LJW7xVME+bsYHm5/HApm4GYrnuoPGNeBp/o2dObawKYvw==
X-Received: by 2002:adf:e450:0:b0:36b:aa27:3f79 with SMTP id ffacd0b85a97d-37305252bfdmr164232f8f.4.1724258679154;
        Wed, 21 Aug 2024 09:44:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+AvspN3ANp8D8OkOYAf7VfX7eBe+ARUXdDV1KzYegvFDJe3qrckw5DAhMczrijJ8Nj7klQA==
X-Received: by 2002:adf:e450:0:b0:36b:aa27:3f79 with SMTP id ffacd0b85a97d-37305252bfdmr164188f8f.4.1724258678209;
        Wed, 21 Aug 2024 09:44:38 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3718983a2d7sm16226321f8f.10.2024.08.21.09.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 09:44:37 -0700 (PDT)
Date: Wed, 21 Aug 2024 18:44:35 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 10/12] ipv4: icmp: Pass full DS field to
 ip_route_input()
Message-ID: <ZsYZc+JGy8Pu6gLP@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-11-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-11-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:49PM +0300, Ido Schimmel wrote:
> Align the ICMP code to other callers of ip_route_input() and pass the
> full DS field. In the future this will allow us to perform a route
> lookup according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

