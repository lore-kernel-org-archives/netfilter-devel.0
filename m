Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC5D346AD8
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769513263; cv=pass; b=dDe/iRK/remeOF2d4ReN5j3V8pV8i5Lf5kCY7F//OyCKAbjWNxcFnzoKCxcd+vsVM4vEwz9Uxqd1p4/PbLjJGGemkKnVSmbqi25rLbsnsJVMttk5PeNkwQOu8a6FUU7TSkX5bDGDxHE4SNZmh+drzhTs2fI4r/1ml0oXxkuXvAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769513263; c=relaxed/simple;
	bh=LZoxGYiN0vHiV7IaMBXIg7wAr4TzwFl7njOcZqJwhgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u7Z13eS7yQZ452rvhKAEBDu8J3u5CWvxdvHEdq9WL/+/BiNWhonC6Ufo/IVM6Y/dHd20F0+9ZGZmGYvNA0p5DJs6q8/eAy58mAgtmuBdLL9bPPp7GL2tRwsByvTZyLHXVcQbSrPSX7X74htmJ/k6RjgbqpDhupPUUMmbqwc597w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vuwm7Lgn; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vuwm7Lgn"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59dcd9b89ecso6894398e87.1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 03:27:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769513260; cv=none;
        d=google.com; s=arc-20240605;
        b=IXjkjQnXr94j14sc8oSjDU6glRFGTI1XRoWEJhf50Uz4ewmFW9hiRlC6fRRKWOFJeI
         ek42BrKC5lKULj9ZU+1NzA7h5qWdvLxXdp1SL1gXALF16WeIFtso9itfsimcufBPV9Bm
         ewNIDHSMyryQCCJWW+7ExdHWQYUSJloB7qH6HrYdM1OIpqnHd/9U9fpH2pW+SVjKkPQm
         VOI9RkvxJYeVkEQwh24dbRd01QcCoarJGikVyNdcl54GUDhreZeYuzhTonICwMd7WrzY
         iMtLkM/APvNWstkQDpK9/i5gPF4PAfc60n6bJYuhPgajTlgM+hD4ZrmqebI9XGuvn0bf
         E52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LZoxGYiN0vHiV7IaMBXIg7wAr4TzwFl7njOcZqJwhgc=;
        fh=bMGN+JiYlz/DpxgIypAfdOE+gD1ktJKH/IyfVlpCZkw=;
        b=AoTzCXq2NbUN8f6uT3GnSBXBo8VvEV910hVOyjY75xuempErt+yPFZgaN71HyTHzfg
         +SlIGUyOjK664SSo4FtukehnAaXXEpDl1A78RiGIdEn5rRWUo/JgG1azTce1/p7a0DWa
         uBlhALSrJpD677SC0xGgD9LIeV3JUTB6kqZRtx+gJnJ/4kq6+DeFXoghe0KF6fu0bWpg
         bpDIdiSYm/TbepyOVhc3cL41R6ICwBFdwpS2U3WxlFpQFv1MBlF3IRjfrwtqIzp4ib2g
         9wNhbOZn70tR3JMWXFehDe2S2nf0bWq6/v8k9NpwSzUAI5hlKLWDw7fTnlh/iBERH0s7
         txnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769513260; x=1770118060; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LZoxGYiN0vHiV7IaMBXIg7wAr4TzwFl7njOcZqJwhgc=;
        b=Vuwm7LgnNzRJSBvwVeEYFu8ab8r2mQi3NAczzt5qobuZfk5MEeoE/WHOwr0RorF5Mj
         8nRtfCCXhEzJXpAqwPxDLY/11xn0o07kSApQKA91RNmMZHoKrVafTF0wKMCRZ4CA2bzd
         RQZal+5CbJW783cJvkyGE6eWQF8mD/eyCRBakOvAMpx678TAhQb1KXN9WuDdKXYjTWlb
         nWVly1SGag41aDdVeDoF1xhMdDWcY5CHvjV+1hkE/cbW9uyL53T+x6qPYz+I2JY9vRdN
         CkCnxgDBQaN1v15F/FJynbfaKzQcLrgaTpFQswQ4WbXUXIFzrf0dy9uUf5LaoWRN/fcy
         O5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769513260; x=1770118060;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZoxGYiN0vHiV7IaMBXIg7wAr4TzwFl7njOcZqJwhgc=;
        b=UZiMtS9zL2eXHfyR9IFe0MqLFJ7Tdqm8PRpKXjqsBnbskCMPA/K7476nZgefID7e0m
         M+t4LG0gfU4HKmrzcrd9A02dEPyNb9V5P9L/kklD8enkHoZInmpTgOqAXTNxditDg6lI
         5r4FP1OyX6Gk3OjWbHovReqXhUK4V3QGvZ/tnutsQ9ekN+7oYwRlpZfo9MiVhka/3Eq7
         tku+JvfUqV8iwRqFm4F+rCUAcPp+WwlXKMX8hD4t9CAI2DQMOUxsZyQSxtyqN/92I+Bh
         z8lU9Y/u/liOqc9Oq0g4gTDcwcpkOX7zA6z2USDPuZQSIEqFBKwviHWv6L64iqcOhsxI
         ItCw==
X-Forwarded-Encrypted: i=1; AJvYcCVvNyP5CUdg83iWu658dUTSsJcE3Goj1p9ZrcCmgr+lUemaD2NW9ab0j1/tuAWFvL5tHDziQma3qulv+3a8gWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbDeeccipIB95JiOmTuxihIecL8BrGIjzzDbEPdSJcO/TTtU09
	YsAyC+ZMvikUqI+u1aJOCKpkdly0WqvdBSZ4akyfiXRkLGYRggGmp0gej2FpJfV4498kmNBezDa
	tavrH5gn9B1pwx7C7wRl2ORSpMKkd0Jc=
X-Gm-Gg: AZuq6aLezyGVPudfFrbqWwkzASZdDs/BSbLvvikY5RjnoerYigncLzOPOjFCDB/Mhdi
	KRF0ydel+9LFtc6vanCIyNU0FRT75Rho/hl4xMMEKwghsvZ+WSgQ8uc7p9G4x/rzkvHsAGsqacQ
	OMliqOcFJaxPj+HXCnTtOu6u9QgFk0iNleqOtT5JEjg8I2d/G2usDSAK1Mkv4TklFL3Z8HTU/72
	X3B6DdadXkIfhVozwvh2VdctlTbUKqyPH4G45xfNzo92Ik+jZn8yENHQpguiR9bEMebt838SoVM
	yCfPSTpqRuoZZY0v7r/zDEkqnw==
X-Received: by 2002:a05:6512:61a4:b0:59d:eb40:3 with SMTP id
 2adb3069b0e04-59e0413e62dmr556849e87.20.1769513260389; Tue, 27 Jan 2026
 03:27:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-5-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-5-one-d-wide@protonmail.com>
From: Donald Hunter <donald.hunter@gmail.com>
Date: Tue, 27 Jan 2026 11:27:28 +0000
X-Gm-Features: AZwV_Qj78QlukASUl0qBzsmck7KFGqr0HZlwBXaLlgFkIp-Cb-R9BFq_Iq-h_T0
Message-ID: <CAD4GDZxxY=RxJq-UEw49-vxuzo3SzbKj4GYCrWbEKemxha=3UQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] doc/netlink: nftables: Add sub-messages
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Jan 2026 at 18:47, Remy D. Farley <one-d-wide@protonmail.com> wrote:
>
> New sub-messsages:
> - log
> - match
> - numgen
> - range
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
