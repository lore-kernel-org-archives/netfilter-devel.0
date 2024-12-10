Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32F23ED59
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733854607; cv=none; b=Jlf/t8mJ1pmr6hY2eP7oPRGdCpUCg7DJ4U4wgJslzzBlcFAeg2gEJ9Hx4SYJ1SoPQBvUs2RsaaVKgJMF8wWcZz6c+QXeqjrpt54Uy4BvypzA6oM4b4m6pgk3rh2M2LeTY5LQ4E1EYj5n/GAOjelxbx5JKp7grjp//VsB+5ZyAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733854607; c=relaxed/simple;
	bh=NqfxkG/7sDfuD2iQWZbKeWB/av0z90N16l7n7J8JPOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idZySeDsfvU+qHW0d8vdDELO36/ezvoNV0iCsqaGqQUvLX1m/iZ7up+KGWiZhXgVvSQSkGq/aoAAeNHYGjadWK3raX98CkV6/z22eG/TRKrxo90+tfwcGuVT9Yldo8pIWB41/+Kzl8frHqRWpHTb2wleeoBXIQPQ5gs1Embphhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=oH9uhwqa; arc=none smtp.client-ip=83.166.143.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="oH9uhwqa"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y76CF3g1SzmYc;
	Tue, 10 Dec 2024 19:07:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733854057;
	bh=6LgOitHB3nVKvCSnANMTHsIe8bCpQDN4V883/D8N1Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oH9uhwqas6rfxPkd9kTzIuuXWpoVbPLCaBGBwMbQ6M6lmiZN3lUr9njLY1jszqPaD
	 zuw+0GzAVJsUJuhFSMbktmnpP48rda4UlU2KyQaf/RymbwPEC+M/R9FrRSiHLqoJ7j
	 GuVWZ9kT1USa4y/tfWDS6VEdqhH9pKb886zP2c8s=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y76CD4qqDzVNM;
	Tue, 10 Dec 2024 19:07:36 +0100 (CET)
Date: Tue, 10 Dec 2024 19:07:33 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, 
	Paul Moore <paul@paul-moore.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 6/8] selftests/landlock: Test consistency of
 errors for TCP actions
Message-ID: <20241210.ahg9Zawoobie@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-7-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241017110454.265818-7-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Thu, Oct 17, 2024 at 07:04:52PM +0800, Mikhail Ivanov wrote:
> Add tcp_errors_consistency fixture for TCP errors consistency tests.
> 
> Add 6 test suits for this fixture to configure tested address family of
> socket (ipv4 or ipv6), sandboxed mode and whether TCP action is allowed
> in a sandboxed mode.
> 
> Add tests which validate errors consistency provided by Landlock for
> bind(2) and connect(2) restrictable TCP actions.
> 
> Add sys_bind(), sys_connect() helpers for convenient checks of bind(2)
> and connect(2). Add set_ipv4_tcp_address(), set_ipv6_tcp_address()
> helpers.
> 
> Add CONFIG_LSM="landlock" option in config. Some LSMs (e.g. SElinux)
> can be loaded before Landlock and return inconsistent error code for
> bind(2) and connect(2) calls.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/config     |   1 +
>  tools/testing/selftests/landlock/net_test.c | 329 +++++++++++++++++++-
>  2 files changed, 324 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
> index a8982da4acbd..52988e8a56cc 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -3,6 +3,7 @@ CONFIG_CGROUP_SCHED=y
>  CONFIG_INET=y
>  CONFIG_IPV6=y
>  CONFIG_KEYS=y
> +CONFIG_LSM="landlock"

We should not force CONFIG_LSM because we may want to test Landlock with
other LSMs.

For now, I think we should ignore wrong error codes that may be returned
by other LSMs but send this patch with a patch series fixing the LSM
framework as a whole.  Feel free to include these patches too:
https://lore.kernel.org/all/20240327120036.233641-1-mic@digikod.net/

