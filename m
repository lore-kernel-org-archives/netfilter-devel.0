Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D8439FEE
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 12:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707742367; cv=none; b=oPQdmuXUIcJ2W9UpOOvVwF3sXY0zLyRElJT3KoZSMrXkGvnswbfWNIL8wlI/p3NCICxFNp2eV3w+6QByBDDVAQc/0wkhqVNwLTJANIWO+lPm8+dF8lRO/NOoHNJ+7dMzM3rhbzqRIA3CK9nFkSpbUp8jicXsCJwapFd/ryWM3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707742367; c=relaxed/simple;
	bh=KBzSCkKk/epxIuMl89doBzrWCERGPHtUR4vRSgZPJ5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xg7ixKFi9hSA4ggODMKnxchKoNdpcRdpzRv/et7ln1xaV/llkSyxlTv5Zdx9on8MkBfryldLgOE4mHoZRBd5O2Wps1VUDnEsY2P4FK7OOUmkujrw48acdV/P0pty9xm412Yu3nZxliEzCDTijF+58t/dorYUclMXX3qAShHHA7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=TAHK/hjB; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="TAHK/hjB"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-60779014458so506647b3.0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 04:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1707742364; x=1708347164; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT77QK2K/eolSrbqrzyryE5LotziozXah5SZs614Cis=;
        b=TAHK/hjBXyHB30/9CZr/IwcCZa/pMlTHnorj+qtA6aA2TiKjGaf3KjHY2GGFXD0ROW
         E6AeU2YLyJoOmJRWwQNjDNOqw0cdTVdcoe3oK5Y7Ccu5JydfOQQI+zAVsOKePX03nsF9
         4Q2PZW5AICjelEnirxwSq2IABntA/08DI/vUZf2xNjDBTqCJLm915tA9bsRJeRLTtXgh
         go2RDSrWpEHYNanwwnaJPJ//x1iKy/BhXfwisb0MUCyGs47RFEorS4aeTMlu/KS8IzTQ
         6q8JM4luf42L9fVnqXDi5ckPHtate23AMkwmRunkgw6XaFDucNATTQCx0DLByC1gSeMZ
         Hq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707742364; x=1708347164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OT77QK2K/eolSrbqrzyryE5LotziozXah5SZs614Cis=;
        b=SZUM9OFAZve+Mo33szcA5xad0jOuBsnKFgHxcgLDdi5ib+DyGpmoJTQdLngq7xd4XZ
         AMu7EkIVhDdb2n9TOw9HDTbLVpJoIqLUC3MsQ/lNyyJb2/0SmeEcRw6izIF3pdph5V2g
         4cefJqwwLJTteTdahcZqkU+jAcQYTy3AzFVKt7bkxDPpFNPVCe+/EpKKFvF/O6TKmuAD
         FpTaTkpD9ClHWG7izcJ2RXkIdti1hjO4s9tXSE7z8r5JWq2G+uAoRn1jorzL+hBiZpfh
         YnewJXQVMs0WM73V6cndIqYGX7pzXgVbVy36sURMMURFIQ4KXeWXT7vyyb/6ZgfUY/Tf
         fQrw==
X-Forwarded-Encrypted: i=1; AJvYcCWtMQehSB7CYeDse/kZuD3zXt8R4z0Z5wVtq45amXU7O3ecCPIidnrM1+c6s1qFBEo+vf09NBBvn2CfVscNVctUWe6vX0da3klpFiGkECHO
X-Gm-Message-State: AOJu0YwdRePl+FstnTjYmsT15tKirF/Lzd8G0YxKnTkXn+xaKmlN39mF
	z8Yfb9RSnAQsUUu85ggECaOVnjbc6UhjBK2VzSLeZVgpkqjOBP25C1vZ3mbYgQzBvJu924ugKx2
	DFgMc/orC4iomNwYqFpdX6pJZl2E3rfrZSwfNTQ==
