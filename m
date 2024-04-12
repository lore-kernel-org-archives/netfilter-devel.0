Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290561B968
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 05:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712900141; cv=none; b=I/j5REA8g9b4oWtBscih2NHylRRCUsUdmey4ng7D58S/7hI4uGG/v2HtavKp6DIWDKRp2vF0Z9p7d0zkF1iLV6ulZcP1Wdv0RwWreFi6/SSSA4DK/GFPluivX4YE5sWjxkXFRja8QYKjARxTCsXjdLW9RiEn1chh5EBssqgKKm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712900141; c=relaxed/simple;
	bh=O/nX0bk0Hnk747AhoIv1q2hqaXTmeJYDv0eLhv0qamU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9ANDW3Qg0xasqo2+aMIdApPMpU+dQj/hSkORSs4Ft/FcGBx06QTEJSn3+Be/NLHbN2RGcj0PTu9tpklSpzdzFbd/kAECiR5p1ZWHH13QHNLNJlgfbilpcsVp/poHrgZ01htdU96kN5GPCmSMfYKHkSywPBpPLPWZ1cA3D3UdUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qe782jIU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qe782jIU"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e3e56c9d2cso5156105ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 22:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712900139; x=1713504939; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O/nX0bk0Hnk747AhoIv1q2hqaXTmeJYDv0eLhv0qamU=;
        b=Qe782jIUq3jSZQrywQ0MVof/K+Z/P1lBjBw82JIaNY+6WROYBSfEqMm7zEGAzVPXz9
         ucIfOR1rxNtHI6gg1FUTvoQV6RN4LfIP3uG3pRIeD8jYbLfMeyqocinZqU2SJRpkudN3
         UDpYJRwEkl6qQ/Vsrr/zxBrfD5JiBNupJxTzHnGIN20q5Yf66LdH00zd/I7exDZWK7km
         r1nBRWJE/A9TNCQm1A0I20F1w2Panx4yzyFTiKAlP8dkhoejJ+ku1cmwqvULyRuyeIH4
         gA+8FWZC4xbG9oOmGQEBFsuuGGhBLtBbrtUQIlpirXILy6X6e2lEY0wRKBFpRTXqT67A
         siDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712900139; x=1713504939;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/nX0bk0Hnk747AhoIv1q2hqaXTmeJYDv0eLhv0qamU=;
        b=FIYWFruhrOdcpdav6glSswt6lLqyslFMQne3ChD+5WvSti7XoTW3JHv+AsxA35DLdJ
         hWv83zne2hH40g0l4HwWvtg8t/e+zYzd8BttM9Y1PbsaLI7OAKF7trGLKPhnns2h1qCF
         cMij2cka/YrI42scWECGmHo5+GRZsKxfmVN+E5pkD/D0nb+/p9i7HX75AO17+3FJ4ktE
         Ol6JOqULepLZAxCc6FUgQWL6YM3FlslAbYwXGuyS/9afcdus2n3g5G/UXHc6MxV+H3DG
         HjA+OxPtxc6nictXf4BABXHgLYf8Twa0iiznIWuvXWZvYDEVj/8YI8GPCVG7V4/NY9GR
         MMAg==
X-Gm-Message-State: AOJu0YxyFnamPHPHZ2g+u3s0kVdPoSYt4SVHB4ZqcvC2tms59ZXo3tw9
	f8lbcP4V1W6whzqsqm0c7FJRKunrKJNhgpcGz/nDa/CLfNmv1KsREr6dPA==
X-Google-Smtp-Source: AGHT+IHO5rnpY6Gb2NoyfB1RBi1T+Wu0K1gVkAD4OuxanY40F+XtKPSSSO7b4sL5nFR/gETpLwsKeg==
X-Received: by 2002:a17:902:e54c:b0:1e4:fd4:48db with SMTP id n12-20020a170902e54c00b001e40fd448dbmr1557653plf.43.1712900139456;
        Thu, 11 Apr 2024 22:35:39 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902da9000b001e0ea5c910dsm2124220plx.18.2024.04.11.22.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 22:35:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 12 Apr 2024 15:35:35 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: (re-send): Convert libnetfilter_queue to not need libnfnetlink
Message-ID: <ZhjIJ3qJ45783PI5@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZgXhoUdAqAHvXUj7@slk15.local.net>
 <Zgc6U4dPcoBeiFJy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgc6U4dPcoBeiFJy@calendula>

Hi Pablo,

On Fri, Mar 29, 2024 at 11:01:56PM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
[SNIP]
>
> ... Then, document how to migrate from
> the old API to the new API, such documentation would be good to
> include a list of items with things that have changed between old and
> new APIs.

Waste of time I think. People are not going to migrate - what's in it for them?

*We* have to do the migration, because *we* then get to ditch libnfnetlink.

Over the years you have mentioned a desire to do that. Now it's done.
>
> Would you consider feasible to follow up in this direction? If so,
> probably you can make new API proposal that can be discussed.

Actually yes. It would make things easier for new users of libnetfilter_queue.
Will detail in another email.
>
> I hope this does not feel discouraging to you, I think all this work
> that you have done will be useful in this new approach and likely you
> can recover ideas from this patchset.
>
> Thanks for your patience.
>
Cheers ... Duncan.
