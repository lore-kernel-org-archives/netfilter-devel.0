Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68682581
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 00:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715299996; cv=none; b=t/4eXsGdYGHqOGQnpx9xumQKz21WUVvpNIc9jyVyK0dTpSIVlUiC0b/K3Rjz3wMdjqXyxwqFcP6S6/GQwnshaS/SGA2RRdVXhec2gsCfzcKqFN4pZETXj8p4YYzAUauubIkP5yxJe5xyeQnHDzDOxeC7KDuxpt2YYUtgdsrjsQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715299996; c=relaxed/simple;
	bh=mXwnANxyx6SV83YqARPWMxSP88SH+hLM9Y/nKmVDmLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soTDF8tkZ1oTzGx8ip5gUAzEUDrWIBIjqAfCwCIAUlAPuBMIXkMNIIszfYfp05jJYqhuVUea9tuuDlmKmpTFeLBHVSXKWIdlxdHnC14UOZ6G5mXSSps3PJV3tpGuZeB/K/dmb7kni09rrU5VbCI1mGVCrl9J/6T50Gbtdp0idRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 10 May 2024 02:13:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [nf-next PATCH 0/5] Dynamic hook interface binding
Message-ID: <Zj1mlxa-bckdazdv@calendula>
References: <20240503195045.6934-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240503195045.6934-1-phil@nwl.cc>

Hi Phil,

On Fri, May 03, 2024 at 09:50:40PM +0200, Phil Sutter wrote:
> Currently, netdev-family chains and flowtables expect their interfaces
> to exist at creation time. In practice, this bites users of virtual
> interfaces if these happen to be created after the nftables service
> starts up and loads the stored ruleset.
> 
> Vice-versa, if an interface disappears at run-time (via module unloading
> or 'ip link del'), it also disappears from the ruleset, along with the
> chain and its rules which binds to it. This is at least problematic for
> setups which store the running ruleset during system shutdown.
> 
> This series attempts to solve these problems by effectively making
> netdev hooks name-based: If no matching interface is found at hook
> creation time, it will be inactive until a matching interface appears.
> If a bound interface is renamed, a matching inactive hook is searched
> for it.
> 
> Ruleset dumps will stabilize in that regard. To still provide
> information about which existing interfaces a chain/flowtable currently
> binds to, new netlink attributes *_ACT_DEVS are introduced which are
> filled from the active hooks only.
> 
> This series is also prep work for a simple ildcard interface binding
> similar to the wildcard interface matching in meta expression. It should
> suffice to turn struct nft_hook::ops into an array of all matching
> interfaces, but the respective code does not exist yet.

Before taking a closer look: Would it be possible to have a torture
test to exercise this path from userspace?

Thanks!
