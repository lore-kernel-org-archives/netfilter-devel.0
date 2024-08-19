Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69ED3F9CC
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724104363; cv=none; b=t/dlUpvyANlohOyXn7n/ZGiRkdworeLguc4NREjCUCgKxKMRZUh1FNhFN0xCW2lpDZ9+/6nWjsAhK/VHjoTPBR+PpPlwIQk5Y/4pMoN4iLXjF5nchM7TF73HkIIwmm00oRAFF8tFdNb+x1S+7GDOfRlMbSoC7Wvjf4GXMJXX120=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724104363; c=relaxed/simple;
	bh=KHGw8auXTrIKdKpRw8P+WjAwcmgkyhvREKNkvqDSFAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ieF9EpyrZ6P0OaubMHD2rDDXyBJh4YXgh78w33uoI2qyjwSH3JEh6d7FIxqcTJj7gOpv9aBN2lHRKprb2nynivIG+5/mwCzJi9r+ZhUiC1beDWa6vxC8SSaEK/j1XAGJY4zkDhWEGjMS/8IId6Yd7+Lk+658UKXTS/UFe6SmOXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m0AffOGI; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m0AffOGI"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a80717f86ffso694984566b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724104359; x=1724709159; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJlHoejZtUeKl4kaK6eAwjps3ryi8Mxu/1WFERYSam4=;
        b=m0AffOGIC1KXRRdxZqxF6SZ+McHBGEDBilZJtBhkWfRbulhEF+qHEdUn88MaCavBVn
         y5pE5rCP8tUzcavAJR0wgFPBQ2qQxmGxtolG6YUF6l4r+RDSj3FtMvwmY/JWzG1J7x+J
         3fi+hZPaaaHjTn4wvJ+tj6RtB6IlhgI08jSpd+buTJREy/cocz5kdaSLrYxXHhz/Jx64
         /JbGIkkAcTfEvBFV4tTRIVSwYBYYO0+d9ua+Mxi5dZ2c/u5Cb1XbqG2WT/U2unHcU9Rn
         6NiP7DtUVoktQdMUj/wgXqNvAl4XY/2ar2Sg8KPXrKpTxx75ayjnMU1cZCkZiWJ/uxRc
         zEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724104359; x=1724709159;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BJlHoejZtUeKl4kaK6eAwjps3ryi8Mxu/1WFERYSam4=;
        b=MWR3dhEqrdJgMKfOQXYkalywdq7v3sBX4xBdG72EaVSjqZ9IVp7fZCKPUH9n3zJS9N
         fdAKnvmX1t+Cp2N/O1Uub5EOJ7AqjTk6bKWmro8rKkHUeA6YKyGNrj9usda+pCqvFh+a
         jfPK/rQHqEqECDmqELPSqu2g1wecdiazAMUcZpw7QEB+XqFrsaxU6Ur/ivfDRNUKzcgh
         zOCbU4KpZpFhCiz6bWc7inmiU5zOKp/17RDsBd7cC8Cg1Qk37m72h3m4xoCyDpUwMqsi
         W1y2yMaKAVWRQEo0NvHUlORZ00/dQfRi+DUJWPFhb7lC6pVmK23/8+3vxS7WjZASqZ/o
         pxug==
X-Forwarded-Encrypted: i=1; AJvYcCVCUXnYZ5yOjB4e+vlR6UwAZKJuyl2d1okQrAKrEJNUEDgHnP7kOv7HrvbTNtchZytSHk7mwtA06JRbdnOEA/E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi1rBjEMBrBfRKK48b+eHl5lTNDGKeAibAIVTwjizXO+sozNbw
	SYzgKH273p/2oPBNiKVK/qg8secgxwrQiI+AeOuyjqrrZnBa16SElPMO90XLtRbXSCx2eJWkOja
	wrw==
X-Google-Smtp-Source: AGHT+IFAdVzWwIZWt7EsRLtpPlIkSKBXvMPotCsBkIUvay9MgKIquncBMJc6Q/G9Xk8GB5iaSZkxGdaeLNQ=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:6acc:b0:a7a:854f:819f with SMTP id
 a640c23a62f3a-a8643f3f466mr96366b.2.1724104358700; Mon, 19 Aug 2024 14:52:38
 -0700 (PDT)
