Received: from mail-oo1-f65.google.com (mail-oo1-f65.google.com [209.85.161.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DA03D3CFF
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728134; cv=none; b=RgITYUGSXnABCOLNZHOcS0fGyKBT9sHH4Wdv2+8epqk6+k79pXdEQST17eCLEHdMbSWFWavzGm6ZGTmEasKJMfGRvE+mE4UUzDnNRhxt/d2MQBvkUqQvA9T0uHFYLRR7UfWQUYFeex77NP9dYZi1mOVU1a0OqzKY/vOfG6uzofU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728134; c=relaxed/simple;
	bh=UJMMueYGnDPFysL0784GHRpRLCeFirY/pdilXRWklJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ue+JmTwdpJrPCLM0FPI+l2/3w6HZXgq/u5/KRXiqf6fQ660eTSLSyDQEm5ytP/stKKVD0kczsU9SUUnbzlHsL7eIfZFLnBMoAwHCoCmyFXZdT3DipzpeNUxOzzo7fCiaTTrP+1Akzm0xT0S+iGV9nuVyiBtTbP5FkMuWTBbiqSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=ZFtWMKES; arc=none smtp.client-ip=209.85.161.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="ZFtWMKES"
Received: by mail-oo1-f65.google.com with SMTP id 006d021491bc7-662f2fa7e67so3368346eaf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Mar 2026 08:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772728132; x=1773332932; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlPMcv6N3Y/+mWnEMF2Wqs2gvjIQxxbuY5gzr6wMqo0=;
        b=ZFtWMKES8WGY9JO0S57zavAwnKZuQcZV8iQNyA+6conQmNulNB37T8OM8Y0WKGJogf
         0gSd6grmkXdad2HhmNbW+oO3CVpsEi3EnDMfzf60pawyzzpbXz76sMmcSoZ6ixw+Nxrb
         irg27qWGbryHE88tNgstWC2SDBn//lcwP+CaEUbMiRhuoflwOouG3e3ku5gGJ8b7mybK
         aySWe1fGDcV/XwbSkM08TEOOwRYo7MDHmq0rObC2TSoHu45I/r8fsivLdZOeMclewBT1
         X1lqAKbjv7wYO9bIn39PbPlvD4sNBnMns6KWyClPsJf5XCC46Tu4bjY27QarVLSv5S6R
         RMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772728132; x=1773332932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlPMcv6N3Y/+mWnEMF2Wqs2gvjIQxxbuY5gzr6wMqo0=;
        b=RZxsh+Qjlm8M1X+Hk8lNoMvzkuCy75CdJYwt8ol68+YSMmDDn6YeAJRgEWNje9V37I
         i5t75k3Hz8Cj4aiF1u3TEmnQVJeZ1QJrTgjeirvy+0UUwXxI+IVnz1iNyg3n63Rjc/P9
         RdvMNXYSxeFD3qSE4hdk93XkvCSPlWMCEhdJX2VNeNhKOV4py0gdtS5/CPKwNIHeKPHX
         oPTaS5VBkPReUAO+eFJ71EWMSEVdXw5QvmHmhc6dTmkwF+eiXFBgspjPIwtQrEIEzUgs
         VYT7F+jPoWjrU7M1G9sKOFzZSArx98eta2nGUAAZr9yUlANiZ6Po6ryLr9Pb2NU4Bvet
         xCtw==
X-Forwarded-Encrypted: i=1; AJvYcCXxwxVkWKgn6zc2b/TVwX8HdNV2rXJXJtfUeJ0rB72m8OElH+QuEl3hGBI6DqT5Hq+w8e0W7eoSXiutU4u0WCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YybhC/JGdkKYlYi0ECTB+sf5FuwQztGIZbZnrG7ARDficIbiXPY
	zgcIz059N2qFbMhrOnycbcn4x97OhrFnh+N8Jr2hcQBWGFbtSeMT80wpHSGlVIgCQ+PAj1fY6yl
	h+NoZ91DvaA33
X-Gm-Gg: ATEYQzw5zaJbdtVzvy4+btNRYIs9vS9PCL71BZAB6pZf2ZODmot3BPzh6UCQ1FaS7EM
	d9yd09fDjJnQeSgTlJQLpdlPrhNbU1iVfGYue0JbUMAH3ulybjqNrEJsiQzznPjIOKkPhsrHtpX
	/IL81BtbQw7nzNqJaKKtuaMDb0K/Au4J/Eo0wVveWrHzIEFnWjgX2iU0d4BoIOOSVZ0JfyUnokf
	ntzPSX+1K4Zgi1OSpqoUEbxuFu/bV8kQ+MGFdyXvvIctf9cKaEoP7aafwQz/evQe+p+ZzWIUyta
	ozCq8QT5horJ3DF357rxOTfnEPAZron1sHfkNOu+CnBLVGokN6c83/EF3p45/OodGKi25ih1Ttf
	v9lhEcqdeQ9C3pp5Dk01ha1mjDxwr6V44NQmacKrcC/JJnOdSqqfWaHEmlGuIZFInLSL7kE/imf
	dUJIO7cw==
X-Received: by 2002:a05:6820:4cc7:b0:678:1970:b69e with SMTP id 006d021491bc7-67b1e9252d7mr3400958eaf.69.1772728132078;
        Thu, 05 Mar 2026 08:28:52 -0800 (PST)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67a201e1fa4sm5438444eaf.4.2026.03.05.08.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:28:51 -0800 (PST)
Date: Thu, 5 Mar 2026 10:28:49 -0600
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lwn@lwn.net,
	jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aamvQTTZu4-chpsS@20HS2G4>
References: <aahw_h5DdmYZeeqw@20HS2G4>
 <aaijcrM5Ke5-Zabx@chamomile>
 <aaij0XAgYRN40QdD@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaij0XAgYRN40QdD@chamomile>

On 2026-03-04 22:27:45, Pablo Neira Ayuso wrote:
> Resending, your Reply-To: is botched.
> 
> -o-
> 

I noticed after I sent, thanks for fixing.
> Hi,
> 
> On Wed, Mar 04, 2026 at 11:50:54AM -0600, Chris Arges wrote:
> > Hello,
> > 
> > We've noticed significant slab unreclaimable memory increase after upgrading
> > from 6.18.12 to 6.18.15. Other memory values look fairly close, but in my
> > testing slab unreclaimable goes from 1.7 GB to 4.9 GB on machines.
> 
> From where are you collecting these memory consumption numbers?
> 

These numbers come from the cgroup's memory.stat:
```
$ cat /sys/fs/cgroup/path/to/service/memory.stat | grep slab
slab_reclaimable 35874232
slab_unreclaimable 5343553056
slab 5379427288
```

> > Our use case is having nft rules like below, but adding them to 1000s of
> > network namespaces. This is essentially running `nft -f` for all these
> > namespaces every minute.
> 
> Those numbers for only 1000? That is too little number of entries for
> such increase in memory usage that you report.
> 

For this workload that I suspect (since its in the cgroup) it has the following
characteristics:
- 1000s of namespaces
- 1000s of CIDRs in ip list per namespace
- Updating everything frequently (<1m)

> > ```
> > table inet service_1234567 {
> > }
> > delete table inet service_1234567
> > table inet service_1234567 {
> > 	chain input {
> > 		type filter hook prerouting priority filter; policy accept;
> > 		ip saddr @account.ip_list drop
> > 	}
> > 	set account.ip_list {
> > 		type ipv4_addr
> > 		flags interval
> > 		auto-merge
> > 	}
> > }
> > add element inet service_1234567 account.ip_list { /* add 1000s of CIDRs here */ }
> > ```
> > 
> > I suspect this is related to:
> > - 36ed9b6e3961 (upstream 7e43e0a1141deec651a60109dab3690854107298)
> > - netfilter: nft_set_rbtree: translate rbtree to array for binary search
> 
> More memory consumption is expected indeed, but not so much as you are
> reporting.
> 
> > I'm still digging into this, and plan on reverting commits and seeing if memory
> > usage goes back to nominal in production. I don't have a trivial
> > reproducer unfortunately.
> 
> The extra memory comes from the array allocation, the relevant code
> is here:
> 
> #define NFT_ARRAY_EXTRA_SIZE    10240 
>  
> /* Similar to nft_rbtree_{u,k}size to hide details to userspace, but consider
>  * packed representation coming from userspace for anonymous sets too.
>  */     
> static u32 nft_array_elems(const struct nft_set *set)
> 
> > Happy to run some additional tests, and I can easily apply patches on top of
> > linux-6.18.y to run in a test environment.
> 
> I would need need more info to propose a patch, I don't know where you
> are pulling such numbers. You also mention you have no reproducer.
> 
To clarify this issue _is_ happening in our production environments, so I can
reproduce this issue there. It only happened when going from 6.18.12 to
6.18.15, and with a service inside a cgroup that is mostly applying large sets
of IPs via nft. I do not have a simple reproducer script or something I can
easily share yet, but am working on that.

I'm going to try and revert rbtree patch series locally and see if it still
happens. I can also play with NFT_ARRAY_EXTRA_SIZE and see if that is a factor
here as well.

> > We are using userspace nftables 1.1.3, but had to apply the patch mentioned
> > in this thread: https://lore.kernel.org/all/e6b43861cda6953cc7f8c259e663b890e53d7785.camel@sapience.com/
> > In order to solve the other regression we encountered.
> 
> Yes, there are plans to revert a kernel patch that went in -stable to
> address this.

Thanks.
--chris
