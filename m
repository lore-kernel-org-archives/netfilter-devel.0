Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCA9190052
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 23:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742684870; cv=none; b=aKzJksmJjSe5qRZY5jtPrCoar8n7485MsiW57evfaHMKobuaBhICzS2nmKWDyao5cqHR+CPPxtGeHEzqNrFiJkBd0AMRU9ZLFjUW0XexRlodQSxj/hGsKEBkV4ZLRHxfnZmB1x2rMN2NAHiCJOcF4/MWFzB/73t+V/5hCsTTdlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742684870; c=relaxed/simple;
	bh=Mg1hHKa6dO7xw9upwrYYLOBr5R4K40MXBhd5Lwe4mzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vv1+mQi/TDCyb/cGgHcaSzovyDwX9FDRWb/iRwl0Nu0F+VfyrsfEiJzzupm04rZzzevLEJoAwNtKDw8Qo5k/hnSb6hrRvhNPKq4zsJ4Kz4h2dA1QLBpqddoFGCDLZDGW8squZtIXPPxH/XuyC6N0E8Q7S8fj1EES+TiG5iYX0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tw7wJ-0007Ut-Ca; Sun, 23 Mar 2025 00:07:39 +0100
Date: Sun, 23 Mar 2025 00:07:39 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: replace select by depends on for
 IP{6}_NF_IPTABLES_LEGACY
Message-ID: <20250322230739.GA28529@breakpoint.cc>
References: <20250321103647.409501-1-pablo@netfilter.org>
 <20250321145845.GC20305@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321145845.GC20305@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> ./extensions/libxt_TCPOPTSTRIP.t: ERROR: line 4 (cannot load: ip6tables -A PREROUTING -t mangle -p tcp -j TCPOPTSTRIP)
> ./extensions/libxt_TCPOPTSTRIP.t: ERROR: line 5 (cannot load: ip6tables -A PREROUTING -t mangle -p tcp -j TCPOPTSTRIP --strip-options 2,3,4,5,6,7)
> 
> The kernel module has a 'defined' check for ipv6 mangle table, not sure
> yet how to replace this (ipv4 works).

Probably best to replace two
IS_ENABLED(CONFIG_IP6_NF_MANGLE)
with
IS_ENABLED(CONFIG_IP6_NF_IPTABLES)

The Kconfig dependencies require either NFT_COMPAT or IP6_NF_MANGLE.
With the planned LEGACY change MANGLE table isn't set anymore but
NFT_COMPAT is.

For existing cases (LEGACY set) there would be no difference in
behavior given MANGLE is a subset of IP6_NF_IPTABLES.

We should propbably also select
CONFIG_IP6_NF_IPTABLES in case CONFIG_IP6_NF_IPTABLES=y|m to make
sure you can't create a kernel with
CONFIG_IP6_NF_IPTABLES=n
CONFIG_IP6_NF_IPTABLES_LEGACY=m|y