X-Google-Smtp-Source: AGHT+IHt3rirpVHqNH61MUs8kyqfWibULOJp6qRJ6sDEpAAl5mw9x6wLRm9y7Gh+L22G714nImtPDmBldNS2cFf3aVA=
X-Received: by 2002:a25:74cb:0:b0:dc6:9c7d:c844 with SMTP id
 p194-20020a2574cb000000b00dc69c7dc844mr3773516ybc.32.1707742364126; Mon, 12
 Feb 2024 04:52:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209121954.81223-1-ignat@cloudflare.com> <ZcYctDP7BTBRgY+h@calendula>
 <CALrw=nHRJ-a0k6YF=DQO7v0dLUUrJLH4v2c4v8wxA++yAzdUoQ@mail.gmail.com>
In-Reply-To: <CALrw=nHRJ-a0k6YF=DQO7v0dLUUrJLH4v2c4v8wxA++yAzdUoQ@mail.gmail.com>
From: Jordan Griege <jgriege@cloudflare.com>
Date: Mon, 12 Feb 2024 06:52:33 -0600
Message-ID: <CA+=Uk6bW5+hNgqKCxpiRRQWK8HRRbYFRXgRp-efgWHCPAUcOqA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 9:03=E2=80=AFAM Ignat Korchagin <ignat@cloudflare.co=
m> wrote:
>
> On Fri, Feb 9, 2024 at 12:38=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilte=
r.org> wrote:
> >
> > Hi,
>
> Thanks for the prompt reply
>
> > On Fri, Feb 09, 2024 at 12:19:54PM +0000, Ignat Korchagin wrote:
> > > Commit 67ee37360d41 ("netfilter: nf_tables: validate NFPROTO_* family=
") added
> > > some validation of NFPROTO_* families in nftables, but it broke our u=
se case for
> > > xt_bpf module:
> > >
> > >   * assuming we have a simple bpf program:
> > >
> > >     #include <linux/bpf.h>
> > >     #include <bpf/bpf_helpers.h>
> > >
> > >     char _license[] SEC("license") =3D "GPL";
> > >
> > >     SEC("socket")
> > >     int prog(struct __sk_buff *skb) { return BPF_OK; }
> > >
> > >   * we can compile it and pin into bpf FS:
> > >     bpftool prog load bpf.o /sys/fs/bpf/test
> > >
> > >   * now we want to create a following table
> > >
> > >     table inet firewall {
> > >         chain input {
> > >                 type filter hook prerouting priority filter; policy a=
ccept;
> > >                 bpf pinned "/sys/fs/bpf/test" drop
> >
> > This feature does not exist in the tree.
>
> Sorry - should have clarified this. We did indeed patch some userspace
> tools to support easy creation of the above table (so it is presented
> here for clarity) however we don't have any kernel-specific patches
> with respect to this and it is technically possible to craft such a
> table via raw netlink interface.
>
> In fact - I just retested it on a freshly compiled 6.6.16 vanilla
> kernel from a stable branch (with and without commit 67ee37360d41)
> with a small program that does raw netlink messages.
>
> > >         }
> > >     }
> > >
> > > All above used to work, but now we get EOPNOTSUPP, when creating the =
table.
> > >
> > > Fix this by allowing NFPROTO_INET for nft_(match/target)_validate()
> >
> > We don't support inet family for iptables.
>
> I've added Jordan Griege (Jordan, please comment) as he is likely more
> competent here than me, but appears that we used it somehow.
> For more context - we encountered this problem on 6.1 and 6.6 stable
> kernels (when commit 67ee37360d41 was backported).

I'm only so familiar with the kernel side of nftables, but I believe we are
indeed using the nftables API.  The netlink messages we send to create an x=
t_bpf
rule in an inet table use the NFNL_SUBSYS_NFTABLES type in the netlink mess=
age
header.  It's my understanding that the nftables API is capable of creating
xtables matches, thought it doesn't seem to be a goal of the nft program to
support all of them.

As Ignat said, we aren't asking for the nft program to support this case, b=
ut
it seems like a breaking change to other users of the nftables API.  Am I
missing some detail of the way that the iptables and nftables systems are
separated in the kernel?

Thanks,
Jordan
