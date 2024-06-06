Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CEEEEDB;
	Thu,  6 Jun 2024 02:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640591; cv=none; b=nbhgrgl+Djb2LjrjrCdSBH90cbFgxyT3AuJ0tLyoW9BPsRh1ZpZBripc3GiN1/KTHZWL7xr/IfYw6RqDU42XhgVRWOuiTHB4BB1URznrF9U3EmKK0i5PrgAEtvEPlbfq8LObHrkoQWMyjlpl2vAXjkn304bOGJrvXWP+5aq8jYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640591; c=relaxed/simple;
	bh=W0a+0ehrLAizO8ZEIWCINwV2FfHVY+xNX/I2byf9iyo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuvUEg7h99ByxVMmNVzuog51XVFuWiImHu3XI3VuupZf1HLh3oh+oWCK9CVKCF7/TWpYj/7PwBmBwctVtQ79bdVbsNKnllihcvX4tMgWKAZHDg4vyQC9ntYucnrb/Mk2sNIz6Hd8UtYjjKwXN6V5rSjeYBOC57riVrWuHh2tAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFeuFoDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFeuFoDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596C7C2BD11;
	Thu,  6 Jun 2024 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717640590;
	bh=W0a+0ehrLAizO8ZEIWCINwV2FfHVY+xNX/I2byf9iyo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mFeuFoDuj8ijxhhFG+1Aofyt10d1UW7e48wIxqiXcpyUEpnceKTgNCcVQqquGFOxR
	 cHij8qlyipcw7T204y9jZ+QTkFUJ5zKN2v1MlUBdKiE8a8Bi9xlh7dOCQdb2irBSWT
	 DUXEq9SKM2IEuldNJb0rkQ5MKdQZTwg/LS+jT8+Ebs6hpukHCQl4g2HiOuTHonFf39
	 JFh/htGXHHx0vDP23aSBCGR30+2kD3DRw9Lganvi9XhAnLMwj+RZsJchqKcX+ybMxJ
	 2+vJCpUd0RWZoR8h7J7Ow7BeFbEIvue1EiZJ6T64Eya+zcgPg1nhR/1eXF8v3Y5fX7
	 xTehPL1zfApkA==
Date: Wed, 5 Jun 2024 19:23:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jianguo Wu <wujianguo106@163.com>, wujianguo
 <wujianguo@chinatelecom.cn>, netdev@vger.kernel.org, edumazet@google.com,
 contact@proelbtn.com, pablo@netfilter.org, dsahern@kernel.org,
 pabeni@redhat.com, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net v2 2/3] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
Message-ID: <20240605192309.591dfedb@kernel.org>
In-Reply-To: <ZmEapORjk3v3FYke@Laptop-X1>
References: <20240604144949.22729-1-wujianguo@chinatelecom.cn>
	<20240604144949.22729-3-wujianguo@chinatelecom.cn>
	<Zl_OWcrrEipnN_VP@Laptop-X1>
	<eaf06c77-2457-46fc-aaf1-fb5ae0080072@163.com>
	<20240605173532.304798bd@kernel.org>
	<ZmEapORjk3v3FYke@Laptop-X1>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 6 Jun 2024 10:10:44 +0800 Hangbin Liu wrote:
> > Please follow the instructions from here:
> > https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
> > the kernel we build for testing is minimal.
> > 
> > We see this output:
> > 
> > # ################################################################################
> > # TEST SECTION: SRv6 VPN connectivity test with netfilter enabled in routers
> > # ################################################################################  
> 
> If I run the test specifically, I also got error:
> sysctl: cannot stat /proc/sys/net/netfilter/nf_hooks_lwtunnel: No such file or directory
> 
> This is because CONFIG_NF_CONNTRACK is build as module. The test need to load
> nf_conntrack specifically. I guest the reason you don't have this error is
> because you have run the netfilter tests first? Which has loaded this module.

Ah, quite possibly, good catch! We don't reboot between tests,
and the VM must have run 10 or so other tests before.

> > # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING
> > # Warning: Extension rpfilter revision 0 not supported, missing kernel module?
> > # iptables v1.8.8 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain PREROUTING  
> 
> Just checked, we need CONFIG_IP_NF_MATCH_RPFILTER=m in config file.

:( Must be lack of compat support then? I CCed netfilter, perhaps they
can advise. I wonder if there is a iptables-nftables compatibility list
somewhere.
