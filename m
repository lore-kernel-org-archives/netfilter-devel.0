Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAAA1FCD1F
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752788518; cv=none; b=UgBnRQDpwSEElbD+xORVDC8cpOoEuF+c9XkRJ/UD7Nl0b9Fh/eTOtmP6ftjbGamiujrakAEzU2ftz6wYMa47YjLTFGaiq7MSbBpoL4ay/i69si+EogMn3YqJZQOIfUQRCnjNg10mCM4aXYbXgT7d1cKXycXLvZVyhJ1SyW+5cs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752788518; c=relaxed/simple;
	bh=dYT4onUuR63vQ1U/FPLFwrXmlwNIiAFoiKf8LhM8HKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SAXK/ouEtGJvGvLC1kSVbfe60MGaF1OqdS2k2d5TSUcvA1Vm5s529s5SK7sM7wAWIinX3PeqV1jYSvmNnXfz5DUAYg6jbDvQTqM/7B8hKmyfPLbWQstIybdwJ7OGTwr7K9jWrq3DxLQOJSRMmP6e6AtKX+Gdgv9QJU/hmVWEuQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ol/dfOSG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ol/dfOSG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-234f17910d8so13524425ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 14:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752788515; x=1753393315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1RVsAatRchXPNwv1tD3AMQfnAtyWtrmL8imZzj0jaU=;
        b=Ol/dfOSGhtfMsli4NMhZZNhGwqsQgXOlZYBOXOrNMV1/AF25JHkq5uHIZ53T8neGdg
         Tf8ZjJpZtQ7oqJuTinXPPn6JTKgRkxRZdGnWlvRAVkBaGtAZEffWZcm4HRjZYRK/u2XH
         4AtTLcfe5JeBQDk7U64zDHCYxnjc+BZqdagV+UC0NvfKTXswo2Y3nWy6wnXmVQyE2D0K
         XQaWR1qvM2FeYl4TEgoDVXKTM59sCfWxmauurUzFUDBYYMllMvd7JzgOkF68v7rNw+2w
         nAUmYNS/fj2wzLzEldwl6M48904GxVwmrKOnmFrnRwNssWSi8igHeeclvpzhKI9sw24Z
         Lyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752788515; x=1753393315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1RVsAatRchXPNwv1tD3AMQfnAtyWtrmL8imZzj0jaU=;
        b=qzGZT+2d5buvOkaGB5fkdeIdIQZZEdb8JmrtDpQ3K1CvNaUOvV+G30EHkO8PQfgwmX
         nN3V1QeSJy/YK5g5GqtbZY9uJ4xB+CqOvjQtxPg9lbMTai0pjZZIZqO07qCny9KvPv7B
         M3teb4eCXMyF8hyMfg11aeKrCb4/fl0QFiDwB3jKnjv0uX3WYDN5a0Q25E8HkCsxTHNg
         mp4wG8AsJQaTgMSQI+m8DSa46/jfUkcsFgSV+f73Oow86wcRtb/L2razkV3bm6DaeHd7
         y9x78qAMn7p4ZdEkc4qGYA9glXyVf6NLPfYIL4Os056x8ght98gJNpjxeDw4chY5XBtz
         T0bg==
X-Forwarded-Encrypted: i=1; AJvYcCVuIWeLpwDn/epgenkK36mebV9LDrzG0t5So6KP27yPfp095jVkeZVKnxW4Kntw2tlKq4KBi5TH6OmcMY5lPSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFa9R9FkPC0XCZzTk35DxNF2SRbxQe/sBYYfhBxmbTaouYE0TL
	0jhN8jSYBMNxJw9NUZIGvhxX4nyvT0A5WMg0QCoz/93rRlJRs7ccoawa/jNipFN/qV5A+O9ggh0
	GciqYK7A3nTui5EBbRAqnU1UI3CwLlZ2hOwIqpHC0
X-Gm-Gg: ASbGncumEO6EecXB3PLpqFkCjv4Qpv8yE/rt6J1GiN/JSVBK2B3mFiYl0PeRbQF93rp
	9jNtjoYtCTW03i0PPoOEO4KPokU6nHGHpmX8ndqJQTvElHECYZ7Y/FWmFbLKrx/44b3RJuNnyP2
	YA7F7BqtmIlPffdIyOvPjxbWam5xpe86gJsyY4Wmt2EjKf482PdzYMovNX5hKEqjt/xq3nM8/2N
	8BKVUVSABPPVFTIgX+ZN9nfNmInris54yQXDEla
X-Google-Smtp-Source: AGHT+IFJ+VcxLXyyUjZfKsbth9zKtPrAaTF5y1GZg9JU7qJ47TLHsTGnbyEHLd9uXo6XsFb8DAiXJk5JvRikRWhYvT8=
X-Received: by 2002:a17:90b:5708:b0:313:2adc:b4c4 with SMTP id
 98e67ed59e1d1-31cc25e6754mr654793a91.24.1752788514570; Thu, 17 Jul 2025
 14:41:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717185837.1073456-1-kuniyu@google.com> <CAADnVQJdn5ERUBfmTHAdfmn0dLozcY6FHsHodNnvfOA40GZYWg@mail.gmail.com>
 <aHlqiEaG43iqUsOX@strlen.de>
In-Reply-To: <aHlqiEaG43iqUsOX@strlen.de>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 17 Jul 2025 14:41:42 -0700
X-Gm-Features: Ac12FXwOVNDpIK0boXx9z2Ddijuq6YU-aaoMI6hEk48L6rjvoQhda96DcILS6DE
Message-ID: <CAAVpQUD=_-rsQcva7EkkV6oqOuah+n17NZq3r05yeiE1z9N=Lw@mail.gmail.com>
Subject: Re: [PATCH v1 bpf] bpf: Disable migration in nf_hook_run_bpf().
To: Florian Westphal <fw@strlen.de>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, netfilter-devel <netfilter-devel@vger.kernel.org>, 
	syzbot+40f772d37250b6d10efc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 2:26=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > Let's call migrate_disable() before calling bpf_prog_run() in
> > > nf_hook_run_bpf().
>
> Or use bpf_prog_run_pin_on_cpu() which wraps bpf_prog_run().

Thanks, this is cleaner.

>
> > > Fixes: 91721c2d02d3 ("netfilter: bpf: Support BPF_F_NETFILTER_IP_DEFR=
AG in netfilter link")
> >
> > Fixes tag looks wrong.
> > I don't think it's Daniel's defrag series.
> > No idea why syzbot bisected it to this commit.
>
> Didn't check but I'd wager the bpf prog attach is rejected due to an
> unsupported flag before this commit.  Looks like correct tag is
>
> Fixes: fd9c663b9ad6 ("bpf: minimal support for programs hooked into netfi=
lter framework")

Sorry, I should've checked closely.  This tag looks correct.


>
> I don't see anything that implicitly disables preemption and even 6.4 has
> the cant_migrate() call there.
>
> > > +       unsigned int ret;
> > >
> > > -       return bpf_prog_run(prog, &ctx);
> > > +       migrate_disable();
> > > +       ret =3D bpf_prog_run(prog, &ctx);
> > > +       migrate_enable();
> >
> > The fix looks correct, but we need to root cause it better.
> > Why did it start now ?
>
> I guess most people don't have preemptible rcu enabled.

I have no idea why syzbot found it now, at least it has
supported the netfilter prog since 2023 too.

commit d966708639b67fe767995dfab47bf4296201993f
Author: Paul Chaignon <paul.chaignon@gmail.com>
Date:   Wed Sep 6 13:38:44 2023

    sys/linux: cover BPF links for BPF netfilter programs
