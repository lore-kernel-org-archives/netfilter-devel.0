Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419DE331EAB
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787503248; cv=pass; b=uIGUP4jytveW05QVirP0EpWoyh5o/hklEw0D6Y+h2KTzuMyOkMjXGicvuFA8rH8EWg2vPSwuR3v5Aj0eTiUBJBVECcrfnEYEAa+cYu9rQolgVOKvkGPMasnE7JT5z4YuzpMz5pp/jkGuWQTrF6/pgFnS99Uwo7bA2OSadBRZWNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787503248; c=relaxed/simple;
	bh=2qrJ07HmFhMiDarJWqhbEJyNsikA2+xhGbEddsDBpHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9OSMN3h6hL3j48JCzZoVUZdmmEfIz8AkdxY2YDzJ7YFscbQ3hLYEFEQ43VPIyMYRzmgQjMaohH8T1TekeCX06WxjpdVykaU9aZXEDCJfqKy5ddysgXjWV5aGV5ORnRyo7C1ihVsFdoeJjxqRWj73Sf+1gdntJWQ2WyDEV9mrmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMdamEA6; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMdamEA6"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15e62c695cso18481266b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 09:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787503244; cv=none;
        d=google.com; s=arc-20260327;
        b=d2v2A2wisO0ztPkz3lGPIKdAgz0+myvNItGtKCJCRRcTltfesrIdjtSxQXtf2RPCiD
         WKIbfebGMvtvzpg1UPKuMZ0A7WcBwxBF9V2l2jaY7Nkzq2lJ29QjiSkf4tbtUhwpuuRi
         Ni8SM2IeOI5Yj1Al69KQs4MXpckZAHesbIDPk/yYZ3xJZ5WTU3uwHNG4ZAXWpAZ3lPvj
         tM+2b49KXLiwhKl9VcTni46JgrfsuDrIMGQj1l10kL0vxC/vPJy7hxwX5R+HcinlhDeU
         7TFLpsiJOV9gu4cdG2Uz4OW79u23u/6j6JDddlBKOK8SWBkGRazO1j8DWkCujLQVo+yj
         LLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m/sDxPalhg584dD1gtugx9nNfFRP6hf2NhTD5B4YszU=;
        fh=TyfQ19FBXK4kgNZ/B+RyOSuWZVfJ2MvXq7eIN5gji54=;
        b=sS52mvxVcOy6haelHPLvBtmxQl5oXB7VCndAt7Ah6d5xLn1sKVrcFtLnFnUyYxKjlt
         i2qa+OQDtZI5ZU4SotNMj4D++kAZDZOlo5RpYKrzqSEx7R50LZpJKvCbuzMjRZ01MW8a
         e0tcvIfnpM6zvmtd61IhDajE2Yxye9KIRDNLJXKEPeOa3nW+Zf1XlZkIviuPe7Ow2ttW
         fU2DwIXh/EkBncEjlRb7kf9GOy+kW9RWTAGNIFu6xJJWVd+zoVxGE9ObuTw1TmSWT12v
         pYkCytSLJ4dkaRdU/dzz94bOVH61WarAToapvkv9w/Xn29uSzXlcFBnAKyK59qBwWs+D
         6EHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787503244; x=1788108044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m/sDxPalhg584dD1gtugx9nNfFRP6hf2NhTD5B4YszU=;
        b=AMdamEA67Y2pefFwgzzT1EqkPGd0eUCauP2Ytvmu2kR3FE0W413s/JHoqavNimSNZD
         NcuTIy0XImGP5o16PxCuT+bhCdyOxanR9OaWZyct2NOmJpQYKaNXL4MT84aIw5rgVElP
         ioBR+1IAA7f8bwpEnOlWrgrQmVaWIko5hSZmEMR/6Wuha96S4DdSzy/nSxdGuX81UvaM
         vtKT72LEuj0yl8ifX6EQMecUMlgXR5yH2d0nytp3Loc7NNpU1w8ZUwdJGsEpzLyKbC9z
         EXJZQqWlmQ5CQpcJOLxrxNOnLgSWdd+31gwthJAUFVSwsnOgcdQoPtYtOKXN5kf+nB8V
         nc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787503244; x=1788108044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m/sDxPalhg584dD1gtugx9nNfFRP6hf2NhTD5B4YszU=;
        b=Oxs+KSHmRQtac4O9iC4zW3e6toJyRgP058NiLmU++kZMcMS3G0fshNwnIXdxKQLGuV
         /v9oeXtM3K8WiMCQN72MkaUNCLDEMbaceS9KuiNO3Orin4BU8KQLjpFg1t80C6xWynv+
         jHAT787nJ5ZIBaSoi7Q8LD3IIUA/2wGtkeoPkVK7aiq1xn5ZUFOmPkL9RvqgGbGcJ04D
         fRAFo8QOhx9b7Z0yvygVhEzXGrmNeQTGji2gQgcGrGUOOQBdAMnL//UBvwqSYmV6DvmB
         aadB7IAQVlu8cVKCFtJ877F9Dely/LcelQcA0rkvshx05yBTEEMmqnXLqxbI/jA5Qj5j
         XSZA==