Date: Mon, 19 Aug 2024 23:52:36 +0200
In-Reply-To: <20240814030151.2380280-4-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com> <20240814030151.2380280-4-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZsO-pIGsTl6T5AL1@google.com>
Subject: Re: [RFC PATCH v2 3/9] selftests/landlock: Support LANDLOCK_ACCESS_NET_LISTEN_TCP
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 11:01:45AM +0800, Mikhail Ivanov wrote:
> * Add listen_variant() to simplify listen(2) return code checking.
> * Rename test_bind_and_connect() to test_restricted_net_fixture().
> * Extend current net rules with LANDLOCK_ACCESS_NET_LISTEN_TCP access.
> * Rename test port_specific.bind_connect_1023 to
>   port_specific.port_1023.
> * Check little endian port restriction for listen in
>   ipv4_tcp.port_endianness.
> * Some local renames and comment changes.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/net_test.c | 198 +++++++++++---------
>  1 file changed, 107 insertions(+), 91 deletions(-)
>=20
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/=
selftests/landlock/net_test.c
> index f21cfbbc3638..8126f5c0160f 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -2,7 +2,7 @@
>  /*
>   * Landlock tests - Network
>   *
> - * Copyright =C2=A9 2022-2023 Huawei Tech. Co., Ltd.
> + * Copyright =C2=A9 2022-2024 Huawei Tech. Co., Ltd.
>   * Copyright =C2=A9 2023 Microsoft Corporation
>   */
> =20
> @@ -22,6 +22,17 @@
> =20
>  #include "common.h"
> =20
> +/* clang-format off */
> +
> +#define ACCESS_LAST LANDLOCK_ACCESS_NET_LISTEN_TCP
> +
> +#define ACCESS_ALL ( \
> +	LANDLOCK_ACCESS_NET_BIND_TCP | \
> +	LANDLOCK_ACCESS_NET_CONNECT_TCP | \
> +	LANDLOCK_ACCESS_NET_LISTEN_TCP)
> +
> +/* clang-format on */
> +
>  const short sock_port_start =3D (1 << 10);
> =20
>  static const char loopback_ipv4[] =3D "127.0.0.1";
> @@ -282,6 +293,16 @@ static int connect_variant(const int sock_fd,
>  	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
>  }
> =20
> +static int listen_variant(const int sock_fd, const int backlog)

I believe socket_variant(), connect_variant() and bind_variant() were calle=
d
like that because they got an instance of a service_fixture as an argument.=
  The
fixture instances are called variants.  But we don't use these fixtures her=
e.

In fs_test.c, we also have some functions that behave much like system call=
s,
but clean up after themselves and return errno, for easier use in assert.  =
The
naming scheme we have used there is "test_foo" (e.g. test_open()).  I think=
 this
would be more appropriate here as a name?

