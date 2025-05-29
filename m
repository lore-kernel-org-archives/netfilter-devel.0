Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7378F45
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 03:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748490454; cv=none; b=dBOcvM/rGYTT1ZLaTMHkmQKCwG/FT+dCnZ65NRZgsV2xSYFWfLJK/QEG2YvH9pAV0f26v+Ai7LRiX1Ce0ECxcHVtCA8nGu2cWGN6j3w1zlaZFZh2sxtYVsWMVxtEV+Jz8X2v9siEf6qH6gfnLcs8hH3tRt7EnBe8SejrurU4ftA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748490454; c=relaxed/simple;
	bh=tP42R/yfb5FlXDEh2fP7TXMLGNAgv5vDkxZC2YkS3dU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NwEZ6VsgTEkWx0aPSPiF4PHOQeCJP7bJoa4rLuhajyWym3Q8cnPrG8h6UcqZFEfnXTokZJ3rf/IO5xgAN3FGLiq/cJ6dQXZ6N0tO4V4Iy3pEIZmLUZrULXelTYV120LjnuWrK764w2NtU+P9+dZDXeiqUw4eOuIo4qj+FMSRtuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBVdr033; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBVdr033"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7d094e26252so71147685a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 20:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748490451; x=1749095251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xgh4g05+ruRnsAwkZQvtwTB2LIi+/vC/yIoDjspwUOs=;
        b=BBVdr033fsW41N8G3YSlJPcOdWH2xnf/9W69gm5Teh1DwBngc0DbEhySInjHo+rf7w
         t5gfsR/gcUNBKESFpYYi5VpT8hVPTGI9aP6WFNjmgPbmMSxSLNACGJKSsQfjVRooXD9/
         kr/3SqnYOWBMpYNyMgdAmbRlw5uz1axKwmV8i/O1zr6maejkzgN43AOlyx6dZ7yyoIIJ
         qjwuipTJUUCkTecu383BZ8CTf1ndGtMr7CWh/p4/FbtVkBj4QWOuAtEpBr1JV3uLqi6/
         S+TMxKXeX/qjF3v7eCDCxCIUg0KtURy+Hy+9qmJWIaJK/3yItuOewcSJo9WY4K02woiC
         oKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748490451; x=1749095251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xgh4g05+ruRnsAwkZQvtwTB2LIi+/vC/yIoDjspwUOs=;
        b=CrJH3rqyH8P2h+jxRICjdWPe73aEWGweI7oNPdm/VsNJ1q/X0vDSkkg+quvxAgoAQm
         I0JgMqNTOXDo/FYTRsLCBXjLAsanB+697LQWGmI+79RPXJxXJwQbBjpB1Pv6F0uhfFGt
         bRkqdSc4VcKoSaGbX5y8+3zz/QykxzbmeybNk51ysfi2nPcQIcvPy07bQKCzl8Het8Bz
         DJzML22D/Py9lDqZocwJpruAn4Lj5gXgAEDZJyFdRaZak0mvyO09EO0DVDPzQZwAv1gS
         7rDe0Q/jIkaQ0Yd2VvgtP402Xs+TpTGwC6WxAjTlT/h0zOXigU1hKoSlrcdkxvaNqIHK
         wMZw==
X-Forwarded-Encrypted: i=1; AJvYcCVSJb4lbcTSX2MPID6qxymGVG2pfI/i0uqSMwj/1bkVDaZ9OSuo8Wlp9NOs2OS19L/rPQ5lSv4Tyvbnirk8iTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbIfZm46gJRjDyYResPh6/OqHUNvQFJ7mctgNrBr1Whrotmg+T
	/9l/qJSKdyNf2Z0HfM9bTx/kmzHYehmgf2xPWqa8u/c8KBN1RkyxmZF3PWuxe9dAcUUZl6fpyAu
	Whyc4Grc01P6HaSnorjumDt7CfWmeTrpE07gMSbM=
X-Gm-Gg: ASbGncsA7PWu3WAE+sQrQbYfdj06v3l0E5itPwsx0VQ03Q/C5lTtQ2KunBsSfrx1N9l
	2FoJNQ6kSuQ9lXoJWEKB3XiMQyeaM038Vx0cIqiXGNMZPAnRYojStnvpvb/piL+J2XRP9aA3bOD
	BI0gODuEv+SjN5i/DoGyYBGLwr91R1L0zOlA==
