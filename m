Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFAF6CDA8
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581725; cv=none; b=SSzgeKEfeGXBRxYCfQhXdWGSuDMgI4p+ZErPQKMf4XLPZIcUxR1gGAQjlBtwfLXvSx+7JM0G/G18cjweYn8UNx8ZX/IQbpbZO/6uYKq+J8V0d0ETPrqdLRAw1HKcYB0L+FmEtR4xh0IvA71cKBhq+yvqyP+DweuYXnSItVSt/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581725; c=relaxed/simple;
	bh=m+jw77nLcnkLeRDbaHPflyBgSYWw0KkJf+HonyKXlD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZZ4tFi06WIDbo9HtvDgUhiTFZ4rMRt3vGEGl/OX/UaaV8TLrQqCDcloofEXkQIe//jEX12mDsVjosaf90tKQNi7+3SUQlPexu3DXH0eOwc1CHvLLrHP7n3E2R28fxQ8xWOPd105jPKHClntdRJ7vJnFWknnzScYhpHCuuwjzgfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IxKar8Xl; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IxKar8Xl"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd169dd4183so5624637276.3
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712581722; x=1713186522; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d06Ago2/G5anqicwOggM0K0/XYbwCAxGONLNO2HI/JQ=;
        b=IxKar8XlnVWQG5vb0UYCKgcjuZDfc8BxwaxxTnjRPDu/xHUeAck28UHHJzDNArqyny
         h+WnOl62r9k2z18YxZlbG5YXJe+nCjJ2+JEeMLojjYteTt9i1cKn4R1xmPT/8brasNFV
         68PfmUa5hY6kWVUA73yoEFfqQbjGAhPM497fzrp5lLWL7BK0mGh9MtdAZpmvcpaW6g2L
         QK4D1WLi0LPHYCcauZDaeSCPHjZm8gbgNMzSk7PqvXa1DiLWaQfVRWepof0yLaydvjKN
         gAoRJzatOTbqTNqXlswK2EHbcyautL+OLQNe5IQ3PdOi8n028FGT5UCi05JChQmCi+jY
         vj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712581722; x=1713186522;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d06Ago2/G5anqicwOggM0K0/XYbwCAxGONLNO2HI/JQ=;
        b=g+kwgHiMAl7ywtL4PNp1l4ZHWacxRs0OZgi8fZ7j9R05Yhlj+LkyAn/1aqrt5ruwp3
         mEy8Aa6dkbDP9gbuWMAeuDcR7FHBLjgEgkJwjngzGSccvA7EdfI1DPocV4vJIHzvGcpl
         NcOt0ieX/rHvvF52dgsOp3e7D3gER4RjZ3dnpSW7r5TdTWnZMG3i8h4YmWsXw5ylq3ST
         0Sq1LaCwOh6swZnd8ECghjpO7M8NtM3Qeh9a7j7r0xHUQJQ9r3jbppMqksENcpba7WFH
         fWPnq/RbLkFvjfoeV9nkRTPird/q3kbbXaPP9iHodQHGLCdVkWbC/mtKD2IFCGdz7nZN
         vy1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZADsm1MEi4BTKtxWHvT63mSF7iLFrgf14iMqyV8C/Ws+Q3fCri5JfNzpz8NIO742S43SbqPdAnftUeINqLZttcHSMzREaP4CeUwvYLBt4
X-Gm-Message-State: AOJu0YyGdNbRx5QfCQleSUGk+ZGzBbibYDZVSDf2q2tJ/65Ty3fdgEy+
	Ip5VIpLD3TMgnz8ok8314Vmcp/sr/m4UqjmRbsY/fK+I56Kia8nRx9+jXjUU8njmZMhRyGY+hrH
	pww==
X-Google-Smtp-Source: AGHT+IGcg1Ntpbtl+ojQVjIfyP2CUrOqPziIvPtcqCRCiSSD5vtFjGMNukw3ga8LybH10Tc112piZU0ftFc=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:2d06:b0:dcd:3a37:65 with SMTP id
 fo6-20020a0569022d0600b00dcd3a370065mr701394ybb.7.1712581722377; Mon, 08 Apr
 2024 06:08:42 -0700 (PDT)
Date: Mon, 8 Apr 2024 15:08:40 +0200
In-Reply-To: <20240408093927.1759381-4-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com> <20240408093927.1759381-4-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZhPsWKSRrqDiulrg@google.com>
Subject: Re: [RFC PATCH v1 03/10] selftests/landlock: Create 'create' test
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

I am very happy to see this patch set, this is a very valuable feature, IMH=
O! :)

Regarding the subject of this patch:

  [RFC PATCH v1 03/10] selftests/landlock: Create 'create' test
                                                   ^^^^^^

This was probably meant to say "socket"?

(In my mind, it is a good call to put the test in a separate file -
the existing test files have grown too large already.)


