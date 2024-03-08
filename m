Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE927470;
	Fri,  8 Mar 2024 00:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709858582; cv=none; b=pZERfqZDYj9HoXVtE2kgaz1wP3dlQk4/plKER33vPyIZnVg84/LMgdptPy4UWXXYdGMbikR7jrGELmtQR7FpGGO+Fsa2+81Dr9QM3X8hZX+WO655RBBcnupjS59x8bToiAwWBKyYQW+PrO5t6dDQ+dLmvcm/WZQfoWjnm59bRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709858582; c=relaxed/simple;
	bh=3NEG6TNj7KsFoTEvmnkdQHLT3ZPCDsEdozgYR6CjZtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MQ/WTxlUGyseRncgrs0PZC9we1Fov7sRQxGbLmPdTpzDFx9fsj3vR44weK3lfOyX2wAfGS+vhdJv3QLya3k19goB+oal7QiDi9/tDlwAugIQuJIcuK6/dOyWjtUd8eFj09xt0fn48lCQdLFMZKvpfuULEqBA7qhBPErJa7pfcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/QuucnA; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/QuucnA"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-567bac94719so322497a12.0;
        Thu, 07 Mar 2024 16:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709858578; x=1710463378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYvQtqEyJB+URroCRC8pQOSdeHppTkKZaU1WCC5rpUs=;
        b=h/QuucnAbMcZBcUoCeKLMrmMcKxPty1oDpQKgWHqdHu0FX1wrd3lEjP6lf2SN0c8oz
         mXmmJJibI3lrb9WL6+qUoywlfcM1DQGctlItnRF/Sto8Zh7de/1GzsELxEzZTK4W7kkv
         vh4fmzMr1URIBuxCWvx9P7GqO2j0VZQw86oKHqllkVySQQny0siRMhpyW/hreHJvQN2y
         JYPAYmdDZAtB8h4jySj088y/za6FeVCGSt8pF20roU8LLQsf3tjnZ/yPyQRAZ9XzwFzb
         FvlAAY0nX4WD0LxyGaGa+lt/Q3qGoJSObN+rGBBq4E7BYzaQlIKOH2eDnLZtVCuOrL8t
         GlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709858578; x=1710463378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYvQtqEyJB+URroCRC8pQOSdeHppTkKZaU1WCC5rpUs=;
        b=I+B/qXDZ+jrkK3oliLRyxmP3p91955r615vwEtrfKpZpVHC6Tu9hF3wOhXA9lgcGJ2
         g5YtwoTRrBVsrT1IWpGMCR9cNWeTY5F4noJ1NC1fGAadeZV87BYjFe/zJIAJIelnwd4m
         6i0niZ0Sq0l/spnvjnlHjzNoBdx1z19aS9wdEnRv0NVt2vzZxrdjEGbUht4PRNrYt9Z2
         0BJXGM8zV0GOzsfHsWdmwlYFSOTTNkM7M+/2k10gqkhhN0BQ4J5GRygdIBb7ctSPL25x
         g6LxD2EOIIHJsgWVaVJeD5ixm5fjQhbdhEl2c8jqgvKjf02O/kjMZWPSIoBCYxFbX9dQ
         DyLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtvZpTH02ksZJxa7AY6nhU9Mfq/RXv54biwuz6pzv1x4xG7MDVTzHXMEJDJLfRTvq9mW/2TH2mn1NQjlkXkQF7r9VdBguB/mIzYdMTU3/0eNG4gncb9GYCZeaA2qckJOzTwsVQY+LG
X-Gm-Message-State: AOJu0Ywx6CjTRrtX/crEtVV6A9tZRJzSmpaWE/KGs07FilPmvy5BKdDL
	h7hSMmAFR5Xj8TLaGZlCURGkHWjvUrG7BUR9km91Llki9WsXkRjWAzPJRJ2tC8f5aTwYM+dxi8d
	uV7ufywne51y7TfIk9cEpBql9zmg=
X-Google-Smtp-Source: AGHT+IFgPm3Vx3eCeRo828gl5p0zzcm1Y75zw1kGYKt2C6e5P0rt9hWDeKEXQwsMFV5wa7KzlxHqWsTkHaYTWwCz8aM=
X-Received: by 2002:a17:906:3b81:b0:a43:86f3:af37 with SMTP id
 u1-20020a1709063b8100b00a4386f3af37mr13061731ejf.53.1709858577767; Thu, 07
 Mar 2024 16:42:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc> <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc> <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
 <1cf0cef4-c972-9f8d-7095-66516eafb85c@blackhole.kfki.hu> <CAL+tcoBwmnPO8y7zDvi3h0Y_QzKpj=fjnxiOuQYP_OBzoh=qEA@mail.gmail.com>
 <55a00270-6750-ca72-f20c-4be84afa0c3b@blackhole.kfki.hu>
