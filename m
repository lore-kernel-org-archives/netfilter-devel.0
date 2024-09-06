Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C2222315
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725624182; cv=none; b=qRZZSCNkWxHEvbQ4a3ODKyEwOFExDhPDLGUb/Qf9UVP87I8HbL/FfFtZOABJdBFLCwc6fHInlj/HGzlDD5kC8iaCuY6vgU95BrkMdAi7AImbpD0UWPDEFgn+4JD6IP4iQedxgFQvIhsnCJxOBoWI2s1t2LSugjtN5yeVIHTqilw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725624182; c=relaxed/simple;
	bh=SzxUx97+S6KIAnLwmxguKmEFLZ9yAdCsp/nWhUUS7FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGFWp+TAsC5Bk59sV5AllrOBIQ9P2utpcTZ5SkKwsGNo6QiyAJgekgG9oUkhC7jjTa2suW3xLcdDh75vsu5ue9nbAb2+VAuoYn9npyzcWMJEo8FBhn/8qaI1qS8JFkDmubZUuTBsZ/Qm/kTjfd/UHmW104GRtEm3vTuSnoqe2mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCbbTZ4Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCbbTZ4Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725624180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SzxUx97+S6KIAnLwmxguKmEFLZ9yAdCsp/nWhUUS7FE=;
	b=cCbbTZ4Ypxqo5mGp+SjgEHdXAov3on4FYCa67PLCOq8NNDQLZYEPWrYjWOrtaIiP4VvtZy
	CXyRurLUNibPRU8z7erevNXQ1MdGNo9cX/JwF15MpqGtSRxWSEmhvfQGRJaG+riUmx/+D6
	FBKhjmRp7LU/XMAhYd5qn+9uP2VNqVI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-uCQrY7WYOpujk3Uq9RlzUQ-1; Fri, 06 Sep 2024 08:02:59 -0400
X-MC-Unique: uCQrY7WYOpujk3Uq9RlzUQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42c7936e4ebso15848835e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 05:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725624178; x=1726228978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzxUx97+S6KIAnLwmxguKmEFLZ9yAdCsp/nWhUUS7FE=;
        b=bNsOonQG/hbII5HpEEBxbf/ttodtOK2abBtGVrafW3RD8zDWgF3vkIlIVCymdxlsSJ
         2c9w27Gw00iVwTNS6SDMyLMHMMpbzm5DtwyCVZtxU7Nag7itSLZZanCUnHGvmoYh0z2X
         oJe33JT+21fXdOimF53KLNt909dPp5bUIu6hjwu7Txak5u3nNke4ADrov3EsTrYbU2MA
         qXd0OJHvMJD711TPjXUrNtkpF2lDwDc5EiUFjmieqVzN+5QvMd9ZeUTQTQXE185RQzaG
         Tr0xjGnEe+mZufO942Wsi5RwoqLwP19maHQGqwAaGCyZWWGD32uycTbIyK3/z/vPVh+D
         apCw==
X-Forwarded-Encrypted: i=1; AJvYcCUDQ+ZgUnhGALplxKzakjRjS6uWL6qORfxH5Yt/CxI0ntwVScYSevsBeOWGeol1vk+5XlsLxU0JK44+H14zTZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmLZGrnUGu/In0+dRssdlUVlxiZTb5h6o4apRHEAcfQkH7hcBl
	Uy8ME0k+pI/kPCU53y01lRNM9Ptj+lNNZLNdgcfkUK6iWRamylRtj1sjkz9WMr+kAXIoEicVmfY
	I65yCwq/AfYYfF4Zz5UzFiOim8yO1JT+RSmrmcsA7TAzuZOMGw0CfFcuC9rrDcKfqdw==
X-Received: by 2002:a05:600c:4e8c:b0:426:6921:e3e5 with SMTP id 5b1f17b1804b1-42c9f9d6a97mr14855415e9.24.1725624177993;
        Fri, 06 Sep 2024 05:02:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoI0DxPX/u6R3aYPAJ18qh/X+91B4iTbd+r7c0r2GHaqUyL4q8mSemuf8LpPqF1l3DBpiAhg==
X-Received: by 2002:a05:600c:4e8c:b0:426:6921:e3e5 with SMTP id 5b1f17b1804b1-42c9f9d6a97mr14855095e9.24.1725624177430;
        Fri, 06 Sep 2024 05:02:57 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3788dea8eabsm1004604f8f.114.2024.09.06.05.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 05:02:57 -0700 (PDT)
Date: Fri, 6 Sep 2024 14:02:55 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 11/12] ipv4: udp_tunnel: Unmask upper DSCP bits
 in udp_tunnel_dst_lookup()
Message-ID: <Ztrvbx3qzXI2VCN8@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-12-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-12-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:39PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

