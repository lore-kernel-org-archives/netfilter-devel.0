Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670BA2853FA
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748435547; cv=none; b=gCRw9lQkK6Lva7eAvHsLg2EWJ9XlVWL88FYj88nbhqBzuQXX2LX0ck7UCTeT46FVqP+vo5cH/vCwmDmA5udlj3VTnQd8m2/dfKuXAHETBYdC8uoP4vCYLrZSROUPIcsTyWSUguC9H7YRh/yW5X+RF+tkDG5g89hEGtDl8ZhkbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748435547; c=relaxed/simple;
	bh=mXUUbbMrE/wyBy8r66cqRAWvrnnQDNQDZCclGF22wFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d30hnmXtLNUHEAf0m/I1PwoWlqGcNO+Y/WOLgLNfGEbvkmt06rVk/6EbjErLGooIynZnGRpl/1/lh996Pv/7bvpEIxUnCDPxVhLtUFTmDLyf3Zp4cafimN2vFmfnel06MgYBGNYbIYq7UaYP0wcNRf5YJiIfHZUMyvW0SFiroVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1M+7ihr; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1M+7ihr"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6f0c30a1ca3so47209706d6.1
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 05:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748435544; x=1749040344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2m3IDi4TdkeKJks3aYPcZFMKnEMx2vGkoqV0SiQ9D8U=;
        b=C1M+7ihrWW0Sl+nnv57lhDOdjz+7IvZSahkpIDXCao+x+Uxt8h0moiNaePjsCSaSj9
         XbXRipK53giHedZYJXIkn/ZVCYxmU4agsnqP1dJ4Qsq+LNQTpFppqZnpoK/1Npg9Ecbg
         TyacQXDZ9NDg6ASgskxqDZuCqG8ZOQ5ioj6b1z8kXGder4TjX9sipIer0+dExLdu8ZLS
         k4hs6q8jCbXlviEIxZjcxsdEY/LfZZkEqNEMpWuj9PHfFD46EE+rwyQ0rO0vSw2r/vXm
         0GSksMFEoZP5ogh6ARlCSTAOkDhOtT9z120E1UXOUxON23ahGksVuD3XY0vL/DYUA1nq
         l31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748435544; x=1749040344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2m3IDi4TdkeKJks3aYPcZFMKnEMx2vGkoqV0SiQ9D8U=;
        b=K+7HEJvxgVK9L4RRmeLgRVvcotw3fVRpAWpyzjQPRrVdlgJHQ/Nwh80V3S33OkofYh
         wISfmiGQmuLUGiaKS+elJ/7Ioh8rW+h7vzWyrAMAxboM8QEZAVzaUho6aDveZDj9lUYU
         g+1TaeeAZz8Pr6usWrkiqvi+LFhJxt3DIkSjEFz27ve73So1hXGWNSjKquHWGbiOXsW4
         zZuVBvSkyYJDxL/EaliLlfjc6r0YXNNfpYr0Ce4rXSOdhrjJeRzNES5syJ/ZJVcySRG1
         DWFiT0edkheQ0p3WIH9gp/Sh4JtOry27GO5JvA7s0kL2/uY/fWfVIMOO+dw8c7Y2ZX+9
         DXCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQXL2ICyDvPsfohMyPub1RfKP1vW6+afD9yHVdrB/2hxaV/DzOlOERpMAdn6edOK3oARNBVfmmfQSDy9rw4yk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4EjW2Wbcgk7+Bd9WH+rZrrn+nK1dAhHTg22D3BwrW2h++dGSR
	e86oBCdOdoBWXyws2MWH58YhAP8O7AQZUpgDz9dLDCMPZuJD/NgOP+x+WEfVqPkezgMzbT7Rx33
	dPr4CH8LDQx56GKl4ZiCDjDFrFkvajDs=
X-Gm-Gg: ASbGncvD9BdtWuJtT1Oi5/s6HeYYDgGOAMDVW4Or45oHaQ/s+/7JF8e+acQA2+vh6uJ
	sHqCx1Ntr72EycatDEUqkMWxHd5fQ70bdMXcImsyEP0iVfgtwCt8KJAt7bQG7zvUhEboAHR8DXV
	ZlyeoknApWWDkL+Hg8feyOPex6qWeC/SoPvg==
X-Google-Smtp-Source: AGHT+IHl5++jIPKaZU9rRVhR+iCLK8ePUce9TW20xYRW7UI793R2KQmYpR1k/ualCIyErpd0UEsVb+gWrEOeuE57SUc=
X-Received: by 2002:a05:6214:405:b0:6f8:a667:2957 with SMTP id
 6a1803df08f44-6fabf29520bmr30476716d6.10.1748435543956; Wed, 28 May 2025
 05:32:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de> <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de>
In-Reply-To: <aDb-G3_W6Ep19Zjp@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 28 May 2025 20:31:47 +0800
X-Gm-Features: AX0GCFuGKXG3BoQApGlEnRJwRlpEhICDZVW25z_UXyIfsqZFpsH4UOuiNC3wmAY
Message-ID: <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 8:15=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yafang Shao <laoar.shao@gmail.com> wrote:
> > > And I don't see how you can encounter a DNS reply before at least one
> > > request has been committed to the table -- i.e., the conntrack being
> > > confirmed here should not exist -- the packet should have been picked=
 up
> > > as a reply packet.
> >
> > We've been able to consistently reproduce this behavior. Would you
> > have any recommended debugging approaches we could try?
>
> Can you figure out why nf_ct_resolve_clash_harder() doesn't handle the
> clash?

I will try it.

>
> AFAIU reply tuple is identical while original isn't.  It would be good
> to confirm.  If they were the same, I'd have expected
> nf_ct_resolve_clash_harder() to merge the conntracks (nf_ct_can_merge()
> branch in __nf_ct_resolve_clash).
>
> Could you also dump/show the origin and reply tuples for the existing
> entry and the clashing (new) entry?

Original 6.1.y Kernel (Unmodified) , there are two entries:
$ cat /proc/net/nf_conntrack| grep 10.242.249.78
ipv4     2 udp      17 119 src=3D10.242.249.78 dst=3D169.254.1.2
sport=3D49469 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
dport=3D49469 [ASSURED] mark=3D0 zone=3D0 use=3D2
ipv4     2 udp      17 29 src=3D169.254.1.2 dst=3D10.242.249.78 sport=3D53
dport=3D49469 [UNREPLIED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=3D494=
69
dport=3D477 mark=3D0 zone=3D0 use=3D2


After applying commit d8f84a9bc7c4, only one entry remains:
$ cat /proc/net/nf_conntrack| grep 10.242.249.78
ipv4     2 udp      17 106 src=3D10.242.249.78 dst=3D169.254.1.2
sport=3D34616 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
dport=3D34616 [ASSURED] mark=3D0 zone=3D0 use=3D2


After the additional custom hack, the entries now show two records:
$ cat /proc/net/nf_conntrack| grep 10.242.249.78
ipv4     2 udp      17 27 src=3D169.254.1.2 dst=3D10.242.249.78 sport=3D53
dport=3D46858 [UNREPLIED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=3D468=
58
dport=3D53 mark=3D0 zone=3D0 use=3D2
ipv4     2 udp      17 27 src=3D10.242.249.78 dst=3D169.254.1.2
sport=3D46858 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
dport=3D46858 mark=3D0 zone=3D0 use=3D2


--=20
Regards
Yafang
