Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD623183CDE
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726663353; cv=none; b=JYe9u9nsKJzJopdjMOXGIpb8TFwIlwBUcpCLZqUKX8yvD1cdpLL4VIgw6ena/32AOYeLYsSWN12z9QYAutR22aOdOk6LZ1s0v1mSab6Nymj+cYHyuZrZOHDWEtYwI5eNKRGkITaCIbHusEfRwA5UNXpfEsCLLkYdLu7J1v5CEAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726663353; c=relaxed/simple;
	bh=YuyzMJS60HutvgbpoJTpxl2qOeZhR7R3VcbTf7ngxec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7kc6IDOULX6Vb/CsxodfDG4ZaDDDPsL8P/wSzNoGyHGQ9x+huweH9bY2fYqak6fIEbQBEp3NrCJ6qAFP/opoonSKY/ystw6mcnDIpmlIduu0voC9tqjHabUnI0iTx0Idjru1D4nAzY58Dao9Z49reZFnUrF/15xp1Zd6WvgVX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wh0F0EHV; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wh0F0EHV"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a8a9094c973so530962066b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 05:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726663349; x=1727268149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGJ0f/kEihxaf9XHRtf990oQq84zNlc7esDTrAZ7XRI=;
        b=Wh0F0EHVMsj0xvEW/WZabcJD1nS8lgOiBSg+g2FzSMLgy8D3AifZ64SfpL3ikMFGG7
         1585UitnRs6mUZJDApD6zLiqweOAQe9D42XKZfcr6QMIAjo8UZ2Osh+i+Qrxu2LmzNzE
         KDF8fPEI4LzZfUVp52MA4gd4VGDBjEIaM+18muVj8pF5CGr488b4R+ONHi8aG0mbxPlT
         FIJp5gLRdk8HKWKghBco0accHqUuB6JdWCIXr5B6lBfUe9e1hH58mZO5TKjrHzMQoGTH
         SI9/vW2ARiGYKw7g348EfsS/ejyCsZUD2y6N56AB3wgdanovhT8AlNeE2nGQg8ydHRM6
         qYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726663349; x=1727268149;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gGJ0f/kEihxaf9XHRtf990oQq84zNlc7esDTrAZ7XRI=;
        b=eKUeeu6cqRkzo08xE5tvFy345QC9mmWiFRtrurZDQAwUimKQrn1bCx+WJGiFhIJaiv
         7b1uAE05il1QK+qSzznqzh1cJ8hbTrQgrSlQPRTH+tl9rDC/BekoXAh/fpg9irMfyj7O
         meVOB1ML07HoXFmUYVi4KMY1oadFKacnDdVeM7kKthlOQrhqaA0ajNR8TIf5LzVUkKVi
         xIYCv0QAZLSTYl2TUAB2CEmysYmgtUhrHDvJMzscUikcpgTACyGOV6lA8zVWtL6JngVr
         lBfUSKYHVtZPxHC2sH9Wacz3Ye4U7cAkC9d/KWqtzdPFIDmsSx9I/vjTc4R1FzIM8aZF
         Gb8w==
X-Forwarded-Encrypted: i=1; AJvYcCVS+s0BeLx/dJNhnxLRLxl3GKy9+ASmGTVHJnsERlyJWzGSSP6ephKmlPSCcZ4Ry+hycynsZdCd6kosLjphAbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTsZcMVOjCC5SCJcGBRCyOxLUMLcIw+dQIRjL0sWIIj/In/JPn
	4wKv5X4x9cBjoK8ucbto5EIVFRbRXcXFDSdvloR9R+amcWUMWfxfMu5hwZQfP4cfDNWxYy+obLG
	pmQ==
X-Google-Smtp-Source: AGHT+IFl21qxhmyOXUg8lNc9sb+HkGJIE4koHAaq0dLwgaVvB8XbDGHG9iih5tbFXBeKdxYrwTeThjtybT4=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:dd4:b0:a86:6d4e:57c0 with SMTP id
 a640c23a62f3a-a90295ceaa8mr1026666b.10.1726663348975; Wed, 18 Sep 2024
 05:42:28 -0700 (PDT)
Date: Wed, 18 Sep 2024 14:42:26 +0200
In-Reply-To: <20240904104824.1844082-8-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-8-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZurKsk0LHrIxCoV9@google.com>
Subject: Re: [RFC PATCH v3 07/19] selftests/landlock: Test adding a rule for
 empty access
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024 at 06:48:12PM +0800, Mikhail Ivanov wrote:
> Add test that validates behaviour of Landlock after rule with
> empty access is added.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> Changes since v2:
> * Renames protocol.inval into protocol.rule_with_empty_access.
> * Replaces ASSERT_EQ with EXPECT_EQ for landlock_add_rule().
> * Closes ruleset_fd.
> * Refactors commit message and title.
> * Minor fixes.
>=20
> Changes since v1:
> * Refactors commit message.
> ---
>  .../testing/selftests/landlock/socket_test.c  | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index d2fedfca7193..d323f649a183 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -384,4 +384,37 @@ TEST_F(protocol, rule_with_unhandled_access)
>  	ASSERT_EQ(0, close(ruleset_fd));
>  }
> =20
> +TEST_F(protocol, rule_with_empty_access)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE
> +	};
> +	struct landlock_socket_attr protocol_allowed =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family =3D self->prot.family,
> +		.type =3D self->prot.type,
> +	};
> +	struct landlock_socket_attr protocol_denied =3D {
> +		.allowed_access =3D 0,
> +		.family =3D self->prot.family,
> +		.type =3D self->prot.type,
> +	};
> +	int ruleset_fd;
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Checks zero access value. */
> +	EXPECT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					&protocol_denied, 0));
> +	EXPECT_EQ(ENOMSG, errno);
> +
> +	/* Adds with legitimate value. */
> +	EXPECT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &protocol_allowed, 0));

In my mind, the check with the legitimate rule is probably already done in =
other
places and does not strictly need to be duplicated here.

But up to you, it's fine either way. :)

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>

> +
> +	ASSERT_EQ(0, close(ruleset_fd));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20
