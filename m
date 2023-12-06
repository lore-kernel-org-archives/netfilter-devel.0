Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jovmhc7D"
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEDD59
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 08:29:25 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so14241a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2023 08:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701880164; x=1702484964; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Q0ni2/1KGl8oE8mSvYKMN/w7HkQAhvJXLW7tvjYVJg=;
        b=jovmhc7DMq6RVlsgp1hJ63pBy4RtOFJwNC6VWUkmD7EDMaUQrsf8UY+H1Rfc3W4qqz
         je9YeZLkzdlT1ckXaZIODlqK1PE8uGpUVZ2HLkks5hcmSMqfcLidvfogEQ/2UmhRdqsS
         fZXiu5H5Ps/iDIX0rlzLIKUD0OE9q2EFF5tWMn0Zej0m0uQbSuqSHQPgkpcXeljYgwKd
         5Pci1PJskzuOoaNhhC3ftT/tzB86BdbwiHxETeZgJkS92Xjp7zDlgWftYryoCg8z02oa
         0PUD1sDAThiZOMXNH4uqNNNxsE8qzvgz47JelqRAkbVimhCtTiBhc45/EZbfCTezQhBp
         0ECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701880164; x=1702484964;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Q0ni2/1KGl8oE8mSvYKMN/w7HkQAhvJXLW7tvjYVJg=;
        b=g1joUn9IHZUZ7y3GlNwP6DtMNDkQDhZbnQK6r24GXe3iDJWpQD67xMxnIa6r1Nnjns
         pYGXjfWrcuETSInH3FPs/VG62ZjuMKY3p1fG+haF83RpQzJU5nSa9TOOGM/f1hoQcaWs
         FPtiz3RK7YznVwa/Tl1IqbScMvVfl40EkMXqXtho3dTEo25JWyPtqOYwNtSdmvfsYrb+
         qjBcsd2D6eIyNLQme3rEUC2U0WQ4XIhnJx+YCcYNVWoJfvpC75kKyMNN3/+FsgtjWFU4
         8ZXIWGMYc7dSrkHF095u/CbX7Cm4S5NzihSBl4r09FydVh1sZF77AGYagkovmVWnn+3S
         UxsQ==
X-Gm-Message-State: AOJu0YylBGFRhkD+Qc+nfjxQ9rB44MYaQ41Nej2aBZVUJSSDI6clAj4t
	AvLzUbpUmeqRJjg0rfd7vZhac3LwiWCg/ldrkHIhNA==
X-Google-Smtp-Source: AGHT+IEFOrwFlWr5FZ0KB2T0KCgIgdyHQa1hSadWxXyDA/De9hFfeLO8tTOPlMdmKuy/UHtCU0vM/qUxtA/0BWamgeg=
X-Received: by 2002:a50:c048:0:b0:544:e2b8:ba6a with SMTP id
 u8-20020a50c048000000b00544e2b8ba6amr100459edd.3.1701880163670; Wed, 06 Dec
 2023 08:29:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez0TfTAkaRWFCTb44x=TWP_sDZVx-5U2hvfQSFOhghNrCA@mail.gmail.com>
 <CAG48ez1hXk_cffp3dy-bYMcoyCCj-EySYR5SzYrNiRHGD=hOUg@mail.gmail.com> <ZW+Yv6TR+EMBp03f@orbyte.nwl.cc>
In-Reply-To: <ZW+Yv6TR+EMBp03f@orbyte.nwl.cc>
From: Jann Horn <jannh@google.com>
Date: Wed, 6 Dec 2023 17:28:44 +0100
Message-ID: <CAG48ez2G4q-50242WRE01iaKfAhd0D+XT9Ry0uS767ceHEzHXA@mail.gmail.com>
Subject: Re: Is xt_owner's owner_mt() racy with sock_orphan()? [worse with new
 TYPESAFE_BY_RCU file lifetime?]
To: Phil Sutter <phil@nwl.cc>, Jann Horn <jannh@google.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org, 
	Christian Brauner <brauner@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Network Development <netdev@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 10:40=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
> On Tue, Dec 05, 2023 at 06:08:29PM +0100, Jann Horn wrote:
> > On Tue, Dec 5, 2023 at 5:40=E2=80=AFPM Jann Horn <jannh@google.com> wro=
te:
> > >
> > > Hi!
> > >
> > > I think this code is racy, but testing that seems like a pain...
> > >
> > > owner_mt() in xt_owner runs in context of a NF_INET_LOCAL_OUT or
> > > NF_INET_POST_ROUTING hook. It first checks that sk->sk_socket is
> > > non-NULL, then checks that sk->sk_socket->file is non-NULL, then
> > > accesses the ->f_cred of that file.
> > >
> > > I don't see anything that protects this against a concurrent
> > > sock_orphan(), which NULLs out the sk->sk_socket pointer, if we're in
> >
> > Ah, and all the other users of ->sk_socket in net/netfilter/ do it
> > under the sk_callback_lock... so I guess the fix would be to add the
> > same in owner_mt?
>
> Sounds reasonable, although I wonder how likely a socket is to
> orphan while netfilter is processing a packet it just sent.
>
> How about the attached patch? Not sure what hash to put into a Fixes:
> tag given this is a day 1 bug and ipt_owner/ip6t_owner predate git.

Looks mostly reasonable to me; though I guess it's a bit weird to have
two separate bailout paths for checking whether sk->sk_socket is NULL,
where the first check can race, and the second check uses different
logic for determining the return value; I don't know whether that
actually matters semantically. But I'm not sure how to make it look
nicer either.
I guess you could add a READ_ONCE() around the first read to signal
that that's a potentially racy read, but I don't feel strongly about
that.
