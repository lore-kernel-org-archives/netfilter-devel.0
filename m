Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0527470;
	Wed, 28 May 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443928; cv=none; b=pZpWwOL3kw9rQA04jP4cd9lFGrawpb006DFvQBFKSen1tVNNej6Dnja4yz6KKSmYf/RUGtmGKGLkMDyfHyGrcNR7cACGrSsLzguo6V1UAKTv+APIahgF6vrh87rapfXE2kNTQNq8h62TgCtlYAgem1zCN4kD9DTiC6AWCMTreqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443928; c=relaxed/simple;
	bh=FYFAtjZgoReCRh1+A0oOMulxdV/0cEOl0qPoTpv12QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVzRzEMj6fudwVqiPglJtk70xJPHAPnawrc2BgfxUtDa/wGHsEkOKErSIkY/iiJYvdIGzg6ROpzTRMDc74ELQEpLs/za58s56GqsKHT9Jm92Zf56ULq5ilP4E8bp95d1y1jtE5QKVigVuP8Y2ivSukb//3FRccedFtHlz2U9Kx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6pkJnAz; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6pkJnAz"
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-604e745b6fbso4816689a12.2;
        Wed, 28 May 2025 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748443925; x=1749048725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYFAtjZgoReCRh1+A0oOMulxdV/0cEOl0qPoTpv12QI=;
        b=c6pkJnAzIv7vJX2qYkjaVDwtMy7BYJLZmlgQxinl9kJAU4eJidXZqUZrNi1/BGtTUy
         xnm6jXIvs7xzHWzvy6a0EBYSAxawxx5XzZD2etBuarvS94v/u7Bsvh0UZ0wFYT3X2Qv4
         4i4enQEPhizRHjD5BUl0iD3SIb91m/Y5f3S5ZxxijmukNbizwK98yaCJAuZ1sm337hx/
         +gQ485dEsDSaL+STtyGwRoDK0Tc0KWG8Z9OCvTc0/0A2nmUWnwCSYMKe96wJlBeaO+gt
         uIM27fJPzjNlL+1ApFKt9B9dDhLhbsNZKeGpvSRE04IyZSmbZ/CzBodYxF6ZWZ2txeGn
         AxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748443925; x=1749048725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYFAtjZgoReCRh1+A0oOMulxdV/0cEOl0qPoTpv12QI=;
        b=RBGs1s4aiSJ6FLNW8AbLIiqNEqIqg1N2wsGXrWsfxQuyY+yR4qMcV4BhNfwpgCe6U6
         vY2AYzE8LHisRQBpQ77bJKCFwTcgPaQjj/47Prq0F/bACW+xgZye8cD32A2Uml6lewuL
         NaSeJxkh3JribTU7z+8fYrqaQz0IJiYu3BtzGZ3ghy8BJrW2pYuiiXROOqEUkolOHeH0
         oU8ZpnIKHdecF1y8FD8rLfLlibfwuCBFQapLsR0XLnurPMTuyg7UwpyjaiyL9znE2DWH
         DfpsHro3b0N+ibj6W/xzd4CiIkrmrcmn9SSe2fvdgPnPqdaQYLtVLSOiqCvjTn5XThh8
         W/2w==
X-Forwarded-Encrypted: i=1; AJvYcCV/Si9m+I1SZtzKKLJt24VVe6U1PFTFh9CasA2RF9BfVBdaxikxJymk7gJoBXceqrR6Rehyxh9R@vger.kernel.org, AJvYcCVb9Hhqxs7qCwUfdcBdPLDV9aqX7SZnJyAnshKiYb0Jo/lcAT4kK9zBKNWJq345yKEbJXpff5ra72Cg0UM=@vger.kernel.org, AJvYcCXOFKurlRLWYw/wUHeGT92QAtTK3/ZlpmRvK/saOluBcZeQCiJ9L/1LDcuRyfTZHkNGlTHFRRjLZENlWGBEjPle@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu5kElts048e7+MtXTMQXfyl/g0GpOnxitNOPZtqYEz7n1IhQm
	J/JGRpHPg+saloVvpW66haqclKliwqACHS98Ij1A5e64eqkrGw+viJANixtwQ++PZXW9t7Ps5X5
	m+KCbLJ/x+wH+B91Pa7bIKb3+fcPEFIA=
