Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE94145348
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575908; cv=none; b=EUU3SaQe1Eolt0QhAHg+MpV9K6r1EvyzWbqUKuY+WCLuqLI8TKBFvDgSq/OttmqtoY07RkdY5nD0dWcZM7EiQPFHbP/Fsv0XK11HgZHj2ANo3jT/JWWMEfnZsIohwYAGI+1b17SPjXE9OLOV2jlr5mCLJUmZDD6LAHlNHZv69Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575908; c=relaxed/simple;
	bh=qnoY7cOjPkroB4B1MgUiKP7eL0TRHOlWUIxiHkl3pYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdJddfdvNSxGzaJKQpGiq3PJRKphbuzfVXWA0uIXKUZA7L4a1bahod+XwP1oM1G2Gu7K2KbPZxYDbLMZDcmPfYGL2mkntRNoFjjj9G2i3H11NSdhGjsjUF2hMXeMhu0jdyzoRceU6D73pjOgfI4a2e4ZTNa2WLUwSgT/AB+rnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=bWI6Fwzz; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="bWI6Fwzz"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d67f1877so14281335ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 07:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768575906; x=1769180706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0x6oEupL8FezFbLidvr5iQfcAfe+7QHzOvs8wDLBV4=;
        b=bWI6FwzzUHNEwDsZz+oiLxXsECdprRixsx1bF1VjQk+gQSaWYLdlvedBdHymFcMVhl
         sbPqEMOoLyn+fhG6DbTVAyxR5SY9Ilpc9gL+lyT0zRI/yOWhehYlTE0YTAnhlmPaUWDV
         ALz6Zc6szetCnFNK0pwmLm+WbOgLyXOLlSlgljhrNRw0w8u5YWT9KvO568cXCza10aLf
         /OhCoKiClnUOE92btWnbctU7acUazakdkv4iWYfSCnn5FrSnpBOQzxj4wbJhm+UOKmK+
         x27RzDg4jgcgrswP8+JfgCl0iGIwh2mIvGXVFhAS0OO5v6ha785Kg7QxC+Y5sAWEsORj
         57xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768575906; x=1769180706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u0x6oEupL8FezFbLidvr5iQfcAfe+7QHzOvs8wDLBV4=;
        b=bNu/DPAhtHWTvh9kkPwFoLzSAab09p4WCKbHyagR12CKlwGJwsX1sR131cxLInq+ty
         XLXD///SrUPutEwWRR2SGVY+ygDQMcWc11vmm5xcwZ9qorkZd2+XuNaZTdjUnetg3rA7
         V27endd9uRsGpR9jk21dmJ+grwDF1k0VIUKpbMdLxegkwZ+L5wBOufTTtDm6gPuwsjXq
         rUgGHuzuOSepiW9bbSU98VUcZZh63jtHhJkwim1VWjWnoHJsQoTVvn2v5uw+9cLZhFjf
         RrMydDb6zI+WjGFQ9dxbm6L/4X5VlAQtH5QkjUVVP5+I3x8WpUn4betfUDDTnQ32nq0n
         emnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbs1oJySYgGYohIQ+qS+BJvakuIV5SvxotHYqdprNaoDCALAG6cV47YyfcY04SU0BvYSUZlEeY7HgwUXSIC8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4dr12CQAdBP/E9B5kGyb+wk3RJNnAcET84V22FIKvh2/0OvEH
	DlQUPy50tV10orYYfmSxiyn2k8IZd5hhOEq2Jj8HhRMOuxtyyWmp3Tl+1UKHvLmTfV/LfPxeS9l
	DILCRYQjObwsgh/aPqhQuBKp9wXxkcHSRiYGy4v9u
X-Gm-Gg: AY/fxX7tpcYZFp96a2MxOnOeJ4GmRBWcrw6Z2KTLIPKGw3p68lMRxICUDQK9BYau6TQ
	m4KJPveMs/7I409sL8ywEXPqDzfMgwKX8/Bz9nSS2dMo0Z0tcRpke+0QryOPGJuuCp9N40/xVBy
	Szn/+Qk2zsl0DV6a6eQ4XROAA+1P6qzdZYYVtORW8vwYn15x3iLkfqQbLEi5DLFgiixBfcbXz6I
	sGhWFgnAPfgVz4Y5j6zddfcZi0wm303qlAR8EXKnum91Z811QTjs2hgicIS/C4g8VLEvGwvX5gR
	AqOg9F6cdoEYhA==
