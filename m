Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C631D2874ED;
	Wed, 28 May 2025 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748440802; cv=none; b=Tr7pMVdOlUWsTJOINw2g2I3Xb6Tu8bLTBmCCjuY52yF9z1/TVD88EZQWru1LZlV18uRPcaDdmSmf/95EbLSwBoVAQAS5NHijvfkS3gqMNn6zrm5RHXblBKGfVhFke50ARam16XYWFKexehH1rgKbvababIzjdjPnb8luQSAkTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748440802; c=relaxed/simple;
	bh=jDWMGCBFBAmmQhAZ09sBNpBGKcM+6Klk14eVZPogPE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rq5qMXAq9feysE+ds2vx8lr60Y/29CxkDkhyOPz1AH5qGX7uCW2mIm94RnZkfwaTWmGXz69spLSQ/mdz/L5x4m0JfD7dMZHt3wPMdqPSNcfdJNOKn9ulIWWQqw/Oi+At7PMHT8eLpSa0KlXIwsxSx/01P46N4MXkNGRKMzqCqb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQWv9oF3; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQWv9oF3"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-ad1d1f57a01so889959566b.2;
        Wed, 28 May 2025 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748440799; x=1749045599; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDWMGCBFBAmmQhAZ09sBNpBGKcM+6Klk14eVZPogPE4=;
        b=MQWv9oF3OJxBuPiv+p/jXrNVQOYUlf8qLxAkaD7c0wMDRcxjKQgvIaEbZ4eNjFqm64
         klfIHuzviHKJDt4b1FtBI9QOFdrTzYlOJ0nPZqCZe4BrESLxKXLBuURxQrCoPc+KpnfJ
         Ms+NHoiFnMRHE0Iub127vebxCMygvjJnIczwoMF3trq7Fpufe0Lm50vhV1qRCYE5em1t
         5WzvIlFh483OOjyebDJ8BZhPevdnXnuGuoStL7UX4Fmv8Go+j2n932kHH6YAgu2JOpZd
         5+DsJjD9whx+cRoQkRMHYxZyEaLrC8H5vHdIdRQjaL7uEHKtxqmcXpv7/sge3jz0G7bv
         P/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748440799; x=1749045599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDWMGCBFBAmmQhAZ09sBNpBGKcM+6Klk14eVZPogPE4=;
        b=UtK+5PLmSGY8JJ4lFHiUNsE8es8WGIsbVwgYlk+IVy2C9Dp7KTJmm8Ximh2mrOeH7x
         crCA5SaOxdVpA3Osqh02EQit1701k5WQYc+4bHuzCgvygNHn+aKJeSqEbGHkDULSG16X
         G6v1UBiOV3OntT8cs8QJaeVgY1TFKeEf6aPXMLYNfO1fmkWwm4LwrXfmu52U7PncJrCa
         Dd6CPUMFpFj7Ldp9VrTQa6Hrgyli2NILMKhMWJtQet7LUyVu3slLN98abmB9/jFWsezU
         Xx+jzMjBMy4oTcSuMx/stbIT1aQmQPQUgrVXxBPNYbqUwSqtK/M99jMdiEBY1FUdEPqH
         FCzA==
X-Forwarded-Encrypted: i=1; AJvYcCUU4fEmdhyYZcfEnVYd8+Zi0GgdQ5t31feoBs3UHY4VKk4M/GiKIT1NOkt3qPDW9MfrEWGXcKy/rkwHMj3wYw77@vger.kernel.org, AJvYcCWhX3TAjau1+VynwrvhvVtrO5WfgIVOpFol6PFXNxvXlEMCnzKLcVtygLMmnJptHmbw2PXpZNU7@vger.kernel.org, AJvYcCXG0EupXfXsZpqAuj4yUSaSIgfliv0rAYSozt4a8pvMoIb4CxU5TTcTmzmsDaSFAHiQB4eHCE7q3fEPHWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFETetvyHEdtW8FG6Uo/kuGab6lleAfuVAy/aF5IHp9CVVFHDX
	7Xvc9cSYhZ50LTo397cZpmJIrLr4BCMLyPW5DfJuQ9fnowq1gCwYxSbQH5uMrQc/ZoEfpFou4d0
	pos+mjx0SlgMQl3kz02LuLxi85WZESro=
X-Gm-Gg: ASbGncsPZO3xiX1QP2bpI3W0oY33ybrjbieuVYI5IWKcEDPjuJEpPczroTC8aZ4yPub
	FsFdub89sagKe6G4cm6kXsMGtfeErU3DuhJZ1B0LQI4mQFa5K/l2YNX9AY4qAdEjk//LJ6aRkJf
	vKU+ZoQyv15nZCOqXvXfaNkrs77B2MVIVzog==
X-Google-Smtp-Source: AGHT+IH8f0JYmjfBUBPYnA648QhneJOatZxwlVfzIb3tmGjf46Ypy+jLXOvc5AiUNS+l6hFGY0ZB0Kl8A0MN+bbpDFI=
X-Received: by 2002:a17:907:3ea7:b0:ac6:f3f5:3aa5 with SMTP id
 a640c23a62f3a-ad8a1f0d657mr220144066b.16.1748440798781; Wed, 28 May 2025
 06:59:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
 <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com> <5611b12b-d560-cbb8-1d74-d935f60244dd@blackhole.kfki.hu>
In-Reply-To: <5611b12b-d560-cbb8-1d74-d935f60244dd@blackhole.kfki.hu>
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 21:59:47 +0800
X-Gm-Features: AX0GCFuXGt78Q0HnJTJb2d_BkBMcOhFo-eb4XfPaFy_IvoMd825HFkT-P2HgpDg
Message-ID: <CAN2Y7hxZdWLfd34LPzhUPZJ-oMksajLMVt5K8B6Gy70e9TXMpw@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, pablo@netfilter.org, 
	kadlec@netfilter.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 9:45=E2=80=AFPM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> On Wed, 28 May 2025, Eric Dumazet wrote:
>
> > On Wed, May 28, 2025 at 6:26=E2=80=AFAM ying chen <yc1082463@gmail.com>=
 wrote:
> >>
> >> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de=
> wrote:
> >>>
> >>> ying chen <yc1082463@gmail.com> wrote:
> >>>> Hello all,
> >>>>
> >>>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc=
4.
> >>>> Running cat /proc/net/nf_conntrack showed a large number of
> >>>> connections in the SYN_SENT state.
> >>>> As is well known, if we attempt to connect to a non-existent port, t=
he
> >>>> system will respond with an RST and then delete the conntrack entry.
> >>>> However, when we frequently connect to non-existent ports, the
> >>>> conntrack entries are not deleted, eventually causing the nf_conntra=
ck
> >>>> table to fill up.
> >>>
> >>> Yes, what do you expect to happen?
> >> I understand that the conntrack entry should be deleted immediately
> >> after receiving the RST reply.
> >
> > Then it probably hints that you do not receive RST for all your SYN
> > packets.
>
> And Eric has got right: because the states are in SYN_SENT then either th=
e
> RST packets were not received or out of the window or invalid from other
> reasons.
>
> Best regards,
> Jozsef
I also suspect it's due to being "out of the window", but I'm not sure why.
