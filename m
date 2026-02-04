Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7158C2C21F2
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 02:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770172329; cv=pass; b=ZFofogxBqwRpgqM8qlKT77tnx41jlNVvI4qBVXn34AfQdDp1u6Brh3krRzLUO2a4Axv0sp8hROMg5leuBZnBmlySXdaGJMpnaSh8BXWlxs3uZtE+Dgq1fqWsuxZHTvo+CRTdRinMRqjoUauhNnksiVR7GXrWd1LFhApONpa/pp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770172329; c=relaxed/simple;
	bh=AEXY2ZozylvPlcmUxZcRERRjpaPjiU3Q0qvMx4BNRVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i1ucgYxz6SAyvod8CZv+mBWfT1imbE8arakMW3Q4nQQIUgrlRD/6IUTw1F7RWVHExp7VctYO3kImOyg4NtkGapMdPnWDreXTuZ62R6dwxXQiu8IC0OqnfEPc6/+hGnUE4c0PUAbj1103fPTeKVyqpD5s3XlogTgQC+6c5rW3vgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWDOn9b9; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWDOn9b9"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-649b1ca87ddso3896528d50.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 18:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770172326; cv=none;
        d=google.com; s=arc-20240605;
        b=KDbTgzcQK05Thwj5kFQCNGVD6RYQ6jRzHBuebPAlu/wJPZs2cxqVRVftpLsPW5WXjv
         0q+XikHNpJMoGaq0W2dwYIopaTkAALGfOEnc4z/TVYXgV9CV09aZkJK/HN5Z4I0iMn6W
         FmtkVtl505GitOjthKWtnB8JeyTtIotIPHsJ1NBK5BvJAzfMTMsRL33zfbvBHU+6V5il
         nVm5CZzqIaYAHS2sGGXpNvClomJtQAWhfICr761cRT+esttcxhs7z5zmiq5jJmbnA8xw
         07XnFCXt75iRsHa8wype9onG2C52/eZkGsswSTNlf4xFWbBdayhe0RDTYw/NZY4UUcX5
         0Wyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bIjyPXX1IIp15cL3fUQqHYHhSaht5nuIKZ8C06CfsMY=;
        fh=gzQJGbyL5ge7bwSjyOc1u8wij3DQnUQa0IwLjxqzG2c=;
        b=RxU6JZwK8TGz7dlxVFrmCr9QBdCqhevZ9RmcONguAqBeeBnP8bsy7LDeAAPkDKs/3S
         z6fFcY5JCCsdKYvpYveg0cMn5dsrlrh63FJ3eoWo/h4esfMXhJ/9aSiqqEfWWi4rBGaQ
         TUYzYiNIaFUzdjcBS7ULDEmsr01v7BAxt1KffyHDcX6ewgDxWX4nEXn2pCdHnTBglXj1
         roOVkTt8CLuZLTGVZnIfALSJKjcoG77s/9tps5VeKp1TVkUg8NZkfXW6oma71Hpr7oVq
         nAgEz3sHXIWoBsgEfV5h9YuHesI7ZUcJvQv1XC/efN4a0yxELkIruPfkMn+xWVKymt2s
         Hprg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770172326; x=1770777126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bIjyPXX1IIp15cL3fUQqHYHhSaht5nuIKZ8C06CfsMY=;
        b=MWDOn9b9q6fCDH/FZaGfi3ICMQ1a4Ndkk0/KAjNFvtGXNauDYEY8XqnVO87n2FXOL/
         BrAHNucUJhZHjowerRhOMAi+PY2at8eyHrmgHAr2rjwB0ch3fC/JS8Cy3OcCIGYbsK8D
         OBFEYSOBxTZW2uHaB535GHs2W7q3/2Z/kCBZA22Fdb09terYyRJTfSqdOgziq+S1u19s
         eNK+PXwgiLNS0Q7Fzpfzm6KD8itVo+xMSvfZUw2QovQIuD9gIFk17USmLthEOwrsqdYG
         C6uoTE9MjiVgI9Euwz2SloVuGDjtF822x8b2FTGarBDhpFNyYl2c0T6HKOCle/jLgFjo
         YEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770172326; x=1770777126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bIjyPXX1IIp15cL3fUQqHYHhSaht5nuIKZ8C06CfsMY=;
        b=Bp33GQNIw8NILArFGKILThkiy2+NlKFpBggk3ietm7yRFxc0yGm6jFHcAUumyDAT7v
         p4chJOEmuJazp5mhh9vHCsbh3A4SeJzTpW51aBRla5ESH4SiD9eBvv7cuJHjMHx1WCOd
         uzuHRtIYDV9af/YmXkibv+tBNhtLO3Xw36V3mYSg6FYmEw5tT3yqnGpkOb80Zi4PCAuu
         vCs0QJkfdcB/Sy9fOS51O9xZ92FMOLnRpIj3cyiWEs2YsSKa4H4wiTeg/tsAAwfpPgpK
         8M8FuEL3F9JubS20toS57Y4busTrlwHuRkRPF+c/ux9g7uPdxou9Zg4eD8PuSzK4rd71
         r+6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlly8+mfcEbQSwvMbgS06zNbUO4H2T1mU4lptFcUgUnvjQy2bCKzMFQbZWuvuqYsZJ7LcRXC374n+hbf2wPrw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9tJNjzo6IfDiUgA8zVOMz/Y/f1c19+z3cXh3+5dyeBbnOwAHb
	nyzw2S8mP3t+xvJrEjGUjIlUAe4lBffdSAQGOtqFHezfrQN7G1VOc9/iaRUWWayOlZfvRI0woYS
	Ahg0tZSJUyO3W6qQZk5NL4uGPotWflgo=