X-Google-Smtp-Source: AGHT+IE8v+38xWjyeXDgogr7S9MobSR75YjBeYNvkGk2hlUYcqsSTk7Oko8beGhieLjnoFZbWtoI9zAko3suzFrIzaQ=
X-Received: by 2002:a05:6214:20c5:b0:6fa:c46c:6f9e with SMTP id
 6a1803df08f44-6fac46c732emr48324526d6.5.1748490441357; Wed, 28 May 2025
 20:47:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDeftvfuOufo5kdw@fedora>
In-Reply-To: <aDeftvfuOufo5kdw@fedora>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 29 May 2025 11:46:45 +0800
X-Gm-Features: AX0GCFvdYpY6gd7-nBf0nhynId1mPjf7bT325XGIDA2M8Wn8YhXzp8AiF9Xq-ZU
Message-ID: <CALOAHbAwVTfvPiSohbuGb5Qw7HS8ovtE2OFru4NfVKpZ7dwBaQ@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Shaun Brady <brady.1345@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 7:43=E2=80=AFAM Shaun Brady <brady.1345@gmail.com> =
wrote:
>
> On Wed, May 28, 2025 at 05:03:56PM +0800, Yafang Shao wrote:
> > diff --git a/net/netfilter/nf_conntrack_core.c
> > b/net/netfilter/nf_conntrack_core.c
> > index 7bee5bd22be2..3481e9d333b0 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> >
> >         chainlen =3D 0;
> >         hlist_nulls_for_each_entry(h, n,
> > &nf_conntrack_hash[reply_hash], hnnode) {
> > -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].=
tuple,
> > -                                   zone, net))
> > -                       goto out;
> > +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY=
].tuple,
> > +               //                  zone, net))
> > +               //      goto out;
> >                 if (chainlen++ > max_chainlen) {
> >  chaintoolong:
> >                         NF_CT_STAT_INC(net, chaintoolong);
>
> Forgive me for jumping in with very little information, but on a hunch I
> tried something.  I applied the above patch to another bug I've been
> investigating:
>
> https://bugzilla.netfilter.org/show_bug.cgi?id=3D1795
> and Ubuntu reference
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2109889
>
> The Ubuntu reproduction steps where easier to follow, so I mimicked
> them:
>
> # cat add_ip.sh
> ip addr add 10.0.1.200/24 dev enp1s0
> # cat nft.sh
> nft -f - <<EOF
> table ip dnat-test {
>  chain prerouting {
>   type nat hook prerouting priority dstnat; policy accept;
>   ip daddr 10.0.1.200 udp dport 1234 counter dnat to 10.0.1.180:1234
>  }
> }
> EOF
> # cat listen.sh
> echo pong|nc -l -u 10.0.1.180 1234
> # ./add_ip.sh ; ./nft.sh ; listen.sh (and then just ./listen.sh again)
>
> On a client machine I ran:
> $ echo ping|nc -u -p 4321 10.0.1.200 1234
> $ echo ping|nc -u -p 4321 10.0.1.180 1234
>
> And sure enough the listen.sh never completes (demonstrates the bug).
>
> When I apply the above patch, the problem goes away.
>
> What I _also_ was able to do to make the problem go away was to apply
> the following patch:
>
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index aad84aabd7f1..fecf5591f424 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -727,7 +727,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
>             !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
>                 /* try the original tuple first */
>                 if (nf_in_range(orig_tuple, range)) {
> -                       if (!nf_nat_used_tuple_new(orig_tuple, ct)) {
> +                       if (!nf_nat_used_tuple(orig_tuple, ct)) {
>                                 *tuple =3D *orig_tuple;
>                                 return;
>                         }
>
> This was suggested to me by the bug report.  I had not brought this up
> yet, as I had little understanding of why and what else was broken by
> reverting to nf_nat_used_tuple from _new.
>
> I thought that both patches fix the problem might be of interest.  I'll
> keep digging in to my understanding.....

Could you please extract and share the /proc/net/nf_conntrack entries
for the affected IP address?


--
Regards
Yafang
