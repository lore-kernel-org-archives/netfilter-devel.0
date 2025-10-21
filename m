Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF9135502E
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761048324; cv=none; b=BZMUORc7tZhPYrJDLSfo4L1k4X0CaDLTUI+TusAWBZXMgx1Kv+xlfKWG1qTgu4Q899vNL/hlGCkMeWc7FHj1MexiSMFoVloVLvdtv2Xj/cPgm4RUs0hda3XgRIipXbjOiHxW2xJIigHpp1sW7gkXf5DzwcGONuG98ebEiSAEkLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761048324; c=relaxed/simple;
	bh=BWWI14VYiLugAQUVrwTDN0HmUrLbQecj2X6KmEpyiwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LbHJOeQtdDzXqtdixzNRFaWG+RjgDEKRwkuPDngDn1fM3X13jBoa76k/0bTYYy2X4qhLR4RGamT44ZJURCz/evd+dfjO0D7ciU9tzTmLRcsBGpOTZBxhqds6tCL8ZtuVvxAyhIWLOYbtK2HLVHTQOd3hLixSEGsGM09YEwlfrbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lTanu7/6; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lTanu7/6"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso5430362f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 05:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761048320; x=1761653120; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mL8f6fZVVzr+d2iovkQay97YgFwDxsg6u7TIUb+cVrw=;
        b=lTanu7/6ZifXQw0jnYAtQIOwLAb36gYVKqB6LK1KES+ZookChHCn8Fn6VeLv087ese
         F8yTgF5J9myV6pDEt5b60pYqzBKxfUwRDpvbD9Y47ZN44EsS8ssFefaFEW4QRT3CwGq4
         ppP3FIfdztHHlPNxrZ+VPVF2ja+6UcAxqb+iOI+ATeibc3nx3RadQFhsUs3UBeD4Tg3M
         uC6QNH9Se70lVB4fJRJ8ewIMGe6Qbfk43mWj0jLB5y0JV75FfsKCEy21rVI0JLIZV3kb
         vOre4AsAcmyN/b2K8ESYvQN7UBptjuASjaDFyCMWB24c5QVuM3ordeGoT6Fy8PzOOiWE
         QGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761048320; x=1761653120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mL8f6fZVVzr+d2iovkQay97YgFwDxsg6u7TIUb+cVrw=;
        b=s3WlP5NtWzABG7vwjUU1cAYDJMdpS9F2ZR5va+iN7J/5ca6u7qJlflz2T3ye7X+921
         L7/8z6EN2yD/l7iNTSYuUW78CGHhcK0ldAXisyY+8s6KtYYpvMiMPy3GQmys7bgRKgIY
         Leik5hLcwUrPGfcxvFrUqPWBvR01ZQcNrgi8N0at9DBsmYaizXdPBcd2KX5ZSMSEQW7k
         HWvEk78if2oGAAeVeBdPwZP8l6IKGHfNxagfToQ65E/huAzuKtCk7ctrKtzSMvdrzzxn
         91TWTd7Tcv92ppMddPTT5PEQNcijMpMrXuQ4/0/kw3Z7JY8di2BXuSpCOLTTGtRh7twc
         SCig==
X-Forwarded-Encrypted: i=1; AJvYcCW2Mp55XTwYk6cBHalUB8zlPUxq6e8S5JyVwCaq/3nAPf0FvRB3g0WVjcdNGY+WZqweGQ10bW5kzDnsOpqtO9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvS3Ijg0REa2jEnTHNkpv130OiaAFkSInU64vRG+gGO8u1+r3n
	Km3zR4qt6neyOxONavdQwJ1rX7/gWGxf24AsLTrAiycOznFRQUTBIfcQ1lcr3HEAqon6EuJsoIU
	XOsouzlYNq2YRkirEjPi/jO5mxViAmc5zCVsYvix+
X-Gm-Gg: ASbGnct5/6X2k0wSITsFnpJI08alg0ewxPH24KBxCSMLQEij+6a0lL9bFgviqZEoDhY
	i/WxAcmkp8SzM/krzLe+fgeHT5ncDEfLwuCep8b/uzIr45PojBYywL3lIhlQfFXy83KxtJYPY/p
	F8hgs4GsS8XpcSLGeJAMQ++nYrMhwnRXok4mGRRO31QRTCU+tkbKM0jdqscXg5ULZVa5uDkzwYP
	oMzCXvGTNtKJ8rLNIRST45OGOOOm5qTqG9+rIRV3Gy1ETr2rTExwbU6MkQdznNiXq+aPrSsXv5X
	n3dt
