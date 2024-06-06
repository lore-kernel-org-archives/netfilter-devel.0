Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B391C2E;
	Thu,  6 Jun 2024 00:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717634140; cv=none; b=D7jQiu6kE1F1vw/uUCnPBy3Yk99yDMUMpQBLz0PXPCpxzciXead1Xp14t9UqGwBx60frM5pWri+trczRkmrZkNOrf9Yf5tto67wxyhW7LUBVbFDMkti3LQyw7UaqUszMM09fQWiAO9QJVpVp4hJd6wwFtBg13crgU6ewdH6nYLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717634140; c=relaxed/simple;
	bh=aOGQ6WFlXVj8Sat+De81wFW1YR4LJnyGhk5Mzdbi00w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8wQ3pBXhAobf/xRGyN5WLqSd9Yw4KFDV41pi6GBK3M0RBU2X7q3WdZMRXPToZPhQfS+Nkt97UOkvEWEMhYjfexwUPD4eU2BMeAmuKDU33M1ox0xA1FmdvI7mkTsGg92RGh6SO1zOUwd/ZtAFsHFEuSllNw5CLgyxG24ChtMfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUMs7Jqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUMs7Jqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF45C2BD11;
	Thu,  6 Jun 2024 00:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717634139;
	bh=aOGQ6WFlXVj8Sat+De81wFW1YR4LJnyGhk5Mzdbi00w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oUMs7Jqqk1nmcaEsJuKC3CVlZ6y/8sBoJNYvKQypQ24KQZ3mxMYNWdyHgPpinkcKV
	 zqXHpwzgn4TkqiQwHQaL6O7HfBCiYVaBeFprhx4a68v2eAC5rsRmoZXBhFtZPS2YTO
	 iBCjO8XpgJdIojCe9Tjxkx7uFefC+rnF8kvCjMJpEPiYDA3bmcFhSalG85kldbxn8I
	 NWtSDcWlbm/2JuJEPSRaV/sTToAUGsZulA8BDEIBiUMMMYjoBGFLkZMdzQGABBZ+/T
	 KlCCDP5rBAs0jsqR6sh6sG5d0XLyWJeiebOx78q5+dnred0kXsZbscGqpk/+rfZFj3
	 gdxNQPOHe8dFQ==
Date: Wed, 5 Jun 2024 17:35:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jianguo Wu <wujianguo106@163.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>, wujianguo
 <wujianguo@chinatelecom.cn>, netdev@vger.kernel.org, edumazet@google.com,
 contact@proelbtn.com, pablo@netfilter.org, dsahern@kernel.org,
 pabeni@redhat.com, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net v2 2/3] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
Message-ID: <20240605173532.304798bd@kernel.org>
In-Reply-To: <eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
References: <20240604144949.22729-1-wujianguo@chinatelecom.cn>
	<20240604144949.22729-3-wujianguo@chinatelecom.cn>
	<Zl_OWcrrEipnN_VP@Laptop-X1>
	<eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Jun 2024 11:28:17 +0800 Jianguo Wu wrote:
> > sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory
> > Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > iptables v1.8.9 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
> >   
> 
> What is your kernel version? The file was introduced from v5.15-rc1
> 
> > Looks we are missing some config in selftest net/config.
> >   
> 
> Sorry, I can't find what config to add, please tell me.

Please follow the instructions from here:
https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
the kernel we build for testing is minimal.

We see this output:

TAP version 13
1..1
# overriding timeout to 7200
# selftests: net: srv6_end_dx4_netfilter_test.sh
# Warning: file srv6_end_dx4_netfilter_test.sh is not executable
# 
# ################################################################################
# TEST SECTION: SRv6 VPN connectivity test among hosts in the same tenant
# ################################################################################
# 
#     TEST: Hosts connectivity: hs-1 -> hs-2 (tenant 100)                 [ OK ]
# 
#     TEST: Hosts connectivity: hs-2 -> hs-1 (tenant 100)                 [ OK ]
# 
# ################################################################################
# TEST SECTION: SRv6 VPN connectivity test with netfilter enabled in routers
# ################################################################################
# Warning: Extension rpfilter revision 0 not supported, missing kernel module?
# iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
# Warning: Extension rpfilter revision 0 not supported, missing kernel module?
# iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
# 
#     TEST: Hosts connectivity: hs-1 -> hs-2 (tenant 100)                 [ OK ]
# 
#     TEST: Hosts connectivity: hs-2 -> hs-1 (tenant 100)                 [ OK ]
# 
# Tests passed:   4
# Tests failed:   0
ok 1 selftests: net: srv6_end_dx4_netfilter_test.sh

https://netdev-3.bots.linux.dev/vmksft-net-dbg/results/627022/58-srv6-end-dx4-netfilter-test-sh/stdout



Note that the CI uses nftables-based iptables, not legacy iptables.
