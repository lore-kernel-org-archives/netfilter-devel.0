Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C028F1
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 04:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745382183; cv=none; b=Z3KKS5bNqCYtDgIhlzTFiBt3Mk1w36sr6U8Z61EEtMutkeasiklOtQTle79di41cO56iEXBV1TwSOvvnZtb6BVYeuEueNUYmq9EBA6rDQx4FvYbPQ+KOo2lH+xQ3achmLgYq7Fz6dn4oHpsjPFe4Bz7QPMvnw8gII63ZSjyIbl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745382183; c=relaxed/simple;
	bh=Pbqx89RmPI/iaDsF595c5QCD3iLy7QL8Az4SBDjJDVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUiLNjHGpHYpjs4TPWqEVIi50QPZCLxx7la/MWw6Pp4nf6ykFlMCb3l+KuqONngy4LjxZiS1tphpN6vrBfJ2MufLc2fNjzdfLalPB4RDSF7hu9lFv7J0xuISIwmqewHN06uJzbMT1zmdQyIGuNnOvet5lVaUbW59AV8Dv7bp8Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fs8H+R7M; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fs8H+R7M"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3feaedb531dso1045020b6e.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Apr 2025 21:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745382180; x=1745986980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBwvHmMSf7akSlSgdaFOktYYbxcOH2YDvBp3ks1ViYA=;
        b=fs8H+R7MAerVfBhfNpiXB8NyELQbjDTiAOlvWyPTkniFoCWG8dfKhEfxUSl9ETzNbm
         7lG7QddlPJJAir5KMrHS96hg1056UdbXZ5X7Kgs1RwcQGI7YSZBXasOyjvbwAxqbDBBb
         PK+gSoESgsYyhoKBE7R+kSTFXccpPB6GpmZLL/riGDet9ZTpV/L05B90vyqxPpwmp1KV
         ruuJ6Ff2iobaSydsevLKnGgr49Q995VmnncxFqbe7Yj9UnYSr1YcPzdjVgLL+gVSmnXf
         hNS4PKpZO4uM7Yprn/nJrvUGOGEr7bP8GqMLP4/4/rtV/jjOTnfiKx11GyDJkJ4UpTWn
         GMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745382180; x=1745986980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBwvHmMSf7akSlSgdaFOktYYbxcOH2YDvBp3ks1ViYA=;
        b=hR5rhngAVh3yvuf5lZ+9W6DjOZ6f85HJrfARhZht/+5hRD8IFGuKtIvm5GzGXvuzvk
         Fmn5udbUoMJlYevoRyeBKFrdEp+bM9bgaSMdhWPr8AKfkJ98Nf73wpKTMjDCaVTVKx+X
         1vrP4K6wNtv08EQGl872dRE4f7cR6GMdMCDONMSB3VdY26/r1NxqMnGl32kBys/XqMGO
         It3mia4prdlDb5D34W65f5miM3HFMIRIZRNuSMIua7Z8eU5hxsf/osNcBfqNlCfl74WW
         zL9oDY7vz0zN8QfosBOROYH+iw+ZfU6uHn3tfqK9HLaFaUtealBvwRlbk+RldbIcrszh
         hYxQ==
X-Gm-Message-State: AOJu0YwpGuKvRwqtrrCk5luRFGzzXtSt7wsb0g0Rp8oAvOfbv9pn5XSw
	6NzrN8/HmcdZ44lJUbx/8heHxZJ5VaopmON4NSZvGIK0bEHiIr0+Zs/Us0N2D21LhT4gNDM33KW
	xziUEoJjJxA/D0Av4+pwmyw9r/80=
X-Gm-Gg: ASbGncuDfSnnJigchGIz4XmHvpBALST7QkIoAvzxLOmto+epXqG9dbHSPEZzWKPxt25
	6Alp0qTBsTjgBH3lfXqPv2TpgWBK8clqK157/CDSVjaPPIIsB5DlLn8+5u0ZhIroBsSSAJ17BQN
	oMo9lyM+sCHyirwdN4XNu52Q==
X-Google-Smtp-Source: AGHT+IHkEEPH2Bp48dNuGliIdp+82HrIsN/e/VgcnS7oe6MSBilgijeRkWSSCTDwslThE5yZtjM+gBAoS9kLtbHy+aA=
X-Received: by 2002:a05:6808:2f16:b0:3f6:ab66:f4a1 with SMTP id
 5614622812f47-401c0c7b855mr12229637b6e.39.1745382180293; Tue, 22 Apr 2025
 21:23:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422001643.113149-1-brady.1345@gmail.com> <20250422054410.GA25299@breakpoint.cc>
In-Reply-To: <20250422054410.GA25299@breakpoint.cc>
From: Shaun Brady <brady.1345@gmail.com>
Date: Wed, 23 Apr 2025 00:22:49 -0400
X-Gm-Features: ATxdqUFMfwbDPfeijIfvVvC8wQI6pBqrorMrm7sQVEPJEGQLr9nRuyD4o9-hpZc
Message-ID: <CAKwNus-LzHUdN91umsmm6f0PNUr1jYaSR3BSdcSvYsydk7HygA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: Implement jump limit for nft_table_validate
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the feedback!  Clarifications/questions inline.

On Tue, Apr 22, 2025 at 1:44=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Shaun Brady <brady.1345@gmail.com> wrote:
> > limit of 8192 was chosen to account for any normal use case
>
> Furthermore, the largest ruleset I have archived here (iptables-save
> kubernetes ruleset dump) has 27k jumps (many who are mutually exclusive
> and user-defined chains that are always terminal), but nf_tables_api.c
> lacks the ability to detect either of these cases).
>
> With the proposed change, the ruleset won't load anymore.

Much of my testing was omitted from the commit message.  8192 was
chosen as to what seemed significantly above normal usage; I was way
off.  What I did observe was that machines (both big and small) start
to act up around 16M.  Would it ease minds to simply increase this to
something like 4M or 8M?  This would cover the largest case you have
but keep us below the dangerous threshold.  The tunable was in the
event someone had an extreme use case we didn't think of, or if they
wanted to be extra cautious.


>
> > +EXPORT_SYMBOL(sysctl_nf_max_table_jumps);
>
> Why is this exported?

I believe I was initing at a different location that required this,
and did not back this out.  I will remove.

>
> Possible solutions to soften the impact/breakage potential:
> - make the sysctl only affect non-init-net namespaces.
> - make the sysctl only affect non-init-user-ns owned namespaces.

I may be misunderstanding how limiting control to (only) non-init-*
namespaces would help. It certainly would keep a namespace from taking
the whole system down, but it would leave the original problem of
being able to create the deadly jump configuration purely in the
init-net.  Maybe protecting from a namespace is more fruitful than an
operator making mistakes (the initial revisions intent).

>
> - Add the obseved total jump count to the table structure
> Then, when validating, do not start from 0 but from the sum
>  of the total jump count of all registered tables in the same family.
> netdev family will need to be counted unconditionally.

I had not considered one could spread the problem across multiple
tables (even if you can't jump between them).  This is a good insight,
and I will account for this.

> I think the idea is fine, but I'm not sure its going to work as-is.

Glad to hear, and I would like to try for a rev2, if my
question/clarifications make sense.

Thanks again!


SB
