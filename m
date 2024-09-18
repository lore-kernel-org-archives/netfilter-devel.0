Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5FD1898EF
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 13:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726664454; cv=none; b=ObY2ywQMXTnf3XYcpytH3l3ugWPj9IIM6VXRFtr8DgkPgFrOS/59GhlBbaA4RuWLQWW+h8SE4SYuStHcdV7iMt2e9BXAVAGp5GiJez6PyZ2KrZ17PqEfLvD+LVUc3UcHIRINmBEXbn6FlFHcLmMcpWU/kZr/X2d5nfuEpbnMQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726664454; c=relaxed/simple;
	bh=jSlykW5bt1X8wY+L9DK4yVnbM2Dxjx3IJTifcTupKGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ebSIry8Rrkxrs+zHUjkIOeox41sQULYUNMeJ4TW3SI2ZfG9u3TAdR8KCIxafU98rU0WtZWUNUKXc7RcFB2SJkRAkznDBUZaocXfV0ZenN9olMtTufdkGmpMeXPmrvTJ3xcGLn7I+vH9WlSAKK7m0n4FRETFNCyQolIHf7AcHBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sea8n46W; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sea8n46W"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ddbcc96a5fso66565967b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 06:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726664451; x=1727269251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gG4uk/vP4Auo0JUEJ3TwE/Gi6Jqek9rAO495IQzjEQI=;
        b=sea8n46WPBndORKZxWU8WF4vQCaZglOzjIvF+hJ3+jppuds7d5zVD+ejtkE1Ndp0s0
         7cReYx4iBtLSWB/cVvSFx3BrgL6Y/Vnp07d6RUxBtT5McxgCWoVEQONsglQHWizcFyIQ
         EkuXXL8M0fd1cSwxek5sfnTrxYJMX7sqDiowTy14uAqet+BzeIxE0hWR6Km59gPZjMmR
         QZcqYv59D5WbLW4a3Y7GoZEeox1PRx2feYuby4cR5rUapmGqB/iF1+qBtE1E3FZeDS1j
         53pyhYeF2m9yqFkYjFHX1G7IFD4janPewFePTftrxMbwqLIE3I/OalF8N/rHTkAaDir3
         escg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726664451; x=1727269251;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gG4uk/vP4Auo0JUEJ3TwE/Gi6Jqek9rAO495IQzjEQI=;
        b=ASMuFjH4+6t0RlXCzdNvhKWjG0qMY6Yuy29Qqu3Ob8FILnvAgxdNRN8/JbAlGUBMAe
         /NxZ4iKlghkftR1NfMVVwqE57qAoITaBlvCqUgzhxFUiezPFEyEd0yvQnjWVg6qkIpt3
         LSlah4mZA+iiKixxKSEUlRq8YyqUvD9dnlK1rxlfiSweZ7Gfs8pqPzOQn8AYBPSavKTi
         VmC3xMAi4IwTuXkTrdlCtnsjVvEaEtgsugmJBpqcxE0Qqc/H79CRzam+GdVjJduzf2hp
         oMzSLAnGMPnE/rnXZgLIBrj5i5Orj8AuvjhhNiiH2OGAGsVloq1sGivUjQFoCR3v6Ns6
         ob1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUo/kBabfQwG00bBkaSMU/tbfranNIZuYHx8Xp34eOWcsEgkhlS+J5+EyTyCq0fye64+Lj3ZyQA+ieKYvtLQFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRUdLrAd2GXcstVec9NpOAdobCUL/TEWe9Y4Mwcm9cXTNKjagX
	c19qOTX2qIRdVsnQBOCiNRiAKvVTvT/lZB2rEhdvmefyM3Bj0L766OWWxWm8Hw5wKA3a2QFwaRf
	Dgw==
X-Google-Smtp-Source: AGHT+IGM7KgeWoLxELWBwQUsLDJlm3dR+5XBCvbO6cAZNKMS6X1eXIP4HHAAO5cN0itx0ApCcGg2uc/JWZY=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:690c:6d03:b0:6dd:dcf5:28ad with SMTP id
 00721157ae682-6dddcf5296cmr3749557b3.0.1726664451185; Wed, 18 Sep 2024
 06:00:51 -0700 (PDT)
Date: Wed, 18 Sep 2024 15:00:48 +0200
In-Reply-To: <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-13-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZurPAMch78Mmylt5@google.com>
Subject: Re: [RFC PATCH v3 12/19] selftests/landlock: Test that kernel space
 sockets are not restricted
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This is a good way to test this, IMHO. Good find.
The comment at the bottom is really valuable. :)

Out of curiosity: I suspect that a selftest with NFS or another network-bac=
ked
filesystem might be too complicated?  Have you tried that manually, by any
chance?


On Wed, Sep 04, 2024 at 06:48:17PM +0800, Mikhail Ivanov wrote:
> Add test validating that Landlock provides restriction of user space
> sockets only.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  .../testing/selftests/landlock/socket_test.c  | 39 ++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> index ff5ace711697..23698b8c2f4d 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -7,7 +7,7 @@
> =20
>  #define _GNU_SOURCE
> =20
> -#include <linux/landlock.h>
> +#include "landlock.h"
>  #include <linux/pfkeyv2.h>
>  #include <linux/kcm.h>
>  #include <linux/can.h>
> @@ -628,4 +628,41 @@ TEST(unsupported_af_and_prot)
>  	EXPECT_EQ(ESOCKTNOSUPPORT, test_socket(AF_UNIX, SOCK_PACKET, 0));
>  }
> =20
> +TEST(kernel_socket)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	struct landlock_socket_attr smc_socket_create =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family =3D AF_SMC,
> +		.type =3D SOCK_STREAM,
> +	};
> +	int ruleset_fd;
> +
> +	/*
> +	 * Checks that SMC socket is created sucessfuly without

Typo nit: "successfully"
             ^^     ^^

> +	 * landlock restrictions.
> +	 */
> +	ASSERT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
> +
> +	ruleset_fd =3D
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +				       &smc_socket_create, 0));
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/*
> +	 * During the creation of an SMC socket, an internal service TCP socket
> +	 * is also created (Cf. smc_create_clcsk).
> +	 *
> +	 * Checks that Landlock does not restrict creation of the kernel space
> +	 * socket.
> +	 */
> +	EXPECT_EQ(0, test_socket(AF_SMC, SOCK_STREAM, 0));
> +}
> +
>  TEST_HARNESS_MAIN
> --=20
> 2.34.1
>=20

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
