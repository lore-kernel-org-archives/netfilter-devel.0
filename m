Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [185.125.25.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B3F1B29AF
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525768; cv=none; b=OEgl7zdTP+XdZx/nRLMnLbtJgC5qS5qoJxXf/Ff5GEw/y3uv3+1ea/nHnV/hr92CYDwFq2dbyXEA709PuHEB5n/h56h3VR2dWhmxTcG/KGC3jA47j/QdK+MOu6+WW5dFQxKAL3WYLrAdv85FalMNH3CfCSqGqekzADZMtvAsKzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525768; c=relaxed/simple;
	bh=ccAfHXjlpcxJd+RNPtZFU7WL4Ujx9L4oH+JZadgvssY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQz8g7e775eCL9V/sQ6Q+EAr4H67sGJjlycRzxjUUOT7713ZxgWvEGdEb9+EUQVvAQ2VTR68/uuqMVUeuuL3LfNy0wmBI2veXwHgrEK56sr3ejOH/IoDYBQ6AE4HnVD1q4hNq6k+/d51tjPenAAf1RedtV5lj5ffQTqWkfvFlMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=jHKhb5BM; arc=none smtp.client-ip=185.125.25.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="jHKhb5BM"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4WZWyF2bxwzHTT;
	Thu,  1 Aug 2024 16:47:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1722523621;
	bh=U7ym2UVwNdA0ykceU4yRjRUwU9WZGnk7Uy9wId/ABIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHKhb5BM8ygsXvff3QsCr/HojLPrrK43NBNDkFe6jZ3BRkIB8slxhqWoHS+Ge1Znr
	 W0t4hUSuH0/PZgxtPjbDqANxpEhfwjwQe78tCugX1yZu8pp/3OeOBhqGD5RhALp+wM
	 SEyEP4R4RWMtcuBSDoET0FhI16o+m1GI87eLfHzw=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4WZWyD6jgPz2FF;
	Thu,  1 Aug 2024 16:47:00 +0200 (CEST)
Date: Thu, 1 Aug 2024 16:46:56 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 5/9] selftests/landlock: Test listen on connected
 socket
Message-ID: <20240801.Ee3Cai7eeD1g@digikod.net>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-6-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240728002602.3198398-6-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Sun, Jul 28, 2024 at 08:25:58AM +0800, Mikhail Ivanov wrote:
> Test checks that listen(2) doesn't wrongfully return -EACCES instead
> of -EINVAL when trying to listen for an incorrect socket state.
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>

Good to have this test!

> ---
>  tools/testing/selftests/landlock/net_test.c | 65 +++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> index b6fe9bde205f..a8385f1373f6 100644
> --- a/tools/testing/selftests/landlock/net_test.c
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -1644,6 +1644,71 @@ TEST_F(ipv4_tcp, with_fs)
>  	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
>  }
>  
> +TEST_F(ipv4_tcp, listen_on_connected)

We should use the "protocol" fixture and its variants instead to test
with different protocols and also without sandboxing (which is crutial).

I guess espintcp_listen should use "protocol" too.

ipv4_tcp is to run tests that only make sense on an IPv4 socket, but
when we test EINVAL, we should make sure Landlock doesn't introduce
inconsistencies for other/unsupported protocols.

> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = ACCESS_ALL,
> +	};
> +	const struct landlock_net_port_attr tcp_not_restricted_p0 = {
> +		.allowed_access = ACCESS_ALL,
> +		.port = self->srv0.port,
> +	};
> +	const struct landlock_net_port_attr tcp_denied_listen_p1 = {
> +		.allowed_access = ACCESS_ALL & ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
> +		.port = self->srv1.port,
> +	};
> +	int ruleset_fd;
> +	int bind_fd, status;
> +	pid_t child;
> +
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allows all actions for the first port. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +				       &tcp_not_restricted_p0, 0));
> +
> +	/* Deny listen for the second port. */

nit: Denies listening

> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +				       &tcp_denied_listen_p1, 0));
> +
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	EXPECT_EQ(0, close(ruleset_fd));
> +
> +	/* Init listening socket. */

nit: Initializes

> +	bind_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, bind_fd);
> +	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {
> +		int connect_fd;
> +
> +		/* Closes listening socket for the child. */
> +		EXPECT_EQ(0, close(bind_fd));
> +
> +		connect_fd = socket_variant(&self->srv1);
> +		ASSERT_LE(0, connect_fd);
> +		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
> +
> +		/* Tries to listen on connected socket. */
> +		EXPECT_EQ(-EINVAL, listen_variant(connect_fd, backlog));
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
>  FIXTURE(port_specific)
>  {
>  	struct service_fixture srv0;
> -- 
> 2.34.1
> 
> 
