Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE0812C80A;
	Thu,  7 Mar 2024 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709818431; cv=none; b=lL9IhWIlrISsHvgaK/I/pr/nC0p+qJ/fz/5pHUmMEjqI2b8VsypYf78OniEys/h1tWYbujAZIjv32EhfmrZtFpmbK9qbV74B1I6f/KBfux3ruTxLXJc0FnQuELD46J4NUmqNsY4m+k1o9ZxbtSzcCE83cCKKUEclMEWYJPcsgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709818431; c=relaxed/simple;
	bh=IwLySBNWsXMkCQ48XQ//GUrFE/11iTOEtVXEuz0hLjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okHiG6l4sQDJH0p4Pl8Sc22IfKyJSCSQIMZ3bFL6on5v/tfcpv3ehK+8VFHnGMCWjlfs2vH+2ZjFQB8x4DVDCt7Ng6ivF2M75st7n3DZrs1ab5OCJayzpnzi81sr/O2XeYkM8ugFiDESeFtGFySiYzN43Ekxa3XCjTpyUMT7l38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKi3U+vu; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKi3U+vu"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-565b434f90aso1126191a12.3;
        Thu, 07 Mar 2024 05:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709818428; x=1710423228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qql4YrjVyR2zImJwqrdWfKUU+qwMnI9JUdCdxDlxHzs=;
        b=gKi3U+vufi3vzCAWjKIUYJvUobImJCrzE7K+1g1Fz30jXMC/f06oegUhc/xOd1+1J4
         32zXZWajaiSxEr+lVZQMxR2B1bHXcyd/MOO34IEvcvF5J2F2RSRBaN+2yQ0RLG6LruF1
         IfsX5u60w3LNFOon6hGbC346D7t0OfJWG4jLhpKZEBJFncXM64LizqCDPbYvDKrfzTRt
         skLC0rqWcLqd5g3Z2nu+2ktKg+LqqBjO0ZMLVNfKdstTZG9G1GMZ35Ni4owp5itwk4Ly
         VgMbI2+JB0qwICeCmn/KtNPtsRn3E1PgOBR0Ce9nFlpv+Z13q31Juan6iP6BB3Xty3aG
         XMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709818428; x=1710423228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qql4YrjVyR2zImJwqrdWfKUU+qwMnI9JUdCdxDlxHzs=;
        b=TapE67TWPJamP6FVSPXrAqUq2UBZwxp7yKDpW/n1LCf3EOGVIiMc7kSlntGs84xSE+
         prqzSbIYcQQ+zADqzLyoyr8VSDVQeFh6i7QlfFBTF2xg0QXHkuy0nbQxfzWJ4vF9+sf2
         sCHSTWSHV7nflcgrygSjsyw2VHn5w/82aUnHKRn5ebY6GMwcnlEl9cfd1GlapIYOA8x7
         krMWi9eCeoX6B06by0e+FxMeubxDFwRsh55gM9uoZbcujyOEKGoludj/FhzpxvDKa5JB
         2AdmU11uT68wxkxrZBSwF7HN+TyJOznVKelLDk56wnqzkWGkUXjphQpUp2+IGIsm2xpQ
         T1+w==
X-Forwarded-Encrypted: i=1; AJvYcCUSSWI6MYqclU7bFtyHXGsVgE+rh27585natUhlhrlZLfi6LMGjv8L+g3n8wH8jLvUopHPpatR/3oGE0+ZDyRPXIEkzAM+8YCMI0k486sE9ftlmnY/hKplrWKqUR6r5ixLUbxJEphgw
X-Gm-Message-State: AOJu0YzN1jsIvnrwyBTCvEzb+FgPNs3hsXAPpu0UH9YO2GgBiWjlvPJy
	aF1qVga1O43jopRtolrorHPIj+7jJufckXFlpywPdq8yR1n/QrE6BgArt+VgAUiooF/5HdjO7xI
	4lt6g1eZiyxcPAXR/pbZl4HxnzQc=
X-Google-Smtp-Source: AGHT+IH/JuI+Fy9+dS09E0LZt+MQDxjnhTkFwrZ2MbaMeXyuBRXecO1C3mkePGmgpggMeoBCtg/L6grSHwh5rg080xY=
X-Received: by 2002:a17:906:b04c:b0:a44:b91e:315b with SMTP id
 bj12-20020a170906b04c00b00a44b91e315bmr12094135ejb.68.1709818428158; Thu, 07
 Mar 2024 05:33:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc>
In-Reply-To: <20240307120054.GK4420@breakpoint.cc>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Thu, 7 Mar 2024 21:33:11 +0800
Message-ID: <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 8:00=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > This change disables most of the tcp_in_window() test, this will
> > > pretend everything is fine even though tcp_in_window says otherwise.
> >
> > Thanks for the information. It does make sense.
> >
> > What I've done is quite similar to nf_conntrack_tcp_be_liberal sysctl
> > knob which you also pointed out. It also pretends to ignore those
> > out-of-window skbs.
> >
> > >
> > > You could:
> > >  - drop invalid tcp packets in input hook
> >
> > How about changing the return value only as below? Only two cases will
> > be handled:
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> > b/net/netfilter/nf_conntrack_proto_tcp.c
> > index ae493599a3ef..c88ce4cd041e 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1259,7 +1259,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
> >         case NFCT_TCP_INVALID:
> >                 nf_tcp_handle_invalid(ct, dir, index, skb, state);
> >                 spin_unlock_bh(&ct->lock);
> > -               return -NF_ACCEPT;
> > +               return -NF_DROP;
>
> Lets not do this.  conntrack should never drop packets and defer to rules=
et
> whereever possible.

Hmm, sorry, it is against my understanding.

If we cannot return -NF_DROP, why have we already added some 'return
NF_DROP' in the nf_conntrack_handle_packet() function? And why does
this test statement exist?

nf_conntrack_in()
  -> nf_conntrack_handle_packet()
  -> if (ret <=3D 0) {
         if (ret =3D=3D -NF_DROP) NF_CT_STAT_INC_ATOMIC(state->net, drop);

>
> > >  - set nf_conntrack_tcp_be_liberal=3D1
> >
> > Sure, it can workaround this case, but I would like to refuse the
> > out-of-window in netfilter or TCP layer as default instead of turning
> > on this sysctl knob. If I understand wrong, please correct me.
>
> Thats contradictory, you make a patch to always accept, then another
> patch to always drop such packets?

My only purpose is not to let the TCP layer sending strange RST to the
right flow.

Besides, resorting to turning on nf_conntrack_tcp_be_liberal sysctl
knob seems odd to me though it can workaround :S

I would like to prevent sending such an RST as default behaviour.

I wonder why we have to send RST at last due to out-of-window skbs. It
should not happen, right? As I said before, It can be set as default
without relying on some sysctl knob.

Forgive my superficial knowledge :(

>
> You can get the drop behaviour via '-m conntrack --ctstate DROP' in
> prerouting or inut hooks.
>
> You can get the 'accept + do nat processing' via
> nf_conntrack_tcp_be_liberal=3D1.

Sure. Just turning on the sysctl knob can be helpful because I've
tested it in production. After all, it roughly returns NFCT_TCP_ACCEPT
in nf_tcp_log_invalid() without considering those various
out-of-window cases.

Thanks,
Jason
