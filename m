Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BB71CEAC9
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630755; cv=none; b=dLjDhaFmuR1/T6xGI+NSBB06PCKe/tGGgalv1VnM5tgGDkHrXH8/h14WzbRMBUnBamwmPoL240/D/aRQ64MmUhjB29qZhf3W4Ec8OUmWfQLLr9CCs3rpXSyp2nA3ZaFLvjs4crHn026sjShIoeCoBwUyaFQ13eRvu4ntfDFfZDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630755; c=relaxed/simple;
	bh=q9aU6MLxmooh2pjhdIX2la9jDmWUIouSae2ZL0rKgsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4FczU6frcoAltjTqAlgs7CrDPOTA59/q2WUshk30EHasKmfPmfF+nsCOAoA6AiaV5rZheVLW74fYED8e2KAZ2BYWQLHCVkw5ztjM2fASwuATyZ4EIXm47epZz2FC+0rp5x/X818ceuUNle424yxr8UiHddM0z6MLXsNhr7vXAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YmElOzuE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmElOzuE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725630752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9aU6MLxmooh2pjhdIX2la9jDmWUIouSae2ZL0rKgsM=;
	b=YmElOzuEZIMloSvfZhWslakP/4yky66hoPwPq7PdYa+6L7T/rA6X6okGUr0jpgfQ6q1Yc8
	trm9GFlARDbWaF99ypIdBmqdZ9gvef0jE/K7lrkmWD3EtnzGnHgnQDvHujCpMs99GNx8tr
	tSdAZnh7N6THiOVY3CYZpgMlU5jhKMw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-EFJzmou_N9WN78CjbeJlwg-1; Fri, 06 Sep 2024 09:52:31 -0400
X-MC-Unique: EFJzmou_N9WN78CjbeJlwg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3787ea79dceso1174997f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 06:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630750; x=1726235550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9aU6MLxmooh2pjhdIX2la9jDmWUIouSae2ZL0rKgsM=;
        b=UIZ3W2GEPEtXgIm+OdsKMRzfzu7ZH7lf8OTKVe1u3wzxXbJKopdLb+660ARxq2b0JR
         uZZWye+pngpxf5C+vroG5LiBVNQRr12ezi/FfM4dRE1VIq5MJGfaHKQPB+Ds4QpkHJ3u
         uma0yRlc56SjmzQNQp3XjFeGKvZdEv6DjbF9Cf6+Fuu2T/e5LhSCoGFT3JjgdUQpuyqz
         tq6zLisfw2rHr2a83WQpY1pWbll9dm0q7ZalEACAjOmc4HPLmye7SEU41zTxvzpY2o9A
         HL2Vx4fff3V2tQPRpJEzAGw2SLC5c8CjWExbf8u/LEZf/azcKTvNF4wc/AujRDEuXUb0
         r0fw==
X-Forwarded-Encrypted: i=1; AJvYcCXUvprWFI62DdMY7760fAwymrdcpqFR1dJooLIF/DU80etk+h/RnZPESRGvi99WWYs9DjBIouQc452+5hcS114=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKYflFSmg59oIAGs7ZWjYE5cEpqBzsVY0c2IfiuA+E987zjv8t
	92txqAg7Yi0kjdS5Ao0cGg54te+T0xovtoM3n1yA6i3PQ2O/Kt9BbI71iiGsyFTa87+1LD2FZ/L
	vSHBZZDgtk6Bcvq/cmjav7KIYfjFJ7H/QM6hoIA2o92HYHg74BA73uZFC71X/6WfYtg==
X-Received: by 2002:a5d:5e04:0:b0:374:b5af:710c with SMTP id ffacd0b85a97d-374b5af7510mr12649953f8f.26.1725630750355;
        Fri, 06 Sep 2024 06:52:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7rIucSxMSJNCM9P3fVpLg+fca1j3lilFUPuCE9KWtPYnhwY3r2Fu3rHNI/1QZKG6cYsZRkg==
X-Received: by 2002:a5d:5e04:0:b0:374:b5af:710c with SMTP id ffacd0b85a97d-374b5af7510mr12649933f8f.26.1725630749848;
        Fri, 06 Sep 2024 06:52:29 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3788773ea3csm2131461f8f.54.2024.09.06.06.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 06:52:29 -0700 (PDT)
Date: Fri, 6 Sep 2024 15:52:27 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 05/12] ipv4: ip_tunnel: Unmask upper DSCP bits
 in ip_tunnel_bind_dev()
Message-ID: <ZtsJG3/3syyoQOCH@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-6-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-6-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:33PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when initializing an IPv4 flow key via
> ip_tunnel_init_flow() before passing it to ip_route_output_key() so that
> in the future we could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

