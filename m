Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37367161310
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 21:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716844275; cv=none; b=bds7EoGG4juJCeKnhcmjQaO2PUxttRvsBPyUJZBGdXpD5+aoQyWR0kB6CmJdhrBsnb/8he3Ob36dheZCnGo13Sb6qdYB9aBhzxfz6cHMONRdO2zlm061d20WcAXZj0Qty7VzJ0h/rOvbmDZ2JEOjvnJ/mm2P7TFkBravSI40Joc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716844275; c=relaxed/simple;
	bh=jOH72SbmCuh1qVL9ZpmU9Zt0L0Zg8KmU12p0G8PUjcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iib8T80CuymeniiJNxYpwqD1GkeeJX7oZN2FkxXKmprAzakDpkKpT95VCT+V4D+T/YURAIDrMR5c5F/td/rg/pagLZ0i9qbRwKGIIkasmhtpIJwyUgZMh2Yo4msnbew8lLhiIVj9w1B5W1TKAlYEjaFAxPMtxlgdA6ov3PGUnvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wC1rvMfm; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wC1rvMfm"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df771b4ec6eso196572276.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 14:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716844273; x=1717449073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHTNTLN2NBseetsHgkmI+JNq5t6plhK651mJJB/QFCA=;
        b=wC1rvMfm0b5flKr7mHcBy516GxKjDSYF6wXPdWwbe4t2kDXa6lCqBxUbpMX043BBiv
         MoazRXj4asaakgTr0sGLrfzDKlUXcRd46cHNi7KGkfjAQ6NiLHNDUX1kHBcPn2Ds5DC8
         R4SFbnHHCSv8zxBIw+MxURmkyFSvUQp/z3GtwUeyLh+kEbNxQpAny3VO4qQjY7jzYLwA
         PcIYYn5xx1KunX6jgT57gL1cb2edN4i2bLmewSx8cM3UBJAz+trBV3Upi97M8I734+Bu
         qk+OSNWgxaPhEiQFAzkiF5K3/HP4KYDuaeCzOEz70QWUkA6gOMe6K9PSGKYygJfQxIaD
         ELCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716844273; x=1717449073;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jHTNTLN2NBseetsHgkmI+JNq5t6plhK651mJJB/QFCA=;
        b=CKR6vNhpAGcvOo9LUOKLzQ+/KrSxp0QNY1yREE9MFOUJYbjRgqqRaEnSULfAvczN0z
         7TxEojT4cSOLR0kg+mOY/rgemTOWpw9o4Lz7XbRSMCp8DEfZrH/miVD2Or8qbZnKVCsP
         R7rs4qJ7s1LEWZ5EY22ICKwEIOhqTGBOKFDnUxENioepQ7uL+2gdSTf1A3pNzbf/n3/p
         seo88KEnaIA73x57nUmxnxQ76czAg2u8tQNmAJvfIXdRcHVr7d9HU+T14oukFhhZsMee
         geoaIUr2sAhBDqR+133Z4zodL5qRr+x0c60rv1Z4Iup/PdSYNTQg3+aLF4d2naDjoz+d
         59aA==
X-Forwarded-Encrypted: i=1; AJvYcCV5meu3Ys1G8WYv1o5le0APa/L23t9wKlk2naYbMZ5cqbCO91iPeRpwAfs9dfQzftKyIA8naMvx2mTnDKr5ULC2VUtgwWevzsGq58GAHcSy
X-Gm-Message-State: AOJu0YywhnxR3UPSFgxom+VkK4l+c1tmDKXNKMpxH6Gu37nTSY+ZmGEi
	vtby0IOjDZXK80tEz7Ppl+rrjh1pli4kcQoof/w+MxhLlEMEn66WwMPC7DAWFe4rHvPLEFnQfv4
	x/w==
X-Google-Smtp-Source: AGHT+IEjOCWrO/w/wQv/+CSw5jX5MMbEDuw/w70D/xJDDN7/Tb/pgDzlutH9lO1deRmleYUvQ5+T1wfReAo=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a25:c591:0:b0:df7:83fa:273b with SMTP id
 3f1490d57ef6-df783fa33e5mr590467276.11.1716844273259; Mon, 27 May 2024
 14:11:13 -0700 (PDT)
Date: Mon, 27 May 2024 23:11:11 +0200
In-Reply-To: <20240524093015.2402952-6-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com> <20240524093015.2402952-6-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZlT274CFVomTcl0C@google.com>
Subject: Re: [RFC PATCH v2 05/12] selftests/landlock: Add protocol.rule_with_unknown_access
 to socket tests
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 05:30:08PM +0800, Mikhail Ivanov wrote:
> Add test that validates behavior of landlock after rule with
> unknown access is added.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>=20
> Changes since v1:
> * Refactors commit messsage.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index eb5d62263460..57d5927906b8 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -206,4 +206,30 @@ TEST_F(protocol, socket_access_rights)
>  	EXPECT_EQ(0, close(ruleset_fd));
>  }
> =20
> +TEST_F(protocol, rule_with_unknown_access)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D ACCESS_ALL,
> +	};
> +	struct landlock_socket_attr protocol =3D {
> +		.family =3D self->srv0.protocol.family,
> +		.type =3D self->srv0.protocol.type,
> +	};
> +	int ruleset_fd;
> +	__u64 access;
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	for (access =3D 1ULL << 63; access !=3D ACCESS_LAST; access >>=3D 1) {
> +		protocol.allowed_access =3D access;
> +		EXPECT_EQ(-1,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					    &protocol, 0));
> +		EXPECT_EQ(EINVAL, errno);
> +	}
> +	EXPECT_EQ(0, close(ruleset_fd));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
