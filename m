Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5BA35B142
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 21:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721792; cv=pass; b=JQIrAoSJbnhif8vxMqM2ZDzgG5GQvu5xHAUHnmDkP48CCGjc5Wh7rwa/pZlQsE40iSAndxmg2XRG4iBmtkhPh3arOFJkp4iL5EaJpSjKBJ3vlWy/TuDbfPdySBsGUWE4rn49Ffqj/eXEIDH4nZ0SH6JxBa453k2TYn1k/nShoqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721792; c=relaxed/simple;
	bh=GDj4/r3SS3s+s2QiusxwvkNIs82bmNooEMM3IRav3dA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T9rM/qlZBemNlWhuX5bZqTO/FaUz7/JZFaoYV/JAVoWohCZYMkDJ9fGcp/mdU4q9DAJqLHR3p3UOSXtRqj8/X/GwvoabfMZcLQv4bZUXqTP+VeBtYA7egS4RaVDP4rJ6bf8qKpPtVU+WwEZ/RBZlALw46Gayd7iG4gXbBZmnF+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=T5koWdN7; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="T5koWdN7"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34f2a0c4574so1199430a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 13:23:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769721788; cv=none;
        d=google.com; s=arc-20240605;
        b=fsBdiYkAQ9ufDVe/DhkvtdJewM8ScMBP8WsBRVOJkg5952fxOTWMvyX8X8hAfSY0Da
         txqKr3wBDVQGrj5WW90FmO85UxirvKoFihKyUfICPwqqxdY3gI1/2HZ9GyroeHna+k5+
         XhpghOOkk0D2a66Oa9sF3Yd48Lkq9/0bBRDQdBvXY5emd9gGWW9buJqrqDREbsmnWooS
         S2rQJVGdrFZ4MBiBUNVPNOnfTJDIiNaZsbrvmVt2FT8/rqPDRjlaXLC5cXBdh7WjI5bO
         MmUBRLTTz3JB8YYHiChTVAV+KkIw2I/MqKhf3Yftpv1EOEc06GJb2i0bpQCJeliz0rHA
         gzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GDj4/r3SS3s+s2QiusxwvkNIs82bmNooEMM3IRav3dA=;
        fh=5agEG+QQkBLHMphqk6P/OMWQMWb6v/C9wH8WElclHM4=;
        b=L+4WXAbrVfkwIOpZWskDSM5eW2xXXh22uVAPyDVgXiJUYbMjJ8QM7Ot2HUq+CwpNEk
         4mJ9xLBWW3E3f+NXVJFqsk6ch5TNlRazSrmEc7rDIR/HBAE+3hcLz+s00ymU7mL6O2QN
         /OOkiwdNdMQqzEjhycWt6Vt+5XoeU9vfyr6xVY8shlbWRj1m9tZGS7O2jW072JnbZ374
         bAiSKI49aRP43zNy5ZerFmr8lAc4W6hjhJEBA4c/OfG2ABW1Nxhn3Pb9Cmtw2ZxPTxYU
         wtToG809MR9dY+KdK53S9cegt8sxLcnZX8UX76NlkZKZDrFoZTJFrY9pUZ9ziZV6/9mH
         td8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1769721788; x=1770326588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDj4/r3SS3s+s2QiusxwvkNIs82bmNooEMM3IRav3dA=;
        b=T5koWdN7PKdWeXKEkuejN3z0jj83Kft2aG+XhAvpgq3H9igYLT0QUl/729jUiBxMS6
         wQh5Rz8aoNS9KvhB2XMglZ413iCiFa8rI9yshESi+qtXmCjakkhLrx2kGq/r3naBTdP5
         vysAhWTca6nutjrCFApKivF4l7LmzgV3iPLWH5G0LPqGpJka37vawaAqioGTJ8oydRNG
         ZkL02KvHYon1/Vl8kz5CgOLIoZVO8I2koIQPVGVNYe5xeJjXSY980TRMphApaHEYtrCq
         ePdhlt5+Te7Y9UhMQR6edOyxXL8WQq66ZuOUqENzfdOlz8AyWaWg9Jm5mHk2ilxB7qwV
         X4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721788; x=1770326588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GDj4/r3SS3s+s2QiusxwvkNIs82bmNooEMM3IRav3dA=;
        b=EmrVPwDFvF01gpxEUO8Xs5FPU39BgEibtXoWIc0uyfTjJ0iCcTXPR13TBTpsJFQeEI
         o/OL82SWwnpvkzEUlLwbXIKcjh5IjBPfDlh/Bdkp/Sf/Be1Bmsl9hcwiO/piDQCRT43w
         1kMNULkZYvoVj9ysfADPaTAO29gly6pR93iIgRXzBZtYfImMv3ySkOnxPx/RYl3iSREI
         4dNC8ltVF5btNJ6etby1elsiqz/A4YQ5QDK+InuRWfe9628tGgXmj6EPwWx5XwpXg1x9
         MmKXl14rZUQg9jmS+srtPLZnb7HsprmatTew0BxNoTXxRwFVwWMnP2UvYiu5peHRji/A
         vMZA==
