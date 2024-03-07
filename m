Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53F5182BB;
	Thu,  7 Mar 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709838052; cv=none; b=K4ugTHDh4TTsSe35iKL2ueNGQEGJRfowKHjkjFqqOphKKc2NljD/SQ8C1qq1fuQEyWZXORKf/kXMWbmxZJx9pdTfLRujIUJzF8hKVc8bmwOCBQDwUuRsUvmPXwKgr3i8LT87a3YNrbmWZ0I2idborM41iGjG9s4dEz9cduHOwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709838052; c=relaxed/simple;
	bh=Sw/xhUqawmAQndXXJmF8zzZZUSCsFtN6uDVZUZ+0knQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BY8A0ld9XQYYTPK8ZqQkYkb3u1Y8i1n7P4F6w6blJ2H7EFKImDVhSCJYTRb9rDKUye2jn283WZpL2TTZyGR7PcaTvwu7Qh+gJLBwnWJnaC7OTJM+ryfoS6Ql/FtWBqPi0p39og+XUaDtVDzM2+L06ho4f0hWLQahnb9M0DtqqR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=PZ5CUt1f; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="PZ5CUt1f"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6432ACC02F5;
	Thu,  7 Mar 2024 20:00:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1709838044; x=1711652445; bh=MmY51qT9pk
	H6Vd2rZiFAVHqnVcBrC+abScTmvuJbeK0=; b=PZ5CUt1fwAYeMsOfSotycEhpin
	D27MZQZA7LtYwq1VjmobrX3RCfJHldZHDCMhbvVRH8U9M8VSTedAPhByUdN7OxJY
	AMkADXRv3irE4Ar/ALaZZks/XfoyWQa+JovyK+XpurSaze1bQDX0n0M12knpffuV
	0FAirAQnqGfkto11o=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu,  7 Mar 2024 20:00:44 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id AB312CC02F4;
	Thu,  7 Mar 2024 20:00:43 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 6D972343167; Thu,  7 Mar 2024 20:00:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 6B94F343166;
	Thu,  7 Mar 2024 20:00:43 +0100 (CET)
Date: Thu, 7 Mar 2024 20:00:43 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jason Xing <kerneljasonxing@gmail.com>
cc: Florian Westphal <fw@strlen.de>, edumazet@google.com, 
    Pablo Neira Ayuso <pablo@netfilter.org>, kuba@kernel.org, 
    pabeni@redhat.com, David Miller <davem@davemloft.net>, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
In-Reply-To: <CAL+tcoBwmnPO8y7zDvi3h0Y_QzKpj=fjnxiOuQYP_OBzoh=qEA@mail.gmail.com>
Message-ID: <55a00270-6750-ca72-f20c-4be84afa0c3b@blackhole.kfki.hu>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com> <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com> <20240307120054.GK4420@breakpoint.cc> <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc> <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com> <1cf0cef4-c972-9f8d-7095-66516eafb85c@blackhole.kfki.hu> <CAL+tcoBwmnPO8y7zDvi3h0Y_QzKpj=fjnxiOuQYP_OBzoh=qEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 7 Mar 2024, Jason Xing wrote:

> > > Allow me to finish the full sentence: my only purpose is not to let
> > > the TCP layer send strange RST to the _established_ socket due to
> > > receiving strange out-of-window skbs.
> >
> > I don't understand why do you want to modify conntrack at all: conntrack
> > itself does not send RST packets. And the TCP layer don't send RST packets
> > to out of window ones either.
> 
> To normal TCP flow, you're right because the TCP layer doesn't send RST 
> to out-of-window skbs.
> 
> But the DNAT policy on the server should have converted the port of 
> incoming skb from A_port to B_port as my description in this patch said.
> 
> It actually doesn't happen. The conntrack clears the skb->_nfct value 
> after returning -NF_ACCEPT in nf_conntrack_tcp_packet() and then DNAT 
> would not convert the A_port to B_port.

The packet is INVALID therefore it's not NATed. I don't think that could 
simply be changed in netfilter.

> So the TCP layer is not able to look up the correct socket (client_ip, 
> client_port, server_ip, B_port) because A_port doesn't match B_port, 
> then an RST would be sent to the client.

Yes, if you let the packet continue to traverse the stack.

> > The only possibility I see for such packets is an iptables/nftables rule
> > which rejects packets classified as INVALID by conntrack.
> >
> > As Florian suggested, why don't you change that rule?
> 
> As I said, just for the workaround method, only turning on that sysctl 
> knob can solve the issue.

Sorry, but why? If you drop the packet by a rule, then there's no need to 
use the sysctl setting and there's no unwanted RST packets.

Best regards,
Jozsef

> > The conntrack states are not fine-grained to express different TCP states
> > which covered with INVALID. It was never a good idea to reject INVALID
> > packets or let them through (leaking internal addresses).
> >
> > Best regards,
> > Jozsef
> >
> > > > > Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
> > > > > knob seems odd to me though it can workaround :S
> > > >
> > > > I don't see a better alternative, other than -p tcp -m conntrack
> > > > --ctstate INVALID -j DROP rule, if you wish for tcp stack to not see
> > > > such packets.
> > > >
> > > > > I would like to prevent sending such an RST as default behaviour.
> > > >
> > > > I don't see a way to make this work out of the box, without possible
> > > > unwanted side effects.
> > > >
> > > > MAYBE we could drop IFF we check that the conntrack entry candidate
> > > > that fails sequence validation has NAT translation applied to it, and
> > > > thus the '-NF_ACCEPT' packet won't be translated.
> > > >
> > > > Not even compile tested:
> > > >
> > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> > > >         case NFCT_TCP_IGNORE:
> > > >                 spin_unlock_bh(&ct->lock);
> > > >                 return NF_ACCEPT;
> > > > -       case NFCT_TCP_INVALID:
> > > > +       case NFCT_TCP_INVALID: {
> > > > +               verdict = -NF_ACCEPT;
> > > > +               if (ct->status & IPS_NAT_MASK)
> > > > +                       res = NF_DROP; /* skb would miss nat transformation */
> > >
> > > Above line, I guess, should be 'verdict = NF_DROP'? Then this skb
> > > would be dropped in nf_hook_slow() eventually and would not be passed
> > > to the TCP layer.
> > >
> > > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > > >                 spin_unlock_bh(&ct->lock);
> > > > -               return -NF_ACCEPT;
> > > > +               return verdict;
> > > > +       }
> > > >         case NFCT_TCP_ACCEPT:
> > > >                 break;
> > > >         }
> > >
> > > Great! I think your draft patch makes sense really, which takes NAT
> > > into consideration.
> > >
> > > >
> > > > But I don't really see the advantage compared to doing drop decision in
> > > > iptables/nftables ruleset.
> > >
> > > From our views, especially to kernel developers, you're right: we
> > > could easily turn on that knob or add a drop policy to prevent it
> > > happening. Actually I did this in production to prevent such a case.
> > > It surely works.
> > >
> > > But from the views of normal users and those who do not understand how
> > > it works in the kernel, it looks strange: people may ask why we get
> > > some unknown RSTs in flight?
> > >
> > > > I also have a hunch that someone will eventually complain about this
> > > > change in behavior.
> > >
> > > Well, I still think the patch you suggested is proper and don't know
> > > why people could complain about it.
> > >
> > > Thanks for your patience :)
> > >
> > > Thanks,
> > > Jason
> > >
> >
> > --
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
> 

-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