X-Gm-Gg: AZuq6aJG7h+mskFXdeT+xEdrcy5JmfUMzijwRzlvz2BASTVVR6ANcheNtPbi6EiK+hM
	GQWrL/Hc2LDWhjlnq1XZgg7vbaLtBbvoYaaeLCfQshRuY4t7wBGbYRYoEg7lbGA3hclBEMzDlET
	QquCN4m7l3pwH7bacVaVOVIbd6NEu704662DzyrN/0VY/MkvdjrjiHilxS+fFK0oFNYSlaxWHw7
	C+nyXKeXRquoqiGQhG1+n0ypmVesPYbuQwKHQsLggJsgNl8xlQtlECGycIlQDFN7wzPVg==
X-Received: by 2002:a05:690e:d49:b0:644:ca2b:b659 with SMTP id
 956f58d0204a3-649db49ed41mr1329604d50.64.1770172325964; Tue, 03 Feb 2026
 18:32:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com> <aYIOXk55_DRFKCqo@strlen.de>
 <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com>
 <aYIpcHBufnxrcv5O@strlen.de> <CABFUUZELXbEKyjMxOBfoL246dmtBSS_oe0zeWwnkmrXXpyv3Yg@mail.gmail.com>
In-Reply-To: <CABFUUZELXbEKyjMxOBfoL246dmtBSS_oe0zeWwnkmrXXpyv3Yg@mail.gmail.com>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Wed, 4 Feb 2026 10:31:55 +0800
X-Gm-Features: AZwV_Qj16-gQnWy1oA1jIq5usmdDABqO_QGkIrnjFEl_tMb1KtPYhDutKkh28Vo
Message-ID: <CABFUUZFgXooeCgKGypByzePBsHpcPWqnY-Ea0qv4Vd7=yMOk+A@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

One quick clarification to my previous email regarding the change at line 1=
01.

While line 101 itself doesn't trigger a Sparse warning, using
typeof(nf_nat_amanda_hook)
causes the local variable to inherit the __rcu attribute. This
"attribute inheritance"
is what leads to the "different address spaces" error during
assignment at line 158
when using rcu_dereference().

To keep the code concise while stripping the RCU attribute, I'll use
the typeof(*hook) * pattern
as discussed. I am currently preparing the v4 patch series which will
apply this refined fix to all
affected helpers (amanda, ftp, irc, snmp, and tftp) to clean up these
Sparse warnings across
the subsystem.

Sorry for the confusion in the earlier thread.

Regards,

Sun

On Wed, Feb 4, 2026 at 9:56=E2=80=AFAM sun jian <sun.jian.kdev@gmail.com> w=
rote:
>
> On Wed, Feb 4, 2026 at 12:59=E2=80=AFAM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > sun jian <sun.jian.kdev@gmail.com> wrote:
> > > > Sun Jian <sun.jian.kdev@gmail.com> wrote:
> > > > >  enum amanda_strings {
> > > > > @@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
> > > > >       u_int16_t len;
> > > > >       __be16 port;
> > > > >       int ret =3D NF_ACCEPT;
> > > > > -     typeof(nf_nat_amanda_hook) nf_nat_amanda;
> > > > > +     unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
> > > > > +                                   enum ip_conntrack_info ctinfo=
,
> > > > > +                                   unsigned int protoff,
> > > > > +                                   unsigned int matchoff,
> > > > > +                                   unsigned int matchlen,
> > > > > +                                   struct nf_conntrack_expect *e=
xp);
> > > >
> > > > Why is that needed?
> > > Correct. Manual declaration is indeed verbose.
> > >
> > > The reason I used it was that typeof(nf_nat_amanda_hook) carries over
> > > the __rcu attribute to the local variable, which triggers a Sparse
> > > warning when assigning the result of rcu_dereference().
> >
> > sparse doesn't generate such a warning for me.
>
> I re-verified this with GCC 13.3.0 and Sparse v0.6.4-73-gfbdde312.
> Even without LLVM=3D1, Sparse still reports the "different address spaces=
"
> error for amanda on my machine:
>
> net/netfilter/nf_conntrack_amanda.c:158:33: error: incompatible types
> in comparison expression (different address spaces):
> net/netfilter/nf_conntrack_amanda.c:158:33: unsigned int ( [noderef]
> __rcu * )( ... ) net/netfilter/nf_conntrack_amanda.c:158:33: unsigned
> int ( * )( ... )
>
> It seems newer Sparse versions are more strict about RCU attributes on
> function pointers.
> To avoid manual declaration while stripping the __rcu attribute, I
> will switch to:
> typeof(*nf_nat_amanda_hook) *nf_nat_amanda;
>
> >
> > Also, this pattern you are changing here isn't specific to amanda, it
> > exists elsewhere as well:
> >
> > net/netfilter/nf_conntrack_snmp.c:42:23: error: incompatible types in c=
omparison expression (different address spaces):
> > net/netfilter/nf_conntrack_tftp.c:78:31: error: incompatible types in c=
omparison expression (different address spaces):
> > net/netfilter/nf_conntrack_irc.c:242:38: error: incompatible types in c=
omparison expression (different address spaces):
> > net/netfilter/nf_conntrack_ftp.c:521:22: error: incompatible types in c=
omparison expression (different address spaces):
> >
> > so why only fix this annotation for amanda?
> Ack, I will prepare a V4 patch series to fix it for  amanda, snmp,
> tftp, irc, and ftp together.
>
> Regards,
>
> Sun
