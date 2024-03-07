Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2479112DDBA;
	Thu,  7 Mar 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824309; cv=none; b=TQfCBoZtILyBlm4xk79aI1hrQ77Hp4d1BSuMUayDZo5kDRf5IPu9TfpzyOov1ujJM08tlI9o8r0G8lEBXZ5TXceAwlBBHnxgs2Gziak59zvpkLjw5qCwS6kRqwOUd2HvmZBmrYuCAXk5ovTFSj2q0hS1H4ZOT3eBNvp0B7ujH3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824309; c=relaxed/simple;
	bh=/jHvJYtv7vNkrPtTuZEtvpS9K5s7T5AM3JrNgTNncVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rcGdgibt+MqteEswN7G4zTmk34Zl0zJH6Bd516e5ZRLbgT7r/vSmxzi/gToEZzMA64gKsLaqa1ed7M8HDXCSU0hHKSlYq9Pc2OXxu6nKPQZPhBdhI8Z+WhJhaEOTLnYH3MevfT8zNLhhNwQU+HThYyKxra5DjfgPeY6Py1ZaPAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/7cIgNT; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/7cIgNT"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a2f22bfb4e6so166135766b.0;
        Thu, 07 Mar 2024 07:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709824305; x=1710429105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFJi3jo0LgevKIzk0+N4RWGbEKZ+VBjlFB4Rpe2um1Y=;
        b=g/7cIgNTPjEiQYN2jWk9UFslSTUFiF9mTEDFqQyDyckvW0pRgK5p1j6SgMhzEFY/Wb
         03/6TS1ji8915XBcGlt6tfPe01rz6KAfqhF7Ek6Rj4GsUAupdISVumojZy30nqfL5dm8
         FAKX3FH9bmrIFuqIwYLXSZtujT84VFbXZP12xiyIQ/lmZ2daTFrglzCXSRD0M1YwySED
         xdrWIwojLkI6D9uaEofuB7Gne+66SOHLNY1cduTPCA8c1UVbEwnQMzEnAweMnJw15Qsu
         1YtXBhCIZidTKMilGkDSBbBhMfpSoceoEtIeEUo5f4+ITdab928Yk21uDyE7tWTazhoz
         v1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709824305; x=1710429105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HFJi3jo0LgevKIzk0+N4RWGbEKZ+VBjlFB4Rpe2um1Y=;
        b=sGCZDCRFIHNRKCzEASXvaNag0bWYO42MlmQGi00YEzi4kkxgIsEPrkPd6kUiu8oHuR
         t9PU7OmgeE6FtW1NgEh4TwsywGxRPH96PgrPXyjsXggKtbHTJi7/FNuW+41nVtKS2FJa
         MJLQqwn6/e/2LwoUiXTV/gNv8G5oTHUXhwEHqSLn5QxWDr1CKSaNXbIqtN6/eyX+cN86
         RQtXbEIS8BwzfSDUceyR/MbtAHrXPEXrMoFMBLly2lvMNwauYUZvdhOyL8/9bKuqhAhI
         lweoHsIElrJpQGsjcyNSa8EcnT/fqhmo17KakbAtFFG00klwUTv3UFXolqVIxCpwg76J
         gW6w==
X-Forwarded-Encrypted: i=1; AJvYcCXGWqLw/vxdu+FfdVwHnDARsbd5tBeKCm63dpiULrvu7kuAGZ5NnwKGX+a0Ka4VyXBYmNnH6lP5JU7zwARizAIlU/gFpgmd+k4uiQaDOPF6mqiIsYvx0jxj7hna56Z2PTpM4Sv6ZYwD
X-Gm-Message-State: AOJu0YziJ3bbm76NRDIFnuJeW+0jV+r3Ylw8q/KLUAQLv6ub3MQ9+y5Z
	wrAZ5G2x5iz/PYpylm8n6ILKx2FzqTEFH6ygC847ZZ8YH9t6XlDOkvoYlHE6SwmL8WbPbQDfAkm
	Edw1MSQsPgcqV/jIRE9NGv8VN4c4NoXn1thJOPA==
X-Google-Smtp-Source: AGHT+IF7xUPTaqMWaCtoYEur0e4am8/rq8nUIvaHyTSFhNhujhIe+4bfxOINdjjJdij4uSn1K0q+IYWpT5FWcaLY7Y8=
X-Received: by 2002:a17:906:3c13:b0:a44:2563:c5dd with SMTP id
 h19-20020a1709063c1300b00a442563c5ddmr12116103ejg.45.1709824305124; Thu, 07
 Mar 2024 07:11:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc> <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc>
