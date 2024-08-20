Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B87D18DF6F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724158889; cv=none; b=fxNEzriCLlp7CV85iFr1pzBGn2t6lSz59R+dXclNGo9nLvUXvbagmBzBl9VG4bO7dK3/48cNd2qFov7exdl+IsucMcng9ZR3zy0WW2A7nFC1e+BscvUmMKZSSEPD+s9jFSr/ryNn/YwL1PtJDqK69OVlSJu5260TAsSv4nrcZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724158889; c=relaxed/simple;
	bh=KZEVo7pLpRsfB5Q6b6kEdFNEWymLaLjJuokEiDN0ViU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A790KkhnWhaI1bymRYlKHDNytlz/awx4Gyi8KbPW6jPZAay4Y/2l87nczHnp+X611ydPc/EKq9x7fcBQnEWHXaYaoPd9326W12Rs8IeseOk8Im9jSOKDl3yeIeFPKg1q007znDdmBkCb1hLrIP0u0uTAlsEyoB/VfQVuo3vPnQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RsW14a0z; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RsW14a0z"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5bed5bc6dbeso1812263a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 06:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724158885; x=1724763685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BEKfFspd2Zit7uxjfliIJNLSfniyz2DRkiJ2PyNFH0=;
        b=RsW14a0zEd7UY2PsaRnkF3/BnFY2ceogSe7cdnRGjcXo3Hlsgjv3kgHqT4sAApvtM7
         KdgGBR7RkjwQrkXdbklZ5EGEXhCw6Hm+j9MwxIHguZjGacBHzDAtEXPfRoNoYrFaUHYc
         PeeM2YzNOY6a0YaMXmgCG6JXFH9qYClXs3LFj2oYCb9B+h8N0FWtGEg/oF4S9aevbJvf
         uWBTyULLowKRA31h319ODX8+tfM18Fe3vpkq+b2Jxzym/KDqL5i/RSawVs8lECGuKqga
         LahLF11x4Zf0x5Ak29LAAhB4EGdBzjempw52ARCurGpm5rvWpOqFkfoBVCr50OjJNpvr
         CsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724158885; x=1724763685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BEKfFspd2Zit7uxjfliIJNLSfniyz2DRkiJ2PyNFH0=;
        b=IiXzmiN1urX7jY9wBeySZibXdeqDaINopHLVuwGI7J/jKLHM1xcjbac8HEuJOoc58v
         CZQNd9jdD/bsJwiOV/5Rln7qB2zxcQBxm/OUht//gOWZtx+VfkFmjSQXxRzfWRapbdlk
         wU3LYqB+CnNQwmFslgM/bbuTddN34D1r0lhtuVcdI9DlpPXhuPjdn/rClGVy2HrtHbv9
         VkfVhcS+ukZ/ZSjOzrQxUrq4TvhNHnerjDfw8fHqamc9Z9fnKhsqmoGWhke36gqtfkQB
         g+/W0lzA5cGc4wYK4vJqb+OW/CK9PR4xTrtdGURrfSTxlWtEzu0M3SvH9mD0bRuEGRVN
         DwUA==
X-Forwarded-Encrypted: i=1; AJvYcCXbrWfvONa0wxkNYq8nqaHAM+oNVxpP5aU1lMHcTqGhUT7NWL9Xkb7RZmLPD1oAQ+UdzEsaXRTj60ni97B3nMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM9E6UJLlSUdHs9eElYe52po41Ah2E93wZF5BWRh4BNHXJZamv
	XKv3t7IPnuZJkAvP19uUXjJ4RYyQyighvUQBL/wP5XjKK/J0WTVI7AMYqR1ejpNlloXuUUYKeCJ
	cmg==
