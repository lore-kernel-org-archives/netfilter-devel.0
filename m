Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1201A2C39
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621799; cv=none; b=WVVJrOoaY4CgIaBd1ub5SbMZfyefEIdyYFpkW2OwCxleiLOUvd6RFfVNTFwxKzDh4naas157jo7RcIsmejb/D4GFSI1mSMdy6/ZzRtNAOmNtU8chLQLfGrUoWV+6o5e37mgSmM3W9raCA1fxT3qyLV9gxkO+BkzVDXdv1r5FZpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621799; c=relaxed/simple;
	bh=ppjXtJ7gs7W9QUgkDi7uSrA4aZ6/Z9GMvpuugQHfWxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yx7FlAn0BwKLhxPoffQhjMsWSa5eK2BroMHlAnF0+eNpUuspCR+fwsoxclfrOWtGDGqax75oLD2UOAsPPD/RQJpAoiQKYk0rVfLvoZivkpRA1PWbE1Mnm4skfRCnOVm2v8Y2f2Q8aV7jt0sM3MCh2mpRFxT5kFP0kBvb3GqOpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BZ1MUDLb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZ1MUDLb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725621797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppjXtJ7gs7W9QUgkDi7uSrA4aZ6/Z9GMvpuugQHfWxc=;
	b=BZ1MUDLb5f+CKw6+G0w40+dAR+p2e5DyUKhKlMpKA4gtGVOJl2K3hjnAevTsN4M5Eyjiat
	Ohl/ftk7ZU3TVcDCjHkcyaEtjsWiM+MTadTm6W7m4zWm0vlq0nzXwfFww1K9np24KHGGqQ
	uW1NJaW2tc7yw80/anOrUtAY+Lr7258=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-VHPNLQ5AOLmIp1Gp0Qm_aw-1; Fri, 06 Sep 2024 07:23:16 -0400
X-MC-Unique: VHPNLQ5AOLmIp1Gp0Qm_aw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42bbe70c1c2so15499185e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621795; x=1726226595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppjXtJ7gs7W9QUgkDi7uSrA4aZ6/Z9GMvpuugQHfWxc=;
        b=kDjYxc8Cvui8dazP8io8DF8XI9x1R1T86tLMF6qf+EjNNt8QYLYsMSQqzpRadD6lbE
         uHW8Z+g2IyXqeGXb4EmTZGsqCxIkED/f9E+emQs+zRzxhXyVJUzM2kAdJortoARTdUnY
         p0udbDQj1RAh9yghK3JYajQJGxxIHjMS0+tbZfekbLCfBz7mEKp7ECHLnbDsZbPhFtPM
         7MgPPJR7vjr9JWSR1hXtWKmYnUiJM4sdRRfJQ8/iPrq2KIGN0A4TTMe0+1PdPKuAz7bj
         fuZYOjm8bj1C9+my+Q3sBA61PFSIjWcyPslo+5OgoyuPL3wL7sq2V1+cuqB18ElMvLwQ
         BjRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9yKRdRNmVGzTqmqjtXapeHuOTM5QMN4vp/O5eLpQ27CkM3DYukXmuSAY5R2l8jKrlWMovVNJAxB+ibodTKSU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx04ZqHGd4BsUX/tOpSvPT3XntWVJ2b+T2I7ARC7FD79efAAjQg
	UcrOKuvAri/06E6B2+xwvlXS5UzRF5NcYWkA0LOic/i7Vj4h2vXErq/KZKO7sBsgN2PQuQEZFqV
	A5NtY5HHXbLJsVw11vlEgLpAjyxMX8jy68KddXYVzGAeq+OxS2HoDNNxkvvF/vKe3wg==
X-Received: by 2002:a05:600c:1914:b0:426:5e91:3920 with SMTP id 5b1f17b1804b1-42bb27a9eedmr205061685e9.29.1725621794775;
        Fri, 06 Sep 2024 04:23:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDWt5S+yLwjHr+CBf53VWDHiFksVfZtQBazKOXS3AJWWvyxr4Lz9xJ3DkOyXs6TcqBtg77Kw==
X-Received: by 2002:a05:600c:1914:b0:426:5e91:3920 with SMTP id 5b1f17b1804b1-42bb27a9eedmr205061375e9.29.1725621794156;
        Fri, 06 Sep 2024 04:23:14 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca05f847fsm17687305e9.41.2024.09.06.04.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:23:12 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:23:10 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] ipv4: icmp: Unmask upper DSCP bits in
 icmp_reply()
Message-ID: <ZtrmHrAC40k4hpxe@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-5-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-5-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:32PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

