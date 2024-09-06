Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7CF1CB146
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725624300; cv=none; b=P6b73hKmOn7lnNlBfMY7zI4Y2IvG0NXzuC+/jtnw095gd8nxq81dPWyEQlWisdPwr7Fq/I/m/3F9YY4BSoce7i0whoBqUhHHVRcAp7osRojwW0H3PusxP1tucqMb4KZ63sju4tRkjJFnOtMuzYY4WmDxIZQhTYED/Ets4a2wVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725624300; c=relaxed/simple;
	bh=tc07zvGyCiSLPaYrP+kQC7S675jJOEsGznL3PVrjuoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7Dj+tpLffMMLjxEiwzbqef22z25tYpWdPsVKBfk+QHLrjEhDRzViQQAmPbYQrSvulHxqwuKkb9CYyS7Q0V8xRm7ZZw6lFH3nyPSUek3FpDwZJux6fEKC7sbc2eBugZ+lIUl0KHApQM8CboFV9GbUxq7a8Z8s+5ApMGC/om5RxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZqdgOBs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZqdgOBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725624297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tc07zvGyCiSLPaYrP+kQC7S675jJOEsGznL3PVrjuoA=;
	b=eZqdgOBsO+QSQzGPy1MC8F+My2DdP020oYUbJCUlHfM4pgwcv7JIBECCvtFQJzi9o3pjTC
	0bfbE9EJ4Yh11Mvj74kIsiotAOjn6ciZSWKhXTykv2JwlNcc8qtGj/jfpiQmS1YKUKEGxq
	e6rGagNcD2d/yB/4h8vlwVNOYemLBJ4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-Rk4B-yIiPtGQo5hV57nxMw-1; Fri, 06 Sep 2024 08:04:56 -0400
X-MC-Unique: Rk4B-yIiPtGQo5hV57nxMw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374c434b952so1067556f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 05:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725624295; x=1726229095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tc07zvGyCiSLPaYrP+kQC7S675jJOEsGznL3PVrjuoA=;
        b=iG2v2xEMktnHdTYi2P6SXqv5QGMW46AXCRGER+rR16S0PgWGWGy2AYMYeNhZx4LzlE
         wa/tRr1BoY/IQvBofDC6sPnt4voWsFfotCB6HoiBH7XuiQpVLwLbY+6IxUaLKEAvibv7
         hdyNw42KaH6YNy8p65mqtEWeNjcMhXuGBK6Oep57pVey01s631SL/mwJHlwB0hzYnjrf
         4kKbDsMqrELO3q4fDvWQqYwh1uEvuuhCZUBYesJRtR0A2dxbHgav5MuecrjVZ2pdLJGG
         0GJ4I2smoAQLm7DQDS+gb2mF3TZ/s59a54F7Z9Lf4UrhSO0nP5kS/LPzeaWTipRuoExr
         nbAA==
X-Forwarded-Encrypted: i=1; AJvYcCVbbwiRggbqWCkpxNL3k3JPVR+33IAH1MOVBV/wRU13x9YVDnfMTBn2wuHUV3bo4VbDxXMejg/Ws1Pm10RM2QA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4XSQXPGmKSfKj45Mh+ac3ydAlSCJUy+MHy2I+CvvwGuzwHSej
	ldHgBptmACN2T/jQwH2bTRkBoBgB8qDu6UbHfB9yLdAJy0OgAwhO0wa1EzW//NP9WIkpztqOTKy
	HywPNXbhApCq2096teocsGGwU0ZklkQxrlM0TBh+Ba/Gn5+UwfygtgemNV/oQhEtzkw==
X-Received: by 2002:adf:f488:0:b0:374:bde6:bff5 with SMTP id ffacd0b85a97d-378896a3f30mr1662832f8f.46.1725624294906;
        Fri, 06 Sep 2024 05:04:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbR87w40KjGE1b97gvsYds4sMcM1bBpW/FoDG702Xq5HctTZU+3n1iB0oeDTTrGblPjEdGcw==
X-Received: by 2002:adf:f488:0:b0:374:bde6:bff5 with SMTP id ffacd0b85a97d-378896a3f30mr1662799f8f.46.1725624294075;
        Fri, 06 Sep 2024 05:04:54 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374bde83ebdsm16914774f8f.48.2024.09.06.05.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 05:04:53 -0700 (PDT)
Date: Fri, 6 Sep 2024 14:04:51 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 12/12] sctp: Unmask upper DSCP bits in
 sctp_v4_get_dst()
Message-ID: <Ztrv43ZxmgQRW+Po@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-13-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-13-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:40PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

