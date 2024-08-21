Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B98433B5
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724252717; cv=none; b=OZg28+fY4+h3gg4bT7Ry9vB5+YPcE/KL1FmOXwMjP+mvfe6igG1lS0eY9aXqztb7qXEW6mg9HhNoYcgeoRzJFKX3enEeOdwqDRZPEgkroD4Z3mxD/2kZYgvuTJb1fDRa99ByqKXzE3KeV02Yz/EBa5v5OZafMdsl9h+tlIXbry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724252717; c=relaxed/simple;
	bh=ZV76DnlRgRuVCMPNFKzemZfCcklx29bWsEEtGUWse5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7h6OVASyFAW52QnVtBVAw3dDFhB4MdwMC/0sSEmopyJI5Ckm33wZOJsbgHNGxElFpkmP80hdkCDtcqc7fCzIjgQ7h0S27wYNzRQ6Bpw6UGJlOPaNPbMVc0CAhw/Dwikv9P/EXtlpkGLisXJfJFtJICpLoKnM1ZDCCiJcmGgYpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hg5aeGIb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hg5aeGIb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724252714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtPyNhdXIXz4+vJglLOBphOc3sqQoJSYIIHv/Qiktbs=;
	b=hg5aeGIbwoOe3fgjfCKpo7TquzMgnBtmgvtwT9M9r7aLg7IFfvqvCilRb8rWSQpaxH4SMC
	nZHfOhUukyPS+AwzkYrBewU/H9HmSrtqzOXgc5wz2NEuiYs84qZPbM/kydk5sdjUIDqW8R
	Ti1T39lgW0fWkMeP1ioOIC5QwfuNIro=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-Q9ZrqFvlOd2JrMQ8qDskTQ-1; Wed, 21 Aug 2024 11:05:12 -0400
X-MC-Unique: Q9ZrqFvlOd2JrMQ8qDskTQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52efd58cc5dso6877345e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 08:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724252711; x=1724857511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtPyNhdXIXz4+vJglLOBphOc3sqQoJSYIIHv/Qiktbs=;
        b=fnDWtJWG6HCCsK/GOjEYfViYqN/g/14mLWqYUsrCmdxelCOz2xS2vmKpQ0m2N8Tsk8
         AG7KOHsMqT5mfUBWbpVUBy+1iOq6H2x/2jcc+2xloD1X0rw7zlgTAaMJKPMNRDfuI/cg
         J7mt1qf/OzN8lEUf5BB3EAkTfkfKdcnA41UiHTnKPSy34kZXsqmz7n/A0DiMg4XHIkiT
         8oVa68V1e3/opNwFzVwDIdMwimPVRPV+uxxp/sRvmtx0Hv9FvzLIAAELS6N7GUTlbF7U
         YXp0ztj2Ty/HbxCwnajVNteDPnXHbaTBL7rfqegvolo/cy8FC89TsBBVSw2zv7mfcBkP
         M8wg==
X-Forwarded-Encrypted: i=1; AJvYcCWKT59okvYu5NkZ/VuUXtb/kc9pre7ZjrDdoX9i/BFdbSyY1lV/VW/VuCs4/xqX/yzCzeOm1Xh6zh5rziWAPiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDRU/mBpYXvl4doEc9yKdT/Acf1wb2Pko7i2NFE/ts74GmgER8
	ZuEbsDx5hgNe2aNh+ajKIlA0UQ7AmTk5qwBuOt3FLjxB3o2JcFsG+GH+iQzYUcuIAu8M5ZBghsO
	H+jGqt9obhWE16eV0CONQx3PJDvKAM2kB2sQs5Y9T97gPDgFHJHT4LXEwccsUEI331g==
X-Received: by 2002:a05:6512:3da8:b0:52c:cc2e:1c45 with SMTP id 2adb3069b0e04-53348550ff0mr1593654e87.15.1724252710968;
        Wed, 21 Aug 2024 08:05:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6O4yAiGQzDHr19kMW1ONwMm7G4w+8mhSrKkiGWmZtlL6oFvJTyJGuNvSyfSkYEw1bs9fvxw==
X-Received: by 2002:a05:6512:3da8:b0:52c:cc2e:1c45 with SMTP id 2adb3069b0e04-53348550ff0mr1593598e87.15.1724252709931;
        Wed, 21 Aug 2024 08:05:09 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abed912c2sm28426245e9.5.2024.08.21.08.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:05:09 -0700 (PDT)
Date: Wed, 21 Aug 2024 17:05:07 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 06/12] ipv4: ipmr: Unmask upper DSCP bits in
 ipmr_rt_fib_lookup()
Message-ID: <ZsYCIwtVxvRhzJs/@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-7-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-7-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:45PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ipmr_fib_lookup() so that in the
> future it could perform the FIB lookup according to the full DSCP value.
> 
> Note that ipmr_fib_lookup() performs a FIB rule lookup (returning the
> relevant routing table) and that IPv4 multicast FIB rules do not support
> matching on TOS / DSCP. However, it is still worth unmasking the upper
> DSCP bits in case support for DSCP matching is ever added.

Indeed,

Reviewed-by: Guillaume Nault <gnault@redhat.com>