X-Forwarded-Encrypted: i=1; AHgh+RqW58K1XsiJ59a/OhuDmo54g/BQI/p7h4wHbSlKigPqbje0Mbok/z72FsdeQArdvYa/GTUXfBFV86iWVKdNoMM=@vger.kernel.org
X-Gm-Message-State: AFuF++n+ZnkBGNfO24PcvxboEkr2BsO93ZYIUdi2vTX/X2iNAL1Yxe02
	3w3BsiMgdGG0k1voje3wVDuCJmt7aeNfRK6UxKgLTN01tET+Tf4SBBdoFrAx1ygTIkzHT9ncQgh
	QhaRea0hSPWR3dXETCX8jSuc/xzyfgndiQHwQNiQLtgUA
X-Gm-Gg: AR+sD13L+IfH2lJYHSlS5EUFrOtcVm5nT2JJ8p9Zyq8T8y89BCxRqeiRsb/MzxO9H2H
	D6Gmp1Fv7O09ykloWGzuDM/K55pjUgBtXpO1D098D8Kia8B8vQXpUMjrs+pKEC3VRIj5HWg2Y0e
	xL4Qj1s8yDzUlTpiOZqQrCwsPNYRtSDCc+QSwaav6iRg6jaIpUHnHsLLMu6QHHida8G9bzix+FQ
	wl2f5/kV1R7YF0qAfybZJ3Tq3W3a3RDhiEVFcsrscq4TTJ5MKKGxHbzLpDkHYKxjRBznWccP+BK
	q0MvJOtsfc0nDLjU50h+/rEaikYgDUYUOGgyzpG+WZKKY/gs3l5ehd7eJJ6VlzYii4rzUdacebs
	V0adC1/R9
X-Received: by 2002:a05:6402:450d:b0:6a1:f95b:8cfa with SMTP id
 4fb4d7f45d1cf-6a42f1b47d8mr12742404a12.1.1787503243685; Sun, 23 Aug 2026
 09:40:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260822184658.3787672-1-nicoyip.dev@gmail.com> <aosW-q9G-rQlIXwu@strlen.de>
In-Reply-To: <aosW-q9G-rQlIXwu@strlen.de>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Mon, 24 Aug 2026 00:40:32 +0800
X-Gm-Features: AcwNN1U2ZcUxHGp8iN_ot6HPNtjh2GGRM3ivt46qhGCudofB78avg11NKAz3uLM
Message-ID: <CAAo+4rU8b1H3NFBm_OHqmkr-086w2ZAzrWoFZYvbifBk+358rA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_log: clear per-net loggers on unregister
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Gao feng <gaofeng@cn.fujitsu.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 23, 2026 at 11:51=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Chengfeng Ye <nicoyip.dev@gmail.com> wrote:
> > Logger backends unregister their per-network namespace operations befor=
e
> > unregistering their global logger. This leaves a window where a sysctl =
or
> > netlink writer can rebind a per-net logger after the old per-net
> > selection was cleared, but before the global logger registration is
> > removed.
> >
> > The race looks like this:
> >
> >   CPU 0                                 CPU 1
> >   ----                                  ----
> >   unregister_pernet_subsys()
> >     nf_log_unset(net, logger)
> >       net->nf.nf_loggers[pf] =3D NULL
> >
> >                                         lock nf_log_mutex
> >                                         find logger in loggers[][]
> >                                         net->nf.nf_loggers[pf] =3D logg=
er
> >                                         unlock nf_log_mutex
> > Later, a sysctl read or nf_log_packet() reads net->nf.nf_loggers[pf]
> > and dereferences the stale logger.
> >
> > nf_log_unregister() only removes the backend from the global logger
> > table. It does not clear matching net->nf.nf_loggers[] entries that wer=
e
> > rebound by CPU 1 after per-net teardown. Once module unload completes,
> > those per-net pointers can still reference static data from the unloade=
d
> > logger backend, and later readers can dereference freed module memory.
>
> Why can't this be fixed by unregistering in reverse order?

Right, that would be much more clean, I will send the v2 right away.

Best,
Chengfeng
