Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56CE1DFFB
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727971170; cv=none; b=pfWLTtNx2fQhhIvKY3qyqR8F6lT0MP9ksHDFIexsuIKVb38kYKcsZffRfSm1ok5lyEsns3QerjIdAD1PZzJbofPAvuKdEAc7Qxpffg8etM/L3tBd8xW1Fnk0SHyEeg6mKsKKziWxkWLFQs22cSMnvQYi4eqCkmkAqFcGK11tJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727971170; c=relaxed/simple;
	bh=KxHO2XCKrP/rWiF2GVnhzdTXLhhc+5GMYqHrpmS1UOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFxm+5P/DwXOqGIjf+7+InCd4dfRGLnPWP5n5cjwPMJhoaVwr5kDpDEckMq4oslO3qpHZyqVsTE9cB2CJRUQ2DpSzqvRWbn3d86C7eNlH1uZ7qoBd9gGBQOU15PCqOTSJDvHI2lLU7Rnqb0WEZuNtLK+KmbIh6CCfY/uA0I9+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pLzw8MWa; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pLzw8MWa"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a8b6ed71659so60619066b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2024 08:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727971164; x=1728575964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9TgHWHQLia5GRsXkWuEDP827SlaTWaSQAx/yquFKgA=;
        b=pLzw8MWaIIFOXbLt7fXi4I9v0DFfukfkIlYhpR9QsvzVWiF8E6xwSDvbY8b41hTMs3
         enccPWmVaJwpqalOoXcqSSF3cNwtSYxE9RSlKeO+wfWvWeJYnz3I6GEgGjwocdBiEfFB
         BKCB3rzpGFZV+K4ovzcPF35lEPDtOBnDtEEty6tNGxLX1ypGhpbv1A//2emrZJBK8GGK
         ez3BfZsEPdXOqwpK3f8UmZUn3kIBDO7xmjxRT5JTLgcq+O1I7hvkdjxM+fBlC4fLMkxe
         bqWevgT1aD/1Is9naYBda5RUN5avDaksZjo8UTL+k3CimUb+5bhgH+nLtR/f7kpQG3XX
         +SlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727971164; x=1728575964;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A9TgHWHQLia5GRsXkWuEDP827SlaTWaSQAx/yquFKgA=;
        b=k2j2K7jpP9gMKBaiSJuVUWA4FusFPMSgChl/IYTG/5RvZizmwoaw+aeQTwtvbeqJUv
         qenMUVVyJnv5x+2X9tbvldKPNB7UB+s95ufYyaJYdPi9DlH6hsbwD0m1alfs7q9kg54D
         o5QXgAxaTKmM1c3kSV2lA+W6xEuqgwDghHXVU+Bi83VeqF8Js4Jaz6Es8ETwuXD/QgBM
         28X9Mmq/0ILFeAPlpGwItj56XiYkDIceaPZ60NwuOWBA1IrZOkj2a8P5YKhvB3A7KrEw
         oI0h/D4rhYPMuwfwPllocJbL/sQk8l8vVa8xFjvrdDi6+SGeF5cy5V5Wb64mztRcFnN0
         9BoA==
X-Forwarded-Encrypted: i=1; AJvYcCXgon5chfI2kUnTLQZ28NFLDKymJxD+32cvqdOZ8/QCPWDfaigt51lrlGPZxUQI6tzxtcO2HPiNQwFbgO7x+n0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0o8Z7O/9XJEv+XXW9NfuobJ3WN47DL6LSYFrCdF4Jm5iafJ2t
	cijRaElMfW/07i7zmYl16PRVJX5z7UfGIFIuK0HbD7y67x3wv0iMox0E3CxiSZiURcXCikL+9hS
	UiA==
X-Google-Smtp-Source: AGHT+IGGImLedCWhoatJh7Lpnh+FYmKsi+kl7jwvqwXwtJA6Nyjs9rQuy2+ezLZ8cy32FZfF7VNW834Ygb4=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:f842:b0:a8a:7c56:554c with SMTP id
 a640c23a62f3a-a98f821b538mr297966b.5.1727971156437; Thu, 03 Oct 2024 08:59:16
 -0700 (PDT)