X-Forwarded-Encrypted: i=1; AJvYcCUirImd+vI0Fr8kcMLL5Np3QT0rSi6iVJs6/FkYBeAqTGQcuCFefgtWn/dvivIRcV2uXCbpVPEgKIgcbwQv0NU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1ZqqdirWB4ZhALUunrQiKc7Z/P2+lU4M/zFYsGoJAiqVEq55/
	oUbcIIfT1l5JfraKHUEuLvFnFQ24tMRJ0U6bIpJSmxd/HEag4I9TjjQYHrMFcefsKXkG1L+oIRF
	EGrESsDkUwRQUsX8+AmXQ6bT4dzMSw8k8fkunQn49
X-Gm-Gg: AZuq6aIgaIu69YL7z1+LoyaINYQN8MoXaTNDyj+Nm3rIP2MwhssdNHqNfah2tbyO7Y1
	CdDO2FaIJNnyQA5X/y/1FsqABcngeovS5/DwqH7LuXm+NUF0fMQGFdCmo/ZUUiiX8gJSusC9wQ6
	/AjufwYj41+CvZ1SXfc8mrXKEKMZVUHatX/BTBh4flMBe/OYX90K8iqQThmQ88EHPEzDCKq/zMy
	AGfcHcnH7kNpBgMLYDaNT2vivmTAI+sqidjJjbOXYTRWBTpnd05anDUgGiQrVaXwg9hIBcRtHDz
	RWvnoZnpeDKhRw==
X-Received: by 2002:a17:90b:4c48:b0:343:7714:4c9e with SMTP id
 98e67ed59e1d1-3543b2dbfcbmr682737a91.2.1769721788038; Thu, 29 Jan 2026
 13:23:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
 <CAM0EoMkFMURPj3+gNOaqO60D4deeht2F3EZWZbmShjO+B4wJBA@mail.gmail.com> <CAF=yD-Jah3+1Sj3-Us72fKNu-__sg7pNb+-kC_knAV=iTHAitQ@mail.gmail.com>
In-Reply-To: <CAF=yD-Jah3+1Sj3-Us72fKNu-__sg7pNb+-kC_knAV=iTHAitQ@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 29 Jan 2026 16:22:56 -0500
X-Gm-Features: AZwV_QjrwlV7YwIyQ6tLXbQsHZYNkOUfNXVYF9EnMlUAAM-S-VR9gIDPkbF9bi8
Message-ID: <CAM0EoMmAQ8RvHRmyEeMwehhNe0yXzn8NU5UvwitzAoL3cwVPqg@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	victor@mojatatu.com, dcaratti@redhat.com, lariel@nvidia.com, 
	daniel@iogearbox.net, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 12:06=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jan 15, 2026 at 6:33=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> > On Thu, Jan 15, 2026 at 5:23=E2=80=AFAM Paolo Abeni <pabeni@redhat.com>=
 wrote:
> > >
> > > On 1/11/26 5:39 PM, Jamal Hadi Salim wrote:
> > > > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how=
 we puti
> > > > together those bits. Patches #2 and patch #5 use these bits.
> > > > I added Fixes tags to patch #1 in case it is useful for backporting=
.
> > > > Patch #3 and #4 revert William's earlier netem commits. Patch #6 in=
troduces
> > > > tdc test cases.
> > >
> > > Generally speaking I think that a more self-encapsulated solution sho=
uld
> > > be preferable.
> > >
> >
> > I dont see a way to do that with mirred. I am more than happy if
> > someone else solves that issue or gives me an idea how to.
>
> It might be informative that there used to be a redirect ttl field. I
> removed it as part of tc_verd in commit aec745e2c520 ("net-tc: remove
> unused tc_verd fields"). It was already unused by that time. The
> mechanism was removed earlier in commit c19ae86a510c ("tc: remove
> unused redirect ttl").

True - we used to have 3 bits, but we can leave with two;
Unfortunately, a single bit won't work - otherwise we could have just
used the one available.
Only one bit was available, so we recouped another (skb->from_ingress)
and adapted it to use the tc cb struct.
There is still a chance that could cause issues - all the users of
this field were CC'ed and i was hoping they would respond.

> The IFB specific redirect logic remains (tc_at_ingress,
> tc_skip_classify, from_ingress, redirected). Maybe some of those bits
> can be used more efficiently. The cover letter for commit aec745e2c520
> had a few suggestions [1].
>

Using the iif check against netdev feels a bit "dirty," but if there's
a strong view that it's okay, we could liberate that bit (some testing
needed) and in that case i would leave skb->from_ingress alone.

> Another redirect limit we have is XMIT_RECURSION_LIMIT. Though this
> assumes running in a single call stack. BPF redirect uses it as of
> commit a70b506efe89 ("bpf: enforce recursion limit on redirects"). For
> tx. Rx takes netif_rx, so enqueue_to_backlog. So it does not seem that
> this can address the entire request.

True.

cheers,
jamal
> [1] https://lists.openwall.net/netdev/2017/01/07/92
