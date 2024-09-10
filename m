Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0CD17E8F7
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 09:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960183; cv=none; b=Cg29D6BRqKxqK5qz7ISW+DvBMczQRu2CLdkWpDPGfcuz9vFFUiij54gk4Gs9f6T+C9BwrB6uhA5bCiZ/luSP2p8Qvhxci53oJERpdpJ8dX1qsEgTk7md21F2VYBMo3XUGdj9yXF/qXw9+g0zgwQ1IulOH65vjtxtOcch72nqSb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960183; c=relaxed/simple;
	bh=2U5eh/pdV5Pfu36l56Wzjk+bxN/WpkzMkIXcUAy/CgY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pU5/+OfKM9/wVzP7h9uYrmiGXS1ADbnIbzdWsr9dK3Fgvii54gSC5D5FZwsDQG3fWpcJ9LKOvJwZOhvCtHjYRjwCezoCdUhWpmw19abeBROB12ORBlsZI9fFL12hmXs05tffPBqw+9QvwwVeoXMNDvoqMa4BlGVrEauDUKJr6i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ipZhbniI; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ipZhbniI"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5c3c24f2643so4043087a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 02:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725960180; x=1726564980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMJMyFgsL0Y0uwFcwxe8Dl2qODyk+WDjNJcqT9QUeCc=;
        b=ipZhbniIAETU/NNXrNaJwPRk/TxSOFwA6MqCZgLd2bgNa3B5x+QvhWUpGn1rla7wFa
         bVihiPZUSZJofauiiBDVsURSC2tlPAZ2aDGAJYbxLJtV+3dR8U5yMMge56UKTsQ4DUSS
         KonGf7caqGYy7VEKtMtKwuwEtjRkalhKLsFBmxQTmCjV3nJMJJfZ3lJxaReZN3RgoS2x
         PX+JnCnyKbFh34sI3woVpkzIhbrmveOuZsiJ+4iHinCpMSMmA1FQFyClRPTdUIWUh/OY
         ydWnQNoNf3tD+Kf5Dr8ip98fSsxoAuhqlWNX5Iz/lK/KQkDLQm3AnUObG8gz+IlIrQcs
         mjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725960180; x=1726564980;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hMJMyFgsL0Y0uwFcwxe8Dl2qODyk+WDjNJcqT9QUeCc=;
        b=AByTOCT6+iPj6ar/XV3k4NjNo7Y5eTXi0BO5wbA+ydMWwTzGLo91FRgqyAzlPzzob7
         bPMLe1Vn59d7pKfcpVNSdFsIKCospJ1YcfeckKK/6+I8AwptrJm1Rta3/CTByqb+4Oi1
         HgCbuKgQb7VOHLKmJMC0Nrhg/9U6FkMeHx++wx7uwqn4U1LGUu/Tq6dWTV/+ic2Ahorq
         eVOkLyQjm4RPhWch3UAqTWBfHq6r9ebY2WXq+wb+uIYSo3lKcJEim6tGs4BNR5IK0jcJ
         L3+FyGUq6wVIT2v8EF7VzaWhZvWYSEdHZkOEDT6M5cGK5XM4yHFH8aHF+jGqaAZ4HLDr
         +XEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBQrRn1j4VDNuN1Nvkob7Ne1eKmzzBTH4vV1TSZm8mPle/t0Q9jhC0atnC/32+9rRP1/CQYPNPUKxqWHQICWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEyc1GJf/nzPpX7y4KQOaT2uyxRkzRBdG85G4fI2tsybfewGIT
	t/7IlqvkfEfCPzfcRiUJzkm0ypAJ0iSmFftY+Nskw8zJ+F3Z/K89P0+gG+Fsof0MOvgSoIOLRmP
	xCQ==
X-Google-Smtp-Source: AGHT+IEvLoIBQkVz2O3lTxQ+HO2S2UyQYSwe1/czliyr/A8tQLQoSeVybxzWfsDusd+EzFbXtdkyA2ny9Yw=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:358a:b0:5c2:631b:c5bb with SMTP id
 4fb4d7f45d1cf-5c3dc7c9e87mr9281a12.7.1725960180431; Tue, 10 Sep 2024 02:23:00
 -0700 (PDT)
Date: Tue, 10 Sep 2024 11:22:58 +0200
In-Reply-To: <20240904104824.1844082-7-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-7-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZuAP8iSv_sjmlYIp@google.com>
Subject: Re: [RFC PATCH v3 06/19] selftests/landlock: Test adding a rule for
 unhandled access
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi!

On Wed, Sep 04, 2024 at 06:48:11PM +0800, Mikhail Ivanov wrote:
> Add test that validates behaviour of Landlock after rule with
> unhandled access is added.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> Changes since v2:
> * Replaces EXPECT_EQ with ASSERT_EQ for close().
> * Refactors commit title and message.
>=20
> Changes since v1:
> * Refactors commit message.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index 811bdaa95a7a..d2fedfca7193 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -351,4 +351,37 @@ TEST_F(protocol, rule_with_unknown_access)
>  	ASSERT_EQ(0, close(ruleset_fd));
>  }
> =20
> +TEST_F(protocol, rule_with_unhandled_access)
> +{
> +	struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	struct landlock_socket_attr protocol =3D {
> +		.family =3D self->prot.family,
> +		.type =3D self->prot.type,
> +	};
> +	int ruleset_fd;
> +	__u64 access;
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	for (access =3D 1; access > 0; access <<=3D 1) {
> +		int err;
> +
> +		protocol.allowed_access =3D access;
> +		err =3D landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					&protocol, 0);
> +		if (access =3D=3D ruleset_attr.handled_access_socket) {
> +			EXPECT_EQ(0, err);
> +		} else {
> +			EXPECT_EQ(-1, err);
> +			EXPECT_EQ(EINVAL, errno);
> +		}
> +	}
> +
> +	ASSERT_EQ(0, close(ruleset_fd));
> +}
> +

I should probably have noticed this on the first review round; you are not
actually exercising any scenario here where a rule with unhandled access is
added.

To clarify, the notion of an access right being "unhandled" means that the
access right was not listed at ruleset creation time in the ruleset_attr's
.handled_access_* field where it would have belonged.  If that is the case,
adding a ruleset with that access right is going to be denied.

As an example:
If the ruleset only handles LANDLOCK_ACCESS_FS_WRITE_FILE and nothing else,
then, if the test tries to insert a rule for LANDLOCK_ACCESS_SOCKET_CREATE,
that call is supposed to fail -- because the "socket creation" access right=
 is
not handled.

IMHO the test would become more reasonable if it was more clearly "handling=
"
something entirely unrelated at ruleset creation time, e.g. one of the file
system access rights.  (And we could do the same for the "net" and "fs" tes=
ts as
well.)

Your test is a copy of the same test for the "net" rights, which in turn is=
 a
copy of teh same test for the "fs" rights.  When the "fs" test was written,=
 the
"fs" access rights were the only ones that could be used at all to create a
ruleset, but this is not true any more.

=E2=80=94G=C3=BCnther
