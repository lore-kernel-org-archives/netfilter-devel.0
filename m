Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01EC2BAE3
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 02:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728525790; cv=none; b=ETsiuWh1qQtWeNg66b/6vUfsoLg8vFYY/QQkjOatd+cYNDarRK2rt3etwEeRh+oaMR6yZULgIo5xH0yWM5918QxkxSdiWKSU4THEvW+Y01b5FZJGlyxEPEuWhYjuKtuzaY5ufFG9QMLWKZgP1flZxebbCWAu0/THi0mD6V22YQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728525790; c=relaxed/simple;
	bh=lm9yALyuk4sK7mcT+xBoNNcgiB4rCPycPd5ZLkZn/J4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t26XC653i+RB63Y4mIV46VNRaAAIlV8GnvrJg0HmOpABpD28xl7aXbg9BaA5LBm+JMuBdE9OPHKtBjvMR2dbymdfOFAa9xIVfM7iqC7wWu8CF91IcbKI1z6H3DDG/lwz9Ixc2wz0/GWTf/WjJXx4q4xAr4BcpniljQcNd+pB7Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=KEg7IOtA; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="KEg7IOtA"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso346109276.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2024 19:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1728525788; x=1729130588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tI22F1lPDInL5Y+wCwfLKOYihiyc18G36615UsHfNM=;
        b=KEg7IOtAjmr3rX6vTID3q7KhZUTrH0V+V6MX9u2LfgNg5GkKDHQ36VPZ4DFpUEw0jy
         +gtBLvfSly0lo25ObxQI72jZEFE4Kpgmdg+9fDqxQeibmZX+FqCl+6FTz02j0LMFC3R5
         y+6e+wBdpoUAVycs+aKLvmIHZzoJvHN91doJaremPYgImn0JdX/bBCAIV9hgBBhd76nK
         Il9CLcBufHeyDzhLh+jR4PWzQJDrEoM3S2NnPBvSu2QNcP6jyEdxsTyaMgTTxQ9nFpZA
         o6/oSL2iMxawNjc65RcuZ9uwICNElIXVrbaOxX6CV3whmYI1wjgpIIGs9vFZgv886SaT
         GSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728525788; x=1729130588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tI22F1lPDInL5Y+wCwfLKOYihiyc18G36615UsHfNM=;
        b=fQ3dNw8vKz+k5o5H3jVnj/8wRxEjjTd3xnQreLg5oMHQLI+HZFI4dM1OwAVyfNtaae
         WVH0tifZjr4BpSCv91fojkK8xV5cEdRb27zEyN9X/9f0IfmLNABUiuohGJ6iYZAuFsb2
         BIEnW5ZB2bJGSKxWGb5RHa4EcPLUPZjlRoTUd2DRdAvh8+XjqpTaUaZXyb0DoVvahcVL
         K7m5U6+Xv4oG1PK9z3LgKZlGtrjoArVqeLakemWBcBrORaFM5nrYTkIO+wGJkqT9wzqY
         LPynM92kzHj8e4Mtmm94V4pdw41Kcj+3Rnx9cfHg/YZAU+6OlYIFqRjrnL09NXAo2Xrn
         EKuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcjcn4q/N4kMpv1mKLfB2vrvllhlxr/QSwk8CjTz1PRrJASTyAC0cmfUusY5um/3YRr5DvcUdUh6Dg84ed6p0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKnWDtGPv/EB0HtajYKcTGphHI36SdCMZevnc+01uYWxZdlm95
	nqsuSDS8YTT8uOt1JkKyxhjjFzg4aYbV0T5k1QmgKjrYyYc38S+Gmk2rnJgU6r8h9Kn5QoTmPqq
	vjC1xHid50Gd506NHQ8BWUR5t9DCOS8Z8vOHJ
X-Google-Smtp-Source: AGHT+IEyeMjrAkKGzbUK/00w0l1RMo2D/Rz84dGLbkxfIaBrFu50KXvg+JrSoF/LLGZHMQ5Qfg+g/KPmdvAxhFISkbQ=
X-Received: by 2002:a05:690c:397:b0:6b1:8834:1588 with SMTP id
 00721157ae682-6e3224d1ecdmr47971387b3.35.1728525787839; Wed, 09 Oct 2024
 19:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009203218.26329-1-richard@nod.at> <20241009213345.GC3714@breakpoint.cc>
 <CAHC9VhSFHQtg357WLoLrkN8wpPxDRmD_qA55NHOUEwFpE_pbrg@mail.gmail.com> <20241009223409.GE3714@breakpoint.cc>
In-Reply-To: <20241009223409.GE3714@breakpoint.cc>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 9 Oct 2024 22:02:57 -0400
Message-ID: <CAHC9VhTC=KAXe6w9xTG_rY4zAnNvPv-brQ7cTYftcty866inCw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
To: Florian Westphal <fw@strlen.de>
Cc: Richard Weinberger <richard@nod.at>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, 
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net, 
	kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, 
	upstream+net@sigma-star.at
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 6:34=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
> Paul Moore <paul@paul-moore.com> wrote:
> > On Wed, Oct 9, 2024 at 5:34=E2=80=AFPM Florian Westphal <fw@strlen.de> =
wrote:
> > > Richard Weinberger <richard@nod.at> wrote:
> > > > When recording audit events for new outgoing connections,
> > > > it is helpful to log the user info of the associated socket,
> > > > if available.
> > > > Therefore, check if the skb has a socket, and if it does,
> > > > log the owning fsuid/fsgid.
> > >
> > > AFAIK audit isn't namespace aware at all (neither netns nor userns), =
so I
> > > wonder how to handle this.
> > >
> > > We can't reject adding a -j AUDIT rule for non-init-net (we could, bu=
t I'm sure
> > > it'll break some setups...).
> > >
> > > But I wonder if we should at least skip the uid if the user namespace=
 is
> > > 'something else'.
> >
> > This isn't unique to netfilter and the approach we take in the rest of
> > audit is to always display UIDs/GIDs in the context of the
> > init_user_ns; grep for from_kuid() in kernel/audit*.c.
>
> Hmm, audit_netlink_ok() bails with -ECONNREFUSED for current_user_ns()
> !=3D &init_user_ns, so audit_log_common_recv_msg() won't be called from
> tasks that reside in a different userns.

We have a requirement that the audit daemon and audit management tools
run in the initial user namespace, but these are the audit collection
and configuration mechanisms, not the audit record generation
mechanisms.  Regardless of the namespace limitations on auditd and
auditctl, we want to collect audit records across the system, which is
what we are doing in audit_tg().

> If you say its fine and audit can figure out that the retuned
> uid is not related to the initial user namespace, then ok.
>
> I was worried audit records could blame wrong/bogus user id.

Correct me if I'm wrong, but by using from_kXid(&init_user_ns, Xid) we
get the ID number that is correct for the init namespace, yes?  If so,
that's what we want as right now all of the audit records, filters,
etc. are intended to be set from the context of the initial namespace.

--=20
paul-moore.com