Date: Thu, 3 Oct 2024 17:59:14 +0200
In-Reply-To: <20241003143932.2431249-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com> <20241003143932.2431249-3-ivanov.mikhail1@huawei-partners.com>
Message-ID: <Zv6_Uitud0OzxKTn@google.com>
Subject: Re: [RFC PATCH v1 2/2] selftests/landlock: Test non-TCP INET
 connection-based protocols
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 03, 2024 at 10:39:32PM +0800, Mikhail Ivanov wrote:
> Extend protocol fixture with test suits for MPTCP, SCTP and SMC protocols=
.
> Add all options required by this protocols in config.
>=20
> Extend protocol_variant structure with protocol field (Cf. socket(2)).
>=20
> Refactor is_restricted() helper and add few helpers to check struct
> protocol_variant on specific protocols.
>=20
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/common.h   |   1 +
>  tools/testing/selftests/landlock/config     |   5 +
>  tools/testing/selftests/landlock/net_test.c | 212 ++++++++++++++++++--
>  3 files changed, 198 insertions(+), 20 deletions(-)
>=20
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/se=
lftests/landlock/common.h
> index 61056fa074bb..40a2def50b83 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *const _metada=
ta, const int ruleset_fd)
>  struct protocol_variant {
>  	int domain;
>  	int type;
> +	int protocol;
>  };
> =20
>  struct service_fixture {
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/self=
tests/landlock/config
> index 29af19c4e9f9..73b01d7d0881 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -1,8 +1,12 @@
>  CONFIG_CGROUPS=3Dy
>  CONFIG_CGROUP_SCHED=3Dy
>  CONFIG_INET=3Dy
> +CONFIG_INFINIBAND=3Dy
> +CONFIG_IP_SCTP=3Dy
>  CONFIG_IPV6=3Dy
>  CONFIG_KEYS=3Dy
> +CONFIG_MPTCP=3Dy
> +CONFIG_MPTCP_IPV6=3Dy
>  CONFIG_NET=3Dy
>  CONFIG_NET_NS=3Dy
>  CONFIG_OVERLAY_FS=3Dy
> @@ -10,6 +14,7 @@ CONFIG_PROC_FS=3Dy
>  CONFIG_SECURITY=3Dy
>  CONFIG_SECURITY_LANDLOCK=3Dy
>  CONFIG_SHMEM=3Dy
> +CONFIG_SMC=3Dy
>  CONFIG_SYSFS=3Dy
>  CONFIG_TMPFS=3Dy
>  CONFIG_TMPFS_XATTR=3Dy
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/=
selftests/landlock/net_test.c
> index 4e0aeb53b225..dbe77d436281 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -36,6 +36,17 @@ enum sandbox_type {
>  	TCP_SANDBOX,
>  };
> =20
> +/* Checks if IPPROTO_SMC is present for compatibility reasons. */
> +#if !defined(__alpha__) && defined(IPPROTO_SMC)
> +#define SMC_SUPPORTED 1
> +#else
> +#define SMC_SUPPORTED 0
> +#endif
> +
> +#ifndef IPPROTO_SMC
> +#define IPPROTO_SMC 256
> +#endif
> +
>  static int set_service(struct service_fixture *const srv,
>  		       const struct protocol_variant prot,
>  		       const unsigned short index)
> @@ -85,19 +96,37 @@ static void setup_loopback(struct __test_metadata *co=
nst _metadata)
>  	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
>  }
> =20
> +static bool prot_is_inet_stream(const struct protocol_variant *const pro=
t)
> +{
> +	return (prot->domain =3D=3D AF_INET || prot->domain =3D=3D AF_INET6) &&
> +	       prot->type =3D=3D SOCK_STREAM;
> +}
> +
> +static bool prot_is_tcp(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) &&
> +	       (prot->protocol =3D=3D IPPROTO_TCP || prot->protocol =3D=3D IPPR=
OTO_IP);
> +}
> +
> +static bool prot_is_sctp(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) && prot->protocol =3D=3D IPPROTO_SCTP;
> +}
> +
> +static bool prot_is_smc(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) && prot->protocol =3D=3D IPPROTO_SMC;
> +}
> +
> +static bool prot_is_unix_stream(const struct protocol_variant *const pro=
t)
> +{
> +	return prot->domain =3D=3D AF_UNIX && prot->type =3D=3D SOCK_STREAM;
> +}
> +
>  static bool is_restricted(const struct protocol_variant *const prot,
>  			  const enum sandbox_type sandbox)
>  {
> -	switch (prot->domain) {
> -	case AF_INET:
> -	case AF_INET6:
> -		switch (prot->type) {
> -		case SOCK_STREAM:
> -			return sandbox =3D=3D TCP_SANDBOX;
> -		}
> -		break;
> -	}
> -	return false;
> +	return prot_is_tcp(prot) && sandbox =3D=3D TCP_SANDBOX;
>  }
> =20
>  static int socket_variant(const struct service_fixture *const srv)
> @@ -105,7 +134,7 @@ static int socket_variant(const struct service_fixtur=
e *const srv)
>  	int ret;
> =20
>  	ret =3D socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
> -		     0);
> +		     srv->protocol.protocol);
>  	if (ret < 0)
>  		return -errno;
>  	return ret;
> @@ -124,7 +153,7 @@ static socklen_t get_addrlen(const struct service_fix=
ture *const srv,
>  		return sizeof(srv->ipv4_addr);
> =20
>  	case AF_INET6:
> -		if (minimal)
> +		if (minimal && !prot_is_sctp(&srv->protocol))
>  			return SIN6_LEN_RFC2133;
>  		return sizeof(srv->ipv6_addr);
> =20
> @@ -271,6 +300,11 @@ FIXTURE_SETUP(protocol)
>  		.type =3D SOCK_STREAM,
>  	};
> =20
> +#if !SMC_SUPPORTED
> +	if (prot_is_smc(&variant->prot))
> +		SKIP(return, "SMC protocol is not supported.");
> +#endif
> +
>  	disable_caps(_metadata);
> =20
>  	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
> @@ -299,6 +333,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_t=
cp) {
>  	},
>  };
> =20
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_sctp) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_smc) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
>  	/* clang-format on */
> @@ -309,6 +376,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_t=
cp) {
>  	},
>  };
> =20
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_sctp) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_smc) {
> +	/* clang-format on */
> +	.sandbox =3D NO_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
>  	/* clang-format on */
> @@ -359,6 +459,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_=
tcp) {
>  	},
>  };
> =20
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_sctp) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_smc) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
>  	/* clang-format on */
> @@ -369,6 +502,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_=
tcp) {
>  	},
>  };
> =20
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_sctp) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_smc) {
> +	/* clang-format on */
> +	.sandbox =3D TCP_SANDBOX,
> +	.prot =3D {
> +		.domain =3D AF_INET6,
> +		.type =3D SOCK_STREAM,
> +		.protocol =3D IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
>  	/* clang-format on */
> @@ -663,7 +829,7 @@ TEST_F(protocol, bind_unspec)
> =20
>  	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
>  	ret =3D bind_variant(bind_fd, &self->unspec_any0);
> -	if (variant->prot.domain =3D=3D AF_INET) {
> +	if (variant->prot.domain =3D=3D AF_INET && !prot_is_sctp(&variant->prot=
)) {
>  		EXPECT_EQ(0, ret)
>  		{
>  			TH_LOG("Failed to bind to unspec/any socket: %s",
> @@ -689,7 +855,7 @@ TEST_F(protocol, bind_unspec)
> =20
>  	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
>  	ret =3D bind_variant(bind_fd, &self->unspec_any0);
> -	if (variant->prot.domain =3D=3D AF_INET) {
> +	if (variant->prot.domain =3D=3D AF_INET && !prot_is_sctp(&variant->prot=
)) {
>  		if (is_restricted(&variant->prot, variant->sandbox)) {
>  			EXPECT_EQ(-EACCES, ret);
>  		} else {
> @@ -727,6 +893,10 @@ TEST_F(protocol, connect_unspec)
>  	int bind_fd, client_fd, status;
>  	pid_t child;
> =20
> +	if (prot_is_smc(&variant->prot))
> +		SKIP(return, "SMC does not properly handles disconnect "
> +			     "in the case of fallback to TCP");
> +
>  	/* Specific connection tests. */
>  	bind_fd =3D socket_variant(&self->srv0);
>  	ASSERT_LE(0, bind_fd);
> @@ -769,17 +939,18 @@ TEST_F(protocol, connect_unspec)
> =20
>  		/* Disconnects already connected socket, or set peer. */
>  		ret =3D connect_variant(connect_fd, &self->unspec_any0);
> -		if (self->srv0.protocol.domain =3D=3D AF_UNIX &&
> -		    self->srv0.protocol.type =3D=3D SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot)) {
>  			EXPECT_EQ(-EINVAL, ret);
> +		} else if (prot_is_sctp(&variant->prot)) {
> +			EXPECT_EQ(-EOPNOTSUPP, ret);
>  		} else {
>  			EXPECT_EQ(0, ret);
>  		}
> =20
>  		/* Tries to reconnect, or set peer. */
>  		ret =3D connect_variant(connect_fd, &self->srv0);
> -		if (self->srv0.protocol.domain =3D=3D AF_UNIX &&
> -		    self->srv0.protocol.type =3D=3D SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot) ||
> +		    prot_is_sctp(&variant->prot)) {
>  			EXPECT_EQ(-EISCONN, ret);
>  		} else {
>  			EXPECT_EQ(0, ret);
> @@ -796,9 +967,10 @@ TEST_F(protocol, connect_unspec)
>  		}
> =20
>  		ret =3D connect_variant(connect_fd, &self->unspec_any0);
> -		if (self->srv0.protocol.domain =3D=3D AF_UNIX &&
> -		    self->srv0.protocol.type =3D=3D SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot)) {
>  			EXPECT_EQ(-EINVAL, ret);
> +		} else if (prot_is_sctp(&variant->prot)) {
> +			EXPECT_EQ(-EOPNOTSUPP, ret);
>  		} else {
>  			/* Always allowed to disconnect. */
>  			EXPECT_EQ(0, ret);
> --=20
> 2.34.1
>=20

Looks good.

Reviewed-by: G=C3=BCnther Noack <gnoack@google.com>