X-Received: by 2002:a17:903:41d0:b0:2a0:be7d:6501 with SMTP id
 d9443c01a7336-2a7188befdamr27850115ad.27.1768575906537; Fri, 16 Jan 2026
 07:05:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <CAM_iQpXXiOj=+jbZbmcth06-46LoU_XQd5-NuusaRdJn-80_HQ@mail.gmail.com>
 <CAM0EoM=VHt3VakG6n81Lt+6LFzOVKAL-uzjM2y_xuWMv5kE+JA@mail.gmail.com> <CAM_iQpUGvHLB2cZmdd=0a4KAW2+RALNH=_jZruE1sju2gBGTeA@mail.gmail.com>
In-Reply-To: <CAM_iQpUGvHLB2cZmdd=0a4KAW2+RALNH=_jZruE1sju2gBGTeA@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 16 Jan 2026 10:04:54 -0500
X-Gm-Features: AZwV_Qj-mUwAsnBxPvprBL7VLguE52lCx6mzCrpBlViP7VW68CC2CDN3MyC63Xo
Message-ID: <CAM0EoMmd5L+6vnHR98i4i+rwYrwqZbAAxxBVEZ60WtD9nNKqjw@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	William Liu <will@willsroot.io>, Savy <savy@syst3mfailure.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 3:17=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> On Wed, Jan 14, 2026 at 8:34=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> > On Tue, Jan 13, 2026 at 3:10=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail=
.com> wrote:
> > >
> > > On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatat=
u.com> wrote:
> > > >
> > > >
> > > > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how=
 we puti
> > > > together those bits. Patches #2 and patch #5 use these bits.
> > > > I added Fixes tags to patch #1 in case it is useful for backporting=
.
> > > > Patch #3 and #4 revert William's earlier netem commits. Patch #6 in=
troduces
> > > > tdc test cases.
> > >
> > > 3 reasons why this patchset should be rejected:
> > >
> > > 1) It increases sk_buff size potentially by 1 byte with minimal confi=
g
> > >
> >
> > All distro vendors turn all options. So no change in size happens.
> > Regardless, it's a non-arguement there is no way to resolve the mirred
> > issue without global state.
> > It's a twofer - fixing mirred and netem.
>
> This makes little sense, because otherwise people could easily add:
>
> struct sk_buff {
> ....
> #ifdef CONFIG_NOT_ENABLED_BY_DEFAULT
>   struct a_huge_field very_big;
> #endif
> };
>
> What's the boundary?
>
> >
> > > 2) Infinite loop is the symptom caused by enqueuing to the root qdisc=
,
> > > fixing the infinite loop itself is fixing the symptom and covering up=
 the
> > > root cause deeper.
> > >
> >
> > The behavior of sending to the root has been around for ~20 years.
>
> So what?
>

Let's say you have a filter and action (or ebpf program) that needs to
see every packet as part of its setup. That filter is attached to the
root qdisc. The filter is no longer seeing the duplicated packets.


> > I just saw your patches - do you mind explaining why you didnt Cc me on=
 them?
>
> You were the one who refused anyone's feedback on your broken and
> hard-coded policy in the kernel.
>

Ok, I think ive had it with you. Your claim is laughable at best. I am
the one who wasnt taking feedback? Seriously? you literally scared
people who could be potentially contributing to tc by your drama. You
received feedback on all variations of your four-to-five patche  and
you didnt listen to any. It would be a good idea to use an AI to
summarize mailing list discussions and i hope such discussions can be
captured as part of commits.

> Please enlighten me on how we should talk to a person who refused
> any feedback? More importantly, why should we waste time on that?
>
> BTW, I am sure you are on netdev.

I read netdev emails only when i have time. Emails directed at me will
be read much much sooner.
We have rules: if you send patches, you must copy every stakeholder.
This cant just  be based on your emotions on when this rule applies or
not. Please make sure you do this going forward.

> >
> > > 3) Using skb->ttl makes netem duplication behavior less predictable
> > > for users. With a TTL-based approach, the duplication depth is limite=
d
> > > by a kernel-internal constant that is invisible to userspace. Users
> > > configuring nested netem hierarchies cannot determine from tc
> > > commands alone whether their packets will be duplicated at each
> > > stage or silently pass through when TTL is exhausted.
> > >
> >
> > The patch is not using the ttl as a counter for netem, it's being
> > treated as boolean (just like your patch is doing). We are only using
> > this as a counter for the mirred loop use case.
>
> This does not change this argument for a bit. It is still hidden
> and users are still unable to figure it out (even before your patch).
>

I am trying to make sense of what you are saying.
The ttl being boolean is exactly as in your patch with cb.
The goal of your patch should be to stop the loop. You are making an
additional change so that your cb changes work and you are implying
that the user can only understand it if better you made these extra
changes?

cheers,
jamal
