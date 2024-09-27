Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616111C0DE0
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727448837; cv=none; b=l56KPplVS4iPUGz27wbTkE1+2KlPk73YngudBPSF4tXfM5AA0bGqc+9cmo1XrzQ8uG6+eqPaQaI6mUD6vr75ZoZAbVH1T0cAxoL4WOyBcjKVLq5Dt3bUcJC9iV6G0ZJ72PzhqkHmWDQAlZ3J5knCBGhczmyw8zFLfLYQI7WMlXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727448837; c=relaxed/simple;
	bh=BbJbA5lC6dBh50vuIs6fufz8mni57IsrlAQxteFou9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HA/e+zOo0ugAepMvdaoSmPPmZ07ZdFM4TtFbDx2OI9YWnYIxumdcFxBaTbXj7lpY00bT4/FuMmEAy+KOpPTlod/IpA++Nkh4hosuOlecuSvq3z5RvW3gLzETT3ec8cQYpxKl0LSLNBSSJdpEcFuaEJJkb/QwlpG8HEpiYlBSnPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dBk6bscE; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dBk6bscE"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5c879b8d989so665508a12.2
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 07:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727448834; x=1728053634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMNDopMlhFUGwDKZkzabLCI0jVZ7GTFzxb2f7tDOYLg=;
        b=dBk6bscEVkPwAPe8Q90W8XoO7p5LoiQZGE0pOf4zUccIi1zmkxCnz7J2icV6QjEvqW
         hZHQoVxlVmldYbFRdDRJ8w6YrbkKv5bnt8lbD4NCjGBotN7SL470fYhFnpgAaqRY5ZLn
         Gmmf2AxckshXPbzJ52X2GXrATR5rijwet95e0KUWLD6xgyFRa+op22uNk+QVYDr50N26
         /5AMfJdtBmjjpI43qZLrisVlvMGHk7JpbhyXhOMpieYMS3xL9+h6BFWsWYUD7+dpuUUK
         2a5xeioPRWJhCGerGsy5hdhuBq6l7e0uMoC9QTFc1biTSupT/bYJRoigmnL246qH8HKF
         5BxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727448834; x=1728053634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMNDopMlhFUGwDKZkzabLCI0jVZ7GTFzxb2f7tDOYLg=;
        b=fQ/bQdpYRoMP8emipTmru4hft6tCN2DjLGFwP9xXXwdCDkgq/vZKsya33DwLhk+olV
         efQIYV1xmhRdLMMlUXUk3sELsgZhyIiDCxnzPttEc3FH0CRmmg1dKWmHJY3c8K7Ni1rv
         9WjBMo+t/3v4j+zJDI5WQoADSSs8yfyJZ/Cp9Tt95gvAjRbEtRNrPnYb4mbnmEcSQP8S
         e5nb1V8O6ph/+kTHgKzdp4iGzq4kpZTj/qqD/OWG40FmoXjsM5+BopDmNi0B9Dw9192M
         D8/gQE33lkd0yuqpCbQurarPO34Yk4IbHkRdple3guvgjY2MSaq9jlWV8piYZAc2tYbI
         PgEA==
X-Forwarded-Encrypted: i=1; AJvYcCVP/713bvdCy5kGOVHOs6UXqtQyVk9ZioXNpirxYaSXs0XE9GgdiJxxwBw2nSqRLsxmUhqQ7L/05wPyWqP08rc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLAfNvBdhTXsGn/KJJz1H7l15XUkkbD9EEyiLNfMDxHEnVMFbk
	jJDboM9x8wYHZ9qODZzKy4M4lTcgonPM/fLz5dHdxd5to9nGpaS82h0CjRbRqDwosltSvI5gNrJ
	fJw==
