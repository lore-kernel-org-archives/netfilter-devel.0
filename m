Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8D4264612;
	Mon, 20 Apr 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776698616; cv=none; b=RSdQmBaIInQqcb9CXaIHT+mjAt85WiZCSfcElRaGjWub+/YFJqf7S+rum/kfG8OxeVxZ44ZdL7GN84lD2IScSItPqXxZxr3h53Q2xxEoYxAtoI+O1N1N8pLyOBRQYpqS5CfsIs8+FQuOkVxqlPWNm4J0LqujvYLPh5MJd8wL31U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776698616; c=relaxed/simple;
	bh=Rt7p+f8035FwrglIyG/el9HvMHbr+wpImxFBHqJMTSs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNddmhYGlyffLGp8uVy/Dr6cl41CmLqgDOy48WRdhO99iMPJeu+V7f0XAnewjoqmj+Icw8nMnxb8CoJ1Ab4O0zglkcbdZpW3fzgaweP0etCXp+IsoL+FQJsJk6XVMjFiXl5abLbah45nhS7wZrZBWGZN5T47RQpUy3J3FfKiCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4sex0i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4sex0i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949CDC2BCB4;
	Mon, 20 Apr 2026 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776698616;
	bh=Rt7p+f8035FwrglIyG/el9HvMHbr+wpImxFBHqJMTSs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z4sex0i0zWSKoFotw7bLfFZLHBh637MQHPf1EejQCwYYCKxdG10vZ8N3GOO7lEOac
	 96qjPzuN8ebdmcgO48coFKzp4MXm//Fa6/mVBojlvxL3C3npxMbIFIlmnBKyw41r2F
	 JGfdNkYdYM/BfsKU2fdRe37gtAev3FTvjnYUiHQeoVz1ErY6MDRUKfJllbQv2M/s8H
	 RlkSN2G86MbzB6PMzHgDcKHemgKYmxf/piBhQlzr6mZyq18+u37mRPR9mHKH4Uh4oD
	 EuZVSJWbTJX2gi5j3gAjmU25p1o2/cPJ+Gvq87cNs7NjM5Zj6PhTt2JPeDv8V7fite
	 d3dzkF0cYOxJA==
Date: Mon, 20 Apr 2026 08:23:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yi Chen <yiche.cy@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, Long Xin <lucien.xin@gmail.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, coreteam@netfilter.org,
 netfilter-devel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] selftests: netfilter:
 conntrack_sctp_collision.sh: Introduce SCTP INIT collision test
Message-ID: <20260420082334.7db8cbf4@kernel.org>
In-Reply-To: <20260418195843.303946-1-yiche.cy@gmail.com>
References: <20260418195843.303946-1-yiche.cy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 19 Apr 2026 03:58:43 +0800 Yi Chen wrote:
> The existing test covered a scenario where a delayed INIT_ACK chunk
> updates the vtag in conntrack after the association has already been
> established.

AI says:

The conntrack_sctp_collision.sh selftest is now failing in the NIPA CI on
both the normal and debug kernel builds:

  not ok 1 1 selftests: net/netfilter: conntrack_sctp_collision.sh # exit=1

  # Test for SCTP INIT_ACK Collision in nf_conntrack:
  # Invalid netns name ""
  # Invalid netns name ""

The root cause is a shell variable scoping bug introduced by this patch.
The new test structure wraps `topo_setup` in a subshell:

  (topo_setup && conf_delay $SERVER_NS link0 2) || exit $?
  if ! do_test; then
      ...
  fi

`topo_setup` calls `setup_ns CLIENT_NS SERVER_NS ROUTER_NS`, which sets
those variables inside the subshell. Those assignments do not propagate
back to the parent shell, so when `do_test` is called afterwards, both
`$SERVER_NS` and `$CLIENT_NS` expand to empty strings. The `ip net exec ""`
calls then fail with "Invalid netns name """.

The second test case (SCTP INIT Collision) would have the same problem.

The fix is to avoid the subshell or ensure the namespace variables are
visible to `do_test`. The simplest approach is to remove the subshell
wrapping and call `topo_setup`, `conf_delay`, and `do_test` in the same
shell scope:

  topo_setup && conf_delay "$SERVER_NS" link0 2 || exit $?
  if ! do_test; then
      exit $ksft_fail
  fi

  topo_setup && conf_delay "$CLIENT_NS" link3 1 || exit $?
  if ! do_test; then
      exit $ksft_fail
  fi

Please also note that `conf_delay` references `$ROUTER_NS` directly
(not via a parameter), so it too requires that those variables be set
in the same shell scope.
