Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819E1171E45
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714484212; cv=none; b=nQsAog3/LiJ7Ra48z0TOOHFzPWtsoNssrnP4XQDw0Z1m9ApxSaCWXvjm670M3yT4yJ2swBuBrRMlohxz27h+wEWLFOhQbPcHyqpr+N8zQe4+QXUjkAIta5LLBAp+S+OjAPa6aerCSr87C4W0EFhzElWaNNALIIGpqk6wt2M+xUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714484212; c=relaxed/simple;
	bh=2kb1NEv9MrJKyS+P6Z0fwlozV1tz+fFJTPpEA1OsNAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMkqLIzFbMISu/q0HB3i/pilEm6NtMcqhOhryvzMgdjP5SnE1070eLSeTiWzmZdIoJkulQ7kABM51PZYOI5gd7s1coE4ZS4cdHvRX+3VKrzm4t8BiHbUCJWHwYd0cOH1kgE0DIgk81TyHrTzMlHvmWHma4zYh50uhseYU5kbRKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=oT6l7mjN; arc=none smtp.client-ip=185.125.25.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="oT6l7mjN"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VTLp42R7GzSTs;
	Tue, 30 Apr 2024 15:36:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714484204;
	bh=2kb1NEv9MrJKyS+P6Z0fwlozV1tz+fFJTPpEA1OsNAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oT6l7mjNCAfs9f9AJtweRfJAl0SZUgOcAzrCyxFPQmZRiZK0y2g0DpqEljd6RetXm
	 FVK0bme6LRxqDmfaDWPMUgln99OUBEelzUZdI47NywZ6i2dBXc4PaBW5TjFBOtU3pV
	 3ViHwe40Zehc8J36dmnfZalfYJVjEyzXAXZV6DXQ=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VTLp36KLpzwvZ;
	Tue, 30 Apr 2024 15:36:43 +0200 (CEST)
Date: Tue, 30 Apr 2024 15:36:43 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Subject: Re: [PATCH 2/2] selftests/landlock: Create 'listen_zero',
 'deny_listen_zero' tests
Message-ID: <20240430.ohruCa7giToo@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240408094747.1761850-3-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

The subject should be something like:
"selftests/landlock: Test listening on socket without binding"

On Mon, Apr 08, 2024 at 05:47:47PM +0800, Ivanov Mikhail wrote:
> Suggested code test scenarios where listen(2) call without explicit
> bind(2) is allowed and forbidden.
> 
> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>  tools/testing/selftests/landlock/net_test.c | 89 +++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 936cfc879f1d..6d6b5aef387f 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -1714,6 +1714,95 @@ TEST_F(port_specific, bind_connect_zero)
>  	EXPECT_EQ(0, close(bind_fd));
>  }
>  
> +TEST_F(port_specific, listen_zero)
> +{
> +	int listen_fd, connect_fd;
> +	uint16_t port;
> +
> +	/* Adds a rule layer with bind actions. */
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		};
> +		const struct landlock_net_port_attr tcp_bind_zero = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +			.port = 0,
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Checks zero port value on bind action. */
> +		EXPECT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_bind_zero, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	listen_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +
> +	connect_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +	/*
> +	 * Allow listen(2) to select a random port for the socket,
> +	 * since bind(2) wasn't called.
> +	 */
> +	EXPECT_EQ(0, listen(listen_fd, backlog));
> +
> +	/* Sets binded (by listen(2)) port for both protocol families. */
> +	port = get_binded_port(listen_fd, &variant->prot);
> +	EXPECT_NE(0, port);
> +	set_port(&self->srv0, port);
> +
> +	/* Connects on the binded port. */
> +	EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
> +
> +	EXPECT_EQ(0, close(listen_fd));
> +	EXPECT_EQ(0, close(connect_fd));
> +}
> +
> +TEST_F(port_specific, deny_listen_zero)
> +{
> +	int listen_fd, ret;
> +
> +	/* Adds a rule layer with bind actions. */
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
> +		/* Forbid binding to any port. */
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	listen_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +	/* 

nit: Extra space

> +	 * Check that listen(2) call is prohibited without first calling bind(2).

This should fit in 80 columns.

> +	 */
> +	ret = listen(listen_fd, backlog);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Denied by Landlock. */
> +		EXPECT_NE(0, ret);
> +		EXPECT_EQ(EACCES, errno);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +
> +	EXPECT_EQ(0, close(listen_fd));
> +}

These tests look good!

> +
>  TEST_F(port_specific, bind_connect_1023)
>  {
>  	int bind_fd, connect_fd, ret;
> -- 
> 2.34.1
> 
> 
