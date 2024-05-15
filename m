Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EF4129E8E
	for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715780381; cv=none; b=JM6AsseywprzL44gByaxYgDyLQw9TWBbQ/P3gJJrIGUaEcDlbmIaIbuzcCDmy4TB7J8h0eFRqS3HQPv4AY974sAiWi0imOhkrPAW5IyOPKnNdcyzDrYsZDjAjf8joo0BGVuDbWkUyQSdMiPfG+0TR8/S3JzI1RdyKpkRSqU4/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715780381; c=relaxed/simple;
	bh=y1kr18othdo9z555i2ebrymZjdrQ+azf2WFzvuN3F7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwOY+cr3glzpQWdGMv4Asij4y+gqckPEA290R28VZf5xYzNmLGpniEPLtkDHzQOMCupe4qLD9oCO88T+VXS5J/zv3qw05r9RkTNko5uUDfq94sWSK5ixlXXr7au6coOOwcaPvXPhTc7+Wz2PLLDsGYLVgAyLuNAuNXUe37yYtp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aYtDqPlB; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aYtDqPlB"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-572a1b3d6baso30560a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2024 06:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715780378; x=1716385178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CekFbHf8j15/vizSt7yvwOkjRFWPVGghV18uDZPoAps=;
        b=aYtDqPlBrM8qeKJVAnikoVcx5dkaqb7chCl5XgroSwoxpMqU6XHeQkIhZCr0Tc76Zg
         1S2jOEXGEvnABWvJUzTeTk+ygox77suYHT97QU+bdEcLYaZ8SI2sjVz5mh5EJt9GWXzC
         d82hau7RtsQuSXra7ZC/TaIQm+BSZCVPkNi3SH5szew4vbxSIZudfv1/yH5vqmbxVxpH
         KvF/QNjBODbV0fJvSwRJa+yBp8wxvazvdfZAdxw21UO1gsdYRBZMc04FvuDHyK4rz6+N
         n8Ns7BT45fXNZMp3b7nXUbRtkVgBp7wGcFUChAHxHied4HToMRUFm6pxH5BjsLtt2iZs
         740A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715780378; x=1716385178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CekFbHf8j15/vizSt7yvwOkjRFWPVGghV18uDZPoAps=;
        b=SsxmLVeLHfO0MzlJpuxtnf7IyqE+xbjcV6/NyU1OqOm3ugzwKQ5dz5JX9ejJqgvMIq
         1fZk74Q+bJIFO0QiPhUdLVkhkU6ANKqZzn9siNyx4PeGJh7TR92KBi7I4uWCjgnE7cFx
         eQVFQCLSFX0FTmRETHZqKOny0R3iU+vE2vlG2j6kAvGxe3if4lmVYAFm3bnGpgI385bg
         C2Ixl7LZcN/aV0AD6YaqPsDQvNlbA1F9KXu8zmapvaVM0nPijY/fp5hJvJgPleZM1Gud
         sI3/4cpEh+Ba9wA+5atgP0SCEz5Q6HFnsb17wzMdFP7dzAjSu4g4z4hZ4o7LAekCYq4r
         z9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtcm2QfWWk4YPDf+jt2blgaLLaaDMnUMNX1Rpq7xIhyKhrBiPsOrqf19rUWWZBPu+99sEAq0WVhINvpH9UDaeneLuFaMDrEWPwEjfOi8ex
X-Gm-Message-State: AOJu0Yy93/kzneGAiIFbAVrvFXcyOX7/qJexKia6jFnvgtBw5MZjsREk
	PKzcGCTPnoSK+O1toYzyQgtQ5Rmi4C6lSztq2bwJn5QzedtdBYcJA1LO1PYqsr06wBAUeXYB2zF
	CsTyT5+m6/WPSUoI1+NMcyp2KX3HrfBs94gcE
X-Google-Smtp-Source: AGHT+IERbbqbHBaUqApEjuvas+SyrBcp4u4szS3pD8Atl03n84/xj4wPp7zvhZL2vbxoUPzABhrsQcCYT42FtimLiKI=
X-Received: by 2002:a50:c90b:0:b0:572:a33d:437f with SMTP id
 4fb4d7f45d1cf-5743a0a4739mr754870a12.2.1715780377262; Wed, 15 May 2024
 06:39:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240515132339.3346267-1-edumazet@google.com> <20240515132738.GD13678@breakpoint.cc>
In-Reply-To: <20240515132738.GD13678@breakpoint.cc>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2024 15:39:23 +0200
Message-ID: <CANn89iJUMN6VOkhLi__EH2VxMF1XatEn2x-n=0tLQ1+Bk3u+GQ@mail.gmail.com>
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

On Wed, May 15, 2024 at 3:27=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
> > index 00f4bd21c59b419e96794127693c21ccb05e45b0..f1c31757e4969e8f975c7a1=
ebbc3b96148ec9724 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -169,7 +169,9 @@ instance_destroy_rcu(struct rcu_head *head)
> >       struct nfqnl_instance *inst =3D container_of(head, struct nfqnl_i=
nstance,
> >                                                  rcu);
> >
> > +     rcu_read_lock();
> >       nfqnl_flush(inst, NULL, 0);
> > +     rcu_read_unlock();
>
> That works too.  I sent a different patch for the same issue yesterday:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240514103133=
.2784-1-fw@strlen.de/
>
> If you prefer Erics patch thats absolutely fine with me, I'll rebase in
> that case to keep the selftest around.

I missed your patch, otherwise I would have done nothing ;)

I saw the recent changes about nf_reinject() and tried to have a patch
that would be easily backported without conflicts.

Do you think the splat is caused by recent changes, or is it simply
syzbot getting smarter ?

Thanks !
