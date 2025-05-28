Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693DB21322F
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748441280; cv=none; b=mUaNKZ1cPoLNUg+8hJ2WoV+YQscwpuE4qKOyyC31qWXS7/m5UdD5P4gne5ZC6ghei6y8eB27LAhfAYRNPzy3SxLBqynisAUBNZJzfUh4lTgY6s1Yxe3NMhngX2SshmEpGfZ+0OLo1VoqZqqty3qkUuGn1XqXDWj14OVhsk11IcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748441280; c=relaxed/simple;
	bh=wXOJxeMV3XTHwmddKfego1XF630OkeGRMzRieSBFr4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eNavjaQd4q56HZn78EOie9WkyBegbwjD2Z+teDyjNRSnBSpngHDbzg7xQx1iWKoVbDBdIsveEYhgn415Q74zRZyPgtoOGM6AyOb/J5HWbDi1G5pjN7oNFCK4CtmsZR90Qf5L3UTv0wlBx5t/uKOh4vlGWacnq0SO6AsGJdYkzPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6FJAUfe; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6FJAUfe"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fab12242f0so12882556d6.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 07:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748441277; x=1749046077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwnGpvpC1MFEo/2xfydGKRHIzKnYiUC9DELS/Fkpt50=;
        b=D6FJAUfeLbWFQtOHxLlaFD7cxq08IYvqWX6PwT/tcpc+k0uLuo+PGrTOCY7SRZHUUA
         //CM+AZ21lVLt6BhG+m88w8i0poC6G0kCLYg9EETyNgamaJmkoLpirUpQyP2e0lLKRd+
         fXW4h2ZgkW+zFlEjsK2rLrtheRNRBqP+hrKElJ560YXRwxa1G/Q7sxTkVKm4cTFctKgq
         +b2SffEi838vamo4Z/W+8BKfizPyKP4cno4lvRCDv/ZY0BHNsA3zqpAI5hy6RZ2ngWBg
         QAIjEUCCRNFPTtj8kqOgN2WiZCWPSBqSN0RT6cQmu1MLdNTrfFO/gld2r2jPG16H4fs0
         gtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748441277; x=1749046077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwnGpvpC1MFEo/2xfydGKRHIzKnYiUC9DELS/Fkpt50=;
        b=OS22JPlGW8d1bm7QtnlHd0uWzi+txqv1O9+7UPxU5vKrBZewK1ipk+kJcKnK+QJZep
         4YaPlgDWTB07CfMxZDqgNSUFkknmGNwUtOzkfRCDN+L1CiV1cVaonHwW4gOxvXZml0f8
         0tcbsjyzy0dufj430d8FshkgQtbpoAlLorCBJmxtC1zLBY8tGy10K0zW9WrAkdsELs1y
         xG7VgrslSEjPqCEAh+xxfpv8gUAJ8JYorOKqIxMSmsr/bZly6h6WBFo9v4nba3I7OKfl
         aJ9r1cNW7MCTC1RRhl0TwLzIGkBulZKpe+ZnWLC1kJUKBdyCm3kenLJnnZGdqWxr59eM
         sVWw==
X-Forwarded-Encrypted: i=1; AJvYcCWJJaTMsdNY0Pancr4FAsXrm1i34GZAdfyfxOwPLrFfXu8avLIg+KP5HjAq5Z5IHyVLwQ9MhdRq0og+TcuhINQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfpWE4sdGleOcLO6S1OOYNI86xfzv+gQtkcqIyJsPsrQHkxye2
	jZgSTNsh6yLyRom3lHWJKkLTtXuslZOx9vrV413N0Hzod2l5wETu5l2HVEIulwt3lRjF8EaTBYd
	DmcOmlOApTkH7xgP/qwJqF0w5phHPzhWJsUG8kHLyfw==
X-Gm-Gg: ASbGncvLZuGDKGnW8UqB4FTsBloeHH81G9QLpcjRHAH/CHbSkxo03YtFqE49wzFTSbm
	KYRfJdVL+GBikdxYRgAgrZq/YvsCN5GU9VEkkLGDj6A+m0AcVUP3wrWFK44m2O4HPCUroLK6uRA
	s7gT0G3MvAj2ZWmOTW0AhmCeXGWfN4IStuTANOMDlXS4jg
