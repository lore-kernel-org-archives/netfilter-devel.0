Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE5524DE;
	Fri,  8 Mar 2024 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709888419; cv=none; b=fI6yK55ruJOPtuxENgMwV5/vMjofeSm6lbcs0dkO4jN9gfeA9ahFT7L9iJp1qUgawvtCshpvfddAN6gbyOAt4C6V8bBfLtEjnkEiczBKDXTBVt2K8GOn46vRub0XRPUq/modiJAG54mH0bwZpF/0AEfJXft0sC5gyO7HfQamizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709888419; c=relaxed/simple;
	bh=dglt4wwjV0z/j+pYZw3MOq5INIFuX1awtLSIZ7HBBtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TTH3D+KXH/93oH/N1/M0TA0QejfLztu0pGXD4uVbemuwZ/0sglgsv6NOWGH5IvTo7BDvbuZsgq7wnYDbbs/1jy8yGO7AZyS/n0AYYcn6w5ShoEokF32spNBbA5dLG9vQ4L2U3g3SjojpN3zCaW0fnauvey1+R8dmhuhiAWrrFp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtI7stPu; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtI7stPu"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a3f893ad5f4so75683866b.2;
        Fri, 08 Mar 2024 01:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709888416; x=1710493216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeV/BqFNEHreI7gG8xetgTnPdw+ArBtbuIdMkI18nMM=;
        b=WtI7stPuWNcWNn6yl0/vBPaEO77PR6N/9ATI9GsI7RuvvuVGV4V1S41HpWkKfqAe84
         QJ7sUDBpDT0/dVTFTebKhqBS+oI99nabVy3Qae15baG4qdy9Ml9TnilQYi+FiFRVmWr/
         zlXnvZOF/UOwX8w4Xs2pN30wG0KbcOec4ZUymFpmVoUEADlckMH1N0DJM/+xvYccFm99
         5y+YTXpVaVMe9DSAA3fw0cgdvvdvDWl+RSB2YNWtIoD3B9meftOjVw4kSp8xHcD6Q4xp
         hoDi2cm3yzXkkT8ZN0lgmQoPYEW+HAou8hQf5W9rNtaEq35d8vfy0iSNRAIM76Bj3z0A
         RXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709888416; x=1710493216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeV/BqFNEHreI7gG8xetgTnPdw+ArBtbuIdMkI18nMM=;
        b=NUFrYCwK2LqP/nVZKOHNpsJw/QHUQaqWwx77n3gevKSninU9BoZA8G/cFAzK2IHQQC
         l72HaShNzezopVepnSmDLrxTwOcHbSy+oCVl5LgKt5fOgr9XuB7Mf7slQFWkq2HTNq4u
         D7YXfPa/lQOL8ur/NZ2O+pHL0ub99ZtIaclxLyBWIBVDYeL2NYumQsuN1pDuS+7l5Vqq
         JyQbLxpLaKdmR8Bww2aiqNx60psmV8W1tFLzy0nRJokm5TXAqeATLAjQ7rV6Y2m19LAr
         K/uzyavWbuA8+vlRNe+kPfRn0MFps3WiCbZDcG5k3vAW4g3RGyJ3/1Hddp6o2Wd4be6q
         UbXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNI4P0D/HP6YrPbThx96mLHkM3PBiR9i3RhSdBJsInyz52r2HRXX6iWVJZ10lqybxd22k2+XkMrKi35BO90wp/lQbS+ZI+q9r5zk8URrRmCmTM+Z0c2vbyJsXDISDJ5kU9mLVOzfRg
X-Gm-Message-State: AOJu0Yy47BdwUbhw2W6el4NlGHM0wvYkelG7BkMfx3mFDac8uyHA3Sub
	rVD+N+DvIZlc/LmF78gKVPv3wOSS07kJYdnqZs4IvebQbjHM5q8X561eRx/zo1UMtML+2OvJrvr
	3fYUXJS5lUF0i7aST77887CSpBR0=
X-Google-Smtp-Source: AGHT+IHxd1Prdft65OHM6XjDEuBT1I+4d+f83ifR7RFmOD30QxwTnhcI/v+kd+0ofynTjSKXa3rdfGPLXfAj00fbuXs=
X-Received: by 2002:a17:907:367:b0:a44:1ed2:64a3 with SMTP id
 rs7-20020a170907036700b00a441ed264a3mr14112838ejb.11.1709888415349; Fri, 08
 Mar 2024 01:00:15 -0800 (PST)
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
In-Reply-To: <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 8 Mar 2024 16:59:38 +0800
Message-ID: <CAL+tcoDo3=uLFjxnnKj6LnE+DBHb8UybXK1_HQHTtZVr-tBYUw@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 11:11=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> On Thu, Mar 7, 2024 at 10:10=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > On Thu, Mar 7, 2024 at 8:00=E2=80=AFPM Florian Westphal <fw@strlen.de=
> wrote:
> > > >
> > > > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > > > This change disables most of the tcp_in_window() test, this wil=
l
> > > > > > pretend everything is fine even though tcp_in_window says other=
wise.
> > > > >
> > > > > Thanks for the information. It does make sense.
> > > > >
> > > > > What I've done is quite similar to nf_conntrack_tcp_be_liberal sy=
sctl
> > > > > knob which you also pointed out. It also pretends to ignore those
> > > > > out-of-window skbs.
> > > > >
> > > > > >
> > > > > > You could:
> > > > > >  - drop invalid tcp packets in input hook
> > > > >
> > > > > How about changing the return value only as below? Only two cases=
 will
