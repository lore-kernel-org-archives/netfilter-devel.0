Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C623FD27
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733921186; cv=none; b=pd2Y4KQvyYSHRYKwLSWAMwlYFFe4R0NOzIICVUWfiRuYnrFZ7pmKDKg8nAQwS0oULj0OJDDk1KaGp55uD215vGqaI0KFf0Zch7fOuJBaXLWf8ajPy9jR0rT5Vaz8fBmXUHeGE/eyNRSMwFzcfePpivX04ryfxi8OIqmeTbKnj+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733921186; c=relaxed/simple;
	bh=ljytafcL4yuL6A3mBTqsDzIsfHaoog36bhny0bY+VLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M1Q6qg5HNA4oi4Vt9s97d1I/Vqgx6HB7far7Vo2obKfGnSY4K5f+PjIyQurMFCbGh6BeVb7yUCMaCrPInWPJX6sxxZxKd1OYXkRgJ5Z4JpEtpuoH/TL4bHF+2wUSd6XfkuxA5ETeOX9RRYhJJ7tDtlJ3jsm/4aiLiEAONt7IJCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=jLH76Wpd; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="jLH76Wpd"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30167f4c1deso34630261fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 04:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733921183; x=1734525983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMRrLT8PBkUb9uwSo3UZOKSbeLIunajxVCGqM67QreU=;
        b=jLH76Wpd0C0oMGqzQv4/KNkLyf+MP0zmD+BLvtwo0hYDG57HDm+0OIh/SRbPkjIWDM
         Y30SOYh2eu9Rham1AE6QsuYzNVJQR4SEiBNwLWa17mDli8DFhtXcALgj+0RyKKSMdgLr
         CcsDTLiKF95tDavEA59gnrS0fjlCOU0bb2HH9iYQambCbjzWcPMvTtpaNWV2hsB7R5Av
         SNatHInKJuVN5Op7nXO10fwbDJr/GpcDRivwrIToC3qRA0cL888EFyjlNWQujClQxV31
         uTxAcuRROaE8Rt70yiwYJUz5/3jq2DT06WSwB8ShrS1wdhPqzDImkk8LpWUlGlmQZnOP
         QtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733921183; x=1734525983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMRrLT8PBkUb9uwSo3UZOKSbeLIunajxVCGqM67QreU=;
        b=ACLmUbk//ZBrapWPVlHgrcZjboS3bShhg560vl07x2d1IxFfIea7VOI/mGavTCCfyU
         rP9rtC190qCafNw2EO5kUae1FAlKsqGtE8OaU36v0rr/5CnSvVQuBfD7EcYZHvKKxdc5
         QkKccv210TQsYPqWc9jvJdGduSDY0JF6wrZNVhe03Zk2t7bqeAgMlF8aKc5v6LibmTmm
         8n5JwxC/Df1xhBROBhL5tusqelvFGbxVZvia1xAlSRQOjeBvGT2eq2/khBtlyUomiUET
         dJCTJU6nEpo/IrPVjAvPkqvETO+RVp1GO3gpfnYsF8UUniWQrCY4weQDNmZC55tEhy6d
         GGyg==
X-Forwarded-Encrypted: i=1; AJvYcCVn++8ZA7cIlYK8YsDJnYBwW8lpc4uittn0e9nV+NhF2YVOhuAmx/SX0QlcOPYLjpNQXXIq3oNk5/+8rETkUKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZvVWeFrhq+IviqxWlffuTCZC0I/wKgNVyLAoQvsYiL4ifQtQB
	a9ly5QkLD+EOfQK7YquoT9nU2xp/YR9np74vaGOjD9EFmEikAsGp89D5Vpb6+rxvP8uS92dK+MT
	yMIfk1C+3SmjjPUbq7c+aKN8k/PXQ17hVy3y3QA==
X-Gm-Gg: ASbGncvuTUFWP60zCxfz8X2cBF01pOouRZmEt5daccSuuF2svp8nrERo35rR/PnmWZj
	SQUOkYi64NMHvY2VtNNkqrUaXuXkkk0lcCI2wjiYY6xnkELMSUYeZ4Y1Vy9isU4ZeXFKXoQ==
X-Google-Smtp-Source: AGHT+IGSGpq67S3KPhxv0QaGyYpi7Ds7VIRtelTKmN8kUlCb5EZQ5DwEZ8oJuL//LObkvog2EV/g3poagrgtfeFDHng=
X-Received: by 2002:a2e:9fcb:0:b0:302:2620:ec89 with SMTP id
 38308e7fff4ca-30240cfb673mr9672121fa.19.1733921182952; Wed, 11 Dec 2024
 04:46:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
 <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain> <CA+G9fYv5gW1gByakU1yyQ__BoAKWkCcg=vGGyNep7+5p9_2uJA@mail.gmail.com>
 <bd95d7249ff94e31beb11b3f71a64e87@AcuMS.aculab.com>
In-Reply-To: <bd95d7249ff94e31beb11b3f71a64e87@AcuMS.aculab.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 11 Dec 2024 13:46:11 +0100
Message-ID: <CAMRc=Mf8CmKs-_FddnLFU7aoOAPU6Xv8MqyZo8x9Uv-Eu+hs_g@mail.gmail.com>
Subject: Re: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
To: David Laight <David.Laight@aculab.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>, 
	Linux Regressions <regressions@lists.linux.dev>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Johannes Berg <johannes.berg@intel.com>, 
	"toke@kernel.org" <toke@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	"kernel@jfarr.cc" <kernel@jfarr.cc>, "kees@kernel.org" <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 3:20=E2=80=AFAM David Laight <David.Laight@aculab.co=
m> wrote:
>
> From: Naresh Kamboju
> > Sent: 05 December 2024 18:42
> >
> > On Thu, 5 Dec 2024 at 20:46, Dan Carpenter <dan.carpenter@linaro.org> w=
rote:
> > >
> > > Add David to the CC list.
> >
> > Anders bisected this reported issue and found the first bad commit as,
> >
> > # first bad commit:
> >   [ef32b92ac605ba1b7692827330b9c60259f0af49]
> >   minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
>
> That 'just' changed the test to use __builtin_constant_p() and
> thus gets checked after the optimiser has run.
>
> I can paraphrase the code as:
> unsigned int fn(unsigned int x)
> {
>         return clamp(10, 5, x =3D=3D 0 ? 0 : x - 1);
> }
> which is never actually called with x <=3D 5.
> The compiler converts it to:
>         return x < 0 ? clamp(10, 5, 0) : clamp(10, 5, x);
> (Probably because it can see that clamp(10, 5, 0) is constant.)
> And then the compile-time sanity check in clamp() fires.
>
> The order of the arguments to clamp is just wrong!
>
>         David
>

The build is still failing with today's next, should the offending
commit be reverted?

Bartosz
