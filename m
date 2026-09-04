Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A084651FCDC;
	Fri,  4 Sep 2026 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547890; cv=none; b=qBVOfR+RMnaCvTJlBhPWjaVBUJuBJG/GARog5sNkr56gT8bFFwEKvC+6ZN3HhfMbMfNb/DBOZoFf0jPyx3XRtJy4iCnUPBWGT3ycGwIHSjagSC1sOzoZFAVVtF/wce0ghyhdSTK/0CrbrW8XuGFvJuF28X/4PL0XXMDtjZ9gO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547890; c=relaxed/simple;
	bh=+cU3cfRC59rihOu+6DbL3lmuUOneb4sLgflXP1rrd84=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBtfoAMwaRJGIRxG4fP2B8k25j1v22VkgknySTXudjklU/VUjNj52qSUCijYEnxnBoQJuP33hnY0RB2OtzwQTKIDWonyrheWATCXNgy+Z81hDOqM7cUqEyuTb4KvOlqrHmXYa7KzklRudrfa+axpTBxnoAM47LkzKblaraoXGF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGMD7JW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGMD7JW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0021F00A3D;
	Fri,  4 Sep 2026 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788547889;
	bh=MOyNRJsDHYyyG5OA3saDsYe3ZRH+LDUq3rlJQQPfaVQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oGMD7JW6nPgnJcuytalIGRcCU1UhxuPOpgUaCenKntw+e5BRymx43v1gdO+9/hN55
	 CTKBw+2aB/CcvIfReyqPGXfsyJVG+7IJC0Cfh4fGmKO4plHGlGZzBYfYOTnmg5/zJd
	 KWrNVKkB/O9KK8s5ljXwPWO61boFt+dmiDqeSvNiX36BFj0vhTekY6ra2Olr8AZRIW
	 gvXLRyZT9fHL5ScWI6JItQghuyA+eloldI2S7UMbQcJ+5PGxKq5zgwu+BOz7TdNUld
	 zp4TqHHs+aZQJM8IGKe0BmCCNL/ICZFb9hwH4ah9TGKazjDN9zye7lcj+wk1EwnfUP
	 iUgybPBzUJuKg==
Date: Fri, 4 Sep 2026 11:51:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Pablo Neira
 Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, David Ahern
 <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 0/2] selftests: net: use KHDR_INCLUDES in CFLAGS
Message-ID: <20260904115127.1c316a33@kernel.org>
In-Reply-To: <64123435-9acc-4d96-806b-4092a2c80628@kernel.org>
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
	<64123435-9acc-4d96-806b-4092a2c80628@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 4 Sep 2026 20:20:44 +0200 Matthieu Baerts wrote:
> These patches didn't get picked up in the tests because the Clang build
> failed with Rust code:
> 
> https://netdev-ctrl.bots.linux.dev/logs/build/1158213/14791779/build_clang/stderr
> 
> I only modified the selftests here. Other patches sent before me have
> the same issue, but some sent after don't. One of those "random" issues
> on the build server?

kbuild / tools build likes to sometimes pick up the wrong source tree
if you have a worktree nested inside a git repo :/
Here the Rust build was partially using the sources from the main repo
and partially from the work tree.
I'll push a NIPA workaround to sync the main repo to something recent
it should paper over this bug. It's not the first time it happened.
