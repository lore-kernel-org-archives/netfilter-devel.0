Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xA6JrMKK"
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16DD5B
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 13:02:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso418a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2023 13:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701896561; x=1702501361; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+uaQdQz6QrhFhwF1BGDVo3HvtsF0av/JrsCNPWP0H8=;
        b=xA6JrMKK7zq5t7NH0UhLIEyiI/WUR5uZQNJY5T7XDC3iR77qkbVZXgbn8VaVtKzGiH
         9PrKVtVZdUrIDLfASfqYgYXsB2Q12BgcFnm+dOWmW4LSOWnejnN57gitRSfmKTNX5baB
         lhDPriynQtfAADCa1Dohny7W8ToV0ZVUZwRprq8l+amgVkRxcnvLRUvib+dcj5LRjLTs
         DzMUUcH0Puc1XuZxsm48ywpEh8aCJXwgPUew1iTZ7Ga9tEQ+VJefFoHFQTcheJOWbBQ0
         OtS6DNLHudhbxb4dc+PoW4C5dlLeW2rAC5BauAvd4wD3H7F7ySifEpCaoxLBnv26bPx/
         Iosg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701896561; x=1702501361;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+uaQdQz6QrhFhwF1BGDVo3HvtsF0av/JrsCNPWP0H8=;
        b=wnsyAETxLBW4KmHzxc/RwXh1ftwkssoTOVbeCgAuLMLtIhpr+at1WveQz0YDzBwR9u
         hbwEU/uKHejAM/nnLu4Go9ETqDqjY70c1p+IlGcKCtgvfFQsNr9Mwz35bxsqQxQRNq5+
         EZ1cRQ27TB37vVNsp55mGDCFfmWDDBx9QrgXxTTzNkr95uarZbJQ9884h5Yf+h4q5sgK
         ogd99NOwP9Yaaf14eQ8XIQE7W5nnKz0jpCK8qiZI0gRPTlNf0SXauMjk2T9Tc/VBXi8z
         5kBZesIwTotoRTq5o2NZMFpPKY7klTd9IbTlxWeTWzXHbPwayPvqDX9YDmc8abtsatw3
         QKdA==
X-Gm-Message-State: AOJu0Yyxs1aiDubKzHmxbjt1ZXunZ7UWHDob0+mviMjYVBYjNKosjYij
	zOhhAw64rLFTrqEAi96SnvOwC/dBYFT42CgydW9QiA==
X-Google-Smtp-Source: AGHT+IGaFpPeOUa5pJ8acL4jNk8ba2S6zn80/0RY0+ToikBAjDYwgKXjIIG+inhLt+24e/6pD2aIRpWsch8xjOOWqFw=
X-Received: by 2002:a50:baae:0:b0:545:279:d075 with SMTP id
 x43-20020a50baae000000b005450279d075mr115598ede.1.1701896560601; Wed, 06 Dec
 2023 13:02:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez0TfTAkaRWFCTb44x=TWP_sDZVx-5U2hvfQSFOhghNrCA@mail.gmail.com>
 <CAG48ez1hXk_cffp3dy-bYMcoyCCj-EySYR5SzYrNiRHGD=hOUg@mail.gmail.com>
 <ZW+Yv6TR+EMBp03f@orbyte.nwl.cc> <CAG48ez2G4q-50242WRE01iaKfAhd0D+XT9Ry0uS767ceHEzHXA@mail.gmail.com>
 <ZXDctabBrEFMVxg2@orbyte.nwl.cc>
In-Reply-To: <ZXDctabBrEFMVxg2@orbyte.nwl.cc>
From: Jann Horn <jannh@google.com>
Date: Wed, 6 Dec 2023 22:02:04 +0100
Message-ID: <CAG48ez1ixOapt330sDoCfhnVhN0VmO=i9H8cSQontGkvi_NT7A@mail.gmail.com>
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

On Wed, Dec 6, 2023 at 9:42=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> On Wed, Dec 06, 2023 at 05:28:44PM +0100, Jann Horn wrote:
> > On Tue, Dec 5, 2023 at 10:40=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote=
:
> > > On Tue, Dec 05, 2023 at 06:08:29PM +0100, Jann Horn wrote:
> > > > On Tue, Dec 5, 2023 at 5:40=E2=80=AFPM Jann Horn <jannh@google.com>=
 wrote:
> > > > >
> > > > > Hi!
> > > > >
> > > > > I think this code is racy, but testing that seems like a pain...
> > > > >
> > > > > owner_mt() in xt_owner runs in context of a NF_INET_LOCAL_OUT or
> > > > > NF_INET_POST_ROUTING hook. It first checks that sk->sk_socket is
> > > > > non-NULL, then checks that sk->sk_socket->file is non-NULL, then
> > > > > accesses the ->f_cred of that file.
> > > > >
> > > > > I don't see anything that protects this against a concurrent
> > > > > sock_orphan(), which NULLs out the sk->sk_socket pointer, if we'r=
e in
> > > >
> > > > Ah, and all the other users of ->sk_socket in net/netfilter/ do it
> > > > under the sk_callback_lock... so I guess the fix would be to add th=
e
> > > > same in owner_mt?
> > >
> > > Sounds reasonable, although I wonder how likely a socket is to
> > > orphan while netfilter is processing a packet it just sent.
> > >
> > > How about the attached patch? Not sure what hash to put into a Fixes:
> > > tag given this is a day 1 bug and ipt_owner/ip6t_owner predate git.
> >
> > Looks mostly reasonable to me; though I guess it's a bit weird to have
> > two separate bailout paths for checking whether sk->sk_socket is NULL,
> > where the first check can race, and the second check uses different
> > logic for determining the return value; I don't know whether that
> > actually matters semantically. But I'm not sure how to make it look
> > nicer either.
>
> I find the code pretty confusing since it combines three matches (socket
> UID, socket GID and socket existence) via binary ops. The second bail
> disregards socket existence bits, I assumed it was deliberate and thus
> decided to leave the first part as-is.
>
> > I guess you could add a READ_ONCE() around the first read to signal
> > that that's a potentially racy read, but I don't feel strongly about
> > that.
>
> Is this just annotation or do you see a practical effect of using
> READ_ONCE() there?

I mostly just meant that as an annotation. My understanding is that in
theory, racy reads can cause the compiler to do some terrible things
to your code (https://lore.kernel.org/all/CAG48ez2nFks+yN1Kp4TZisso+rjvv_4U=
W0FTo8iFUd4Qyq1qDw@mail.gmail.com/),
but that's almost certainly not going to happen here.

(Well, I guess doing a READ_ONCE() at one side without doing
WRITE_ONCE() on the other side is also unclean...)
