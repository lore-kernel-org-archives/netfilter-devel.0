Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ACE1CB152
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725631472; cv=none; b=csmhixvtcnGU74AD4ZnQ2UtAO/IkHWRMOn8hG+f07HpIWK4NUkIjsQPVBF3x3frMEO9H2ocZfAMmNLJU0oP54GFYQ4YsEThVHQbkyZHIB6uf/xWUbsJ+OCOutULltss2g1jiegIwh71OXgi0AHGzfcRu3I4XahNX98HJfHjb6/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725631472; c=relaxed/simple;
	bh=HHFC+pt8F30hf4thaLXM7MllDwsBRp0xvNHzUpudAOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrqknjMelKSuUtsuojh7Fb0BOLyXKsYFQ2mxyafWxhdldb0L/sY11m7L5wwaj8hlDDe7Qo/8jSCQsmIAHbroxX2gl5v8t3Aogsd10b50ionWbfUtef/SygYzYkKXvBi60WUuqRWLLvReZ1IaGxjhVBdHGc0Tz1HUVrzJfaIJmMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vx4YBsIg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vx4YBsIg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725631470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HHFC+pt8F30hf4thaLXM7MllDwsBRp0xvNHzUpudAOw=;
	b=Vx4YBsIgzZWwm5LHkZzAsX8POI0wfFGZyMiTYtWnKimj+iNwOovhqNm1Ni5xyJXllpCmjr
	tXDnfL5/luN3xPXFi9GsxdCDbQNgSjcWUHR+3EJWLLFt3X8ta8vIBTJhh7bYSklr9XrDUe
	IJ/TVOXCC+av7OVJqvoyMWjjjBgBjfQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-9Cyzh1gdM22BjiFbNwqvQQ-1; Fri, 06 Sep 2024 10:04:28 -0400
X-MC-Unique: 9Cyzh1gdM22BjiFbNwqvQQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-53654fd283bso1177592e87.3
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 07:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725631467; x=1726236267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHFC+pt8F30hf4thaLXM7MllDwsBRp0xvNHzUpudAOw=;
        b=S9wyp9someIcSLzu02GDZ5q9POpQALI7Xj/WpW0Ws2++g7eALPntdjEGjuOmGJ9om0
         VIYg+U1B21FibA0g4A7m2zoQMKiVMPC/g1qvqu0jVU07RJg8YlynZ9GlB6JYPejM3nie
         3YZw6ziHa79wJ58zUwxZCeF3+nDaRR4kn1GB6aymPEIFEYVxv+Fe5mfS6gnaK+pCGxz8
         wwn8h3fWOpIxb6HZvF376II3ABslP6vpja/pO+UykBLCnpAHk3lDu5GY7NNlwRbUt4St
         wqmJaRwnpi/1lC0+LPI5a+nVfTp7ue4820d8Om7sobY/lca8la/ePJGzakQpWoPcEWxj
         ih+g==
X-Forwarded-Encrypted: i=1; AJvYcCXwWkHNrC4PHor8ttWS5Dz7C10jY7POKWTeHilaBu6oPzVmhbFBs7K2+S2hIG+kkjpI7/KOxpCq244mWgUNsEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkSNfB/aY+3yOJNAHcpHJPWtbCSc9Qc7CuotUKrHEgP4qcVi6+
	ruWC2t+vDkVkk7F0F3MKGVds+UXmPsM9w6bbmqHl4ul5Mly04xD0b1Kp+wE27Ks/6vZvXOqx8dJ
	HA971UU1iEZ5K1Cg0e5NcOvjPFIOzx1oT404HMntFHAWaKmm5OSPWglLQUgjTP3Ja6A==
X-Received: by 2002:a05:6512:224f:b0:533:d3e:16fe with SMTP id 2adb3069b0e04-536587fa8e4mr1676576e87.38.1725631467073;
        Fri, 06 Sep 2024 07:04:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKQ5/38TKV/Y2UqEsgT1myno6QGvAIBzgZWsQu6maWs8a2tVqrqi7GmjJ3p9IQvBhwQGLDzg==
X-Received: by 2002:a05:6512:224f:b0:533:d3e:16fe with SMTP id 2adb3069b0e04-536587fa8e4mr1676511e87.38.1725631466186;
        Fri, 06 Sep 2024 07:04:26 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca05cee8csm21366785e9.21.2024.09.06.07.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 07:04:25 -0700 (PDT)
Date: Fri, 6 Sep 2024 16:04:23 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] ipv4: ip_tunnel: Unmask upper DSCP bits
 in ip_tunnel_xmit()
Message-ID: <ZtsL5+/aztO2HBuR@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-8-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-8-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:35PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when initializing an IPv4 flow key via
> ip_tunnel_init_flow() before passing it to ip_route_output_key() so that
> in the future we could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