On Mon, Apr 08, 2024 at 05:39:20PM +0800, Ivanov Mikhail wrote:
> Initiate socket_test.c selftests. Add protocol fixture for tests
> with changeable domain/type values. Only most common variants of
> protocols (like ipv4-tcp,ipv6-udp, unix) were added.
> Add simple socket access right checking test.
>=20
> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>  .../testing/selftests/landlock/socket_test.c  | 197 ++++++++++++++++++
>  1 file changed, 197 insertions(+)
>  create mode 100644 tools/testing/selftests/landlock/socket_test.c
>=20
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testi=
ng/selftests/landlock/socket_test.c
> new file mode 100644
> index 000000000..525f4f7df
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -0,0 +1,197 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock tests - Socket
> + *
> + * Copyright =C2=A9 2024 Huawei Tech. Co., Ltd.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <linux/landlock.h>
> +#include <sched.h>
> +#include <string.h>
> +#include <sys/prctl.h>
> +#include <sys/socket.h>
> +
> +#include "common.h"
> +
> +/* clang-format off */
> +
> +#define ACCESS_LAST LANDLOCK_ACCESS_SOCKET_CREATE
> +
> +#define ACCESS_ALL ( \
> +	LANDLOCK_ACCESS_SOCKET_CREATE)
> +
> +/* clang-format on */
> +
> +struct protocol_variant {
> +	int domain;
> +	int type;
> +};
> +
> +struct service_fixture {
> +	struct protocol_variant protocol;
> +};
> +
> +static void setup_namespace(struct __test_metadata *const _metadata)
> +{
> +	set_cap(_metadata, CAP_SYS_ADMIN);
> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
> +	clear_cap(_metadata, CAP_SYS_ADMIN);
> +}
> +
> +static int socket_variant(const struct service_fixture *const srv)
> +{
> +	int ret;
> +
> +	ret =3D socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
> +			 0);
> +	if (ret < 0)
> +		return -errno;
> +	return ret;
> +}

This helper is mostly concerned with mapping the error code.

In the fs_test.c, we have dealt with such use cases with helpers like
test_open_rel() and test_open().  These helpers attempt to open the file, t=
ake
the same arguments as open(2), but instead of returning the opened fd, they=
 only
return 0 or errno.  Do you think this would be an option here?

Then you could write your tests as

  ASSERT_EQ(EACCES, test_socket(p->domain, p->type, 0));

and the test would (a) more obviously map to socket(2), and (b) keep releva=
nt
information like the expected error code at the top level of the test.

> +
> +FIXTURE(protocol)
> +{
> +	struct service_fixture srv0;
> +};
> +
> +FIXTURE_VARIANT(protocol)
> +{
> +	const struct protocol_variant protocol;
> +};
> +
> +FIXTURE_SETUP(protocol)
> +{
> +	disable_caps(_metadata);
> +	self->srv0.protocol =3D variant->protocol;
> +	setup_namespace(_metadata);
> +};
> +
> +FIXTURE_TEARDOWN(protocol)
> +{
> +}
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, unspec) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_UNSPEC,
> +		.type =3D SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, unix_stream) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_UNIX,
> +		.type =3D SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, unix_dgram) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_UNIX,
> +		.type =3D SOCK_DGRAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, ipv4_tcp) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, ipv4_udp) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_DGRAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, ipv6_tcp) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, ipv6_udp) {
> +	/* clang-format on */
> +	.protocol =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_DGRAM,
> +	},
> +};
> +
> +static void test_socket_create(struct __test_metadata *const _metadata,
> +				  const struct service_fixture *const srv,
> +				  const bool deny_create)
> +{
> +	int fd;
> +
> +	fd =3D socket_variant(srv);
> +	if (srv->protocol.domain =3D=3D AF_UNSPEC) {
> +		EXPECT_EQ(fd, -EAFNOSUPPORT);
> +	} else if (deny_create) {
> +		EXPECT_EQ(fd, -EACCES);
> +	} else {
> +		EXPECT_LE(0, fd)
> +		{
> +			TH_LOG("Failed to create socket: %s", strerror(errno));
> +		}
> +		EXPECT_EQ(0, close(fd));
> +	}
> +}

This is slightly too much logic in a test helper, for my taste,
and the meaning of the true/false argument in the main test below
is not very obvious.

Extending the idea from above, if test_socket() was simpler, would it
be possible to turn these fixtures into something shorter like this:

  ASSERT_EQ(EAFNOSUPPORT, test_socket(AF_UNSPEC, SOCK_STREAM, 0));
  ASSERT_EQ(EACCES, test_socket(AF_UNIX, SOCK_STREAM, 0));
  ASSERT_EQ(EACCES, test_socket(AF_UNIX, SOCK_DGRAM, 0));
  ASSERT_EQ(EACCES, test_socket(AF_INET, SOCK_STREAM, 0));
  // etc.

Would that make the tests easier to write, to list out the table of
expected values aspect like that, rather than in a fixture?


> +
> +TEST_F(protocol, create)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr =3D {
> +		.handled_access_socket =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	const struct landlock_socket_attr create_socket_attr =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.domain =3D self->srv0.protocol.domain,
> +		.type =3D self->srv0.protocol.type,
> +	};
> +
> +	int ruleset_fd;
> +
> +	/* Allowed create */
> +	ruleset_fd =3D landlock_create_ruleset(&ruleset_attr,
> +							sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	ASSERT_EQ(0,
> +			landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
> +					&create_socket_attr, 0));

The indentation looks wrong?  We run clang-format on Landlock files.

  clang-format -i security/landlock/*.[ch] \
  	include/uapi/linux/landlock.h \
  	tools/testing/selftests/landlock/*.[ch]

=E2=80=94G=C3=BCnther
