Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9994D20A5D1
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 22:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548124; cv=none; b=CwdNFEPWn/bXfNPlbUk3DQZPr37O9/UmYbFolw+i7HzxXPPZzpSJXLDM3VNwqN7cpEFQeNWfRM4TNcHvog/r3l6NIS4Unig48u4u/XmWjYgarz+dRVJWLZN9gnSmsQHhPA+eE1+vZcYVar+ysBg+ay2UmHJIXhRmNaKQbYJysJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548124; c=relaxed/simple;
	bh=yz7hdHzSGT8RLxqjv66rLYzAlso1UyK95kybCpSwVaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=VQ/D4geH6xbQBTIk0bQdF/aKKttoD20tVn+FXSPJLOPFlNwr0i20a+sBABcgxWXope64TrBoY+5TQtN2PdPSBMw8ShORxAL2d53d5Y8evbpZQUxqjLC9IxiKAW3bGehZN0MBBqJZH4RnbsZBMNoNX8qwsVxXW5y5daXESe7ESz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6ZWZNB9; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6ZWZNB9"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaeef97ff02so426182466b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 14:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736548120; x=1737152920; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbVeUTCDauDg/x9IqGObYb0HfZyuMEP+GDJgpAiPuzk=;
        b=O6ZWZNB9ncFYLKs68nbUoWGG172vxFAY2q8yf3Y4SiuRFJGtNhvt5Lc5j8KIVmntP+
         KvF2y0MeC6PEGPltht+4ewnbTDZ3IsvYwDHtpVIAK3CmApFU6ND4k2KpGDQIn1+bzJcO
         XM5hl6TKlts8JVlFAxqRNtpUjhGSAiHOUB/PshToUbd4iPIRk0N1qjKeWy5WABD5eKAI
         xBQpKfVKIu9d6blVgNOJ4EB5Lg4flr8ojxzfjim0BDOEKt0UA/zpUVFTxd1R6Ck46gxl
         G/7P7P8BvUGqj/XXs0Jajd2e+882QcEKVXOWDElVXyxLMlJT9a+SIdY1VhwtonEtJ7mF
         BbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548120; x=1737152920;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbVeUTCDauDg/x9IqGObYb0HfZyuMEP+GDJgpAiPuzk=;
        b=rwCshl2b54FiOVcUeosOBed3rRMDquCHQq9ab9NUQc6S97h1+XKoNhWhdklVW1leNl
         b+V9RivJ9sbaddl+xD8UJtC3bklnezyI8nkH9qpL1TjkAM10JLaEm67OlwGWzZJIRspg
         FIl9Zuug7MxfNjwYuRegetS7NdiX8jcgL2eQPOuGIE/p4hjGzTAA1VjUO82WGdgsTzo9
         qmNMbNS7DMV1LrxT2xw5K1cQFfuwtpszYCRQS4wz+tmCloga/ZGKANfnM7Jjww5gXqq8
         MeINkgjxawiQhAU2sKEOToee7wjIpy/qN2eC3M+tj0ad8m0qifPPvPihqxUj8e+e8bmM
         g73w==
X-Gm-Message-State: AOJu0YyPE7BTR2PF0E2X1GvgiOo+kyb4x/ICFgTdIAAsdtZew+Aj7i/3
	sJy4OJHiFstigLnySv3wgS0qdkeFblwb5Jafj56XEbhtE/m2ahW2bVP6pvKXQGKRuzAhMW+B74d
	r7AmnfMDcjvU4A6Zp9HGfWpOb46EwI7Pk
X-Gm-Gg: ASbGncu5w63+i78kFTyDNmkEB0D9IrmkrIjAGFVBERw4bZRmYCKo3/GQJ0cc2nPLmjr
	42AF6Fwc44z0RfP1zBwzK487XH9aLCibgCp5VWGFR9pLIGCZrGHCYqYTxZR6zoJDsABdJ8/e7
X-Google-Smtp-Source: AGHT+IHqq86jk7hIl4EZqt4IOluE09dWD9Qn0SL5zNC7tA3dQaENCfMESBGDw+RMOO6Zc0p/TYLH2OWuK4HHu2cAc4Y=
X-Received: by 2002:a17:907:3e9b:b0:aa6:ac19:b579 with SMTP id
 a640c23a62f3a-ab2ab70df11mr1033218266b.26.1736548120326; Fri, 10 Jan 2025
 14:28:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
 <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com>
In-Reply-To: <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Fri, 10 Jan 2025 14:28:28 -0800
X-Gm-Features: AbW1kvbgLOaZjpkvHvLumlHWKw8ZvaGTCdYqohxdi7sQRA-GhK67uRCaLSns7FE
Message-ID: <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
Subject: Re: Android boot failure with 6.12
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Which likely means the fix would be:

https://android-review.googlesource.com/c/kernel/common/+/3445350/1..2

On Fri, Jan 10, 2025 at 2:23=E2=80=AFPM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> Oh, wait
>
> .family         =3D NFPROTO_IPV4,
>
> in the v6 section
>
> On Fri, Jan 10, 2025 at 2:20=E2=80=AFPM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > We've had to:
> >   Revert "netfilter: xtables: avoid NFPROTO_UNSPEC where needed"
> >   https://android-review.googlesource.com/c/kernel/common/+/3305935/2
> >
> > It seems the failure is (probably related to):
> > ...
> > E IptablesRestoreController: -A bw_INPUT -j MARK --or-mark 0x100000
> > ...
> > E IptablesRestoreController: -------  ERROR -------
> > E IptablesRestoreController: Warning: Extension MARK revision 0 not
> > supported, missing kernel module?
> > E IptablesRestoreController: ip6tables-restore v1.8.10 (legacy): MARK
> > target: kernel too old for --or-mark
> > E IptablesRestoreController: Error occurred at line: 27
> >
> > But, I don't see an obvious bug in the CL we had to revert...
