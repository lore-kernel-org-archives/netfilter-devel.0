Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB28A3C4540;
	Wed, 11 Mar 2026 10:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223656; cv=none; b=Jl5v43XulmLv2wB75NuCYk0LIgyM/88QYDLDvLzPEHyVUXum+gBepk786RlcKHfcGaj2g+E42fzup6JT0lsZef3CTTcTGD9KM5XfUvgGpj4D+0eFB13jNN5sSFEh8GNQq/WfsllPt2s9WE0jxj7vndNSKcEkK+U0hn94CC3VgkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223656; c=relaxed/simple;
	bh=nkFvTOBymiABpgJmrtfhyLTp5hEAWbCMGwh+f3R6Bug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7WUatXgYkuff2+XNI2MLeJeuhtdf3Xr26QIoJYekqURfbhYLizYlmx5wRt4tIGGHYVe4b6NhBYsF1J5mU9SzfWRQjNGUZ6DUtP4G3V8rJAjzTcQOpWDgkvtE6YNdKFdG/8feD442Y0k5cZVRjXEJX8TPH48tbOZAdhCE6dZ2cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B2T7G3YR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B2T7G3YR"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 204986056D;
	Wed, 11 Mar 2026 11:07:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773223653;
	bh=m/8S7RBTR/Do/a9cmkERnH2SfIfHWLQqnSsyCvBT/zo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B2T7G3YRMRWIfuGm4Fiq6EAqej4S2V3tUPqmriquPIDgz/XhAv6Hd9BUm3vGcmUSR
	 ccN5BPf22cRK4s5nBv2h8krEBor4TFg/i9UrriQ7UaDeUUmOixMREgClaCvKL1YC6F
	 Q0TmCowaB+Lg21A6VDoG2tr7x//f7+dHqmY/R+lXanGTjQmKlKve7vVo4afKAeShve
	 6KEb/1N8pbakh+ILwyjI/JU9VISxRruv6KI5e6Fpy7pUNLrK+fRdKvSP/XWay4TpbA
	 QLveZ2cdXt64NVCoVTqJPl7ajZ9dtD2wcZWRwLrQ5wsUy012QFOlvfiWLZdbCgzoEH
	 kxxSYZ+d0/ktg==
Date: Wed, 11 Mar 2026 11:07:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v19 nf-next 5/5] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <abE-4uU7z6BtfhVH@chamomile>
References: <20260224065307.120768-1-ericwouds@gmail.com>
 <20260224065307.120768-6-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260224065307.120768-6-ericwouds@gmail.com>

Hi Eric,

On Tue, Feb 24, 2026 at 07:53:06AM +0100, Eric Woudstra wrote:
> In nft_do_chain_bridge() pktinfo is only fully populated for plain packets
> and packets encapsulated in single 802.1q or 802.1ad.
> 
> When implementing the software bridge-fastpath and testing all possible
> encapulations, there can be more encapsulations:
> 
> The packet could (also) be encapsulated in PPPoE, or the packet could be
> encapsulated in an inner 802.1q, combined with an outer 802.1ad or 802.1q
> encapsulation.
> 
> nft_flow_offload_eval() also examines the L4 header, with the L4 protocol
> known from the conntrack-tuplehash. To access the header it uses
> nft_thoff(), but for these packets it returns zero.
> 
> Introduce nft_set_bridge_pktinfo() to help populate pktinfo with the
> offsets.

I just posted a slightly different approach to deal with this which
also works for the netdev family. My understanding is that your
proposal has a strong dependency on the conntrack infrastructure, and
it would be good if stateless filtering on double-tagged vlan and
pppoe is also possible.
