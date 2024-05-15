Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50313E8B2
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715780583; cv=none; b=r8xudfNvg6tmNyvIJVYfN1Du86JJ+Z+apjBYYGPNXYONtHqDumYmxB4+7cG8HdVP/dQk8hBsYeuVn5m+/PcGRnGVfyX25a0qdBjiQ/oiRXFWr21IPX9ueWQ48/jIHzlkPiHBK7uk2mbc/MsYTYKlwBx8Ckn+1ZiSZxIUeRFHKAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715780583; c=relaxed/simple;
	bh=ZIJKpFQGQCPHu7fdAfsBRhdtWKQgrUyUWFf/KozOkuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAzMSdMLtEcnsJFznGZAk2XQd+E2GjX63dICOdVF1CvQaGc44Gn73gUEephxEvdJ7cJCLbsqO2CYQQHGkHytKJxKFcGjZvSGIEfpxgXC82HPlb92gSDf3Zq8adtOtcPX3BO9vUkA9ZmU+dIJm/rtZ7yVGxOqtNVWHE84vnBSTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OCl06w44; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OCl06w44"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-572a1b3d6baso30601a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 06:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715780580; x=1716385380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkxNnBQQ3mFrgW9/g1qJOnfkFhqWA5W59jKQj1UZo4I=;
        b=OCl06w44Cf7V+Efllw7c0TnX0TzATPiLOuND7kYr4KEI4Pti/yviYSSMlnDjLy5xyM
         O+9/6eLJhaM8lWw6ELd6bcDfWZ9lgrOmcSo5bB27DM6OakaPMg4EkhOSg4/ccM12yDo0
         Mw50UxnoUPBQKWfp1DEn1QmuhH3xZaTDHSWGSWlJZGZJWu00r24VvrDlQKzfSyAE16+w
         Oqx9XFmu4eRLvO49eE5R3povR4orSdqqVfs6e3LLiwf1MON1oj/J1jWhGT6GbJHMjxL0
         EEKm5k6vmUR3TcvPikTI98jZ1gUeCQ++1YcSuiwoQx7RdvUxws01Kmm/JKbFd6d+HHCC
         /EJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715780580; x=1716385380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkxNnBQQ3mFrgW9/g1qJOnfkFhqWA5W59jKQj1UZo4I=;
        b=IdJLZPqSOq5yS4fuIRpn9qbQXmGWeoYFs9cLM1r57oR65/5t0k9XkbQFatkZqOgq1w
         9Fj06v0FMDZ6twgKJi2cj+i0b8sFAv9h3m4K1IrraGmBcS3pvseRaMiP8ZJvwTO1bJlh
         +KbpjMlYgU6tKY33B+RT4iPxF1oNLdY0TR6yEgH6mUAPHiQnasCeyeXZXkydwMVJVbrY
         Wfpc4C+mX7ELHNi+3iiHdVGv9wXCdhhd9c7L8mjBJzBhk6LqVk05FwmRCg5g2yVxkyc6
         ul4SSCOZzm/LDlUm8vbnbfo9F1xflJQEJ/H581HXVQWCPmQJmsAd4O916op2coBJvkWp
         vuAA==
X-Forwarded-Encrypted: i=1; AJvYcCUFX5MdQ9yPT5KsGvyCFnkjI2oPinepGk2pgIC/mfayyEcNh9Ubacxoi45F+ASRWIhZHl8Q4yQuxVDemI2MBdvbBTAMfWY+oYLoJA26Zy7K
X-Gm-Message-State: AOJu0YwFKT9EW2PvUQms6Iajti5lmEAhgVsgNz6jzC9asxO/v8tnql4l
	JWggMp3QdI20CKKiv4bOiGOhbIaGtu7ackGGxO2zy6YbNplrfTRRQKj5FB4DfFPnajFwn4pJbOm
	+mBRKaXjKHxbyWCGHJ1De/653Gfiuo9icBZyT
X-Google-Smtp-Source: AGHT+IEPfVfO/DzSdvtd+0FM07L/3SVSFUKP/ahjrK4mH8em8O1KyW5dFmo/QjtOBFIZlWni20KUTxnbzlX+8pcgvHQ=
X-Received: by 2002:a50:cac7:0:b0:572:a154:7081 with SMTP id
 4fb4d7f45d1cf-57443d4db9amr725860a12.4.1715780579806; Wed, 15 May 2024
 06:42:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240515132339.3346267-1-edumazet@google.com> <20240515132738.GD13678@breakpoint.cc>
 <CANn89iJUMN6VOkhLi__EH2VxMF1XatEn2x-n=0tLQ1+Bk3u+GQ@mail.gmail.com>
In-Reply-To: <CANn89iJUMN6VOkhLi__EH2VxMF1XatEn2x-n=0tLQ1+Bk3u+GQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2024 15:42:47 +0200
Message-ID: <CANn89iLA=SfNB6c65FG2DCD90NZLdzPBcA2a0VDhx+vsnXKnww@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: acquire rcu_read_lock()
 in instance_destroy_rcu()
To: Florian Westphal <fw@strlen.de>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 3:39=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Wed, May 15, 2024 at 3:27=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > Eric Dumazet <edumazet@google.com> wrote:
> > > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlin=
k_queue.c
> > > index 00f4bd21c59b419e96794127693c21ccb05e45b0..f1c31757e4969e8f975c7=
a1ebbc3b96148ec9724 100644
> > > --- a/net/netfilter/nfnetlink_queue.c
> > > +++ b/net/netfilter/nfnetlink_queue.c
> > > @@ -169,7 +169,9 @@ instance_destroy_rcu(struct rcu_head *head)
> > >       struct nfqnl_instance *inst =3D container_of(head, struct nfqnl=
_instance,
> > >                                                  rcu);
> > >
> > > +     rcu_read_lock();
> > >       nfqnl_flush(inst, NULL, 0);
> > > +     rcu_read_unlock();
> >
> > That works too.  I sent a different patch for the same issue yesterday:
> >
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/202405141031=
33.2784-1-fw@strlen.de/
> >
> > If you prefer Erics patch thats absolutely fine with me, I'll rebase in
> > that case to keep the selftest around.
>
> I missed your patch, otherwise I would have done nothing ;)
>
> I saw the recent changes about nf_reinject() and tried to have a patch
> that would be easily backported without conflicts.
>
> Do you think the splat is caused by recent changes, or is it simply
> syzbot getting smarter ?

(It took me a fair amount of time to find a Fixes: tag, this is why I am as=
king)
