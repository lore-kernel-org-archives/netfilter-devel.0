Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FBF214211
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 12:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748436230; cv=none; b=G9g3d+luu2jopdo1mJvHeEERtU3P3xrQcg8XzdHFMpxTBYQ2Zd/sQlbu2Gww0ImFTiReJiSftzSWP4eHns1DtFvwano4XNFEMBggpkvzo5CHiUhmdjKK4nlKmE/XRV0hDrz9YVSDPTMw8JlVXxpo+oIs+c01aO/XNikc5tEYS7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748436230; c=relaxed/simple;
	bh=5gAdm900lwMh88MOLyBED+i51QXIU3w/UkSJQN5yt4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GB3uJ0lmQvqbO+KavjRX+c2ABcuZEtQVCv4F6gHvYzVCeSnzq5YQaH+fhsPk4cCHYjvxAW3N9T2iHNHFEl/E2mFOg8d8OIpz3T8CDzzghrvn4ZmG+sxEdwz6AeONlLUljwZ7/CTP15IAA9wQQ8iambvSguTqhA1m90xHYtH46xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cgm+pmg8; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cgm+pmg8"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fab467aad1so17023506d6.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 05:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748436228; x=1749041028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ME70JqOBASdLt8SvoyFPCg+xcK4MriBA7ZHJZVbg8/Y=;
        b=Cgm+pmg8wsys0ag6kXorfa2xWi0uqrzHg20mgolK2iA9RGiflHZHbFyDoHOrTyQuDc
         fat092orlLKu8BBMaq614vIJPYbSnoaf50I5I/9JO7VOqLZFyLXPLo+f07UrtKaIeCKf
         qJpESMNGdQidgFglQQJrvosx+a504r7gy5XhUt1GSif2WG+UbLDiA9gb0EGIAjOyfuHs
         Sd6xVniCUa0S+x8RQA9TQv7o6yWScEhjdicTombe6lD87+cxV2zNDtqCDfLa6SWNIs4p
         YzmyBw7byHQznzQF4equugaAOetyU8iH2HKMMLm2Rf8VYY2CNe6S2uPRo3cKFHjsh7j4
         qUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748436228; x=1749041028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ME70JqOBASdLt8SvoyFPCg+xcK4MriBA7ZHJZVbg8/Y=;
        b=szZYNnBFywrd4NcJuOuRpzUHVeTUiN9ssFIsXCUf987VyC70w1Vh1TbH1adeasXWS3
         UhuT3O3fSZSFlZPRNNH5Fc10e/++gKMQnT5hdFFmXhSTqxw6geKtxUZShQx51brb2A1H
         PkenqdQYXyFsm4ccQ+7WUvnCCXxYZHbnVscPOLPbu6ey1HKw0zGwa47PlgEx0NuHJRDa
         HKQ7+1R1k0q49Ojrf8dvWD/ZdRGH8ZdlwiImeHd8B+YV5A3bUd3JI/RiSHHhSjEovOKH
         sy+5/STpF+7cqVDI8tt2BJhEMNgExuCqqqQYzCYPf4zSTWnYa7vMWFy4C5Ts+mKm0x3f
         dtCA==
X-Forwarded-Encrypted: i=1; AJvYcCUEXxeFTHSufkvFA1mDQPY9vhJSc5rY/GvJLReg2pK5DT6RKSQMQYsaJ2Abks6rl7znvC6C4S3eIMzFStmV0n8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvWCS/22lv4sXHy/7j6cwGU1NQWciVLrRzOmlemGRnCqjvaTfO
	jKWgbrhMrwlIdVKqFo50yY5IOnB7jF71ZZa2fFt2HCluNrJrbZmgD5VN4YNzYuc5rUEtA6K+Kqq
	Dst38YphCRWeo+Uk7m/rBDAFMmnJrynk=
