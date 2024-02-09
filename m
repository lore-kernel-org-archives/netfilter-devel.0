Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDFF36B17
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707491002; cv=none; b=ST2GUfJRTdE97Ku9u16HIWigMnJBPVTzgGcnoCCp9J7mZAU3Ut4WXBx83kQIeT9jRWJsAthbfJxwFDx2DujTFhBGNLM8saPRMXoyQ6Nz6l15+Ar3UL7V06iCVrOjgJGBtBYKe+XJPrlwHG6HvzG6RCeJxwq12W24QamgCCZtorc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707491002; c=relaxed/simple;
	bh=7piMPkpl1EhbffBZgiicoJzEbxADpM95wihdWp/M44Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LA5f816NbxrBEyZnY2ayvSFIJOzpsBQVStoKsbGmxuO7CextUXZlfkdCOeRRtX/vSyMXf2QT0YkWNdUDFVwkGFAsLSFN1gw7ceDvZjEWmJqS708/flWNfeTwPK+BVv2ro6knRamN738WJStFJkAYZYfPzPTUoY/1C2Rw9yvlVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=OQCKlevT; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="OQCKlevT"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-296e8c8d218so766178a91.3
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Feb 2024 07:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1707490999; x=1708095799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oRBjSnf0xDjOCMmRnlFM68XUs61ph5sQ3hvIMEClkk=;
        b=OQCKlevT0FMw4d9/wgc+tRJT/XQItRO+fv1xMqegP6Z4sjmtraU8wB5m/rasAYXNfX
         16DrGhszA0d/wYIse3iQjNL0Cfe28nkPXvJNc8H69vqfP2j1licmGR7fTOzMKwXWUpA/
         8Esjquyf5kpemq5O0Gq26eezsCOEfuthP3LPVvYQ/PmVl42neIcIJ/B9rUxIXbebM49X
         onV0uV+C2SSplem8a09BP5P6CtglMNHnJz5IAvXtP8wMjyB1mTfuclSVDdROVzySOLNh
         RyK7KfkwHVUX0mcCI1bfOyjfSiT+1DtHvB8FTrMI1a73G0GST7wyv2J2z+il+SXzyyUl
         uAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707490999; x=1708095799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2oRBjSnf0xDjOCMmRnlFM68XUs61ph5sQ3hvIMEClkk=;
        b=Pjq125m8tThmlvVW5dTkd/K5w1h8wAKCbxStdIFKGQHJoVi2PSSQ96ivm6+UilL2vR
         OSAWQBxHXOa7xw397zVjhKAhWMOxJDqt8QU7DhNy1im3RfAPtk8JTw9H9pgyoMRnIRnf
         QtWmWomWIQmmPnjZkkVHRLXaKHEMjsGFssl6AuDJ1RpkBmyS1eX9KxxPV5gxK1eE9rqa
         GYe2njY2rr7CrfJfm5/egaRZb5NQdAn4o9pjOuvvNQ1lF377o2zbz3Qifcplp7NU1i2O
         4ahMNHBvuOdXL3JXBOjy1lT7brIbH2XKBwPEDSZ4PpHrnnMl58qF7zBVTRQbQxlgTyt0
         0DUQ==
X-Gm-Message-State: AOJu0YypBjrExMG4cWTCwv5kgZntc+AL6CCA+rWx43Xs8VKMgsPP5LcM
	gV13wGxN7uYA6X4wzLjaGMZqPPYLcih8g3w4gDCDDptawJXgszIbtHBOmnXmP7GITT/aQHxF9wC
	SHjY6UHvtAIYvdHUmTPP6J4V8vaBngOUCyheeEaC2isNxAh7DyR8=
X-Google-Smtp-Source: AGHT+IHQwhmJ0Gr6hX6kPUaCmaknY44nC/6/pzbG67sIHfMmHpDG2j+ai3KxgU6jk4MT6dhRX4YSKIjQHeuzY3BFhJA=
X-Received: by 2002:a17:90a:4944:b0:296:44c9:4e7d with SMTP id
 c62-20020a17090a494400b0029644c94e7dmr2005115pjh.9.1707490999546; Fri, 09 Feb
 2024 07:03:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209121954.81223-1-ignat@cloudflare.com> <ZcYctDP7BTBRgY+h@calendula>
In-Reply-To: <ZcYctDP7BTBRgY+h@calendula>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 9 Feb 2024 15:03:08 +0000
Message-ID: <CALrw=nHRJ-a0k6YF=DQO7v0dLUUrJLH4v2c4v8wxA++yAzdUoQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
To: Pablo Neira Ayuso <pablo@netfilter.org>, jgriege@cloudflare.com
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 12:38=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,

Thanks for the prompt reply

> On Fri, Feb 09, 2024 at 12:19:54PM +0000, Ignat Korchagin wrote:
> > Commit 67ee37360d41 ("netfilter: nf_tables: validate NFPROTO_* family")=
 added
> > some validation of NFPROTO_* families in nftables, but it broke our use=
 case for
> > xt_bpf module:
> >
> >   * assuming we have a simple bpf program:
> >
> >     #include <linux/bpf.h>
> >     #include <bpf/bpf_helpers.h>
> >
> >     char _license[] SEC("license") =3D "GPL";
> >
> >     SEC("socket")
> >     int prog(struct __sk_buff *skb) { return BPF_OK; }
> >
> >   * we can compile it and pin into bpf FS:
> >     bpftool prog load bpf.o /sys/fs/bpf/test
> >
> >   * now we want to create a following table
> >
> >     table inet firewall {
> >         chain input {
> >                 type filter hook prerouting priority filter; policy acc=
ept;
> >                 bpf pinned "/sys/fs/bpf/test" drop
>
> This feature does not exist in the tree.

Sorry - should have clarified this. We did indeed patch some userspace
tools to support easy creation of the above table (so it is presented
here for clarity) however we don't have any kernel-specific patches
with respect to this and it is technically possible to craft such a
table via raw netlink interface.

In fact - I just retested it on a freshly compiled 6.6.16 vanilla
kernel from a stable branch (with and without commit 67ee37360d41)
with a small program that does raw netlink messages.

> >         }
> >     }
> >
> > All above used to work, but now we get EOPNOTSUPP, when creating the ta=
ble.
> >
> > Fix this by allowing NFPROTO_INET for nft_(match/target)_validate()
>
> We don't support inet family for iptables.

I've added Jordan Griege (Jordan, please comment) as he is likely more
competent here than me, but appears that we used it somehow.
For more context - we encountered this problem on 6.1 and 6.6 stable
kernels (when commit 67ee37360d41 was backported).

Ignat