In-Reply-To: <20240307141025.GL4420@breakpoint.cc>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 7 Mar 2024 23:11:07 +0800
Message-ID: <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 10:10=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Jason Xing <kerneljasonxing@gmail.com> wrote:
> > On Thu, Mar 7, 2024 at 8:00=E2=80=AFPM Florian Westphal <fw@strlen.de> =
wrote:
> > >
> > > Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > > This change disables most of the tcp_in_window() test, this will
> > > > > pretend everything is fine even though tcp_in_window says otherwi=
se.
> > > >
> > > > Thanks for the information. It does make sense.
> > > >
> > > > What I've done is quite similar to nf_conntrack_tcp_be_liberal sysc=
tl
> > > > knob which you also pointed out. It also pretends to ignore those
> > > > out-of-window skbs.
> > > >
> > > > >
> > > > > You could:
> > > > >  - drop invalid tcp packets in input hook
> > > >
> > > > How about changing the return value only as below? Only two cases w=
ill
> > > > be handled:
> > > >
> > > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > index ae493599a3ef..c88ce4cd041e 100644
> > > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > > @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *c=
t,
> > > >         case NFCT_TCP_INVALID:
> > > >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> > > >                 spin_unlock_bh(&ct->lock);
> > > > -               return -NF_ACCEPT;
> > > > +               return -NF_DROP;
> > >
> > > Lets not do this.  conntrack should never drop packets and defer to r=
uleset
> > > whereever possible.
> >
> > Hmm, sorry, it is against my understanding.
> >
> > If we cannot return -NF_DROP, why have we already added some 'return
> > NF_DROP' in the nf_conntrack_handle_packet() function? And why does
> > this test statement exist?
>
> Sure we can drop.  But we should only do it if there is no better
> alternative.
>
> > nf_conntrack_in()
> >   -> nf_conntrack_handle_packet()
> >   -> if (ret <=3D 0) {
> >          if (ret =3D=3D -NF_DROP) NF_CT_STAT_INC_ATOMIC(state->net, dro=
p);
>
> AFAICS this only happens when we receive syn for an existing conntrack
> that is being removed already so we'd expect next syn to create a new

Sorry, I've double-checked this part and found out there is no chance
to return '-NF_DROP' for nf_conntrack_handle_packet(). It might return
'NF_DROP' (see link [1]) instead. The if-else statements seem like
dead code.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/net/netfilter/nf_conntrack_proto_tcp.c#:~:text=3D%2DNF_REPEAT%3B-,return%=
20NF_DROP%3B,-%7D%0A%09%09fallthrough%3B

> connection.  Feel free to send patches that replace drop with -accept
> where possible/where it makes sense, but I don't think the
> TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.

Oh, are you suggesting replacing NF_DROP with -NF_ACCEPT in
nf_conntrack_dccp_packet()?

There are three points where nf_conntrack_handle_packet() returns NF_DROP:
1) one (syn_sent case) exists in nf_conntrack_tcp_packet(). As you
said, it's not necessary to change.
2) another two exist in nf_conntrack_dccp_packet() which should be the
same as nf_conntrack_tcp_packet() handles.

The patch goes like this:
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c
b/net/netfilter/nf_conntrack_proto_dccp.c
index e2db1f4ec2df..ebc4f733bb2e 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
struct sk_buff *skb,

        dh =3D skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
        if (!dh)
-               return NF_DROP;
+               return -NF_ACCEPT;

        if (dccp_error(dh, skb, dataoff, state))
                return -NF_ACCEPT;
@@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct,
struct sk_buff *skb,
        /* pull again, including possible 48 bit sequences and subtype head=
er */
        dh =3D dccp_header_pointer(skb, dataoff, dh, &_dh);
        if (!dh)
-               return NF_DROP;
+               return -NF_ACCEPT;

        type =3D dh->dccph_type;
        if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))

>
> > My only purpose is not to let the TCP layer sending strange RST to the
> > right flow.
>
> AFAIU tcp layer is correct, no?  Out of the blue packet to some listener
> socket?

Allow me to finish the full sentence: my only purpose is not to let
the TCP layer send strange RST to the _established_ socket due to
receiving strange out-of-window skbs.

>
> > Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
> > knob seems odd to me though it can workaround :S
>
> I don't see a better alternative, other than -p tcp -m conntrack
> --ctstate INVALID -j DROP rule, if you wish for tcp stack to not see
> such packets.
>
> > I would like to prevent sending such an RST as default behaviour.
>
> I don't see a way to make this work out of the box, without possible
> unwanted side effects.
>
> MAYBE we could drop IFF we check that the conntrack entry candidate
> that fails sequence validation has NAT translation applied to it, and
> thus the '-NF_ACCEPT' packet won't be translated.
>
> Not even compile tested:
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_co=
nntrack_proto_tcp.c
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1256,10 +1256,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>         case NFCT_TCP_IGNORE:
>                 spin_unlock_bh(&ct->lock);
>                 return NF_ACCEPT;
> -       case NFCT_TCP_INVALID:
> +       case NFCT_TCP_INVALID: {
> +               verdict =3D -NF_ACCEPT;
> +               if (ct->status & IPS_NAT_MASK)
> +                       res =3D NF_DROP; /* skb would miss nat transforma=
tion */

Above line, I guess, should be 'verdict =3D NF_DROP'? Then this skb
would be dropped in nf_hook_slow() eventually and would not be passed
to the TCP layer.

>                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
>                 spin_unlock_bh(&ct->lock);
> -               return -NF_ACCEPT;
> +               return verdict;
> +       }
>         case NFCT_TCP_ACCEPT:
>                 break;
>         }

Great! I think your draft patch makes sense really, which takes NAT
into consideration.

>
> But I don't really see the advantage compared to doing drop decision in
> iptables/nftables ruleset.

From our views, especially to kernel developers, you're right: we
could easily turn on that knob or add a drop policy to prevent it
happening. Actually I did this in production to prevent such a case.
It surely works.

But from the views of normal users and those who do not understand how
it works in the kernel, it looks strange: people may ask why we get
some unknown RSTs in flight?

>
> I also have a hunch that someone will eventually complain about this
> change in behavior.

Well, I still think the patch you suggested is proper and don't know
why people could complain about it.

Thanks for your patience :)

Thanks,
Jason
