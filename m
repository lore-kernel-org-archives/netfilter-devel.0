Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA5728851C
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770170231; cv=pass; b=XI+FpWHRmSGJDggUP0kCMqW6b91de6jM37ETZ8h9U6VzSO8Kz2IV/bDY/dgIor/olwucYBP5VEyzQstU353WpRl7uP4VG1Z10ZFZmPFq0VKHPOEd+Lx228WS8aMjcFqrQThtqw0/1u7kacN8NThb1CPT9+S8sON1YcZsR1TT6pU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770170231; c=relaxed/simple;
	bh=CS6Hdnn4FB231aPDfUFWzHDPplaGR1hHA8PrYCJG8tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pouXxef0TZo7YGPbSMUPWNGhsy9t9ozkWmXhAHOtczmZd3aJ1WQ5zEPVowIBbjSXdlek6yomncBpoyRprEm6z11Q6wciO6qWnlUBAh/1/fssemPkYLtsxhNrR7jIX2d4OMzrjEaiwfnrTczLxxJxf/ghxC3c+/D8nWhc48huleM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YXXDYjZP; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXXDYjZP"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-649bd1f08acso350150d50.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 17:57:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770170229; cv=none;
        d=google.com; s=arc-20240605;
        b=Ox9NVM/hwmkIc1qVNbMwg4iL0UHC32AhWKjlbLDjqiWTeC5sMmfmOYjpj+7baqhVBE
         RQAx9BWS8o69sNj4Si16xN/Tx3jcG98DB2dbbTPld+7MN5m2rFz23apAIWwUQm69fjEI
         eyOSu72LDUup+c7JiLmTcaynDVvypIqqqT/JUj8B7qz0H/Mh8YYl15+wDqTEgKav6TL7
         IfDavUvXWP6NwRvz1Vj9qqfuwNZwJmEhQsQ42ui5TaVIoIYIP8qp1VlrmCwI36Lsa2+3
         fqZpPURBofiA42gjL+qOG5OulmAjGyBgA5xFmyDe8NkDX+2RgQBrdzcthGCLBcRpNZQT
         a5BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JxZQXId/A+aMKZYLsP/G5fTLN63HSRpBMmCY9kYwWYM=;
        fh=9/QevL5xs43wZZuvRzXQ/5xKKpqGlD/xTbkeRd7cDqg=;
        b=CR5PM56tkFrjyIvcZ1FnQFJBfoM/qoab+RVLGF+5FpTOhMEXaBAeOh6T0bh9idXfe/
         +HlBzZ5fn7vOpCCYxCDQcnsfFfQivKE6sxOQYyG4rTnJqJ4pq78P4UM8JpxG9cUB/amp
         HwOX/GfQKZLlzreQsa+C+y12iTefEJitzzgZ5R+lg/93cIbZV+ZsicpvBUvm4i8wQgSo
         xhHk2yej+FJpiQs0nNwO8ZEUzSfpDerVajezgqG7wyB4WRzcrJ02+m6Xx5dF/+lRMh01
         9hCJkzYrcmc++zs1kHYu6mezCYrSGDT4SrbHHCSHQ5mkndnJdchuRXZls5L0KwyI525T
         Dmaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770170229; x=1770775029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxZQXId/A+aMKZYLsP/G5fTLN63HSRpBMmCY9kYwWYM=;
        b=YXXDYjZPqLUyLDNo/nzfvOKrMdernxlCKDOENBggBt27s57fJPKXtcZwTaq02VL9IR
         ny3JseJQg0dgsirTTE4p67LeCmIDEopLS6FudX6pBZ6NFz742n1lp9v2L98RD2dYF94R
         CRDCBTYtCVUR83LK/P4MDCFvK3GMQmQP8Tv0cXmLfJ7zG2CttxgrwTKtMo6c8uq4kl26
         c4mNveAxsHHXsWCZ1ABRaD35zOHyJTf7+EobYIYYNGQoVEFIJVahd44LaM9xM33zoLCg
         y/SQZmQOK6ILeKTMCYq5t3NYMdPUpfUg4G4Kvq5dNhpQGUpWPLu50uHEPa5MxrZh+Bev
         CfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770170229; x=1770775029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JxZQXId/A+aMKZYLsP/G5fTLN63HSRpBMmCY9kYwWYM=;
        b=Yuz4F92rWtcarv4CdcNPfZDmiD7c4/LPfoR7rj/+YZo4h9+dSKzV5Y96rnq2C4BPA4
         C3rL+90406zRipYuKlT+4rHEOxCzvbRLdmAfj42VknX6p4wGZNzbnw2b77mZQbn30owE
         kKK8/WftPm/+a+dJWjXDV2WCPRMcdg/DdK/H6rxn09fyJmFe+tgTgv4GLJIfTv08hkSP
         /HdCacjffA3XZhlrx8YVV8PAb/9u4JzAaGfIYfVKxTnSxFkNDpE7h5fNKglPx3A+jD2a
         CWDu4gxNJ+GUEpnQj7aMz0Hae+UtGmJJ5RWZn9rvZOTA2hq74ofpi0pmoTz9ydtQzi7g
         LqeA==
