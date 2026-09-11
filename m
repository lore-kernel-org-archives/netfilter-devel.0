Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F331924676D;
	Fri, 11 Sep 2026 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126302; cv=none; b=Q3Di2S9goM8LbBJ7CrgHixXe/OcdjLhgMLDtumFt0xAu5yBivFI5NWh/yf0kszYy0dv8I2z9tXhGQKwCJcQkpczbVQ/Kz3Pw/U9jCX8CQ6X+NVWr5y758pcuQUajY6dE7pUaiqSc3F4UGw/iFPfT4bop0krT4p6ayIpZwP7GZVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126302; c=relaxed/simple;
	bh=BHo9LMSaBsPymS/+x9Dr+UAJYrHUkuz0QCym+XAFhSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0/uW+kuqoXdEveok5QxAbqIJtFcpGVDzLonTmZwHn9k2kz0QG7+9IhIbLRxky22RimdTnw/pZNiYQxkPN6+d5ftkIr1URpl3RMVllGvM0x6rcoHKJ1MNEe2gqst2TI7Sg+pvAMZTaXWO4usZkdjnyoQsWBpcQj2V0OnF5+aDlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M11OMq6u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M11OMq6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789126277;
	bh=eQfvuCdYfDRbgvg7ST+cptCBp6rGeQKuTgDUuvhUYN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M11OMq6uCQK2ZUZBRWR3sbDzkUSYg15/6HetxD8/sR6640FoMfZnFH2vNsZkTkEvy
	 EZSswCJvKzoSJoK4F5mJktixypsfCQbp18RznUrNCa0CWvKSMcWPZ5sU02WekdRxKt
	 5uJ+VHapViwBdY2CsWOQx0nspHy6gpbFxcmpZEJLxum/R8g0KQP2fPWWtpJv0BeYRJ
	 UOxUm2UKj5gVX6IGPNfu9GCJisFNrQIZfKBFLr4rnQT9C8+PVh+KGxVbjnC8VZcHff
	 On0M+Ytj+8A9Ab6PB48UqcWNDXmt+8TIG4R1jnZvZk6YcCXSFjtKjpkZr2PK9B484o
	 eevczF7F3mRqw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 675CF603DC;
	Fri, 11 Sep 2026 13:31:17 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:31:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alice Mikityanska <alice.kernel@fastmail.im>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Felix Fietkau <nbd@nbd.name>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Alice Mikityanska <alice@isovalent.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH net] netfilter: flowtable: Saturate 16-bit flow_tuple->mtu
Message-ID: <aqPmghtf5zrFaFao@chamomile>
References: <20260910162052.94648-1-alice.kernel@fastmail.im>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910162052.94648-1-alice.kernel@fastmail.im>

Hi,

On Thu, Sep 10, 2026 at 07:20:52PM +0300, Alice Mikityanska wrote:
> From: Alice Mikityanska <alice@isovalent.com>
> 
> ip6_dst_mtu_maybe_forward clamps its return value to IP6_MAX_MTU, which
> is 40 bytes bigger than U16_MAX. While it can be a valid IPv6 MTU (IPv6
> payload_len doesn't include the header), this value is assigned to the
> 16-bit flow_tuple->mtu in flow_offload_fill_route.
> 
> To avoid the overflow, use U16_MAX for all MTUs bigger than 65535. Since
> flow_tuple->mtu is just a threshold for the software flowtable fast
> path, packets exceeding it won't be dropped, but rather punted to the
> normal forwarding path: nf_flow_offload_ipv6_forward returns 0, and
> nf_flow_offload_ipv6_hook returns NF_ACCEPT.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901195714.673548-1-alice.kernel%40fastmail.im
> Fixes: 4f3780c004ef ("netfilter: nf_flow_table: cache mtu in struct flow_offload_tuple")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Alice Mikityanska <alice@isovalent.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 03241d4bfd5e..8f15540ae206 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -107,7 +107,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
>  		break;
>  	case NFPROTO_IPV6:
> -		flow_tuple->mtu = ip6_dst_mtu_maybe_forward(dst, true);
> +		flow_tuple->mtu = min(ip6_dst_mtu_maybe_forward(dst, true),
> +				      U16_MAX);

This reminds me we should not catch the mtu.

>  		break;
>  	}
>  
> -- 
> 2.55.0
> 