X-Google-Smtp-Source: AGHT+IFjFxkDEFgwTALnbjQqttd/xtDKHZG9ENeNSlVYU7p8wcECHX8vVJ9SLMwO1lktfch/kKZ1zzECFBk=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:360e:b0:59e:f6e7:5476 with SMTP id
 4fb4d7f45d1cf-5beca4a1653mr12915a12.2.1724158884208; Tue, 20 Aug 2024
 06:01:24 -0700 (PDT)
Date: Tue, 20 Aug 2024 15:01:22 +0200
In-Reply-To: <20240814030151.2380280-6-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com> <20240814030151.2380280-6-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZsSTouBzDOHFKC1L@google.com>
Subject: Re: [RFC PATCH v2 5/9] selftests/landlock: Test listen on connected socket
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"

On Wed, Aug 14, 2024 at 11:01:47AM +0800, Mikhail Ivanov wrote:
> Test checks that listen(2) doesn't wrongfully return -EACCES instead
> of -EINVAL when trying to listen for an incorrect socket state.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> 
> Changes since v1:
> * Uses 'protocol' fixture instead of 'ipv4_tcp'.
> * Minor fixes.
> ---
>  tools/testing/selftests/landlock/net_test.c | 74 +++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index b6fe9bde205f..551891b18b7a 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -926,6 +926,80 @@ TEST_F(protocol, connect_unspec)
>  	EXPECT_EQ(0, close(bind_fd));
>  }
>  
> +TEST_F(protocol, listen_on_connected)
> +{
> +	int bind_fd, status;
> +	pid_t child;
> +
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = ACCESS_ALL,
> +		};
> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
> +			.allowed_access = ACCESS_ALL,
> +			.port = self->srv0.port,
> +		};
> +		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
> +			.allowed_access = ACCESS_ALL &
> +					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
> +			.port = self->srv1.port,
> +		};
> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Allows all actions for the first port. */
> +		ASSERT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_not_restricted_p0, 0));
> +
> +		/* Denies listening for the second port. */
> +		ASSERT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_denied_listen_p1, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}

Same remarks as in the previous commit apply here as well:

  - The if condition does the same thing, can maybe be deduplicated.
  - Can merge ruleset_fd declaration and assignment into one line.
    (This happens in a few more tests in later commits as well,
    please double check these as well.)

> +
> +	if (variant->prot.type != SOCK_STREAM)
> +		SKIP(return, "listen(2) is supported only on stream sockets");
> +
> +	/* Initializes listening socket. */
> +	bind_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, bind_fd);
> +	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));

I believe if bind() or listen() fail here, it does not make sense to continue
the test execution, so ASSERT_EQ would be more appropriate than EXPECT_EQ.


> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {
> +		int connect_fd;
> +
> +		/* Closes listening socket for the child. */
> +		EXPECT_EQ(0, close(bind_fd));

You don't need to do this from a child process, you can just connect() from the
same process to the listening port.  (Since you are not calling accept(), the
server won't pick up the phone on the other end, but that is still enough to
connect successfully.)  It would simplify the story of correctly propagating
test exit statuses as well.

> +
> +		connect_fd = socket_variant(&self->srv1);
> +		ASSERT_LE(0, connect_fd);
> +		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
> +
> +		/* Tries to listen on connected socket. */
> +		EXPECT_EQ(-EINVAL, listen_variant(connect_fd, backlog));

Since this assertion is the actual point of the test,
maybe we could emphasize it a bit more with a comment here?

e.g:

/*
 * Checks that we always return EINVAL
 * and never accidentally return EACCES, if listen(2) fails.
 */

> +
> +		EXPECT_EQ(0, close(connect_fd));
> +		_exit(_metadata->exit_code);
> +		return;
> +	}
> +
> +	EXPECT_EQ(child, waitpid(child, &status, 0));
> +	EXPECT_EQ(1, WIFEXITED(status));
> +	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +
> +	EXPECT_EQ(0, close(bind_fd));
> +}
> +
>  FIXTURE(ipv4)
>  {
>  	struct service_fixture srv0, srv1;
> -- 
> 2.34.1
> 
