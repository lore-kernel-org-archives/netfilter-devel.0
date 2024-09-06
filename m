Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A461C870E
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725622724; cv=none; b=jR2cvebyr74zbds/I4wPAcyUXZDbjs6gFX2OQT7JaIjIH4ToYhizr1yzGy3jK6jT8k6GTUysoG+1TxooQvD+oHEAcoeQQJHEVGsUQ3qqRC8VMnOcCaFXez3boQAXH5UJT9lTd/j3GGnCCwy+OVCL7I3uZrZymoWe2pVsQy9udIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725622724; c=relaxed/simple;
	bh=3OSEMPeLSNHVCNVbKv7RAO1iD4GGzvlj38LVpMDyE9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C66ou09/g9vPEjb6rYVkX6VEJ1A8AuuaB/RMUlPbrnCNgfwFHdu/B/wTu0i1iS7IG1bclTMBBiHynYAvgKhs01TjERK85dmuusKK+VPnb4fw1M+YyMLOiHnQe0iPWtJP7KFXjTkc3mNVHqcAltzi03Rp4FXl9IPX5Ewipf5g85k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNvEDg2O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNvEDg2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725622721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3OSEMPeLSNHVCNVbKv7RAO1iD4GGzvlj38LVpMDyE9k=;
	b=JNvEDg2OAKAtaRGouESzx3GBBJS5P/Fx2scwr76pPS7hFqMqBGg5t6K/uspFdmv60XTEVA
	Gyk+zIsi24NCZtkcNTZMLQ1HE70nABXUBGMy7adcTDwUn8CoY5SGD7hO0hIUPGzyZN4Rb1
	pzgRc2ZCF9+yEpGwB2ooAdi/w4JqFFw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-fyEs0H_qPqaTz1n6wE5uAQ-1; Fri, 06 Sep 2024 07:38:40 -0400
X-MC-Unique: fyEs0H_qPqaTz1n6wE5uAQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42c78767b90so15418995e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725622719; x=1726227519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OSEMPeLSNHVCNVbKv7RAO1iD4GGzvlj38LVpMDyE9k=;
        b=p1A7LfYWhnQFCRaz6PHeVZWvfKoY4AwEpx24lmQ3rjDdrBH1SC7YSL5FIAAAuf4bAH
         aqc5gZHp2Yt1LUPd9xpmojgo1gndb8FQOrdo6r1XZZEF4gVXI9ZALwWNDEjAIYHt/NLM
         2vU/4As+UGV8ie966XEOvQj3zama9J+k9zZGeLF0H6Zrs0MAvHfTjUDP6F6Q5gQx9Xf7
         fk4bipLPpMHjBuJdJbPt4sbAHkA936DZYxh9reFEtyLEkIGEyOAy08jgggUZPyGvTj88
         z0QxhP9Kgztkikr8CEtpuX00/FLh+KkjnfPhhxhWNDOhq+mfvkKcYVyNnhgWLubqFRFd
         Kxeg==
X-Forwarded-Encrypted: i=1; AJvYcCVLKSJHxaXA8WmspAkia01bA0g9NisYYyjUIorYOcc2lMwom7l/wAtKxx5yjW+dOneG+d+grM26K9cf2RGfxoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmlCNMDH8V7plxwcPSnJ0jUjTVAE2ly3UqSAb9n/iwvetdkjw2
	BwSu2EEMO207N40aUpEgFsd9LKh3Sn/ZTrvRfwe59p0wn4iep00h8J2PBZWJXSsST6+wSMzjGuB
	yvu9Vb+hzYNiZPGsNo+Ym7AnZNsUTAOdeV5uujDHnBnJw6Cu1ri6V7HwkRW62CWh6NQ==
X-Received: by 2002:a05:600c:1c1b:b0:426:641f:25e2 with SMTP id 5b1f17b1804b1-42c9f9d7035mr18302855e9.25.1725622719304;
        Fri, 06 Sep 2024 04:38:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuAsg7pwxpDVtdYJ/6+D+Ph/FNa76MdgLyOilEwQ/89LMv1D0nMU3M5+amZnhf14vF76nDJg==
X-Received: by 2002:a05:600c:1c1b:b0:426:641f:25e2 with SMTP id 5b1f17b1804b1-42c9f9d7035mr18302555e9.25.1725622718460;
        Fri, 06 Sep 2024 04:38:38 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca05cc3dbsm17708455e9.20.2024.09.06.04.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:38:38 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:38:36 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] ipv4: netfilter: Unmask upper DSCP bits
 in ip_route_me_harder()
Message-ID: <ZtrpvGliOjZzPkyv@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-9-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-9-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:36PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

