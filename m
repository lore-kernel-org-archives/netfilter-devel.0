Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0E16191E
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716844546; cv=none; b=UNf6QwHtyUCESSKO+zNJMO7Sl11u4jmiZFZ/5uAB8mH1pFuvYAYybzpmvGS/RzuHRHiJxsVhpL7jIGd2SQyvwcjfiyHiL3OnJvpeyO4EcL2cffkJEn4C5pWv51ZqAEB6gFJx6PKemESI7wsQqj8GvOwz9suqHNCeDdl7wkZOEtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716844546; c=relaxed/simple;
	bh=cU4au/xE2uT6iT3b0leCXA1gJWV3T5+VWJ+Zf2Tcpyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cyKzOevkOsOfNXjnDXkWVMLJBH1pnQ6c8O3Qa5NFpA5PMxe57Gk9yEj8TOXO1Ptz4v0k4sAixixE+/P9CB/FgWoSA5l4iuhlGy8smMXWmKDEXKcOgkHN26XcUOq4VXY19ofgCVPQKBUqVfNyUkqS03PkrpTSjZiNY7XZESSppgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BpUSUApC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BpUSUApC"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df771b71994so215185276.3
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 14:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716844544; x=1717449344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MV7q+vdtQXuXLfTDMASuNLp3UUHxOfqwGFDJ01F8y3k=;
        b=BpUSUApCSEXhjaen/jhQM1RQLyXrDZ7s2ySg0wM39edz4jjl0obTwMM8degA0l7Iws
         mth/JJeVN+rpNdqKhUD3N8qLuPyTVSP+UyvieILVkEZTIq2Y0au7APKIRgWcpucs3Gu+
         wZEN25XIeWbQO9k0il4k0QvVkbB/k3RALyN/UjqJIrpO6I9Km0kHDSfgnuCuEAJvcoXk
         FPHLZyH8knKEyDuHO+bWYC7hxS8607jQzgZuZrSXD7XJCvZm/57fv5fUY05Ew+u0Ah2x
         9ZB9GjYAR1QdLbboAzPSJ1SmZ5is3LIlHe35AhDrtqV44octD6++yU0cbH4flz1pu+L8
         GbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716844544; x=1717449344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MV7q+vdtQXuXLfTDMASuNLp3UUHxOfqwGFDJ01F8y3k=;
        b=MkSebUAw/ZzvkGBhQOVuQ3opLZoBSXOcQMq9uVvIeV/18Tn8OwtONnix0zN/OkTrbs
         tCQ9GHcu6QyDN2Cef53hON2u7WUTounb6dHOI2hpvKTBGELlMmlb10o7Dsh72hAZ1hzm
         cTYjjmt7hlEYbS3wF9VlSbGOTHsBJ/paSl9DIKwjbOdLsnrxWIwnRFMmuIftApJ9B9FC
         Ifw+fnSvUoBoyyGMAoiQ4Wj4WtBzWo6U5XXShAf3jKg89tmqWUeu8Uru2xQpT0RgZ7WC
         8xi6g5A6D4M7lykiUl8Q4Vi+0sa/dzNMJCKSWcbKGepyrxsBho70yhbyCM7XCYluvYhp
         yCCw==
X-Forwarded-Encrypted: i=1; AJvYcCVfUveYdlrQ/CvIBFnWBlBHtVt9F1kUD0ZRg3S3bwq9TziojWKH8mp8EiiDlrG300W0NA9KZE86e7+02pAkjTJwOtFA4oV1cGDBBdIwc7Bf
X-Gm-Message-State: AOJu0Yz8gaIHHCp7Pn9dB9/BD0ddGyLc7mdB9iC1Ruj3oo4Pwz7zhv6g
	2aUdautNBLmplLEqJdOQEmg0wmJwb+rX702p0F2LFrYH3isr7KOW5P3QTp67f25O8cSUnwTEYuB
	6Jg==
X-Google-Smtp-Source: AGHT+IHQNShL8pBVopWZLIB8VV4ljsCmllvzBR6phLcoQTAPk/NUOFPVrgumCAbWvKqmFCNb/NtSC9ov8hA=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:114d:b0:df7:a340:4600 with SMTP id
 3f1490d57ef6-df7a3404d9dmr1348888276.10.1716844544376; Mon, 27 May 2024
 14:15:44 -0700 (PDT)
Date: Mon, 27 May 2024 23:15:42 +0200
In-Reply-To: <20240524093015.2402952-7-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com> <20240524093015.2402952-7-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZlT3_lNxzB_zW9s9@google.com>
Subject: Re: [RFC PATCH v2 06/12] selftests/landlock: Add protocol.rule_with_unhandled_access
 to socket tests
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 05:30:09PM +0800, Mikhail Ivanov wrote:
> Add test that validates behavior of landlock after rule with
> unhandled access is added.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>=20
> Changes since v1:
> * Refactors commit message.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index 57d5927906b8..31af47de1937 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -232,4 +232,37 @@ TEST_F(protocol, rule_with_unknown_access)
>  	EXPECT_EQ(0, close(ruleset_fd));
>  }
> =20
> +TEST_F(protocol, rule_with_unhandled_access)
> +{
> +	struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
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
> +	EXPECT_EQ(0, close(ruleset_fd));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>

Like the commit before, this is copied from net_test.c and I don't want to
bikeshed around on code style which was discussed before.

Trying to factor out commonalities might also introduce additional layers o=
f
indirection that would obscure what is happening.  I think it should be fin=
e
like that despite it having some duplication.

=E2=80=94G=C3=BCnther
