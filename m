Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9815B193097
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 12:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933092; cv=none; b=HWz22qYAMN5VOKYxTTcAQCsZApzeVUNEJ37/3ZcZQsfoyukCbSqk9m7fvXVXOmNKsB9L4ZGXgi35eEg/2iobbBhkgX5Ol4ea79YneX93Isuk+POXQVrR8Rp0XKhR3+B0x8nCWt9zYLoBdvZs6NBvFZv67f9ft0OjjRB+aNjHB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933092; c=relaxed/simple;
	bh=3TV9ovRmfbIKF5feyjBePyV5R4bYPrY3+rJnxmHqztE=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caYDaMd3TNP/ZSkjveDQadyhl11eFjfknFKPAfgy/2Gmnj4EE1udBa+9oAiWcSTdN6ng0oWNvTOEoTkX3Y3sHHcliXvcgRzYexUTtmM+OIx7bvjXpccG3MfiBF+ia73Qw6Pu+mRAN5fwWWFIubcN5hTSPGVxXAdVhhHWO0mE8Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gAuudSaE; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gAuudSaE"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86cc0d10aaso59596666b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 05:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724933089; x=1725537889; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7EX40gslhdhY+NN3lrltEDo314H6/g1OwEaC0Y0GMHw=;
        b=gAuudSaE37UxOzp+ucYwLhWyoYRHi6NtJ942s/cXVWaSyZCF0mbcx5KT7cErEOgILp
         fvG143ScdhEK75PwYtgswlWfJTodioSx9txCnOvfUHxkIMqKRA0b17v+t6Muu6xktvMF
         F68Q69hq1i6IDkfp37BvYzLxDOjp68rQOFhdAlNp2FBlavBA3zRdkQEsfpMXU0jxx/sz
         2FreKP3dSl/kSua/OtAbrYnNIOhxMj2zU5xEOpjmr4O6Coxkhw+/H+DSDIGXTkH0Yz33
         x8n6iYn+Rdc5G8xczsA/RuLY5Z1beWzDn1Y5/2wvWIcxi5xcWgdal1chc91/XdEu9YNR
         cx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724933089; x=1725537889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EX40gslhdhY+NN3lrltEDo314H6/g1OwEaC0Y0GMHw=;
        b=w7g8HSCuK6vrXQbFmlojWm+MCBsdoeZdpipQieAxTx2iJLgYvvaUEqF7+r4jGhSPun
         5tNo0BvGZ9JyvEbFFFSVVu0jP6vZtr0zPYIidXB5VF7g252qTy+UCT1AWNIX2OJW0Mx9
         mQv4pr0zYlbhu3Fmvca6sp1HTgx5o8E32u8PtgyyQffTVgs3UVWfBtAHe99MchG2J87o
         Ff7Yg6Br2rFTTqe27XUw3H0NNOQw+2YemhEGMZlCVfRlLFoFUX5sVMehGDwyWaM3hsYn
         z7PHj5EhL0ryLRpVJsIHJgLJTlODYB3Tbt2QGINb+ms9m23reWX3WrAsOY7aoA60f9jn
         aO8A==
X-Forwarded-Encrypted: i=1; AJvYcCUdJIRbXPSJRiYM3G3Y7yq80sVmtDPRKO7wNHzbStgELYkCwnaPsZZgjgphEWR+IS6LAVcL5aiaAjgVMaXr1Rw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt3yRQNsvXJ7SxAwzGKIHEf/8+NYvKL3GFeGQhmKGz1hNnSzAD
	gUAM3GyJOKJaFAnAVuojXszrNuKyL4rmTBg/nZCivHQGOATfft7Z
X-Google-Smtp-Source: AGHT+IHUGT/HcTCNQknOuwRANVh4wbT/SV2Jq7azIMIwoQZJC3cmqI84/UTXsMxO3uoVAF1FYDvVPg==
X-Received: by 2002:a17:907:3f1c:b0:a83:94bd:d913 with SMTP id a640c23a62f3a-a897f7892d1mr196590966b.10.1724933088533;
        Thu, 29 Aug 2024 05:04:48 -0700 (PDT)
Received: from thinkpc (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989195e8csm71456766b.105.2024.08.29.05.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:04:48 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
Date: Thu, 29 Aug 2024 13:04:46 +0100
To: Phil Sutter <phil@nwl.cc>, Joshua Lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/1] configure: Determine if musl is used for
 build
Message-ID: <ZtBj3hmWMn5lapzA@thinkpc>
References: <20240828124731.553911-1-joshualant@gmail.com>
 <20240828124731.553911-2-joshualant@gmail.com>
 <ZtBWoImxzGRBFLs2@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBWoImxzGRBFLs2@orbyte.nwl.cc>

Hi Phil,

> Thanks for the patch! I tested and it may be simplified a bit:
> 
> [...]
> > +	#if defined(__UAPI_DEF_ETHHDR) && __UAPI_DEF_ETHHDR == 0
> > +		return 0;
> > +	#else
> > +		#error error trying musl...
> > +	#endif
> [...]
> 
> Since the non-failure case is the default, this is sufficient:
> 
> |       #if ! defined(__UAPI_DEF_ETHHDR) || __UAPI_DEF_ETHHDR != 0
> |               #error error trying musl...
> |       #endif
> 
> Fine with you? If so, I'll push the modified patch out.
> 
> Thanks, Phil

Looks good to me :)

Cheers,

Josh