X-Google-Smtp-Source: AGHT+IG6Ac4e8+zAqTLVGhovxLznmM3T9IFmM75tdToulGi3YeJZD0v9stXqB1uAbkSmVv0SeI/xoA4aTPUzyPRddK4=
X-Received: by 2002:a05:6214:401b:b0:6e6:5bd5:f3c3 with SMTP id
 6a1803df08f44-6fa9d2d6bfamr277025416d6.44.1748441276903; Wed, 28 May 2025
 07:07:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de> <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de> <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
 <aDcNjpqOKNonzrT-@strlen.de>
In-Reply-To: <aDcNjpqOKNonzrT-@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 28 May 2025 22:07:20 +0800
X-Gm-Features: AX0GCFsDAoExq0TXJiTyXoAURJG5taw7xLkud1kBeXfupR1NiQe_WxJiO0xUAI4
Message-ID: <CALOAHbA2fT+zcnjivX8-D00FrNyGnj3tvvEX1PghAEwk+uyRSg@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 9:20=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yafang Shao <laoar.shao@gmail.com> wrote:
> > After applying commit d8f84a9bc7c4, only one entry remains:
> > $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> > ipv4     2 udp      17 106 src=3D10.242.249.78 dst=3D169.254.1.2
> > sport=3D34616 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
> > dport=3D34616 [ASSURED] mark=3D0 zone=3D0 use=3D2
>
> Makes sense to me, thats what would be expected, at least from ct state, =
no?
> (I inderstand that things are not working as expected from DNS pov).
>
> > After the additional custom hack, the entries now show two records:
> > $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> > ipv4     2 udp      17 27 src=3D169.254.1.2 dst=3D10.242.249.78 sport=
=3D53
> > dport=3D46858 [UNREPLIED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=
=3D46858
> > dport=3D53 mark=3D0 zone=3D0 use=3D2
> > ipv4     2 udp      17 27 src=3D10.242.249.78 dst=3D169.254.1.2
> > sport=3D46858 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
> > dport=3D46858 mark=3D0 zone=3D0 use=3D2
>
> That makes no sense to me whatsoever.
>
> The second entry looks correct/as expected:
> 10.242.249.78 -> 169.254.1.2  46858 -> 53    DNATed to 127.0.0.1:53  10.2=
42.249.78:46858
>
> ... so we would expect replies coming from 127.0.0.1:53.
>
> But the other entry makes no sense to me.
>
> src=3D169.254.1.2   dst=3D10.242.249.78  sport=3D53 dport=3D46858 [UNREPL=
IED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=3D46858 dport=3D53 mark=3D=
0 zone=3D0 use=3D2
>
> This means conntrack saw a packet, not matching any existing entry for th=
is:
> 169.254.1.2:53 -> 10.242.249.78:46858
>
> ... and that makes no sense to me.
> The reply should be coming from 127.0.0.1:53.
>
> I suspect stack refuses to send a packet from 127.0.0.1 to foreign/nonloc=
al address?
>
> As far as conntrack is concerned, the origin 169.254.1.2:53 is a new flow=
.
>
> We do expect this:
> 127.0.0.1:53 -> 10.242.249.78:46858, which would be classified as matchin=
g response to the
> existing entry.

Could this issue be caused by misconfigured SNAT/DNAT rules? However,
I haven't been able to identify any problematic rules in my
investigation.

>
> Do you have any load balancing, bridging etc. going on that would result =
in cloned
> packets leaving the system, where one is going out unmodified?

No, we don't have cloned packets.

>
> Is route_localnet sysctl enabled? I have never tried such lo stunts mysel=
f.

The config is as follows,

net.ipv4.conf.all.route_localnet =3D 1
net.ipv4.conf.bond0.route_localnet =3D 0
net.ipv4.conf.bridge0.route_localnet =3D 0
net.ipv4.conf.default.route_localnet =3D 0
net.ipv4.conf.docker0.route_localnet =3D 0
net.ipv4.conf.eth0.route_localnet =3D 0
net.ipv4.conf.eth1.route_localnet =3D 0
net.ipv4.conf.lo.route_localnet =3D 0


--=20
Regards
Yafang
