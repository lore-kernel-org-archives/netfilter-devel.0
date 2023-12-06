Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0kvVHlQk"
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7799D5A
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 06:39:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso9449a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2023 06:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701873569; x=1702478369; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tW4rpGHQhN9YNVTV5oiqqcaigarX5iDMhMQO+9Q6sBI=;
        b=0kvVHlQkWbFbLJ/N6mDI4+2NwPNiFc1a1bqcH8YyRBUQQnRM33ptdGgPouOmKzj+vM
         31mSR5wENDfbI9HdVmVFXn10nAvx7T9AE8e0dl5QPz4CrYm1zQ80eoKbeir1dM6feypY
         RMuX71mOq0zXtYG7YtLaFvqKaAiwza/AYqltw8gL2Pi4bvaBbslUEQdMHDHjTuKs6R73
         XpixfnL86MnfuWBppF9Whr77kuDbZnn37OTaWF9QE8B+gQs+YMCJVnaDOqfZLaukZ/RJ
         FgxefBeVtvx4Vrr/bKufL1uayeOXrVHP5IUvuKhoqk3W79hoThx3IDTJl0zPa8QZTcJw
         zlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701873569; x=1702478369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tW4rpGHQhN9YNVTV5oiqqcaigarX5iDMhMQO+9Q6sBI=;
        b=RDbc9chUTIXYM8HV+pTBTqXq62waOtzeD3ppDgF65Kq83qHSMBP17dQVCtL4oqhh02
         mZ4nqFMPOVAfBNYlDQcfqf6Vdt0pJvexjyrjAwZJwIMJNmgaLBNPgoUrNK882jelFBX5
         PtEEke2LtXM8PdI4Nqst5c1tSfOvOdAzlydhdqrZQ3eH44bh2inOVWSW+qqoAzEbvWwN
         hewuLkkNSssC8qNtRWu+jqaNMU3h2JaSLo87RdzHameIFWr/O5qoVFlzOpGWZHcPs4at
         VheoWdu94ja9AcDWEhxCA4IDSIWdfzpliXWzJJ214e4LXW5tMEFzrYv4GpD8zonUVU6u
         rktg==
X-Gm-Message-State: AOJu0YyIUjrRonlxba6RxDsSDIPMPTHuQZPoJnDVD+xAyMl5nOgWno21
	R5GSwDjbcearPcCQbVHOXoZaXiSN31ypwOsaZGbKsQ==
X-Google-Smtp-Source: AGHT+IHOApoAkKvH3wtbpKAIohGjJybdA9WJOGcJGuGDhFjsElRi+QiZLT+HeS9ho01lLQhVQILt1AqrvqJ5qf9gzrA=
X-Received: by 2002:a50:c35d:0:b0:54c:79ed:a018 with SMTP id
 q29-20020a50c35d000000b0054c79eda018mr96470edb.2.1701873568956; Wed, 06 Dec
 2023 06:39:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez0TfTAkaRWFCTb44x=TWP_sDZVx-5U2hvfQSFOhghNrCA@mail.gmail.com>
 <CAG48ez1hXk_cffp3dy-bYMcoyCCj-EySYR5SzYrNiRHGD=hOUg@mail.gmail.com> <20231206-refinanzieren-werkhalle-22db5334f256@brauner>
In-Reply-To: <20231206-refinanzieren-werkhalle-22db5334f256@brauner>
From: Jann Horn <jannh@google.com>
Date: Wed, 6 Dec 2023 15:38:50 +0100
Message-ID: <CAG48ez07dJ_=KUzRONVhMmr2koW9PwiZ5KxMHfx8ERPA=j4cUw@mail.gmail.com>
Subject: Re: Is xt_owner's owner_mt() racy with sock_orphan()? [worse with new
 TYPESAFE_BY_RCU file lifetime?]
To: Christian Brauner <brauner@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Network Development <netdev@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 2:58=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
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
> In your other mail you wrote:
>
> > I also think we have no guarantee here that the socket's ->file won't
> > go away due to a concurrent __sock_release(), which could cause us to
> > continue reading file credentials out of a file whose refcount has
> > already dropped to zero?
>
> Is this an independent worry or can the concurrent __sock_release()
> issue only happen due to a sock_orphan() having happened first? I think
> that it requires a sock_orphan() having happend, presumably because the
> socket gets marked SOCK_DEAD and can thus be released via
> __sock_release() asynchronously?
>
> If so then taking sk_callback_lock() in owner_mt() should fix this.
> (Otherwise we might need an additional get_active_file() on
> sk->sk_socker->file in owner_mt() in addition to the other fix.)

My understanding is that it could only happen due to a sock_orphan()
having happened first, and so just sk_callback_lock() should probably
be a sufficient fix. (I'm not an expert on net subsystem locking rules
though.)
