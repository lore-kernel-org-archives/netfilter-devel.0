Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2C518DF6F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 13:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724158957; cv=none; b=cNfK5PXmmYMsAtIMkoCa+08ty0MtxGoOZKdhwgN9JQ4Jykem0nlqMYQmhPMQCQqs1ygwSMXVefqj7W3xDw9dVLw5aeRngiuUY3vgLYcF4AiDTZWJrg1OALE6wvRMQ6lYx3lPQNF4fWoyo62x3a6M/fRefcM/TkHcf965sPqHXLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724158957; c=relaxed/simple;
	bh=nCzMRGlo1hLxPcT+mtDFksiwrIQ/bdUP6HbK+zoJmeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ttP+kfwEC0azoK6af11JDDNmbphh3Z2l0hdFqdfpxhXsxKZRV47VvyQF7yFew6k8PVHQb+VMpnIZh9FNuGGIFT1u/CCCvvu+cpsfyYZcdPId4WKwmwzeEeQrO3MgaeyEQq5PgvGjePg4vifTUtjILKpfSojZHtR4RquaYsW9DOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yjWdjhdQ; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yjWdjhdQ"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a7d2d414949so428503366b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 06:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724158954; x=1724763754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXABJiHoMlyY3OaJbpW4PBh0OFZruP2cOuAYtilLvGk=;
        b=yjWdjhdQF/LuYz/nDarJRwcyhELF1O7tWY19GzmybXwU/q0bARAIgiMa1qmG/V/Vms
         fTITH9YXlDSFtyABzPZxagQEEISBGLfIvTSIXXrHNX7Nhgix25eJ9T29NxlnkD/vY68i
         OyXWaLvJmb9RYxdXUZvFOJMQoSme2+Cmd1YhSv5/o4anqLMhZX0ujuKdaAe7nIsn1cZY
         KnVGxW6OofzpQokcwsu8M7V4mF+2F7PG3k/Qnflld3ZgCWXHkIj19iobrFKdTAqVYA9n
         ev3Bi6s3N5Zws3T86r31UTlnK0xDjC/jRscEDnwyyCYWAfPCkHEtes7rvF9zrKnZbrNt
         BH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724158954; x=1724763754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXABJiHoMlyY3OaJbpW4PBh0OFZruP2cOuAYtilLvGk=;
        b=AX9XUeXRDlmmu9XfneFD6/rHpgteHldWsb7ktNnFJ2kKExBbmb7SBusbecrXLL7fdz
         b+4JZF1ZrRyqbVc4/UX7L7Dv7C11Tk1iiVXs29an2FZpBjNjsBGpngtkCFNjuWeejlND
         6RNfgCPnida5BkXrcYanQaGzkb3lGaNBPV0/rJF+qGu8g+AMUIaPXbXJuk4aj1QCJMJj
         nLBXrqv6eExwhyFPkUvrF/GypKwZaQrmWrRM9OvkX0PKFU8X7NHEZ4VW7RZwFhNEI+Qo
         pZCkmwCkt5gb8OfCU+Lmrp+BNdDKGQyxEbd7AdAfATB0fquojb02PY4smmhUkLjj8VO3
         AR3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZeWFM5y2dvAp7ZBRD2BuUPa+jN5FDhGZBAz4lv9wfXdmR4rvn50L1oQNRVM0Ffk0rTBxAfsdl7lIdfd3dirw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt8HQ9EAZnBQ7oa1mPeQebXRGLx5DSqOCV17rofHtqD9zMYRMk
	ImbAPmuUNTJ4zaQZhQdCXepFb6peCouUu8UBRbWdbvyr5bQ1XLV+yVj2IIZ1THgzvWuf9AVBUWl
	x/A==
X-Google-Smtp-Source: AGHT+IGpqNzD8f22S0nBAMoR+qGi2YC0P1pmjeA6oVWDLRjXL1FDhDBfBouvbrfCFfwIBheLAbfT0yBJvLY=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a17:906:f158:b0:a7a:859e:fa83 with SMTP id
 a640c23a62f3a-a8392a05303mr1103866b.9.1724158954049; Tue, 20 Aug 2024
 06:02:34 -0700 (PDT)
Date: Tue, 20 Aug 2024 15:02:32 +0200
In-Reply-To: <20240814030151.2380280-7-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com> <20240814030151.2380280-7-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZsST6Nk3Bf8F5lmJ@google.com>
Subject: Re: [RFC PATCH v2 6/9] selftests/landlock: Test listening without
 explicit bind restriction
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"

On Wed, Aug 14, 2024 at 11:01:48AM +0800, Mikhail Ivanov wrote:
> Test scenarios where listen(2) call without explicit bind(2) is allowed
> and forbidden.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/net_test.c | 83 +++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index 551891b18b7a..92c042349596 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -1851,6 +1851,89 @@ TEST_F(port_specific, bind_connect_zero)
>  	EXPECT_EQ(0, close(bind_fd));
>  }
>  
> +TEST_F(port_specific, listen_without_bind_allowed)
> +{
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					      LANDLOCK_ACCESS_NET_LISTEN_TCP
> +		};
> +		const struct landlock_net_port_attr tcp_listen_zero = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_LISTEN_TCP,
> +			.port = 0,
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/*
> +		 * Allow listening without explicit bind
> +		 * (cf. landlock_net_port_attr).
> +		 */
> +		EXPECT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_listen_zero, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +	int listen_fd, connect_fd;
> +	__u64 port;
> +
> +	listen_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +
> +	connect_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, connect_fd);
> +	/*
> +	 * Allow listen(2) to select a random port for the socket,
> +	 * since bind(2) wasn't called.
> +	 */
> +	EXPECT_EQ(0, listen_variant(listen_fd, backlog));
> +
> +	/* Connects on the binded port. */
> +	port = get_binded_port(listen_fd, &variant->prot);

Please rename "binded" to "bound" when you come across it.


> +	EXPECT_NE(0, port);
> +	set_port(&self->srv0, port);
> +	EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
> +
> +	EXPECT_EQ(0, close(connect_fd));
> +	EXPECT_EQ(0, close(listen_fd));
> +}
> +
> +TEST_F(port_specific, listen_without_bind_denied)
> +{
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_LISTEN_TCP
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Deny listening. */
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +	int listen_fd, ret;
> +
> +	listen_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, listen_fd);
> +
> +	/* Checks that listening without explicit binding is prohibited. */
> +	ret = listen_variant(listen_fd, backlog);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Denied by Landlock. */
> +		EXPECT_EQ(-EACCES, ret);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +}
> +
>  TEST_F(port_specific, port_1023)
>  {
>  	int bind_fd, connect_fd, ret;
> -- 
> 2.34.1
> 