>  CONFIG_MPTCP=y
>  CONFIG_MPTCP_IPV6=y
>  CONFIG_NET=y
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index d9de0ee49ebc..30b29bf10bdc 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -36,6 +36,22 @@ enum sandbox_type {
>  	TCP_SANDBOX,
>  };
>  
> +static void set_ipv4_tcp_address(const struct service_fixture *const srv,
> +				 struct sockaddr_in *ipv4_addr)
> +{
> +	ipv4_addr->sin_family = srv->protocol.domain;
> +	ipv4_addr->sin_port = htons(srv->port);
> +	ipv4_addr->sin_addr.s_addr = inet_addr(loopback_ipv4);
> +}
> +
> +static void set_ipv6_tcp_address(const struct service_fixture *const srv,
> +				 struct sockaddr_in6 *ipv6_addr)
> +{
> +	ipv6_addr->sin6_family = srv->protocol.domain;
> +	ipv6_addr->sin6_port = htons(srv->port);
> +	inet_pton(AF_INET6, loopback_ipv6, &ipv6_addr->sin6_addr);
> +}
> +
>  static int set_service(struct service_fixture *const srv,
>  		       const struct protocol_variant prot,
>  		       const unsigned short index)
> @@ -56,15 +72,11 @@ static int set_service(struct service_fixture *const srv,
>  	switch (prot.domain) {
>  	case AF_UNSPEC:
>  	case AF_INET:
> -		srv->ipv4_addr.sin_family = prot.domain;
> -		srv->ipv4_addr.sin_port = htons(srv->port);
> -		srv->ipv4_addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
> +		set_ipv4_tcp_address(srv, &srv->ipv4_addr);
>  		return 0;
>  
>  	case AF_INET6:
> -		srv->ipv6_addr.sin6_family = prot.domain;
> -		srv->ipv6_addr.sin6_port = htons(srv->port);
> -		inet_pton(AF_INET6, loopback_ipv6, &srv->ipv6_addr.sin6_addr);
> +		set_ipv6_tcp_address(srv, &srv->ipv6_addr);
>  		return 0;
>  
>  	case AF_UNIX:
> @@ -181,6 +193,17 @@ static uint16_t get_binded_port(int socket_fd,
>  	}
>  }
>  
> +static int sys_bind(const int sock_fd, const struct sockaddr *addr,
> +		    socklen_t addrlen)
> +{
> +	int ret;
> +
> +	ret = bind(sock_fd, addr, addrlen);
> +	if (ret < 0)
> +		return -errno;
> +	return 0;
> +}
> +
>  static int bind_variant_addrlen(const int sock_fd,
>  				const struct service_fixture *const srv,
>  				const socklen_t addrlen)
> @@ -217,6 +240,17 @@ static int bind_variant(const int sock_fd,
>  	return bind_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
>  }
>  
> +static int sys_connect(const int sock_fd, const struct sockaddr *addr,
> +		       socklen_t addrlen)
> +{
> +	int ret;
> +
> +	ret = connect(sock_fd, addr, addrlen);
> +	if (ret < 0)
> +		return -errno;
> +	return 0;
> +}
> +
>  static int connect_variant_addrlen(const int sock_fd,
>  				   const struct service_fixture *const srv,
>  				   const socklen_t addrlen)
> @@ -923,6 +957,289 @@ TEST_F(protocol, connect_unspec)
>  	EXPECT_EQ(0, close(bind_fd));
>  }
>  
> +FIXTURE(tcp_errors_consistency)
> +{
> +	struct service_fixture srv0, srv1;
> +	struct sockaddr *inval_addr_p0;
> +	socklen_t addrlen_min;
> +
> +	struct sockaddr_in inval_ipv4_addr;
> +	struct sockaddr_in6 inval_ipv6_addr;
> +};
> +
> +FIXTURE_VARIANT(tcp_errors_consistency)
> +{
> +	const enum sandbox_type sandbox;
> +	const int domain;
> +	bool allowed;
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, no_sandbox_with_ipv4) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.domain = AF_INET,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, no_sandbox_with_ipv6) {
> +	/* clang-format on */
> +	.sandbox = NO_SANDBOX,
> +	.domain = AF_INET6,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, denied_with_ipv4) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.domain = AF_INET,
> +	.allowed = false,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, allowed_with_ipv4) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.domain = AF_INET,
> +	.allowed = true,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, denied_with_ipv6) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.domain = AF_INET6,
> +	.allowed = false,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(tcp_errors_consistency, allowed_with_ipv6) {
> +	/* clang-format on */
> +	.sandbox = TCP_SANDBOX,
> +	.domain = AF_INET6,
> +	.allowed = true,
> +};
> +
> +FIXTURE_SETUP(tcp_errors_consistency)
> +{
> +	const struct protocol_variant tcp_prot = {
> +		.domain = variant->domain,
> +		.type = SOCK_STREAM,
> +	};
> +
> +	disable_caps(_metadata);
> +
> +	set_service(&self->srv0, tcp_prot, 0);
> +	set_service(&self->srv1, tcp_prot, 1);
> +
> +	if (variant->domain == AF_INET) {
> +		set_ipv4_tcp_address(&self->srv0, &self->inval_ipv4_addr);
> +		self->inval_ipv4_addr.sin_family = AF_INET6;
> +
> +		self->inval_addr_p0 = (struct sockaddr *)&self->inval_ipv4_addr;
> +		self->addrlen_min = sizeof(struct sockaddr_in);
> +	} else {
> +		set_ipv6_tcp_address(&self->srv0, &self->inval_ipv6_addr);
> +		self->inval_ipv6_addr.sin6_family = AF_INET;
> +
> +		self->inval_addr_p0 = (struct sockaddr *)&self->inval_ipv6_addr;
> +		self->addrlen_min = SIN6_LEN_RFC2133;
> +	}
> +
> +	setup_loopback(_metadata);
> +};
> +
> +FIXTURE_TEARDOWN(tcp_errors_consistency)
> +{
> +}
> +
> +/*
> + * Validates that Landlock provides errors consistency for bind(2) operation
> + * (not restricted, allowed and denied).
> + *
> + * Error consistency implies that in sandboxed process, bind(2) returns the same
> + * errors and in the same order (assuming multiple errors) as during normal
> + * execution.
> + */
> +TEST_F(tcp_errors_consistency, bind)
> +{
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		if (variant->allowed) {
> +			const struct landlock_net_port_attr tcp_bind_p0 = {
> +				.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +				.port = self->srv0.port,
> +			};
> +
> +			/* Allows bind for the first port. */
> +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +						       LANDLOCK_RULE_NET_PORT,
> +						       &tcp_bind_p0, 0));
> +		}
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +	int sock_fd;
> +
> +	sock_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, sock_fd);
> +
> +	/*
> +	 * Tries to bind socket to address with invalid sa_family value
> +	 * (AF_INET for ipv6 socket and AF_INET6 for ipv4 socket).
> +	 */
> +	EXPECT_EQ(-EAFNOSUPPORT,
> +		  sys_bind(sock_fd, self->inval_addr_p0, self->addrlen_min));
> +
> +	if (variant->domain == AF_INET) {
> +		struct sockaddr_in ipv4_unspec_addr;
> +
> +		set_ipv4_tcp_address(&self->srv0, &ipv4_unspec_addr);
> +		ipv4_unspec_addr.sin_family = AF_UNSPEC;
> +		/*
> +		 * Ipv4 bind(2) accepts AF_UNSPEC family in address only if address is
> +		 * INADDR_ANY. Otherwise, returns -EAFNOSUPPORT.
> +		 */
> +		EXPECT_EQ(-EAFNOSUPPORT,
> +			  sys_bind(sock_fd,
> +				   (struct sockaddr *)&ipv4_unspec_addr,
> +				   self->addrlen_min));
> +	}
> +
> +	/* Tries to bind with too small addrlen (Cf. inet_bind_sk). */
> +	EXPECT_EQ(-EINVAL, sys_bind(sock_fd, self->inval_addr_p0,
> +				    self->addrlen_min - 1));
> +
> +	ASSERT_EQ(0, close(sock_fd));
> +}
> +
> +/*
> + * Validates that Landlock provides errors consistency for connect(2) operation
> + * (not restricted, allowed and denied).
> + *
> + * Error consistency implies that in sandboxed process, connect(2) returns the
> + * same errors and in the same order (assuming multiple errors) as during normal
> + * execution.
> + */
> +TEST_F(tcp_errors_consistency, connect)
> +{
> +	int nonblock_p0_fd;
> +
> +	nonblock_p0_fd = socket(variant->domain,
> +				SOCK_STREAM | SOCK_CLOEXEC | SOCK_NONBLOCK, 0);
> +	ASSERT_LE(0, nonblock_p0_fd);
> +
> +	/* Tries to connect nonblocking socket before establishing ruleset. */
> +	ASSERT_EQ(-EINPROGRESS, connect_variant(nonblock_p0_fd, &self->srv0));
> +
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		};
> +		const struct landlock_net_port_attr tcp_connect_p1 = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +			.port = self->srv1.port,
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Allows connect for the second port. */
> +		ASSERT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_connect_p1, 0));
> +
> +		if (variant->allowed) {
> +			const struct landlock_net_port_attr tcp_connect_p0 = {
> +				.allowed_access =
> +					LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +				.port = self->srv0.port,
> +			};
> +
> +			/* Allows connect for the first port. */
> +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +						       LANDLOCK_RULE_NET_PORT,
> +						       &tcp_connect_p0, 0));
> +		}
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +	int client_p0_fd, client_p1_fd, server_p0_fd, server_p1_fd;
> +
> +	client_p0_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, client_p0_fd);
> +	/*
> +	 * Tries to connect socket to address with invalid sa_family value
> +	 * (AF_INET for ipv6 socket and AF_INET6 for ipv4 socket).
> +	 */
> +	EXPECT_EQ(-EAFNOSUPPORT, sys_connect(client_p0_fd, self->inval_addr_p0,
> +					     self->addrlen_min));
> +
> +	/* Tries to connect with too small addrlen. */
> +	EXPECT_EQ(-EINVAL, sys_connect(client_p0_fd, self->inval_addr_p0,
> +				       self->addrlen_min - 1));
> +
> +	/* Creates socket listening on zero port. */
> +	server_p0_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, server_p0_fd);
> +
> +	ASSERT_EQ(0, bind_variant(server_p0_fd, &self->srv0));
> +	ASSERT_EQ(0, listen(server_p0_fd, backlog));
> +	/* Tries to connect listening socket. */
> +	EXPECT_EQ(-EISCONN, sys_connect(server_p0_fd, self->inval_addr_p0,
> +					self->addrlen_min - 1));
> +
> +	/* Creates socket listening on first port. */
> +	server_p1_fd = socket_variant(&self->srv1);
> +	ASSERT_LE(0, server_p1_fd);
> +
> +	ASSERT_EQ(0, bind_variant(server_p1_fd, &self->srv1));
> +	ASSERT_EQ(0, listen(server_p1_fd, backlog));
> +
> +	client_p1_fd = socket_variant(&self->srv1);
> +	ASSERT_LE(0, client_p1_fd);
> +
> +	/* Connects to server_p1_fd. */
> +	ASSERT_EQ(0, connect_variant(client_p1_fd, &self->srv1));
> +	/* Tries to connect already connected socket. */
> +	EXPECT_EQ(-EISCONN, sys_connect(client_p1_fd, self->inval_addr_p0,
> +					self->addrlen_min - 1));
> +
> +	/*
> +	 * connect(2) is called upon nonblocking socket and previous connection
> +	 * attempt was closed by RST packet. Landlock cannot provide error
> +	 * consistency in this case (Cf. check_tcp_connect_consistency_and_get_port()).
> +	 */
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		EXPECT_EQ(-EACCES,
> +			  connect_variant(nonblock_p0_fd, &self->srv0));
> +	} else {
> +		EXPECT_EQ(-ECONNREFUSED,
> +			  connect_variant(nonblock_p0_fd, &self->srv0));
> +	}
> +
> +	/* Tries to connect with zero as addrlen. */
> +	EXPECT_EQ(-EINVAL, sys_connect(client_p0_fd, self->inval_addr_p0, 0));
> +
> +	ASSERT_EQ(0, close(client_p1_fd));
> +	ASSERT_EQ(0, close(server_p1_fd));
> +	ASSERT_EQ(0, close(server_p0_fd));
> +	ASSERT_EQ(0, close(client_p0_fd));
> +	ASSERT_EQ(0, close(nonblock_p0_fd));
> +}
> +
>  FIXTURE(ipv4)
>  {
>  	struct service_fixture srv0, srv1;
> -- 
> 2.34.1
> 
> 