X-Gm-Gg: ASbGncvI18PC3/MaCy4xHQ5v1Wt5Ef74IYOY9d3fM1nXzmL6X2gbFTUwdIRN631hyO2
	pjVwzklXl1WvFuxYPEzY8eHuS7XtDhMAsr/o7f8hMOQX22XHbx8bAmUoeABgWuuD9Aui0WVwAvI
	zxd2c/mQUan/YUqpDxH7E4M/mY1b9+kxoAv69kyL77rdM4
X-Google-Smtp-Source: AGHT+IHCHj5i/JHxprIIVBaMZEIsSAEK5ItwSVFw3hjD1m2MYmYw0U1Nqq6jpvx1vYLohy4LiF7mFibPrSyZXcfQm6o=
X-Received: by 2002:a17:906:4fd5:b0:ad5:7234:e4a9 with SMTP id
 a640c23a62f3a-ad8a1f30fc2mr222132266b.28.1748443924494; Wed, 28 May 2025
 07:52:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
 <CANn89iLG4mgzHteS7ARwafw-5KscNv7vBD3zM9J6yZwDq+RbcQ@mail.gmail.com>
 <5611b12b-d560-cbb8-1d74-d935f60244dd@blackhole.kfki.hu> <CAN2Y7hxZdWLfd34LPzhUPZJ-oMksajLMVt5K8B6Gy70e9TXMpw@mail.gmail.com>
 <c9255252-3b6a-886a-5959-d59d0bb4640e@blackhole.kfki.hu>
In-Reply-To: <c9255252-3b6a-886a-5959-d59d0bb4640e@blackhole.kfki.hu>
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 22:51:52 +0800
X-Gm-Features: AX0GCFvOG3jraqdCxOfoKuHE86_L1n-yGH8mYqszeOJ3-K1ynaukKbLupId3EKg
Message-ID: <CAN2Y7hy=DRkm9zpNbHfkqjHeGm6UAWeUweXzPH2+Nzf=O9i7-Q@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, pablo@netfilter.org, 
	kadlec@netfilter.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 10:18=E2=80=AFPM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> On Wed, 28 May 2025, ying chen wrote:
>
> > On Wed, May 28, 2025 at 9:45=E2=80=AFPM Jozsef Kadlecsik
> > <kadlec@blackhole.kfki.hu> wrote:
> >>
> >> On Wed, 28 May 2025, Eric Dumazet wrote:
> >>
> >>> On Wed, May 28, 2025 at 6:26=E2=80=AFAM ying chen <yc1082463@gmail.co=
m> wrote:
> >>>>
> >>>> On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.=
de> wrote:
> >>>>>
> >>>>> ying chen <yc1082463@gmail.com> wrote:
> >>>>>> Hello all,
> >>>>>>
> >>>>>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-=
rc4.
> >>>>>> Running cat /proc/net/nf_conntrack showed a large number of
> >>>>>> connections in the SYN_SENT state.
> >>>>>> As is well known, if we attempt to connect to a non-existent port,=
 the
> >>>>>> system will respond with an RST and then delete the conntrack entr=
y.
> >>>>>> However, when we frequently connect to non-existent ports, the
> >>>>>> conntrack entries are not deleted, eventually causing the nf_connt=
rack
> >>>>>> table to fill up.
> >>>>>
> >>>>> Yes, what do you expect to happen?
> >>>> I understand that the conntrack entry should be deleted immediately
> >>>> after receiving the RST reply.
> >>>
> >>> Then it probably hints that you do not receive RST for all your SYN
> >>> packets.
> >>
> >> And Eric has got right: because the states are in SYN_SENT then either=
 the
> >> RST packets were not received or out of the window or invalid from oth=
er
> >> reasons.
> > I also suspect it's due to being "out of the window", but I'm not sure =
why.
>
> tcpdump of the traffic from the targeted machine with both the SYN and RS=
T
> packets could help (raw pcap or at least the output with absolute seqs).
>
> Best regards,
> Jozsef

Using bpftrace, I found that the RST is under the lower bound and
printed the values of the following variables:
receiver->td_maxwin =3D 1
sender->td_end =3D 0
receiver->td_maxwin =3D1
