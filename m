Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D2912F398;
	Thu,  7 Mar 2024 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709826269; cv=none; b=CJOukvX88VDcwaKcMzkVqhQHh/z+ov1k+84BWvo1TJvtJNUxqPXZydGmpVxv4xZx75XP+8QwWpkBlDC8CyNTd7hKiFyemFMFMLkyrGCHDVCXJlDXH9q96Rz8y8mLupw3ImYzjp0L1rfHNFnGCbFW7xyD/PamPJxi3gVpCKb2wuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709826269; c=relaxed/simple;
	bh=m4xfA+vapXshimeVlokT2rpklewP5if2aNHL20DnHPY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XeOoRH0tBxsAENNCi0PRbNNFq0/JfvhOYqvuqy47/v7S3Lehh4dXvUQJLHUoJ6bMdkqyRbINSNv9VyVEUbXmiXufXpsxIZ4aF+vpTaxuawD3CJ+/uqH4gkjP9AXIMazY5axq37bkJqhLkmoeV7/8RE3NmKIJNOcEK8n0GG9bUX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=ENdd9zFV; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ENdd9zFV"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 30672CC02B8;
	Thu,  7 Mar 2024 16:34:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1709825676; x=1711640077; bh=zY8puOsLD8
	FbTRsEZsJ2gxMQoYs/FDAEYPFtq38F5XY=; b=ENdd9zFVDLeUyq1Pu3L1IVcLCi
	iPdLRqNxP3Cg6i+pa4qbk2HIrLPhHvUlOgaqSjrfNrgOvIIkRbRkIH8PhKIXvQ0O
	AEAn3KgcFP3/NIhRdZkMOePyhwYKGcKIBRfjvRQu9zaRvlSkOCjTYcCI2/kyjdxM
	kpx2kGZobp3lhUrws=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu,  7 Mar 2024 16:34:36 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 1086DCC010E;
	Thu,  7 Mar 2024 16:34:35 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id C2D31343167; Thu,  7 Mar 2024 16:34:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id C0E85343166;
	Thu,  7 Mar 2024 16:34:35 +0100 (CET)
Date: Thu, 7 Mar 2024 16:34:35 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jason Xing <kerneljasonxing@gmail.com>
cc: Florian Westphal <fw@strlen.de>, edumazet@google.com, 
    Pablo Neira Ayuso <pablo@netfilter.org>, kuba@kernel.org, 
    pabeni@redhat.com, David Miller <davem@davemloft.net>, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
In-Reply-To: <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
Message-ID: <1cf0cef4-c972-9f8d-7095-66516eafb85c@blackhole.kfki.hu>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com> <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com> <20240307120054.GK4420@breakpoint.cc> <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc> <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-266227853-1709825675=:817479"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-266227853-1709825675=:817479
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Mar 2024, Jason Xing wrote:

> On Thu, Mar 7, 2024 at 10:10=E2=80=AFPM Florian Westphal <fw@strlen.de>=
 wrote:
> >
> > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > On Thu, Mar 7, 2024 at 8:00=E2=80=AFPM Florian Westphal <fw@strlen.=
de> wrote:
> > > >
> > > > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > > > This change disables most of the tcp_in_window() test, this w=
ill
> > > > > > pretend everything is fine even though tcp_in_window says oth=
erwise.
> > > > >
> > > > > Thanks for the information. It does make sense.
> > > > >
> > > > > What I've done is quite similar to nf_conntrack_tcp_be_liberal =
sysctl
> > > > > knob which you also pointed out. It also pretends to ignore tho=
se
> > > > > out-of-window skbs.
> > > > >
> > > > > >
> > > > > > You could:
> > > > > >  - drop invalid tcp packets in input hook
> > > > >
> > > > > How about changing the return value only as below? Only two cas=
es will
> > > > > be handled:
> > > > >
> > > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > index ae493599a3ef..c88ce4cd041e 100644
> > > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > > @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_con=
n *ct,
> > > > >         case NFCT_TCP_INVALID:
> > > > >                 nf_tcp_handle_invalid(ct, dir, index, skb, stat=
e);
> > > > >                 spin_unlock_bh(&ct->lock);
> > > > > -               return -NF_ACCEPT;
> > > > > +               return -NF_DROP;
> > > >
> > > > Lets not do this.  conntrack should never drop packets and defer =
to ruleset
> > > > whereever possible.
> > >
> > > Hmm, sorry, it is against my understanding.
> > >
> > > If we cannot return -NF_DROP, why have we already added some 'retur=
n
> > > NF_DROP' in the nf_conntrack_handle_packet() function? And why does
> > > this test statement exist?
> >
> > Sure we can drop.  But we should only do it if there is no better
> > alternative.
> >
> > > nf_conntrack_in()
> > >   -> nf_conntrack_handle_packet()
> > >   -> if (ret <=3D 0) {
> > >          if (ret =3D=3D -NF_DROP) NF_CT_STAT_INC_ATOMIC(state->net,=
 drop);
> >
> > AFAICS this only happens when we receive syn for an existing conntrac=
k
> > that is being removed already so we'd expect next syn to create a new
>=20
> Sorry, I've double-checked this part and found out there is no chance
> to return '-NF_DROP' for nf_conntrack_handle_packet(). It might return
> 'NF_DROP' (see link [1]) instead. The if-else statements seem like
> dead code.
>=20
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/tree/net/netfilter/nf_conntrack_proto_tcp.c#:~:text=3D%2DNF_REPEAT%3B-,r=
eturn%20NF_DROP%3B,-%7D%0A%09%09fallthrough%3B
>=20
> > connection.  Feel free to send patches that replace drop with -accept
> > where possible/where it makes sense, but I don't think the
> > TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.
>=20
> Oh, are you suggesting replacing NF_DROP with -NF_ACCEPT in
> nf_conntrack_dccp_packet()?
>=20
> There are three points where nf_conntrack_handle_packet() returns NF_DR=
OP:
> 1) one (syn_sent case) exists in nf_conntrack_tcp_packet(). As you
> said, it's not necessary to change.
> 2) another two exist in nf_conntrack_dccp_packet() which should be the
> same as nf_conntrack_tcp_packet() handles.
>=20
> The patch goes like this:
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c
> b/net/netfilter/nf_conntrack_proto_dccp.c
> index e2db1f4ec2df..ebc4f733bb2e 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
> struct sk_buff *skb,
>=20
>         dh =3D skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>=20
>         if (dccp_error(dh, skb, dataoff, state))
>                 return -NF_ACCEPT;
> @@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
> struct sk_buff *skb,
>         /* pull again, including possible 48 bit sequences and subtype =
header */
>         dh =3D dccp_header_pointer(skb, dataoff, dh, &_dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>=20
>         type =3D dh->dccph_type;
>         if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
>=20
> >
> > > My only purpose is not to let the TCP layer sending strange RST to =
the
> > > right flow.
> >
> > AFAIU tcp layer is correct, no?  Out of the blue packet to some liste=
ner
> > socket?
>=20
> Allow me to finish the full sentence: my only purpose is not to let
> the TCP layer send strange RST to the _established_ socket due to
> receiving strange out-of-window skbs.

I don't understand why do you want to modify conntrack at all: conntrack=20
itself does not send RST packets. And the TCP layer don't send RST packet=
s=20
to out of window ones either.

The only possibility I see for such packets is an iptables/nftables rule=20
which rejects packets classified as INVALID by conntrack.

As Florian suggested, why don't you change that rule?

The conntrack states are not fine-grained to express different TCP states=
=20
which covered with INVALID. It was never a good idea to reject INVALID=20
packets or let them through (leaking internal addresses).

Best regards,
Jozsef

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
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *c=
t,
> >         case NFCT_TCP_IGNORE:
> >                 spin_unlock_bh(&ct->lock);
> >                 return NF_ACCEPT;
> > -       case NFCT_TCP_INVALID:
> > +       case NFCT_TCP_INVALID: {
> > +               verdict =3D -NF_ACCEPT;
> > +               if (ct->status & IPS_NAT_MASK)
> > +                       res =3D NF_DROP; /* skb would miss nat transf=
ormation */
>=20
> Above line, I guess, should be 'verdict =3D NF_DROP'? Then this skb
> would be dropped in nf_hook_slow() eventually and would not be passed
> to the TCP layer.
>=20
> >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> >                 spin_unlock_bh(&ct->lock);
> > -               return -NF_ACCEPT;
> > +               return verdict;
> > +       }
> >         case NFCT_TCP_ACCEPT:
> >                 break;
> >         }
>=20
> Great! I think your draft patch makes sense really, which takes NAT
> into consideration.
>=20
> >
> > But I don't really see the advantage compared to doing drop decision =
in
> > iptables/nftables ruleset.
>=20
> From our views, especially to kernel developers, you're right: we
> could easily turn on that knob or add a drop policy to prevent it
> happening. Actually I did this in production to prevent such a case.
> It surely works.
>=20
> But from the views of normal users and those who do not understand how
> it works in the kernel, it looks strange: people may ask why we get
> some unknown RSTs in flight?
>
> > I also have a hunch that someone will eventually complain about this
> > change in behavior.
>=20
> Well, I still think the patch you suggested is proper and don't know
> why people could complain about it.
>=20
> Thanks for your patience :)
>=20
> Thanks,
> Jason
>=20

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-266227853-1709825675=:817479--
