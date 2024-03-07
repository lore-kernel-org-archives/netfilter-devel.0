Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC0161;
	Thu,  7 Mar 2024 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709827236; cv=none; b=fn50NU21+v5q/3zvrlpwPm4uB7t+jR6IyINBTxgL0abmb5nt2Sbj+dRioanVNBedl1GpENCX+r1nsnLMwPKRXUOaLjoWdej8sewbmAapkvZqx9O9x/0G8MGRH5fsprPHQAL5yD88MWqsR21UR2lwF6lNNniD6FUO3xgrfpKAn/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709827236; c=relaxed/simple;
	bh=qe8BSrCz5XXGmf3v5WvUo+Fw8B8ga3FSQgDQWUFtz6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Smy7gL5Kd1NoFxyYWW5dwqyrr1c1+jThPQHXZwaEqYOe42m29FOw4hcG0xDAGQgjgdSPsrQnmqKRPvKmY5W4wjOvmDARCkquOx5w5d6JMz4k6E02ZuZvjsNQQwpQAB10TlsOg1JBlbayWjsYqfYLpkTXwuQilrxXD4EZDxs2So4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fz8Oyr3+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fz8Oyr3+"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a458850dbddso170586066b.0;
        Thu, 07 Mar 2024 08:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709827232; x=1710432032; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fzdZm9LzCEazFB4mtA9SWnfQKsF5JKfguLk4PVMknm4=;
        b=Fz8Oyr3+Zmf0NutvUF3dPssVJkJa8YJ2yHJtz5r/ZvT93cl4s4jGPMmpHV1Unl8M6F
         VoI/Sh6pUKAAm6QSGAJWEmp7aFTgQy0sAql42UwJ5DeVnq6hCY5X2/y9v+ogiRJU4Wz3
         svMGpPO1haVVCEWvL2JxqiwLZdwVbAKNX2+QUszsqIbjcGQzuC5oncoP5k2DUYgb+Oxr
         o7uYGjv265GXT7hxVCNQTf37368YXYfVPwEfXFN4lCHZTwxYKzo+T10eiyAxFeJfe2fe
         FezbijVxGei/fFdvDfkQCokhszrgMmtHYRhAPIBwsamLnCgWI9dQk548px4aTNtUn8c/
         g10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709827232; x=1710432032;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzdZm9LzCEazFB4mtA9SWnfQKsF5JKfguLk4PVMknm4=;
        b=kzEckLt7L2JnveUy3jE8kFd77K63uwUhOF1kS7P0+ZzvuiumgpJsRX2NARqMhGKtxs
         rkwyTTK4O6GnXyBrtEOu8zU/iuLD35T5oer+rwRL0cvvWIBD2CncH25JrFH3/p4AVtLT
         /uHBBYuLm8iplhYKTpMDZF14guaIGtWR41q29cdgS70CimWpHKwN265uKlxXkFov8gPz
         IaFZI058aqv3q9CKVNJoXZ7fmsPbhkP6Nd58oVzf4DKAkGkOKgGuutRfyRd4V/HZ7nzZ
         /pLlC54c6tdJwFJfUYjp/2shEftMkE/O86mzLA0oXNlFbT/dCN76AVx2cuiC2LCWWUPU
         NWNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlCBiMZQpqAEQDYcqTkmXiKOHvSreJQsk6iWtMAJSraGbLhKC6Z4MP4UrOb0yINVZtSw/EKMAG63SSv7urU9UsB8Hn/L/iLm7QBbO0owHFdjjJFmPSFOB/RvSf/UEOtFMg+1kf1qXr
X-Gm-Message-State: AOJu0YzsNgTu6bW0kHo8teJ8IVm4OlQVsw/blm3QRGNTP+QS5YBgC9Dk
	zeWZEtzk7ZcR2xnxRbVEUJGMGffE+GwfoYNVMk52a7fS9GoQ/kn6nHt49lUv5uF6FLbA0bQfMBw
	HPbAYd7x8aXZn5n91om9OEOU2/tA=
X-Google-Smtp-Source: AGHT+IEnCR04Td894IczOky1bILOy4CN0mJRACFz5M5xEIYh/EFx9JygT168R1nPWbzi/RpNQPB+nNZkji0sXATuz1U=
X-Received: by 2002:a17:906:2448:b0:a45:3308:560d with SMTP id
 a8-20020a170906244800b00a453308560dmr8606229ejb.71.1709827231843; Thu, 07 Mar
 2024 08:00:31 -0800 (PST)
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
 <1cf0cef4-c972-9f8d-7095-66516eafb85c@blackhole.kfki.hu>