> +{
> +	int ret;
> +
> +	ret =3D listen(sock_fd, backlog);
> +	if (ret < 0)
> +		return -errno;
> +	return ret;
> +}
> +
>  FIXTURE(protocol)
>  {
>  	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
> @@ -438,9 +459,11 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_=
datagram) {
>  	},
>  };
> =20
> -static void test_bind_and_connect(struct __test_metadata *const _metadat=
a,
> -				  const struct service_fixture *const srv,
> -				  const bool deny_bind, const bool deny_connect)
> +static void test_restricted_net_fixture(struct __test_metadata *const _m=
etadata,
> +					const struct service_fixture *const srv,
> +					const bool deny_bind,
> +					const bool deny_connect,
> +					const bool deny_listen)
>  {
>  	char buf =3D '\0';
>  	int inval_fd, bind_fd, client_fd, status, ret;
> @@ -512,8 +535,14 @@ static void test_bind_and_connect(struct __test_meta=
data *const _metadata,
>  		EXPECT_EQ(0, ret);
> =20
>  		/* Creates a listening socket. */
> -		if (srv->protocol.type =3D=3D SOCK_STREAM)
> -			EXPECT_EQ(0, listen(bind_fd, backlog));
> +		if (srv->protocol.type =3D=3D SOCK_STREAM) {
> +			ret =3D listen_variant(bind_fd, backlog);
> +			if (deny_listen) {
> +				EXPECT_EQ(-EACCES, ret);
> +			} else {
> +				EXPECT_EQ(0, ret);
> +			}

Hmm, passing the expected error code instead of a boolean to this function =
was not possible?
Then you could just write

  EXPECT_EQ(expected_listen_error, listen_variant(bind_fd, backlog));

?  (Apologies if this was discussed already.)

> +		}
>  	}
> =20
>  	child =3D fork();
> @@ -530,7 +559,7 @@ static void test_bind_and_connect(struct __test_metad=
ata *const _metadata,
>  		ret =3D connect_variant(connect_fd, srv);
>  		if (deny_connect) {
>  			EXPECT_EQ(-EACCES, ret);
> -		} else if (deny_bind) {
> +		} else if (deny_bind || deny_listen) {
>  			/* No listening server. */
>  			EXPECT_EQ(-ECONNREFUSED, ret);
>  		} else {
> @@ -545,7 +574,7 @@ static void test_bind_and_connect(struct __test_metad=
ata *const _metadata,
> =20
>  	/* Accepts connection from the child. */
>  	client_fd =3D bind_fd;
> -	if (!deny_bind && !deny_connect) {
> +	if (!deny_bind && !deny_connect && !deny_listen) {
>  		if (srv->protocol.type =3D=3D SOCK_STREAM) {
>  			client_fd =3D accept(bind_fd, NULL, 0);
>  			ASSERT_LE(0, client_fd);
> @@ -571,16 +600,15 @@ TEST_F(protocol, bind)
>  {
>  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
>  		const struct landlock_ruleset_attr ruleset_attr =3D {
> -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +			.handled_access_net =3D ACCESS_ALL,
>  		};
> -		const struct landlock_net_port_attr tcp_bind_connect_p0 =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		const struct landlock_net_port_attr tcp_not_restricted_p0 =3D {
> +			.allowed_access =3D ACCESS_ALL,
>  			.port =3D self->srv0.port,
>  		};
> -		const struct landlock_net_port_attr tcp_connect_p1 =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		const struct landlock_net_port_attr tcp_denied_bind_p1 =3D {
> +			.allowed_access =3D ACCESS_ALL &
> +					  ~LANDLOCK_ACCESS_NET_BIND_TCP,
>  			.port =3D self->srv1.port,
>  		};
>  		int ruleset_fd;
> @@ -589,48 +617,47 @@ TEST_F(protocol, bind)
>  						     sizeof(ruleset_attr), 0);
>  		ASSERT_LE(0, ruleset_fd);
> =20
> -		/* Allows connect and bind for the first port.  */
> +		/* Allows all actions for the first port. */
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_bind_connect_p0, 0));
> +					    &tcp_not_restricted_p0, 0));
> =20
> -		/* Allows connect and denies bind for the second port. */
> +		/* Allows all actions despite bind. */
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_connect_p1, 0));
> +					    &tcp_denied_bind_p1, 0));
> =20
>  		enforce_ruleset(_metadata, ruleset_fd);
>  		EXPECT_EQ(0, close(ruleset_fd));
>  	}
> +	bool restricted =3D is_restricted(&variant->prot, variant->sandbox);
> =20
>  	/* Binds a socket to the first port. */
> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
> +				    false);
> =20
>  	/* Binds a socket to the second port. */
> -	test_bind_and_connect(_metadata, &self->srv1,
> -			      is_restricted(&variant->prot, variant->sandbox),
> -			      false);
> +	test_restricted_net_fixture(_metadata, &self->srv1, restricted, false,
> +				    false);
> =20
>  	/* Binds a socket to the third port. */
> -	test_bind_and_connect(_metadata, &self->srv2,
> -			      is_restricted(&variant->prot, variant->sandbox),
> -			      is_restricted(&variant->prot, variant->sandbox));
> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
> +				    restricted, restricted);
>  }
> =20
>  TEST_F(protocol, connect)
>  {
>  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
>  		const struct landlock_ruleset_attr ruleset_attr =3D {
> -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +			.handled_access_net =3D ACCESS_ALL,
>  		};
> -		const struct landlock_net_port_attr tcp_bind_connect_p0 =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		const struct landlock_net_port_attr tcp_not_restricted_p0 =3D {
> +			.allowed_access =3D ACCESS_ALL,
>  			.port =3D self->srv0.port,
>  		};
> -		const struct landlock_net_port_attr tcp_bind_p1 =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP,
> +		const struct landlock_net_port_attr tcp_denied_connect_p1 =3D {
> +			.allowed_access =3D ACCESS_ALL &
> +					  ~LANDLOCK_ACCESS_NET_CONNECT_TCP,
>  			.port =3D self->srv1.port,
>  		};
>  		int ruleset_fd;
> @@ -639,28 +666,27 @@ TEST_F(protocol, connect)
>  						     sizeof(ruleset_attr), 0);
>  		ASSERT_LE(0, ruleset_fd);
> =20
> -		/* Allows connect and bind for the first port. */
> +		/* Allows all actions for the first port. */
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_bind_connect_p0, 0));
> +					    &tcp_not_restricted_p0, 0));
> =20
> -		/* Allows bind and denies connect for the second port. */
> +		/* Allows all actions despite connect. */
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_bind_p1, 0));
> +					    &tcp_denied_connect_p1, 0));
> =20
>  		enforce_ruleset(_metadata, ruleset_fd);
>  		EXPECT_EQ(0, close(ruleset_fd));
>  	}
> -
> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
> -
> -	test_bind_and_connect(_metadata, &self->srv1, false,
> -			      is_restricted(&variant->prot, variant->sandbox));
> -
> -	test_bind_and_connect(_metadata, &self->srv2,
> -			      is_restricted(&variant->prot, variant->sandbox),
> -			      is_restricted(&variant->prot, variant->sandbox));
> +	bool restricted =3D is_restricted(&variant->prot, variant->sandbox);
> +
> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
> +				    false);
> +	test_restricted_net_fixture(_metadata, &self->srv1, false, restricted,
> +				    false);
> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
> +				    restricted, restricted);
>  }
> =20
>  TEST_F(protocol, bind_unspec)
> @@ -761,7 +787,7 @@ TEST_F(protocol, connect_unspec)
>  	ASSERT_LE(0, bind_fd);
>  	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
>  	if (self->srv0.protocol.type =3D=3D SOCK_STREAM)
> -		EXPECT_EQ(0, listen(bind_fd, backlog));
> +		EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> =20
>  	child =3D fork();
>  	ASSERT_LE(0, child);
> @@ -1127,8 +1153,8 @@ TEST_F(tcp_layers, ruleset_overlap)
>  	 * Forbids to connect to the socket because only one ruleset layer
>  	 * allows connect.
>  	 */
> -	test_bind_and_connect(_metadata, &self->srv0, false,
> -			      variant->num_layers >=3D 2);
> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> +				    variant->num_layers >=3D 2, false);
>  }
> =20
>  TEST_F(tcp_layers, ruleset_expand)
> @@ -1208,11 +1234,12 @@ TEST_F(tcp_layers, ruleset_expand)
>  		EXPECT_EQ(0, close(ruleset_fd));
>  	}
> =20
> -	test_bind_and_connect(_metadata, &self->srv0, false,
> -			      variant->num_layers >=3D 3);
> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> +				    variant->num_layers >=3D 3, false);
> =20
> -	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >=3D =
1,
> -			      variant->num_layers >=3D 2);
> +	test_restricted_net_fixture(_metadata, &self->srv1,
> +				    variant->num_layers >=3D 1,
> +				    variant->num_layers >=3D 2, false);
>  }
> =20
>  /* clang-format off */
> @@ -1230,16 +1257,6 @@ FIXTURE_TEARDOWN(mini)
>  {
>  }
> =20
> -/* clang-format off */
> -
> -#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
> -
> -#define ACCESS_ALL ( \
> -	LANDLOCK_ACCESS_NET_BIND_TCP | \
> -	LANDLOCK_ACCESS_NET_CONNECT_TCP)
> -
> -/* clang-format on */
> -
>  TEST_F(mini, network_access_rights)
>  {
>  	const struct landlock_ruleset_attr ruleset_attr =3D {
> @@ -1454,8 +1471,9 @@ TEST_F(mini, tcp_port_overflow)
> =20
>  	enforce_ruleset(_metadata, ruleset_fd);
> =20
> -	test_bind_and_connect(_metadata, &srv_denied, true, true);
> -	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
> +	test_restricted_net_fixture(_metadata, &srv_denied, true, true, false);
> +	test_restricted_net_fixture(_metadata, &srv_max_allowed, false, false,
> +				    false);
>  }
> =20
>  FIXTURE(ipv4_tcp)
> @@ -1485,22 +1503,21 @@ FIXTURE_TEARDOWN(ipv4_tcp)
>  TEST_F(ipv4_tcp, port_endianness)
>  {
>  	const struct landlock_ruleset_attr ruleset_attr =3D {
> -		.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.handled_access_net =3D ACCESS_ALL,
>  	};
>  	const struct landlock_net_port_attr bind_host_endian_p0 =3D {
>  		.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP,
>  		/* Host port format. */
>  		.port =3D self->srv0.port,
>  	};
> -	const struct landlock_net_port_attr connect_big_endian_p0 =3D {
> -		.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	const struct landlock_net_port_attr connect_listen_big_endian_p0 =3D {
> +		.allowed_access =3D LANDLOCK_ACCESS_NET_CONNECT_TCP |
> +				  LANDLOCK_ACCESS_NET_LISTEN_TCP,
>  		/* Big endian port format. */
>  		.port =3D htons(self->srv0.port),
>  	};
> -	const struct landlock_net_port_attr bind_connect_host_endian_p1 =3D {
> -		.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	const struct landlock_net_port_attr not_restricted_host_endian_p1 =3D {
> +		.allowed_access =3D ACCESS_ALL,
>  		/* Host port format. */
>  		.port =3D self->srv1.port,
>  	};
> @@ -1514,16 +1531,18 @@ TEST_F(ipv4_tcp, port_endianness)
>  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>  				       &bind_host_endian_p0, 0));
>  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -				       &connect_big_endian_p0, 0));
> +				       &connect_listen_big_endian_p0, 0));
>  	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -				       &bind_connect_host_endian_p1, 0));
> +				       &not_restricted_host_endian_p1, 0));
>  	enforce_ruleset(_metadata, ruleset_fd);
> =20
>  	/* No restriction for big endinan CPU. */
> -	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
> +				    little_endian, little_endian);
> =20
>  	/* No restriction for any CPU. */
> -	test_bind_and_connect(_metadata, &self->srv1, false, false);
> +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
> +				    false);
>  }
> =20
>  TEST_F(ipv4_tcp, with_fs)
> @@ -1691,7 +1710,7 @@ TEST_F(port_specific, bind_connect_zero)
>  	ret =3D bind_variant(bind_fd, &self->srv0);
>  	EXPECT_EQ(0, ret);
> =20
> -	EXPECT_EQ(0, listen(bind_fd, backlog));
> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> =20
>  	/* Connects on port 0. */
>  	ret =3D connect_variant(connect_fd, &self->srv0);
> @@ -1714,26 +1733,23 @@ TEST_F(port_specific, bind_connect_zero)
>  	EXPECT_EQ(0, close(bind_fd));
>  }
> =20
> -TEST_F(port_specific, bind_connect_1023)
> +TEST_F(port_specific, port_1023)
>  {
>  	int bind_fd, connect_fd, ret;
> =20
> -	/* Adds a rule layer with bind and connect actions. */
> +	/* Adds a rule layer with all actions. */
>  	if (variant->sandbox =3D=3D TCP_SANDBOX) {
>  		const struct landlock_ruleset_attr ruleset_attr =3D {
> -			.handled_access_net =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> +			.handled_access_net =3D ACCESS_ALL
>  		};
>  		/* A rule with port value less than 1024. */
> -		const struct landlock_net_port_attr tcp_bind_connect_low_range =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		const struct landlock_net_port_attr tcp_low_range_port =3D {
> +			.allowed_access =3D ACCESS_ALL,
>  			.port =3D 1023,
>  		};
>  		/* A rule with 1024 port. */
> -		const struct landlock_net_port_attr tcp_bind_connect =3D {
> -			.allowed_access =3D LANDLOCK_ACCESS_NET_BIND_TCP |
> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		const struct landlock_net_port_attr tcp_port_1024 =3D {
> +			.allowed_access =3D ACCESS_ALL,
>  			.port =3D 1024,
>  		};
>  		int ruleset_fd;
> @@ -1744,10 +1760,10 @@ TEST_F(port_specific, bind_connect_1023)
> =20
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_bind_connect_low_range, 0));
> +					    &tcp_low_range_port, 0));
>  		ASSERT_EQ(0,
>  			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> -					    &tcp_bind_connect, 0));
> +					    &tcp_port_1024, 0));
> =20
>  		enforce_ruleset(_metadata, ruleset_fd);
>  		EXPECT_EQ(0, close(ruleset_fd));
> @@ -1771,7 +1787,7 @@ TEST_F(port_specific, bind_connect_1023)
>  	ret =3D bind_variant(bind_fd, &self->srv0);
>  	clear_cap(_metadata, CAP_NET_BIND_SERVICE);
>  	EXPECT_EQ(0, ret);
> -	EXPECT_EQ(0, listen(bind_fd, backlog));
> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> =20
>  	/* Connects on the binded port 1023. */
>  	ret =3D connect_variant(connect_fd, &self->srv0);
> @@ -1791,7 +1807,7 @@ TEST_F(port_specific, bind_connect_1023)
>  	/* Binds on port 1024. */
>  	ret =3D bind_variant(bind_fd, &self->srv0);
>  	EXPECT_EQ(0, ret);
> -	EXPECT_EQ(0, listen(bind_fd, backlog));
> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> =20
>  	/* Connects on the binded port 1024. */
>  	ret =3D connect_variant(connect_fd, &self->srv0);
> --=20
> 2.34.1
>=20

=E2=80=94G=C3=BCnther