In-Reply-To: <55a00270-6750-ca72-f20c-4be84afa0c3b@blackhole.kfki.hu>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 8 Mar 2024 08:42:20 +0800
Message-ID: <CAL+tcoBWGEtirQXUKtQ7EnveXc_T3aOCydG_uGUmew4x56hifw@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com, 
	Pablo Neira Ayuso <pablo@netfilter.org>, kuba@kernel.org, pabeni@redhat.com, 
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 3:00=E2=80=AFAM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> On Thu, 7 Mar 2024, Jason Xing wrote:
>
> > > > Allow me to finish the full sentence: my only purpose is not to let
> > > > the TCP layer send strange RST to the _established_ socket due to
> > > > receiving strange out-of-window skbs.
> > >
> > > I don't understand why do you want to modify conntrack at all: conntr=
ack
> > > itself does not send RST packets. And the TCP layer don't send RST pa=
ckets
> > > to out of window ones either.
> >
> > To normal TCP flow, you're right because the TCP layer doesn't send RST
> > to out-of-window skbs.
> >
> > But the DNAT policy on the server should have converted the port of
> > incoming skb from A_port to B_port as my description in this patch said=
.
> >
> > It actually doesn't happen. The conntrack clears the skb->_nfct value
> > after returning -NF_ACCEPT in nf_conntrack_tcp_packet() and then DNAT
> > would not convert the A_port to B_port.
>
> The packet is INVALID therefore it's not NATed. I don't think that could
> simply be changed in netfilter.

Well, what would you suggest ? :)

>
> > So the TCP layer is not able to look up the correct socket (client_ip,
> > client_port, server_ip, B_port) because A_port doesn't match B_port,
> > then an RST would be sent to the client.
>
> Yes, if you let the packet continue to traverse the stack.

Yes!

>
> > > The only possibility I see for such packets is an iptables/nftables r=
ule
> > > which rejects packets classified as INVALID by conntrack.
> > >
> > > As Florian suggested, why don't you change that rule?
> >
> > As I said, just for the workaround method, only turning on that sysctl
> > knob can solve the issue.
>
> Sorry, but why? If you drop the packet by a rule, then there's no need to
> use the sysctl setting and there's no unwanted RST packets.

Oh, I was trying to clarify that using some knob can work around which
is not my original intention, but I don't seek a workaround method. I
didn't use --cstate INVALID to drop those INVALID packets in
production, which I feel should work.

For this particular case, I feel it's not that good to ask
users/customers to add more rules or turn on sysctl knob to prevent
seeing such RSTs.

Instead I thought we could naturally stop sending such RSTs as default
without asking other people to change something. People shouldn't see
the RSTs really. That's why I wrote this patch.

I hope I'm right... :S

Thanks,
Jason

>
> Best regards,
> Jozsef
>
> > > The conntrack states are not fine-grained to express different TCP st=
ates
> > > which covered with INVALID. It was never a good idea to reject INVALI=
D
> > > packets or let them through (leaking internal addresses).
> > >
> > > Best regards,
> > > Jozsef
> > >
> > > > > > Besides, resorting to turning on nf_conntrack_tcp_be_liberal sy=
sctl
> > > > > > knob seems odd to me though it can workaround :S
> > > > >
> > > > > I don't see a better alternative, other than -p tcp -m conntrack
> > > > > --ctstate INVALID -j DROP rule, if you wish for tcp stack to not =
see
> > > > > such packets.
> > > > >
> > > > > > I would like to prevent sending such an RST as default behaviou=
r.
> > > > >
> > > > > I don't see a way to make this work out of the box, without possi=
ble
> > > > > unwanted side effects.
> > > > >
> > > > > MAYBE we could drop IFF we check that the conntrack entry candida=
te
> > > > > that fails sequence validation has NAT translation applied to it,=
 and
> > > > > thus the '-NF_ACCEPT' packet won't be translated.
> > > > >
> > > > > Not even compile tested:
> > > > >
> > > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilt=
er/nf_conntrack_proto_tcp.c
> > > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_con=
n *ct,
> > > > >         case NFCT_TCP_IGNORE:
> > > > >                 spin_unlock_bh(&ct->lock);
> > > > >                 return NF_ACCEPT;
> > > > > -       case NFCT_TCP_INVALID:
> > > > > +       case NFCT_TCP_INVALID: {
> > > > > +               verdict =3D -NF_ACCEPT;
> > > > > +               if (ct->status & IPS_NAT_MASK)
> > > > > +                       res =3D NF_DROP; /* skb would miss nat tr=
ansformation */
> > > >
> > > > Above line, I guess, should be 'verdict =3D NF_DROP'? Then this skb
> > > > would be dropped in nf_hook_slow() eventually and would not be pass=
ed
> > > > to the TCP layer.
> > > >
> > > > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state)=
;
> > > > >                 spin_unlock_bh(&ct->lock);
> > > > > -               return -NF_ACCEPT;
> > > > > +               return verdict;
> > > > > +       }
> > > > >         case NFCT_TCP_ACCEPT:
> > > > >                 break;
> > > > >         }
> > > >
> > > > Great! I think your draft patch makes sense really, which takes NAT
> > > > into consideration.
> > > >
> > > > >
> > > > > But I don't really see the advantage compared to doing drop decis=
ion in
> > > > > iptables/nftables ruleset.
> > > >
> > > > From our views, especially to kernel developers, you're right: we
> > > > could easily turn on that knob or add a drop policy to prevent it
> > > > happening. Actually I did this in production to prevent such a case=
.
> > > > It surely works.
> > > >
> > > > But from the views of normal users and those who do not understand =
how
> > > > it works in the kernel, it looks strange: people may ask why we get
> > > > some unknown RSTs in flight?
> > > >
> > > > > I also have a hunch that someone will eventually complain about t=
his
> > > > > change in behavior.
> > > >
> > > > Well, I still think the patch you suggested is proper and don't kno=
w
> > > > why people could complain about it.
> > > >
> > > > Thanks for your patience :)
> > > >
> > > > Thanks,
> > > > Jason
> > > >
> > >
> > > --
> > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > Address : Wigner Research Centre for Physics
> > >           H-1525 Budapest 114, POB. 49, Hungary
> >
>
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
