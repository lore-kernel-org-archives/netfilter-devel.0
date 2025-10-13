Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920CD2D6407
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760381492; cv=none; b=g+oZ32gjZGuNZ/eXcRX3tJjIpUzApd8WpvHvloB4DrRhoTKas1PAW32KgFmzknjzBHmgNr5Rued/J7YZkpXMRPfdMz2PWK0RRSLZIRBWoyfdb6QIKGryv+l3+WRIVWoox2ho01JXNhDWD0dCaFCDLmyGHhC0gmlgEWeyVtD7XTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760381492; c=relaxed/simple;
	bh=Ny01Z+tUMuPTp2sCkuYOHV58NBNOxAXF1UzukOG01P0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uhYIQqt454pQMSlUhKPXDHY5ko2GO/kzqVdkaFe0kQyg9fAbKlcgsMOkoxkMC/XYeiwVecwhE1BcZAHFHPIOYZ4Y8IdEsIwHH3w5Tvb5Vj0onn/5ly5ub0J8oiVgSjeI/T787SOhQm7cFlLn66Fnj8w5JRujZVkKOaY/D850Pcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=bHjf/+eq; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="bHjf/+eq"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32eb45ab7a0so4829987a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 11:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1760381490; x=1760986290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ny01Z+tUMuPTp2sCkuYOHV58NBNOxAXF1UzukOG01P0=;
        b=bHjf/+eqj5vY/bF2BPG+IBWrL862vg9upeGqiY7tF1XTFjeL/A6Zh1nWIKT7+IR0vv
         V5ZoA3eicWyBe3LnMF7gHpr4O3nDZNgEZ2XJsctatsYUWCrfJ8M44bHY6oG5jxE8UNH1
         xeAQulsuR+SWtgw+rCkUTtZ/D+S0x5A/1c+UyuGvE+cR4Cfh7QMGwpMk1qw0xn7ArO9E
         9Y1lyUFJ0RBmMriiDsDExRMURgH87JXmvdCWqn3GXuqbBxMSVzjrPLmxzw4hP2xZiMAM
         yIz6KgAj4urgu1fjk+zI6JseZEo2ocKhHNGRC7qmNzvjWYKuXbTYP1EOhzwSCQas4MGJ
         skWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381490; x=1760986290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ny01Z+tUMuPTp2sCkuYOHV58NBNOxAXF1UzukOG01P0=;
        b=k5zu83qozIwZ8r5IUnoaeO25KCoxfjPbN+j7Fan3L55uvB9566bUihEKXN5nrCKKaD
         ORpD4jVT1uB9Gb1ut1cDQhvA8npY4P+E7FYQDuvRh7Fo4rQyS1c1Exh3bonZ0MtcKGS8
         +r2w7hsioORc4F22/d8czNB9TZQWp7UeMi2IX4l1NKnppU15+pNs4WEJu3RQpRq4O4EN
         AjZP+WCYLMPe94RaNJNL36IPpnEgYVymTvLPq7vP8HbRMQLS18KxIwMJXqs97GwKwTPv
         vMXR2GTd2r1KZ8M7lNFSo8lCv3puMfQoR0WcV7mDWiav05scJgFgQOqeg5EdgXXLl7nD
         YZJw==
X-Forwarded-Encrypted: i=1; AJvYcCVodeKt7dp3cr18VnEMHuTfkhcKjdSMwXN7qbnfPjY+02RP7uqC0VTK1eWZPv0wJ035M++O0KXDPsB2pQKPHT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw96B+j5QV7KLx3WuCkKw/0o5+CyFt7nzyhY+2/jfTl+rJlyg5+
	yTCMxe4+BOH0d7Kgff+xhK6+XwBYVDGARyezAnN0092Xc6/OnYp470rQcV5MrfBxnKEoEiYKho+
	I+JE2ERLPquiUzOjR36wcg6HuvZwaxI6otaaM3QLs
X-Gm-Gg: ASbGnctK2CU6gEEykWVr4K1oaS03C2DzXGivkG5n2RJLD9P5571HPBa6GfFnCJ+mwGN
	9EgFmVi0Xvsc5gKzIe2gv3iDm3R2hXDJcteunBusH9l22J/GEApGl7dondrQcBpFx0AsDkv4Rx+
	+Sm6DzrAwSFf6xk3MTdhNQ6sGoKyoshoG8FRnaS/SdYxPFhTp3Av6HoSdzqnpxdom3BOyJKCxYj
	DOpBIA4rbpGLY/zbmyNoctX/01iQ9Pm0ua1
X-Google-Smtp-Source: AGHT+IFMC9e/vwhBwj0ALme8Cp8fCsUdX3he4mM8zid+ESaytCdihd+ScwemDPrM3iGDaixXxrSTv0P6mAS0ElBGhM0=
X-Received: by 2002:a17:90b:4b06:b0:32e:9f1e:4ee4 with SMTP id
 98e67ed59e1d1-33b513b2d70mr33835189a91.17.1760381489825; Mon, 13 Oct 2025
 11:51:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926193035.2158860-1-rrobaina@redhat.com> <aNfAKjRGXNUoSxQV@strlen.de>
 <CAABTaaDc_1N90BQP5mEHCoBEX5KkS=cyHV0FnY9H3deEbc7_Xw@mail.gmail.com> <CAHC9VhR+U3c_tH11wgQceov5aP_PwjPEX6bjCaowZ5Kcwv71rA@mail.gmail.com>
In-Reply-To: <CAHC9VhR+U3c_tH11wgQceov5aP_PwjPEX6bjCaowZ5Kcwv71rA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 13 Oct 2025 14:51:18 -0400
X-Gm-Features: AS18NWCCxvCqhwe_ZDUQ1QESEd77z51GhuMdOVqnR8miGtQcczLoD65PJ8boWMA
Message-ID: <CAHC9VhR-EXz-w6QeX7NfyyO7B3KUXTnz-Jjhd=xbD9UpXnqr+w@mail.gmail.com>
Subject: Re: [PATCH v3] audit: include source and destination ports to NETFILTER_PKT
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org, ej@inai.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 2:48=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
> On Fri, Oct 3, 2025 at 11:43=E2=80=AFAM Ricardo Robaina <rrobaina@redhat.=
com> wrote:
> > On Sat, Sep 27, 2025 at 7:45=E2=80=AFAM Florian Westphal <fw@strlen.de>=
 wrote:
> > > Ricardo Robaina <rrobaina@redhat.com> wrote:
>
> ...
>
> > > Maybe Paul would be open to adding something like audit_log_packet() =
to
> > > kernel/audit.c and then have xt_AUDIT.c and nft_log.c just call the
> > > common helper.
> >
> > It sounds like a good idea to me. What do you think, Paul?
>
> Seems like a good idea to me too.

A quick follow-up to this ... when you are doing the work Ricardo,
please do this as a two patch patchset; the first patch should
introduce a new common function called by both audit_tg() and
nft_log_eval_audit(), and the second patch should add new port
information to the audit record.

--=20
paul-moore.com
