Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3288280338;
	Tue,  3 Jun 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748938479; cv=none; b=gybp2XLZrRMXteFXZO/bS8yhceYdkdDRJrPBNWbIq3nPxmxGEPZGAWIiKflBuQu0+RS2UCbrskLFASnqggfTIPKHsSN+Q/PViPjYe9DhRDM4oFc2Wa00cF8buphQRDo4CR2yUCtf3O3DM7Lnxt8jIhNILYn0PV8KyaA2kO0iV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748938479; c=relaxed/simple;
	bh=edrs3H0m30rnRHzLmujwAe+hkL/oUXIBfxEUcstqNNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOZnZJRg9iZcNqD/iCj68QORuxvptpLJfLteFl63jmZp/tKd3zQh94EqIUDitg1U6R9Wkla0n0qXlvFqTfWrXd7R8tHjF7VHINPsBRBFcLSdVD9LbhgvuHH80rkTp3Qchcj/prhIXTEqySVZRiRruR1Vz+01QByR65D8HEZ+Ihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJDWo8Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJDWo8Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA83C4CEEE;
	Tue,  3 Jun 2025 08:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748938478;
	bh=edrs3H0m30rnRHzLmujwAe+hkL/oUXIBfxEUcstqNNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EJDWo8WsLy21GQiSOhsfQ832+Vv8nyNPKUJnGnwqxBs3QCcRn9fC3JTcsNakrbQpt
	 BnyNPUYsix0mmO9FXFAW3i2gqSI0dDOfA70yedVJWsYKb5u+6vzI0OVUC0p/h3p/rM
	 xvlwIhUy0hlFPrIMFHiIjNwOleb30QIgdr89xDaA3KvryN1pOJvfSoNN3v3UKP5Eu5
	 evh04U1MmMQgH/dswd5ASrFr1CwvjzZX/u80rf9k68XoP43qnMIyZoBa340zd+HkrE
	 rsdQjBlfGBd2Xc7owvVCKJXbCDHrGDK4smmTZDYdi6NmjPzBVNBdTBTlO9CvJ363Ft
	 Q7mWWEXuXgScw==
Date: Tue, 3 Jun 2025 09:14:34 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de, kuniyu@amazon.com
Subject: Re: [PATCH nf-next,v2] netfilter: conntrack: remove DCCP protocol
 support
Message-ID: <20250603081434.GY1484967@horms.kernel.org>
References: <20250522145223.198902-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522145223.198902-1-pablo@netfilter.org>

On Thu, May 22, 2025 at 04:52:23PM +0200, Pablo Neira Ayuso wrote:
> The DCCP socket family has now been removed from this tree, see:
> 
>   8bb3212be4b4 ("Merge branch 'net-retire-dccp-socket'")
> 
> Remove connection tracking and NAT support for this protocol, this
> should not pose a problem because no DCCP traffic is expected to be seen
> on the wire.
> 
> As for the code for matching on dccp header for iptables and nftables,
> mark it as deprecated and keep it in place. Ruleset restoration is an
> atomic operation. Without dccp matching support, an astray match on dccp
> could break this operation leaving your computer with no policy in
> place, so let's follow a more conservative approach for matches.
> 
> Add CONFIG_NFT_EXTHDR_DCCP which is set to 'n' by default to deprecate
> dccp extension support. Similarly, label CONFIG_NETFILTER_XT_MATCH_DCCP
> as deprecated too and also set it to 'n' by default.
> 
> Code to match on DCCP protocol from ebtables also remains in place, this
> is just a few checks on IPPROTO_DCCP from _check() path which is
> exercised when ruleset is loaded. There is another use of IPPROTO_DCCP
> from the _check() path in the iptables multiport match. Another check
> for IPPROTO_DCCP from the packet in the reject target is also removed.
> 
> So let's schedule removal of the dccp matching for a second stage, this
> should not interfer with the dccp retirement since this is only matching

nit: interfere

> on the dccp header.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: remove superfluous exception with ct expectation objects.

Reviewed-by: Simon Horman <horms@kernel.org>