X-Google-Smtp-Source: AGHT+IHwgXc977eW8NmFKQ2dAo+OHj17B7HCSLMUic6KHr6qiyQ9vA7R7lsW3AP1IlzihjEEcAqiB4gF/hNcmEHEwsE=
X-Received: by 2002:a05:6000:2383:b0:3ee:15bb:72c1 with SMTP id
 ffacd0b85a97d-42704dc36c0mr11402154f8f.52.1761048320059; Tue, 21 Oct 2025
 05:05:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020200805.298670-1-aojea@google.com> <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de> <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
 <aPdkVOTuUElaFKZZ@strlen.de>
In-Reply-To: <aPdkVOTuUElaFKZZ@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Tue, 21 Oct 2025 14:05:07 +0200
X-Gm-Features: AS18NWBxInhkVzTN2I8TPbr81RwKYf-lS9IHkDKegBt7rQOwHLKVFcTO8ooVDaA
Message-ID: <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Dumazet <edumazet@google.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > I think I'm setting the label correctly but the output of conntrack -L
> > or conntrack -L -o labels do not show anything.
> > If I try to set the label manually it also fails with ENOSPC
> >
> > conntrack -U -d 10.244.2.2 --label-add net
> > conntrack v1.4.8 (conntrack-tools): Operation failed: No space left on device
>
> No space for the label extension.
>
> Does it start to work for new flows when you add a rule like
> 'ct label foo'?

It does work, but it still shows the error

conntrack -U -d 10.244.2.2 --label-add test
tcp      6 86382 ESTABLISHED src=10.244.1.8 dst=10.244.2.2 sport=39133
dport=8080 src=10.244.2.2 dst=10.244.1.8 sport=8080 dport=39133
[ASSURED] mark=0 use=2 labels=test,net
conntrack v1.4.8 (conntrack-tools): Operation failed: No space left on device

the dump of the message that fails using strace is

sendto(4, [{nlmsg_len=80,
nlmsg_type=NFNL_SUBSYS_CTNETLINK<<8|IPCTNL_MSG_CT_NEW,
nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=1761045207,
nlmsg_pid=0}, {nfgen_family=AF_INET, version=NFNETLINK_V0,
res_id=htons(0)}, [[{nla_len=52, nla_type=NLA_F_NESTED|0x1},
"\x14\x00\x01\x80\x08\x00\x01\x00\x0a\xf4\x01\x08\x08\x00\x02\x00\x0a\xf4\x02\x02\x1c\x00\x02\x80\x05\x00\x01\x00\x06\x00\x00\x00"...],
[{nla_len=8, nla_type=0x16}, "\x02\x00\x00\x00"]]], 80, 0,
{sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, 12) = 80
recvmsg(4, {msg_name={sa_family=AF_NETLINK, nl_pid=0,
nl_groups=00000000}, msg_namelen=12,
msg_iov=[{iov_base=[{nlmsg_len=100, nlmsg_type=NLMSG_ERROR,
nlmsg_flags=0, nlmsg_seq=1761045207, nlmsg_pid=-1573183269},
{error=-ENOSPC, msg=[{nlmsg_len=80,
nlmsg_type=NFNL_SUBSYS_CTNETLINK<<8|IPCTNL_MSG_CT_NEW,
nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=1761045207,
nlmsg_pid=0}, {nfgen_family=AF_INET, version=NFNETLINK_V0,
res_id=htons(0)}, [[{nla_len=52, nla_type=NLA_F_NESTED|0x1},
"\x14\x00\x01\x80\x08\x00\x01\x00\x0a\xf4\x01\x08\x08\x00\x02\x00\x0a\xf4\x02\x02\x1c\x00\x02\x80\x05\x00\x01\x00\x06\x00\x00\x00"...],
[{nla_len=8, nla_type=0x16}, "\x02\x00\x00\x00"]]]}], iov_len=4096}],
msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 100