In-Reply-To: <1cf0cef4-c972-9f8d-7095-66516eafb85c@blackhole.kfki.hu>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 7 Mar 2024 23:59:55 +0800
Message-ID: <CAL+tcoBwmnPO8y7zDvi3h0Y_QzKpj=fjnxiOuQYP_OBzoh=qEA@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com, 
	Pablo Neira Ayuso <pablo@netfilter.org>, kuba@kernel.org, pabeni@redhat.com, 
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"

[...]
> > Allow me to finish the full sentence: my only purpose is not to let
> > the TCP layer send strange RST to the _established_ socket due to
> > receiving strange out-of-window skbs.
>
> I don't understand why do you want to modify conntrack at all: conntrack
> itself does not send RST packets. And the TCP layer don't send RST packets
> to out of window ones either.

Thanks for your reply.

To normal TCP flow, you're right because the TCP layer doesn't send
RST to out-of-window skbs.

But the DNAT policy on the server should have converted the port of
incoming skb from A_port to B_port as my description in this patch
said.

It actually doesn't happen. The conntrack clears the skb->_nfct value
after returning -NF_ACCEPT in nf_conntrack_tcp_packet() and then DNAT
would not convert the A_port to B_port.

So the TCP layer is not able to look up the correct socket (client_ip,
client_port, server_ip, B_port) because A_port doesn't match B_port,
then an RST would be sent to the client.

>
> The only possibility I see for such packets is an iptables/nftables rule
> which rejects packets classified as INVALID by conntrack.
>
> As Florian suggested, why don't you change that rule?

As I said, just for the workaround method, only turning on that sysctl
knob can solve the issue.

Thanks,
Jason

>
> The conntrack states are not fine-grained to express different TCP states
> which covered with INVALID. It was never a good idea to reject INVALID
> packets or let them through (leaking internal addresses).
>
> Best regards,
> Jozsef
>
> > > > Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
> > > > knob seems odd to me though it can workaround :S
> > >
> > > I don't see a better alternative, other than -p tcp -m conntrack
> > > --ctstate INVALID -j DROP rule, if you wish for tcp stack to not see
> > > such packets.
> > >
> > > > I would like to prevent sending such an RST as default behaviour.
> > >
> > > I don't see a way to make this work out of the box, without possible
> > > unwanted side effects.
> > >
> > > MAYBE we could drop IFF we check that the conntrack entry candidate
> > > that fails sequence validation has NAT translation applied to it, and
> > > thus the '-NF_ACCEPT' packet won't be translated.
> > >
> > > Not even compile tested:
> > >
> > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> > >         case NFCT_TCP_IGNORE:
> > >                 spin_unlock_bh(&ct->lock);
> > >                 return NF_ACCEPT;
> > > -       case NFCT_TCP_INVALID:
> > > +       case NFCT_TCP_INVALID: {
> > > +               verdict = -NF_ACCEPT;
> > > +               if (ct->status & IPS_NAT_MASK)
> > > +                       res = NF_DROP; /* skb would miss nat transformation */
> >
> > Above line, I guess, should be 'verdict = NF_DROP'? Then this skb
> > would be dropped in nf_hook_slow() eventually and would not be passed
> > to the TCP layer.
> >
> > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > >                 spin_unlock_bh(&ct->lock);
> > > -               return -NF_ACCEPT;
> > > +               return verdict;
> > > +       }
> > >         case NFCT_TCP_ACCEPT:
> > >                 break;
> > >         }
> >
> > Great! I think your draft patch makes sense really, which takes NAT
> > into consideration.
> >
> > >
> > > But I don't really see the advantage compared to doing drop decision in
> > > iptables/nftables ruleset.
> >
> > From our views, especially to kernel developers, you're right: we
> > could easily turn on that knob or add a drop policy to prevent it
> > happening. Actually I did this in production to prevent such a case.
> > It surely works.
> >
> > But from the views of normal users and those who do not understand how
> > it works in the kernel, it looks strange: people may ask why we get
> > some unknown RSTs in flight?
> >
> > > I also have a hunch that someone will eventually complain about this
> > > change in behavior.
> >
> > Well, I still think the patch you suggested is proper and don't know
> > why people could complain about it.
> >
> > Thanks for your patience :)
> >
> > Thanks,
> > Jason
> >
>
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
