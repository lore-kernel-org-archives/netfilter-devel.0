Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEE1514F8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727977551; cv=none; b=ptCjHKp7O6Fkvl3PeFIWSb0zhdqtynnnoa2mqOpSRk7jtFx+hSvEKoGhxh8FmZwsizjuU/6SdVRV9BAh8gouNxxBCVfnreB2qrpihnk4ct8IGuTn0Zhg7YHXxgTHDjH0VySCylB5uYF7Pl2u4217HZu84iXBH+V/edwPva7ziCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727977551; c=relaxed/simple;
	bh=hu8CecOoCGB6rGgV1dUhdJar5G+7XjvsEGZEp3H+bcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErGr3fJxeKoi/DB2P6kejgs9fZfdU7M+p2Fgm/7SAiSiLurmuTuX8+9KRX6Bsne8jhkeU58WqhBc1qXX1YT+R+8g6cClUUiliUwYaoO5uDtv7qIWqy1XgCDA23fXDuuv6z+TK7lzFHHhR7nr5psQY55wagnZK1Lst7BiXFKFKl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=z6rgAMth; arc=none smtp.client-ip=83.166.143.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="z6rgAMth"
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XKJxH2PqzzkJl;
	Thu,  3 Oct 2024 19:45:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1727977539;
	bh=Yd3ek34FWhLGnx72t2ZzSsiYYJevz0Okk9cjED4OEsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z6rgAMthg5wNHODdVq4mkEAQ+Ivnh3T77UGW7Sbs/vAe/lgVJ2O/waMgREfpeX30d
	 vUZjMo4A16lCPvvyl8pucXJpgZtVWXfiNW18109fjyhjC0sGyJ63ivAwkPpyyVAWuR
	 nb2jlOoYYMgqMNtAgl+Dk0Ogk9lcSUkFP2Azr6Ig=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4XKJxG5Y8Dzl6K;
	Thu,  3 Oct 2024 19:45:38 +0200 (CEST)
Date: Thu, 3 Oct 2024 19:45:36 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 2/2] selftests/landlock: Test non-TCP INET
 connection-based protocols
Message-ID: <20241003.ietiejo3juF9@digikod.net>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241003143932.2431249-3-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Thu, Oct 03, 2024 at 10:39:32PM +0800, Mikhail Ivanov wrote:
> Extend protocol fixture with test suits for MPTCP, SCTP and SMC protocols.
> Add all options required by this protocols in config.

Great coverage!  It's nice to check against SCTP and MPTCP, but as you
were wondering, I think you can remove the SMC protocol to simplify
tests. MPTCP seems to work similarly as TCP wrt AF_UNSPEC, so it might
be worth keeping it, and we might want to control these protocols too
one day.

> 
> Extend protocol_variant structure with protocol field (Cf. socket(2)).
> 
> Refactor is_restricted() helper and add few helpers to check struct
> protocol_variant on specific protocols.

> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/common.h   |   1 +
>  tools/testing/selftests/landlock/config     |   5 +
>  tools/testing/selftests/landlock/net_test.c | 212 ++++++++++++++++++--
>  3 files changed, 198 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index 61056fa074bb..40a2def50b83 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -234,6 +234,7 @@ enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
>  struct protocol_variant {
>  	int domain;
>  	int type;
> +	int protocol;
>  };
>  
>  struct service_fixture {
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
> index 29af19c4e9f9..73b01d7d0881 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -1,8 +1,12 @@
>  CONFIG_CGROUPS=y
>  CONFIG_CGROUP_SCHED=y
>  CONFIG_INET=y
> +CONFIG_INFINIBAND=y

Without SMC this infiniband should not be required.

> +CONFIG_IP_SCTP=y
>  CONFIG_IPV6=y
>  CONFIG_KEYS=y
> +CONFIG_MPTCP=y
> +CONFIG_MPTCP_IPV6=y
>  CONFIG_NET=y
>  CONFIG_NET_NS=y
>  CONFIG_OVERLAY_FS=y
> @@ -10,6 +14,7 @@ CONFIG_PROC_FS=y
>  CONFIG_SECURITY=y
>  CONFIG_SECURITY_LANDLOCK=y
>  CONFIG_SHMEM=y
> +CONFIG_SMC=y
>  CONFIG_SYSFS=y
>  CONFIG_TMPFS=y
>  CONFIG_TMPFS_XATTR=y
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 4e0aeb53b225..dbe77d436281 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -36,6 +36,17 @@ enum sandbox_type {
>  	TCP_SANDBOX,
>  };
>  
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
> @@ -85,19 +96,37 @@ static void setup_loopback(struct __test_metadata *const _metadata)
>  	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
>  }
>  
> +static bool prot_is_inet_stream(const struct protocol_variant *const prot)
> +{
> +	return (prot->domain == AF_INET || prot->domain == AF_INET6) &&
> +	       prot->type == SOCK_STREAM;
> +}
> +
> +static bool prot_is_tcp(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) &&
> +	       (prot->protocol == IPPROTO_TCP || prot->protocol == IPPROTO_IP);

Why do we need to check against IPPROTO_IP?