X-Gm-Gg: ASbGncu+O43C1UfqO2AC1WJbcfkGFd92rv8z4ioh0xbgYda6tta5T+ikmeZQaj9eDSl
	7anvsU9FLLhP7sq/+urJNL+t2kDcAaj8DpklXnpvBP6nxvXo66v5NRUI6BuTR+n5ZYijLL3gEYy
	hmemONjpPiWlK05HtRTaRBmsYiBrZc8bkbtQ==
X-Google-Smtp-Source: AGHT+IFZUOrvSCXzDV1h8EINFqNzntlCw/MXFj8+Na9+hon9kK+4nrGN69u5B+Y08O31COSKEK8P2cusKN91SRJgLPw=
X-Received: by 2002:a05:6214:21a3:b0:6d4:19a0:202 with SMTP id
 6a1803df08f44-6fa9d2e99f1mr298879026d6.33.1748436227646; Wed, 28 May 2025
 05:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de> <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de> <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
In-Reply-To: <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 28 May 2025 20:43:11 +0800
X-Gm-Features: AX0GCFtdgmpZRlWBMuPrkBFfawFL7KA6CpsKELsupE4x25DSji6uxgg8ByXAwos
Message-ID: <CALOAHbCWRw6-wjG7iX_bzGhsd-RD5o+CCAGROZHb1aD3UcL=kw@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 8:31=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Wed, May 28, 2025 at 8:15=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > Yafang Shao <laoar.shao@gmail.com> wrote:
> > > > And I don't see how you can encounter a DNS reply before at least o=
ne
> > > > request has been committed to the table -- i.e., the conntrack bein=
g
> > > > confirmed here should not exist -- the packet should have been pick=
ed up
> > > > as a reply packet.
> > >
> > > We've been able to consistently reproduce this behavior. Would you
> > > have any recommended debugging approaches we could try?
> >
> > Can you figure out why nf_ct_resolve_clash_harder() doesn't handle the
> > clash?
>
> I will try it.

After tracing with bpftrace, I found that the __nf_ct_resolve_clash()
function returns NF_DROP. Should I provide any additional details?

>
> >
> > AFAIU reply tuple is identical while original isn't.  It would be good
> > to confirm.  If they were the same, I'd have expected
> > nf_ct_resolve_clash_harder() to merge the conntracks (nf_ct_can_merge()
> > branch in __nf_ct_resolve_clash).
> >
> > Could you also dump/show the origin and reply tuples for the existing
> > entry and the clashing (new) entry?
>
> Original 6.1.y Kernel (Unmodified) , there are two entries:
> $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> ipv4     2 udp      17 119 src=3D10.242.249.78 dst=3D169.254.1.2
> sport=3D49469 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
> dport=3D49469 [ASSURED] mark=3D0 zone=3D0 use=3D2
> ipv4     2 udp      17 29 src=3D169.254.1.2 dst=3D10.242.249.78 sport=3D5=
3
> dport=3D49469 [UNREPLIED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=3D4=
9469
> dport=3D477 mark=3D0 zone=3D0 use=3D2
>
>
> After applying commit d8f84a9bc7c4, only one entry remains:
> $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> ipv4     2 udp      17 106 src=3D10.242.249.78 dst=3D169.254.1.2
> sport=3D34616 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
> dport=3D34616 [ASSURED] mark=3D0 zone=3D0 use=3D2
>
>
> After the additional custom hack, the entries now show two records:
> $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> ipv4     2 udp      17 27 src=3D169.254.1.2 dst=3D10.242.249.78 sport=3D5=
3
> dport=3D46858 [UNREPLIED] src=3D10.242.249.78 dst=3D169.254.1.2 sport=3D4=
6858
> dport=3D53 mark=3D0 zone=3D0 use=3D2
> ipv4     2 udp      17 27 src=3D10.242.249.78 dst=3D169.254.1.2
> sport=3D46858 dport=3D53 src=3D127.0.0.1 dst=3D10.242.249.78 sport=3D53
> dport=3D46858 mark=3D0 zone=3D0 use=3D2
>
>
> --
> Regards
> Yafang



--=20
Regards
Yafang
