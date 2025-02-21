Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1CB212D8A
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2025 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740154181; cv=none; b=p1Sr0h6mWcMC3cqM5Y2pDf1Gb4+7ObT/0UmhD7ggepjhmGlPCPi6FSG+9VKtQaRMWJsaJplzADKtBdb1u1Rsz1SU/BTfYvcJp0wcBLLOeVS8H/BLHY4oPHbF3D1mQCcLeRC7sI+Q8Ocdu7yPbF/drV7TVtFhbYwOGgvolJKR+os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740154181; c=relaxed/simple;
	bh=7OlRJG02e4MjVQGvLWIkfzHlMS56A+sC61fT8RGXD04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoI5lICC4rV9mYgHWMMJ+rosx22sAAxe2WLtdHSdAJBp4fm/m+DlQjaKrKYcIkd8bxdzBMWCWtd2pmUrrsB/dMbkMCuLwrufbUSz319wzelQmZb2ZCxSoCtOAuguEylgaAOq59sTHO18UjP2xeP1G/6727wMxP0HAnNxKUVdeLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=DpIzh2tH; arc=none smtp.client-ip=84.16.66.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="DpIzh2tH"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Yzw7N4lbJzmDM;
	Fri, 21 Feb 2025 17:09:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1740154176;
	bh=am3mS88qb0aUbz/powxHvGIkVv9GbvnKoerku9NQmK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DpIzh2tHNwuvQ88Qe/YKJ1R0qS3OMp9PWbicHX02KIPPhTw0xdq5GEfUVjg4rSZnX
	 7cVvK33EJk0ZY76TnAhP8pdQXhUB3b0EZjjLKnwKIPXPT/oDRXIQpjK4WXvzJTwpk5
	 tGwvZCg5dnhLKpwLhyuPswKKLN7MDBlKHhvx1Jvg=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Yzw7N0ChRzPQY;
	Fri, 21 Feb 2025 17:09:35 +0100 (CET)
Date: Fri, 21 Feb 2025 17:09:35 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v3 0/3] Fix non-TCP sockets restriction
Message-ID: <20250221.yie2Naiquea0@digikod.net>
References: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Thanks Mikhail, it's been in my tree for more than 10 days, I'll include
it in a fix PR next week.

On Wed, Feb 05, 2025 at 05:36:48PM +0800, Mikhail Ivanov wrote:
> Hello!
> 
> This patch fixes incorrect restriction of non-TCP bind/connect actions.
> There is two commits that extend TCP tests with MPTCP test suits and
> IPPROTO_TCP test suits.
> 
> Closes: https://github.com/landlock-lsm/linux/issues/40
> 
> General changes after v2
> ========================
>  * Rebases on current linux-mic/next
>  * Extracts non-TCP restriction fix into separate patchset
> 
> Previous versions
> =================
> v2: https://lore.kernel.org/all/20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com/
> v1: https://lore.kernel.org/all/20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com/
> 
> Mikhail Ivanov (3):
>   landlock: Fix non-TCP sockets restriction
>   selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP
>   selftests/landlock: Test that MPTCP actions are not restricted
> 
>  security/landlock/net.c                     |   3 +-
>  tools/testing/selftests/landlock/common.h   |   1 +
>  tools/testing/selftests/landlock/config     |   2 +
>  tools/testing/selftests/landlock/net_test.c | 124 +++++++++++++++++---
>  4 files changed, 114 insertions(+), 16 deletions(-)
> 
> 
> base-commit: 24a8e44deae4b549b0fe5fbb271fe8d169f0933f
> -- 
> 2.34.1
> 
> 