> +}
> +
> +static bool prot_is_sctp(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SCTP;
> +}
> +
> +static bool prot_is_smc(const struct protocol_variant *const prot)
> +{
> +	return prot_is_inet_stream(prot) && prot->protocol == IPPROTO_SMC;
> +}
> +
> +static bool prot_is_unix_stream(const struct protocol_variant *const prot)
> +{
> +	return prot->domain == AF_UNIX && prot->type == SOCK_STREAM;
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
> -			return sandbox == TCP_SANDBOX;
> -		}
> -		break;
> -	}
> -	return false;
> +	return prot_is_tcp(prot) && sandbox == TCP_SANDBOX;
>  }
>  
>  static int socket_variant(const struct service_fixture *const srv)
> @@ -105,7 +134,7 @@ static int socket_variant(const struct service_fixture *const srv)
>  	int ret;
>  
>  	ret = socket(srv->protocol.domain, srv->protocol.type | SOCK_CLOEXEC,
> -		     0);
> +		     srv->protocol.protocol);
>  	if (ret < 0)
>  		return -errno;
>  	return ret;
> @@ -124,7 +153,7 @@ static socklen_t get_addrlen(const struct service_fixture *const srv,
>  		return sizeof(srv->ipv4_addr);
>  
>  	case AF_INET6:
> -		if (minimal)
> +		if (minimal && !prot_is_sctp(&srv->protocol))

Why SCTP requires this exception?

>  			return SIN6_LEN_RFC2133;
>  		return sizeof(srv->ipv6_addr);
>  
> @@ -271,6 +300,11 @@ FIXTURE_SETUP(protocol)
>  		.type = SOCK_STREAM,
>  	};
>  
> +#if !SMC_SUPPORTED
> +	if (prot_is_smc(&variant->prot))
> +		SKIP(return, "SMC protocol is not supported.");
> +#endif
> +
>  	disable_caps(_metadata);
>  
>  	ASSERT_EQ(0, set_service(&self->srv0, variant->prot, 0));
> @@ -299,6 +333,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_tcp) {
>  	},
>  };
>  
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_sctp) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_smc) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
>  	/* clang-format on */
> @@ -309,6 +376,39 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_tcp) {
>  	},
>  };
>  
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_sctp) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_smc) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
>  	/* clang-format on */
> @@ -359,6 +459,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_tcp) {
>  	},
>  };
>  
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_sctp) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_smc) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
>  	/* clang-format on */
> @@ -369,6 +502,39 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_tcp) {
>  	},
>  };
>  
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_MPTCP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_sctp) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SCTP,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_smc) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +		.protocol = IPPROTO_SMC,
> +	},
> +};
> +
>  /* clang-format off */
>  FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_udp) {
>  	/* clang-format on */
> @@ -663,7 +829,7 @@ TEST_F(protocol, bind_unspec)
>  
>  	/* Allowed bind on AF_UNSPEC/INADDR_ANY. */
>  	ret = bind_variant(bind_fd, &self->unspec_any0);
> -	if (variant->prot.domain == AF_INET) {
> +	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {
>  		EXPECT_EQ(0, ret)
>  		{
>  			TH_LOG("Failed to bind to unspec/any socket: %s",
> @@ -689,7 +855,7 @@ TEST_F(protocol, bind_unspec)
>  
>  	/* Denied bind on AF_UNSPEC/INADDR_ANY. */
>  	ret = bind_variant(bind_fd, &self->unspec_any0);
> -	if (variant->prot.domain == AF_INET) {
> +	if (variant->prot.domain == AF_INET && !prot_is_sctp(&variant->prot)) {

It looks like we need the same exception for the next bind_variant()
call.

>  		if (is_restricted(&variant->prot, variant->sandbox)) {
>  			EXPECT_EQ(-EACCES, ret);
>  		} else {
> @@ -727,6 +893,10 @@ TEST_F(protocol, connect_unspec)
>  	int bind_fd, client_fd, status;
>  	pid_t child;
>  
> +	if (prot_is_smc(&variant->prot))
> +		SKIP(return, "SMC does not properly handles disconnect "
> +			     "in the case of fallback to TCP");
> +
>  	/* Specific connection tests. */
>  	bind_fd = socket_variant(&self->srv0);
>  	ASSERT_LE(0, bind_fd);
> @@ -769,17 +939,18 @@ TEST_F(protocol, connect_unspec)
>  
>  		/* Disconnects already connected socket, or set peer. */
>  		ret = connect_variant(connect_fd, &self->unspec_any0);
> -		if (self->srv0.protocol.domain == AF_UNIX &&
> -		    self->srv0.protocol.type == SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot)) {
>  			EXPECT_EQ(-EINVAL, ret);
> +		} else if (prot_is_sctp(&variant->prot)) {
> +			EXPECT_EQ(-EOPNOTSUPP, ret);
>  		} else {
>  			EXPECT_EQ(0, ret);
>  		}
>  
>  		/* Tries to reconnect, or set peer. */
>  		ret = connect_variant(connect_fd, &self->srv0);
> -		if (self->srv0.protocol.domain == AF_UNIX &&
> -		    self->srv0.protocol.type == SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot) ||
> +		    prot_is_sctp(&variant->prot)) {
>  			EXPECT_EQ(-EISCONN, ret);
>  		} else {
>  			EXPECT_EQ(0, ret);
> @@ -796,9 +967,10 @@ TEST_F(protocol, connect_unspec)
>  		}
>  
>  		ret = connect_variant(connect_fd, &self->unspec_any0);
> -		if (self->srv0.protocol.domain == AF_UNIX &&
> -		    self->srv0.protocol.type == SOCK_STREAM) {
> +		if (prot_is_unix_stream(&variant->prot)) {
>  			EXPECT_EQ(-EINVAL, ret);
> +		} else if (prot_is_sctp(&variant->prot)) {
> +			EXPECT_EQ(-EOPNOTSUPP, ret);
>  		} else {
>  			/* Always allowed to disconnect. */
>  			EXPECT_EQ(0, ret);
> -- 
> 2.34.1
> 
> 
