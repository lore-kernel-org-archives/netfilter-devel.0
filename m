Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE3E13C816
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 07:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723621948; cv=none; b=Ohgnm2lao0v1jCwMHBdHWW1dqvHC0lbjqzER2Lquir8LzlB1tl/xSaae8O7aFbLpXcMzGaAm8xVmLO60j+nXfLI2ptqBb8v2e/PZGfLeJzjigUtYyX0WXsoy1XJJ+VyuWZ7sU3aGbLmEvL8QNiLgORg3XmQ6WMgiGaabFMfN/u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723621948; c=relaxed/simple;
	bh=2eHS0Q7ecdLPUDbCJnxNdDsG5yirZ3tA9weYJJ03WZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iao+JIyJe5rVbHksJLezOAq8CXuxP7fadIwHoAu2ABrnLs06mKDDYorurMhCHLEFaoC7DUGqaw51VtPX0JEcRIv0LrAPh0eOX5vKLxn+0Lc5gvWmU9It7tVLl6aghmkmVIAvI/0Z8cTaJIpfCrcHfr0oHpSCuYJG/YUq2G888uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mUlnweYE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mUlnweYE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=55TRNyNnWK8+bHcOlnIoK9HkG0foKa9ix7e1t1QEFBc=; b=mUlnweYEBj3a/AHT4e3XrFTdnZ
	pCq03W5PQleiYLpWHRV/IL09zoe/dX/r0wPw8RCYmf9HzBJlJS+cEboPUIWZuqg/St+lshT+98fG8
	BE1Ry/L3pkPSTA0Vrp2PvBL0DhDrF3ig9xDV0GS5T61RK8ztQV7Ng9GgQn7OU3WRK/ZVVLJCxBWFq
	6xFQmZhudIZMeEyoTzXfC67lZjLk2KOLap2Gbd1dargVVCpUDDidikYjVYkcwT+fzwjEP5cv2kNb8
	BbZWemiui+q/J7AyAsTDp/ONxfEb6pIn8k/VPLbV/zfvORCo2/CLMWf1sglHLz9K3q/DXzp8Ja0Pn
	ad1aYlcQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1se8nv-000000005W8-0vz1;
	Wed, 14 Aug 2024 09:52:23 +0200
Date: Wed, 14 Aug 2024 09:52:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH 0/8] nft: Implement forward compat for future
 binaries
Message-ID: <ZrxiN17ceAZptW0j@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>

On Thu, Aug 01, 2024 at 12:26:55AM +0200, Phil Sutter wrote:
> Time to abandon earlier attempts at providing compatibility for old
> binaries, choose the next best option which is not relying upon any
> kernel changes.
> 
> Basically, all extensions replaced by native bytecode are appended to
> rule userdata so when nftnl rule parsing code fails, it may retry
> omitting all these expressions and restoring an extension from userdata
> instead.
> 
> The idea behind this is that extensions are stable which relieves native
> bytecode from being the same. With this series in place, one may
> (re-)start converting extensions into native nftables bytecode again.
> 
> For now, appending compat extensions is always active. Keeping it
> disabled by default and enabling via commandline flag or (simpler) env
> variable might make sense (I haven't tested performance yet). The
> parsing component will take action only if standard rule parsing fails,
> so no need to manually enable this IMO.
> 
> The actual implementation sits in patch 8, the preceeding ones are
> (mostly) preparation.
> 
> To forcibly exercise the fallback rule parsing code, compile with
> CFLAGS='-DDEBUG_COMPAT_EXT=1'.
> 
> Phil Sutter (8):
>   ebtables: Zero freed pointers in ebt_cs_clean()
>   ebtables: Introduce nft_bridge_init_cs()
>   nft: Reduce overhead in nft_rule_find()
>   nft: ruleparse: Drop 'iter' variable in
>     nft_rule_to_iptables_command_state
>   nft: ruleparse: Introduce nft_parse_rule_expr()
>   nft: __add_{match,target}() can't fail
>   nft: Introduce UDATA_TYPE_COMPAT_EXT
>   nft: Support compat extensions in rule userdata

Applied patches 1-4 as they are independent from the actual compat
extensions feature.
