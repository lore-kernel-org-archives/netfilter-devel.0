Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615271CEE91
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730500646; cv=none; b=WHl8J5RowBmpJY+h94vAfHkmhKlhdP956c+fZh1TdMk4a7+pWmwnNWw9DemBwbJXW+bvwKsgEBp2yF35UonSVJfVaYWAIe9Ti6UJh3xJ4rDbOuS3Plh9zAy4TtAmJuSIrAZVTutiFQqIUoc8AmFTsyTq25il0LsbmR3h/q0x5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730500646; c=relaxed/simple;
	bh=Twtmdj7NDpS/xXlseNlVMxKnJataWmmn8o1pktkOC90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gDit9I+PWwvRBQWD9U5lEJy6TF8/5GwRmO8SG6Ety2VOZFWFrbAwJZcAbv5iCStOGk/eXXfhbJWdXbrrs90ZxN1400pa44gw9M5MIHAnioDKylaByKYUBbkXtdFIQQQKd1ItriYST4lLX/KZCFMJ+7pFxv1MoUDUGOkbO35pC6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=V8fO7bAd; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="V8fO7bAd"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-84fe06fbdc6so752332241.0
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2024 15:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1730500643; x=1731105443; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kq90Outhkb/pEXAgtoD3699SsKRnRaj47/VxEd06syE=;
        b=V8fO7bAdxWj6fho7PTK6VfZ8wGNWUIK/PvyZKcFxPhMWr3n8UmXttHLuy/TAdcCh2p
         kVZPzCllzaFJ+O2YmTUW8yu/NVKgJH5hBCfu8wui24b4ZWypVeLSUarJXbwv6TeJO0vs
         bTBOOW8iSqOVcdyzOcgcgB7m0MTptUpcHHYgF0MdI2spdFCDHqkHqljF8sVY1YZ4oz7J
         JvaHr55xFuYOn3C3P0M6gAit/Rb5BqH8/Xz6kUa7j8VCAVRXdtIH0oEgzSxOB5lZp/WI
         5E8D/uwe3NBNvxkuqJYIGeYqwKHk4/7EL3JmEOLgDFma2UxFAcCWgKzj7+MwWRW1Nna/
         eIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730500643; x=1731105443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kq90Outhkb/pEXAgtoD3699SsKRnRaj47/VxEd06syE=;
        b=tPh7bphPzhceRZG6RH2QPkuKMJ2eRAJxCgEqoaySH5Hfwo4hKMlUf3npve67n8GW9W
         p6n6sPGYbsUsAa8rZOnfRlIziyT+HfThpS0auSskMYySasbGPaU5hKh6KhxRGyTaC1wi
         +5cPis6zjXyynIBayy+wGP+Sa3On1fKwByzoIlWj3bi/VFBa3C1S8HVwlIlLannuDGQA
         UQKsI2+MoltApfI9vMoh6kR/GG05XfxEBs0L9h+5w/k5rdOc4JqOlRlTXp4JRmMJ4UXj
         aMridy5RlC4bSyNDDf38qCWBu0QHF0eBkObcCV5HcAIDeNaY0UpPmM4R6CYiV2QsmPY+
         FJMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3Ex8mujUjRgK/5CbOZ94vvaF6uWthu18DWVFpCBnaJwFULwNwg561rRKjRDKU2mR/BR2GOCCWxn/0Y/R+snE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOPxfDpOpmpLOtiHMGILamMKMQh5hE+QZZOcZ4kf9chim4n1Mx
	dxuLXM/bs6F5BoddhheiPqYzAOzfE0GA3+TkguMC3rq1mXXGmj6VhtWtLz4QC5A8WLKsu4CdceQ
	A/0sNurX/WYtJfuPuiQvufsS1yqQxH7JlaJNo
X-Google-Smtp-Source: AGHT+IFwPJyj+03UpgiNVOMK/qNUJdNAyF2+C8wVFGzvjM5Sg60Ow2ee5F3QmrHxSePyEFuAnTOSwC651NrtE9WPYxE=
X-Received: by 2002:a05:6102:ccd:b0:4a5:c297:7d5a with SMTP id
 ada2fe7eead31-4a95431688cmr9884174137.16.1730500643313; Fri, 01 Nov 2024
 15:37:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <97463c75-2edd-47e0-b081-a235891bee6e.ref@schaufler-ca.com>
 <97463c75-2edd-47e0-b081-a235891bee6e@schaufler-ca.com> <CAHC9VhTAijBwEtqi5cpdpo1MwSW4aLL+jy9ctwbU1XVcq4wEYg@mail.gmail.com>
 <CAHC9VhT89kE=wbWFG+eU8VCM2aeDXnwn0az95b7pXOtM_8EQjg@mail.gmail.com>
In-Reply-To: <CAHC9VhT89kE=wbWFG+eU8VCM2aeDXnwn0az95b7pXOtM_8EQjg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 1 Nov 2024 18:37:12 -0400
Message-ID: <CAHC9VhSojGT1zd92O9UZWun7-Y5eqsoe47V72jw-CcFL-ii0kg@mail.gmail.com>
Subject: Re: [PATCH lsm/dev] netfilter: Use correct length value in ctnetlink_secctx_size
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 6:35=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Fri, Nov 1, 2024 at 4:07=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
> > On Fri, Nov 1, 2024 at 2:43=E2=80=AFPM Casey Schaufler <casey@schaufler=
-ca.com> wrote:
> > >
> > > Use the correct value for the context length returned by
> > > security_secid_to_secctx().
> > >
> > > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > > ---
> > >  net/netfilter/nf_conntrack_netlink.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Thanks Casey, I'm going to merge this into lsm/dev-staging for
> > testing, but additional comments, reviews, etc. are always welcome.
>
> Unfortunately it looks like there is still an issue.  Running the NFS
> tests from the selinux-testsuite I hit the panic splat below ...

To be clear, this is from code in the lsm/dev-staging branch, not
lsm/dev or lsm/next so while we need to get this fixed, it isn't a "uh
oh, we broke linux-next" type of situation.

--=20
paul-moore.com
