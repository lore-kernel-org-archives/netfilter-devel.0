Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9C53A1DA
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722524943; cv=none; b=egiM0O9EfdXVLXXsl366xAmmpKHJk497AewBFvyF+/rLURLb1jk4ehVpvXd+hZfbmO5ZIG+/5s0uEVeWKqTVQwkT8LgTs35oHBUehYNjDQnNG8PjTlYerQdOdakar58i0Gi61tbrWozdZwWfNYVunU7FC/7gg3UnqSdfTgAW2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722524943; c=relaxed/simple;
	bh=oH9F7811kynHG5V9RNK8QM1PF490b0/8UQiv8AJT1NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZpuEw49Rt8bAzwAa0tHiFnm/+/dLob10FY5N2grPUfBGh3aLWbw8xBiR4eldnG/Yrx1r0YgeRwdN876aLx046xxDrn/R7Qdg/cth7XRRccMnYCj3lwoZCqrFlDqJyOS3ctss8lyKXP9U7Nh3KGuurhKcwQ0DlHKLp8fnPt/oMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=ECZk6S3s; arc=none smtp.client-ip=45.157.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="ECZk6S3s"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4WZXRZ39WjzcLC;
	Thu,  1 Aug 2024 17:08:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1722524938;
	bh=nrkwXktwDxdS+v/5ZsT0xw/qBigeLGpoe9FswOOXb2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ECZk6S3s/pxPL2NNhCD17FdQq2m/8kM/eIJs1XKUCkvP2U3k3dKk/exr4UAs3xjv1
	 JB4JXoRqlRznXLD2rs8E+3oytzgz52wfepnVTaBaa9tq1Po49QkgqZXblixkSadD2H
	 635/VzKee9CVCF9CK4XawEsNlD9bS/V0f0e9Rjcs=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4WZXRY4f2fzBB9;
	Thu,  1 Aug 2024 17:08:57 +0200 (CEST)
Date: Thu, 1 Aug 2024 17:08:53 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 7/9] selftests/landlock: Test listen on ULP socket
 without clone method
Message-ID: <20240801.rae2can8ooT9@digikod.net>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Sun, Jul 28, 2024 at 08:26:00AM +0800, Mikhail Ivanov wrote:
> Test checks that listen(2) doesn't wrongfully return -EACCES instead of
> -EINVAL when trying to listen on a socket which is set to ULP that doesn't
> have clone method in inet_csk(sk)->icsk_ulp_ops (espintcp).
> 
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  tools/testing/selftests/landlock/config     |  1 +
>  tools/testing/selftests/landlock/net_test.c | 38 +++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
> index 0086efaa7b68..014401fe6114 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -12,3 +12,4 @@ CONFIG_SHMEM=y
>  CONFIG_SYSFS=y
>  CONFIG_TMPFS=y
>  CONFIG_TMPFS_XATTR=y
> +CONFIG_INET_ESPINTCP=y
> \ No newline at end of file

There are missing dependencies, and also please sort entries. I think it should
be:

 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
+CONFIG_INET_ESPINTCP=y
+CONFIG_INET_ESP=y
 CONFIG_IPV6=y
+CONFIG_IPV6_ESP=y
+CONFIG_INET6_ESPINTCP=y
 CONFIG_NET=y
 CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y

This works with check-linux.sh from
https://github.com/landlock-lsm/landlock-test-tools

IPv6 is currently not tested, which should be the case (with the "protocol"
variants).