X-Google-Smtp-Source: AGHT+IHksKlke7IXOcIb6Ducm9L8OtFULLO1vHaIevttg0RkGd3LMrgXVBNb9iHalLVGdSvXFjJmE2topP8=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6402:1948:b0:5c5:c4ab:8c68 with SMTP id
 4fb4d7f45d1cf-5c8824e8386mr1747a12.2.1727448833301; Fri, 27 Sep 2024 07:53:53
 -0700 (PDT)
Date: Fri, 27 Sep 2024 16:53:51 +0200
In-Reply-To: <20240904104824.1844082-17-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com> <20240904104824.1844082-17-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZvbG_ym1PKmVY6Ts@google.com>
Subject: Re: [RFC PATCH v3 16/19] selftests/landlock: Test that accept(2) is
 not restricted
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"

On Wed, Sep 04, 2024 at 06:48:21PM +0800, Mikhail Ivanov wrote:
> Add test validating that socket creation with accept(2) is not restricted
> by Landlock.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  .../testing/selftests/landlock/socket_test.c  | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
> index 2ab27196fa3d..052dbe0d1227 100644
> --- a/tools/testing/selftests/landlock/socket_test.c
> +++ b/tools/testing/selftests/landlock/socket_test.c
> @@ -939,4 +939,75 @@ TEST_F(socket_creation, sctp_peeloff)
>  	ASSERT_EQ(0, close(server_fd));
>  }
>  
> +TEST_F(socket_creation, accept)
> +{
> +	int status;
> +	pid_t child;
> +	struct sockaddr_in addr;
> +	int server_fd, client_fd;
> +	char buf;
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
> +	};
> +	struct landlock_socket_attr tcp_socket_create = {
        ^^^^^^

Could be const as well, just like the ruleset_attr?

(I probably overlooked this as well in some of the other tests.)


> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
> +		.family = AF_INET,
> +		.type = SOCK_STREAM,
> +	};
> +
> +	server_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, server_fd);
> +
> +	addr.sin_family = AF_INET;
> +	addr.sin_port = htons(loopback_port);
> +	addr.sin_addr.s_addr = inet_addr(loopback_ipv4);
> +
> +	ASSERT_EQ(0, bind(server_fd, &addr, sizeof(addr)));
> +	ASSERT_EQ(0, listen(server_fd, backlog));
> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {

Nit:
I feel like the child code would benefit from a higher level comment,
like "Connects to the server once and exits." or such.

> +		/* Closes listening socket for the child. */
> +		ASSERT_EQ(0, close(server_fd));
> +
> +		client_fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +		ASSERT_LE(0, client_fd);
> +
> +		ASSERT_EQ(0, connect(client_fd, &addr, sizeof(addr)));
> +		EXPECT_EQ(1, write(client_fd, ".", 1));
> +
> +		ASSERT_EQ(0, close(client_fd));
> +		_exit(_metadata->exit_code);
> +		return;
> +	}
> +
> +	if (self->sandboxed) {
> +		int ruleset_fd = landlock_create_ruleset(
> +			&ruleset_attr, sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +		if (self->allowed) {
> +			ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +						       LANDLOCK_RULE_SOCKET,
> +						       &tcp_socket_create, 0));
> +		}
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		ASSERT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	client_fd = accept(server_fd, NULL, 0);
> +
> +	/* accept(2) should not be restricted by Landlock. */
> +	EXPECT_LE(0, client_fd);

Should be an ASSERT, IMHO.
If this fails, client_fd will be -1,
and a lot of the stuff afterwards will fail as well.

> +
> +	EXPECT_EQ(1, read(client_fd, &buf, 1));
> +	EXPECT_EQ('.', buf);

I'm torn on whether the "." write and the check for it is very useful in this test.
It muddies the test's purpose a bit, and makes it harder to recognize the main use case.
Might make the test a bit simpler to drop it.

> +
> +	ASSERT_EQ(child, waitpid(child, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +
> +	ASSERT_EQ(0, close(server_fd));

You are missing to close client_fd.

> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.34.1
> 
