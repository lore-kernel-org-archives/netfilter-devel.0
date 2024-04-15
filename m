Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702B73163;
	Mon, 15 Apr 2024 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713189762; cv=none; b=LiVCbnAB7Bk+u9z2pWHMgEd0NGzlMxuvKOrvDBVjUOhniUy7+fzdwUgYsHcMXuVuBkgp3lwpg3C9qGfEsoh6wx3zB3aSMxqbv9vfUh0pp024YLmrNtcIRVgrFUanOoCuaodczWP9VvfOd9vA59w8frgVYrU/wDzlQzAkJM4mS80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713189762; c=relaxed/simple;
	bh=6Tr1ljmKeK8gX0fObsnxgo5rZhiRMQGWlE9BWsEcqX8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LfjNfaEd1CBt1IrH0ayZwEhq6mGaszAQvwuOjU0bFWW6BrUoJ3n8yh5J0xILTE+tG3eGtGutjqm3gCGXXRr8Z+7KqjDPJ0OqWcH/ov9G9gM5KajK05beUz5ArtDicAXlgCYqvq/uET1X+bSt9muaM/O1Osd9V4bNcOz8BQHfZmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UA+v7Bl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UA+v7Bl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D18C113CC;
	Mon, 15 Apr 2024 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713189761;
	bh=6Tr1ljmKeK8gX0fObsnxgo5rZhiRMQGWlE9BWsEcqX8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UA+v7Bl2eOYf3j3fEbj76j1qzbioXzDSkGOO/MlVUEsIB2kJ44yncZJfJAUdXM1fw
	 MATxIcnWg1rkHcEjvceUqIZ8Vbn4LgE+gBMNEeX7XlytEUejFkrcBnV/RSkyybvGIS
	 v8Rga5mixMaO0XGsDNQP3n2uEKvvOnnv2eNALnwjAxCXMX1JmKzWXogWzYXv2MPAGb
	 /qPlfn2YALs4R+qH9PKIjgQRcFGn1lDKCiMgcQg5ghXVOq3crZZ1/Si0/xQvRi16fk
	 CfAO6N7upGsCR8G1NDKgUxTVJ5bEil2kBOKUIObS7gYARW8NPUvrJU2rtr3vO1C4oN
	 djVypENWXzSrw==
Date: Mon, 15 Apr 2024 07:02:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 12/12] selftests: netfilter: update makefiles
 and kernel config
Message-ID: <20240415070240.3d4b63c2@kernel.org>
In-Reply-To: <20240414225729.18451-13-fw@strlen.de>
References: <20240414225729.18451-1-fw@strlen.de>
	<20240414225729.18451-13-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Apr 2024 00:57:24 +0200 Florian Westphal wrote:
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config

Looks like we're still missing veth, and possibly more.
Here's more details on how we build:

https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
