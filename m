Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4A2417C3
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Apr 2025 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192309; cv=none; b=UNSQj3U+nUEy9JiGGUlHgapZAvghGiy+eNjYS+s1LpvA9tKYfPhOI3IES04pGfLtt+9LzVeN8M1DRnwwesLfgyOib3DpGnR/lU4NKysZRhul6ygHoW10dSJAgHZh2UIzkQPhMo9gtX27tLoJ9gj6NnxHOahm5qOcKFHY+tkfDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192309; c=relaxed/simple;
	bh=IBVJm7cFwH0n2jX/eRFNNlOlTxnoLfkd0/sVaxXwBGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxc2Mk1CEK6T6OHUQuqjWv+zmmpm9KwtGkeLi4IABeKtRGM3ZYMwxgu54hM6OjJyFuYOR4Ww5dANIX6lnLtpGg/vRhcLOTcl1+0AKXbvX/HLRKX6NcYtRtnqFEpWU6MjarDX193sWEjW9ZTaJc2AMiQFV1fKTWu13rmjEzpvNkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXBgLRlV; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXBgLRlV"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54b0d638e86so7899255e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2025 02:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744192305; x=1744797105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQQY8/h7R2uDIcbvKkpTw7z///zdK3ytZpE0Z7SdlOM=;
        b=HXBgLRlVFW8N7t9XNxA3wGVw01rjdB7VM+m3RXK9/eBxcRaADWWVesEQTv/ZaNv7uB
         Ixn1CVnLwruucFxHSYTZhk4LMf8OZhKOYYIaOr3Jz/JxdNwdrq56Sc7SSc4I+TaFiVdR
         4jysykdsGCss2F/8uCwSazoYeWK//cyFNeqf5JyOmS7ZcgBXIaFtvB4O9qKHd5UpyKZ3
         LbOqfci1NSQO5sFRFvmiQFRX634k9y/ifpIeL1zTBlcwpx7O6q8oT0G3Guwy4lbjB1oU
         HNYETh5bPEkCKaL5h37A7X+J9+5I8OyuupiamodAPPS90TTuBhVyCSZr8bjN/QWsHeZn
         igOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744192305; x=1744797105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NQQY8/h7R2uDIcbvKkpTw7z///zdK3ytZpE0Z7SdlOM=;
        b=ZTxUYaYpuLZbaZNeB2wMFTUCby1cP5stylAKUviqJ17+oAYwRDXNTaF7OsBZPg2Rw6
         XWlvnzVMJY97CtcqfVJWzIJLb7az/adbCS581VuGHS8qNfA8rhn6L3tDYvt52rYrgV33
         zzEV8wvvX3rwzFr8fT/5/tuVpfr21Y2qovkJ/C5ig4O33K+W5rbrvSAIGxDysm3Dz96V
         KwKotkygBuRLvnByol4CBVpqn+3vRHKF1ZTbVlJw5O9g6fDZ6U7m1VhM0GiVkgJyn2AW
         r8bQPxl+gV4yZNFe9PwK4HC8ZEmvZiC/8qDZEivviFiogy8aduNoAZBpXct7ubENi0/d
         746w==
X-Forwarded-Encrypted: i=1; AJvYcCXscS0KxxfGTpDalkQsA5W2FNoAOA0N2N1OHLIRWYTvbmKyk3UqIshBSiPBmWekEEd8uQ4neN+zXZIgiQYFmAs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAIvzbrY5H4gOfW1URaZUIKKN+UqGRnBIem8TqciY12oPaBiQU
	gkKBpqTa0fPtA9471rNhbSuoK5tdp8Py3d568W6/RwWv+WUCUhDoeRIZ3kVVFIJdHNoGhRfRSbl
	tM/Gw1YABkr7uEskZKWPsvl4Rn54=
X-Gm-Gg: ASbGncuer5SSRkNfFzq8WULLcse2knXc01/41vyUeDmuMpACV8Cgs18IQ2VNtuID+/Q
	uKfeAj9Jrn3kKMiDru8u0OWTR3YwNUXB8yYMBUA4xjq5qBNkFNZZMBzFLFcydcmTq82ZQSLoJrr
	pE8jLS27VuOEdMTgXIzjwR4xYTcxtxdtr3HY66QhgUEph31awgQU3YIClu
X-Google-Smtp-Source: AGHT+IGAjLzSvwCJKUZUZI/VU1ljWdhfNvTyJeLYs9S92hZRwye4sgGOemvPqN2hJlraM5d4PVQty6Rh118OnJtV6b0=
X-Received: by 2002:a05:6512:eaa:b0:544:11cf:10c1 with SMTP id
 2adb3069b0e04-54c4450ded7mr524844e87.30.1744192305219; Wed, 09 Apr 2025
 02:51:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404062105.4285-1-fw@strlen.de> <20250404062105.4285-4-fw@strlen.de>
 <20250404135129.3d0b5dc0@elisabeth>
In-Reply-To: <20250404135129.3d0b5dc0@elisabeth>
From: sontu mazumdar <sontu21@gmail.com>
Date: Wed, 9 Apr 2025 15:21:33 +0530
X-Gm-Features: ATxdqUGa6XX0gW-Ars5oPInfEITJCDdWQbYMupRVnCSiEP_jeyMHA4VLBMPnMZs
Message-ID: <CANgxkqxfxzJdE2h1R=boQkAFQB=35EFYQ5fQ734nvaciSyJpow@mail.gmail.com>
Subject: Re: [PATCH nf 3/3] selftests: netfilter: add test case for recent
 mismatch bug
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Florian, do we have the same test for every bit in the ipv6 address
both matching/unmatching ? If not, would it be possible to add this to
confirm that we are matching all the bits in the ipv6 address.

Also, a general question, where is this netfilter code maintained ? I
found this github where the code is present "GitHub - torvalds/linux:
Linux kernel source tree" but couldn't see this fix in Pull request.

Regards,
Sontu

On Fri, Apr 4, 2025 at 5:21=E2=80=AFPM Stefano Brivio <sbrivio@redhat.com> =
wrote:
>
> On Fri,  4 Apr 2025 08:20:54 +0200
> Florian Westphal <fw@strlen.de> wrote:
>
> > Without 'nft_set_pipapo: fix incorrect avx2 match of 5th field octet"
> > this fails:
> >
> > TEST: reported issues
> >   Add two elements, flush, re-add       1s                             =
 [ OK ]
> >   net,mac with reload                   0s                             =
 [ OK ]
> >   net,port,proto                        3s                             =
 [ OK ]
> >   avx2 false match                      0s                             =
 [FAIL]
> > False match for fe80:dead:01fe:0a02:0b03:6007:8009:a001
> >
> > Other tests do not detect the kernel bug as they only alter parts in
> > the /64 netmask.
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
>
> --
> Stefano
>