X-Forwarded-Encrypted: i=1; AJvYcCUmp+46CAVyAzAME8suMwY36aR+bzYojdkS8qSbcgk6orpuOf6YoLYt9VtwkF3r94eL1erWc33zw9vXwLfDAG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ9SDPEAlkNvVnREjf0GgOOn2w1ch8Ix1HbVm2FJ8XCJYRL22p
	wbL15+7oPfoW3t564bf2U2I2OpYV9Ax1B4tY1pIHI++m9CTr1AzlpIX+rxEcjWXMzjPYdAFwg87
	LiR2uj6CbAZ2oYFAZ1D2IsXKEu0J/qrU=
X-Gm-Gg: AZuq6aJUtPx7oUL4gl+lrQHCyauCtCUgCHgVFXLXPVtk9tTbi7YUxz1JJAEp+cG1ulL
	ptV8xYTgdsthWCrZaBFEF73G3VQ6t20X5CCre/GTXUcssAmm3Agltl0aErWNkUbDbCeoRXH8tDW
	mP15Gan/yyzT8xBDibP6VSWQ64aoc6nOrpBmsOMpy90S7sZe5bLBmImOD+kO48/RW4ClOvnNqiu
	EGn6NxDbAf1n2X7GNLXgKrUIXE8b2NCYxCWlJgy1OzpPXmXUlTxnfRslkuZCe+rTGxLNA==
X-Received: by 2002:a53:ebc1:0:b0:644:4a82:304d with SMTP id
 956f58d0204a3-649db4b4750mr1206240d50.82.1770170228855; Tue, 03 Feb 2026
 17:57:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com> <aYIOXk55_DRFKCqo@strlen.de>
 <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com> <aYIpcHBufnxrcv5O@strlen.de>
In-Reply-To: <aYIpcHBufnxrcv5O@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Wed, 4 Feb 2026 09:56:59 +0800
X-Gm-Features: AZwV_Qhg067b7BCygExtNCz8lq6mAu4s4-ST68gEvIKgghXpBpcNF7HhnXs8ecM
Message-ID: <CABFUUZELXbEKyjMxOBfoL246dmtBSS_oe0zeWwnkmrXXpyv3Yg@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 12:59=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> sun jian <sun.jian.kdev@gmail.com> wrote:
> > > Sun Jian <sun.jian.kdev@gmail.com> wrote:
> > > >  enum amanda_strings {
> > > > @@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
> > > >       u_int16_t len;
> > > >       __be16 port;
> > > >       int ret =3D NF_ACCEPT;
> > > > -     typeof(nf_nat_amanda_hook) nf_nat_amanda;
> > > > +     unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
> > > > +                                   enum ip_conntrack_info ctinfo,
> > > > +                                   unsigned int protoff,
> > > > +                                   unsigned int matchoff,
> > > > +                                   unsigned int matchlen,
> > > > +                                   struct nf_conntrack_expect *exp=
);
> > >
> > > Why is that needed?
> > Correct. Manual declaration is indeed verbose.
> >
> > The reason I used it was that typeof(nf_nat_amanda_hook) carries over
> > the __rcu attribute to the local variable, which triggers a Sparse
> > warning when assigning the result of rcu_dereference().
>
> sparse doesn't generate such a warning for me.

I re-verified this with GCC 13.3.0 and Sparse v0.6.4-73-gfbdde312.
Even without LLVM=3D1, Sparse still reports the "different address spaces"
error for amanda on my machine:

net/netfilter/nf_conntrack_amanda.c:158:33: error: incompatible types
in comparison expression (different address spaces):
net/netfilter/nf_conntrack_amanda.c:158:33: unsigned int ( [noderef]
__rcu * )( ... ) net/netfilter/nf_conntrack_amanda.c:158:33: unsigned
int ( * )( ... )

It seems newer Sparse versions are more strict about RCU attributes on
function pointers.
To avoid manual declaration while stripping the __rcu attribute, I
will switch to:
typeof(*nf_nat_amanda_hook) *nf_nat_amanda;

>
> Also, this pattern you are changing here isn't specific to amanda, it
> exists elsewhere as well:
>
> net/netfilter/nf_conntrack_snmp.c:42:23: error: incompatible types in com=
parison expression (different address spaces):
> net/netfilter/nf_conntrack_tftp.c:78:31: error: incompatible types in com=
parison expression (different address spaces):
> net/netfilter/nf_conntrack_irc.c:242:38: error: incompatible types in com=
parison expression (different address spaces):
> net/netfilter/nf_conntrack_ftp.c:521:22: error: incompatible types in com=
parison expression (different address spaces):
>
> so why only fix this annotation for amanda?
Ack, I will prepare a V4 patch series to fix it for  amanda, snmp,
tftp, irc, and ftp together.

Regards,

Sun