> > > > > be handled:
> > > > >
> > > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > index ae493599a3ef..c88ce4cd041e 100644
> > > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn =
*ct,
> > > > >         case NFCT_TCP_INVALID:
> > > > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state)=
;
> > > > >                 spin_unlock_bh(&ct->lock);
> > > > > -               return -NF_ACCEPT;
> > > > > +               return -NF_DROP;
> > > >
> > > > Lets not do this.  conntrack should never drop packets and defer to=
 ruleset
> > > > whereever possible.
> > >
> > > Hmm, sorry, it is against my understanding.
> > >
> > > If we cannot return -NF_DROP, why have we already added some 'return
> > > NF_DROP' in the nf_conntrack_handle_packet() function? And why does
> > > this test statement exist?
> >
> > Sure we can drop.  But we should only do it if there is no better
> > alternative.
> >
> > > nf_conntrack_in()
> > >   -> nf_conntrack_handle_packet()
> > >   -> if (ret <=3D 0) {
> > >          if (ret =3D=3D -NF_DROP) NF_CT_STAT_INC_ATOMIC(state->net, d=
rop);
> >
> > AFAICS this only happens when we receive syn for an existing conntrack
> > that is being removed already so we'd expect next syn to create a new
>
> Sorry, I've double-checked this part and found out there is no chance
> to return '-NF_DROP' for nf_conntrack_handle_packet(). It might return
> 'NF_DROP' (see link [1]) instead. The if-else statements seem like
> dead code.

My bad. My mind went blank last night, maybe it's too late. Well, It's
not dead code because '-NF_DROP' which is still zero makes me
misunderstand :(

I'll post a patch to change 'if (ret =3D=3D -NF_DROP)' to 'if (ret =3D=3D
NF_DROP)' just for easy reading.

Thanks,
Jason

>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/net/netfilter/nf_conntrack_proto_tcp.c#:~:text=3D%2DNF_REPEAT%3B-,retur=
n%20NF_DROP%3B,-%7D%0A%09%09fallthrough%3B
>
> > connection.  Feel free to send patches that replace drop with -accept
> > where possible/where it makes sense, but I don't think the
> > TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.
>
> Oh, are you suggesting replacing NF_DROP with -NF_ACCEPT in
> nf_conntrack_dccp_packet()?
>
> There are three points where nf_conntrack_handle_packet() returns NF_DROP=
:
> 1) one (syn_sent case) exists in nf_conntrack_tcp_packet(). As you
> said, it's not necessary to change.
> 2) another two exist in nf_conntrack_dccp_packet() which should be the
> same as nf_conntrack_tcp_packet() handles.
>
> The patch goes like this:
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c
> b/net/netfilter/nf_conntrack_proto_dccp.c
> index e2db1f4ec2df..ebc4f733bb2e 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
> struct sk_buff *skb,
>
>         dh =3D skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>
>         if (dccp_error(dh, skb, dataoff, state))
>                 return -NF_ACCEPT;
> @@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
> struct sk_buff *skb,
>         /* pull again, including possible 48 bit sequences and subtype he=
ader */
>         dh =3D dccp_header_pointer(skb, dataoff, dh, &_dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>
>         type =3D dh->dccph_type;
>         if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
>
> >
> > > My only purpose is not to let the TCP layer sending strange RST to th=
e
> > > right flow.
> >
> > AFAIU tcp layer is correct, no?  Out of the blue packet to some listene=
r
> > socket?
>
> Allow me to finish the full sentence: my only purpose is not to let
> the TCP layer send strange RST to the _established_ socket due to
> receiving strange out-of-window skbs.
>
> >
> > > Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
> > > knob seems odd to me though it can workaround :S
> >
> > I don't see a better alternative, other than -p tcp -m conntrack
> > --ctstate INVALID -j DROP rule, if you wish for tcp stack to not see
> > such packets.
> >
> > > I would like to prevent sending such an RST as default behaviour.
> >
> > I don't see a way to make this work out of the box, without possible
> > unwanted side effects.
> >
> > MAYBE we could drop IFF we check that the conntrack entry candidate
> > that fails sequence validation has NAT translation applied to it, and
> > thus the '-NF_ACCEPT' packet won't be translated.
> >
> > Not even compile tested:
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_=
conntrack_proto_tcp.c
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >         case NFCT_TCP_IGNORE:
> >                 spin_unlock_bh(&ct->lock);
> >                 return NF_ACCEPT;
> > -       case NFCT_TCP_INVALID:
> > +       case NFCT_TCP_INVALID: {
> > +               verdict =3D -NF_ACCEPT;
> > +               if (ct->status & IPS_NAT_MASK)
> > +                       res =3D NF_DROP; /* skb would miss nat transfor=
mation */
>
> Above line, I guess, should be 'verdict =3D NF_DROP'? Then this skb
> would be dropped in nf_hook_slow() eventually and would not be passed
> to the TCP layer.
>
> >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> >                 spin_unlock_bh(&ct->lock);
> > -               return -NF_ACCEPT;
> > +               return verdict;
> > +       }
> >         case NFCT_TCP_ACCEPT:
> >                 break;
> >         }
>
> Great! I think your draft patch makes sense really, which takes NAT
> into consideration.
>
> >
> > But I don't really see the advantage compared to doing drop decision in
> > iptables/nftables ruleset.
>
> From our views, especially to kernel developers, you're right: we
> could easily turn on that knob or add a drop policy to prevent it
> happening. Actually I did this in production to prevent such a case.
> It surely works.
>
> But from the views of normal users and those who do not understand how
> it works in the kernel, it looks strange: people may ask why we get
> some unknown RSTs in flight?
>
> >
> > I also have a hunch that someone will eventually complain about this
> > change in behavior.
>
> Well, I still think the patch you suggested is proper and don't know
> why people could complain about it.
>
> Thanks for your patience :)
>
> Thanks,
> Jason
