Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608D217DFE0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729193611; cv=none; b=YEMaqhKGVMDdezBpZqJsCjo0+WyEP9JjaGC3IGTwrRv8ovG7wKOhVpyTNNWS/iT9ivKRh6XEOe23CcX27EStWraQO42/PHOi5ijFQi2/GBIbxXSNiV2GFqSEutaL6/mEi1yU1cshXSjqv85TPK3lDDLL8NI+CGPdIZ1XfIWqN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729193611; c=relaxed/simple;
	bh=YPykuqBMoGYJGme4tDpOMLGEXVLGvtgHPmv5wQkHB8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+CByoK6vyh/ngXxeiWbWy8bYfFh0MWRwQKCBRpNpefq23fgQ+lvf5vaUnQHM1D3epnoNIgZJlye/oVtXSh2di+c+N+var7m+qoKMvjEsClUwMrtZw7Ejwufzs5ComsWuvsW2kl55fRNQZkls4MOa7fmZW/k5qnpuwPKO/UuHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=aSBR9ZJ0; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="aSBR9ZJ0"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e2975432b8cso1582918276.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 12:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1729193605; x=1729798405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKg/nPc/+ukx/a7yPgUnKPP0QkFDMNNuytqTQbZzVJY=;
        b=aSBR9ZJ0W/7neo0Nc6mhtj5o+J0a1GLH4xqw1TSDFaEuQpXckThy8exJy0mleTJl4A
         2/DxGsEj1QgaFlBl7NeRboZYnTMH4Qkv0zAfEnr8FcgxQO/zvwv3DBvXrVrD81DKpOH3
         3k1y1SbLrhLsI24uAtw6RnRX4SUakIZRHKtJ5ckVpabjXFrCrJ62kx08tCZ/CL7GKLTM
         LEDNOhvuly42Vgei1ApswM+Vcufzi1KhQOtnK3sBHiqUKDtUOgNj4mWfetdgjUnx5xpz
         un/cdn2Fr+2MCKsfB/542DySTbJ3nSfnW9wgnQtJXs5GcWElgAJyiQ98RqPpg4jswLsY
         tetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729193605; x=1729798405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKg/nPc/+ukx/a7yPgUnKPP0QkFDMNNuytqTQbZzVJY=;
        b=WSfYf5poyZsHrk5WKKoMfQ6EhvB2bRow0qgKM+u2mn9MnluHqx6CyrDbxJX6cDz06M
         poxlhQ4l7orkILph0QQb5Bkpc9CEw/i7g/knBTyuEssUDblhOb4Ejpo4mbAchFQvZa5u
         j0YUWYPzkRmX9DD7mcSo2h43mPZ6KT+6Y+/IRKS0mf3Bh6HwuML7hcw/RCJi8iYKwvrM
         /jArDVCrJX9ncUi81nkiB5iVG7qLben6vP7ht4T21vcu8TNO849VXt4C/9cuRYRtTY5V
         pLus2ZEAV28Lq2wMa8m/Gt15BUjBoAgrFP5I1EyNICPAM/v0wRBRAiPeWEiWlSv/z2i2
         ODvg==
X-Forwarded-Encrypted: i=1; AJvYcCU5uQXyDM2sDDL3t6fBPe1Cs9oLdc5C4HLR/0Wrmqlu5co6RXdKHEmH3/sqjvSYvq6+x9wrJy89ow6DMJSVAGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqS2wlSt9FdFa8xRX8G7UulJLDRh/zlpBPkBrlqDPkyJZVEUyU
	o2lDOaeuM/meHah9HQgMthPKkpV7hBfGAT1amEryGRyi0XSbGesuQ4ZI8cH5kp/QpjGpqyAwIVT
	jfLSEyQqJtBWeYvCEqPil3L66nENCqnqMU+SpgX1cEFbPpsA=
X-Google-Smtp-Source: AGHT+IHqNlDwRQptEKepQlbF2NzrA/nSCVn1VxVzRtHF0swGyfbLRzfteDR6Jn0EgFt4fQ+MI6qNV15rO4NFEdU9doo=
X-Received: by 2002:a05:6902:10c6:b0:e29:485:f57c with SMTP id
 3f1490d57ef6-e2919da6c94mr19703866276.29.1729193605114; Thu, 17 Oct 2024
 12:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241016131917.17193-1-fw@strlen.de> <Zw_PY7MXqNDOWE71@calendula>
 <20241016161044.GC6576@breakpoint.cc> <ZxE6H03jhdp3gONB@calendula>
In-Reply-To: <ZxE6H03jhdp3gONB@calendula>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 17 Oct 2024 15:33:14 -0400
Message-ID: <CAHC9VhQxp4_qhuuKip7qP_Jz-ysv1RZ1o83iARCRP7Psh_dBNQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element
 transaction size
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, rgb@redhat.com, 
	audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 12:24=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> Cc'ing audit ML.

Thank you.

> On Wed, Oct 16, 2024 at 06:10:44PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > This is bad, but I do not know if we can change things to make
> > > > nft_audit NOT do that.  Hence add a new workaround patch that
> > > > inflates the length based on the number of set elements in the
> > > > container structure.
> > >
> > > It actually shows the number of entries that have been updated, right=
?
> > >
> > > Before this series, there was a 1:1 mapping between transaction and
> > > objects so it was easier to infer it from the number of transaction
> > > objects.
> >
> > Yes, but... for element add (but not create), we used to not do anythin=
g
> > (no-op), so we did not allocate a new transaction and pretend request
> > did not exist.
>
> You refer to element updates above, those used to be elided, yes. Now
> they are shown. I think that is correct.
>
> > Now we can enter update path, so we do allocate a transaction, hence,
> > audit record changes.
> >
> > What if we add an internal special-case 'flush' op in the future?
>
> You mean, if 'flush' does not get expanded to one delete transaction
> for each element. Yes, that would require to look at ->nelems as in
> this patch.
>
> > It will break, and the workaround added in this series needs to be
> > extended.
> >
> > Same for an other change that could elide a transaction request, or,
> > add expand something to multiple ones (as flush currently does).
> >
> > Its doesn't *break* audit, but it changes the output.
>
> My understanding is that audit is exposing the entries that have been
> added/updated/deleted, which is already sparse: Note that nftables
> audit works at 'table' granurality.
>
> IIRC, one of the audit maintainers mentioned it should be possible to
> add chain and set to the audit logs in the future, such change would
> necessarily change the audit logs output.

For those of us joining the conversation late, can you provide a quick
summary of what you want to change in audit and why?

--=20
paul-moore.com
