Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B732860B;
	Wed,  8 Jul 2026 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504135; cv=none; b=FSjxB7TZvV/NgLVSegBshFufXTxt3HO83uFzz+AvjhFnZ1/9CChmOP5S1SVAKOMXw0FxsNUCME/ErOh9LLCHW9SbOY7AXRuf5n4oVbdvGBTgjMmSdAjN3rCZdohN2dkyKnmp++OiVlXG69uM5PEeaPMCHsvA1Z3vwpqtcFadOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504135; c=relaxed/simple;
	bh=X5xuPPkM4pw2HH1LwZVPuqZvsbhgyekRtZKLwkDx22Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCzmHCQTPlJTeee1C1SBc8LUF6xT1x0/Z/d4kccA/6Qct/2K4f++WAZBqfN/mALoXiJWLZ/cVyHHoD8HADhk9M2jE60yhsS2BfgHkYC6d/MkRvQuFEl9TQESVpZZh+nvCXDfL78sq1ZYxpplDQx8gud1Oo71ilpbTMZLvzuGsz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qRIpuNf/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qRIpuNf/"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1053960193;
	Wed,  8 Jul 2026 11:48:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783504132;
	bh=UpErLOvc7LypcUmI0780VM1aFUUZM+RYAVzEWgLm5xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qRIpuNf/dF83w9J6TtQmzlvSWfQ3G1P3DskDtizIcaXbreOgXiEsNEERvHoA3y4yY
	 lCCwMyRak/zSK9ebaUTPCuBUESS+cAu9GYN8Vy180Eji5gif9ygiLE7PQfkoTdO/Jx
	 oVaD9+/jbsZWMgYIB7Pm3XCCIYZACUDggdh+iEm8asksjmav7y1d3RQBoTA8l02fDD
	 z8ESgkeQD3T/G9QKHGk+d5bY+XScnZcQ9JdfYnjVYw9brH10Ts0cFj1eAxc+BXkE2i
	 S/hcLlKpT8Ue2FZukY/NegtndsnB/iIO/e6s+QE/cd7u8mrMhfjcSpXfQzfHArD2E+
	 oGXjPtu3OxM8g==
Date: Wed, 8 Jul 2026 11:48:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v12 nf-next 3/7] netfilter: nf_flow_table_offload: Add
 nf_flow_rule_bridge()
Message-ID: <ak4dAXHDmTDRr7-b@chamomile>
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260707091045.967678-4-ericwouds@gmail.com>

Hi,

On Tue, Jul 07, 2026 at 11:10:41AM +0200, Eric Woudstra wrote:
> Add nf_flow_rule_bridge().
> 
> It only calls the common rule and adds the redirect.

I decided to use the new _unsupp() function, so we don't pretend
bridge hw offload is already supported. We will need a driver before
we can add this, this stub does not provide much. I guess your goal
was just to avoid a crash here.

> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  include/net/netfilter/nf_flow_table.h |  3 +++
>  net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 7b23b245a5a86..5c6e3b65ae85b 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -368,6 +368,9 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
>  int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  				struct net_device *dev,
>  				enum flow_block_command cmd);
> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
> +			enum flow_offload_tuple_dir dir,
> +			struct nf_flow_rule *flow_rule);
>  int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>  			    enum flow_offload_tuple_dir dir,
>  			    struct nf_flow_rule *flow_rule);
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 002ec15d988bd..5566ebda7b7d3 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -740,6 +740,19 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
>  	return 0;
>  }
>  
> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
> +			enum flow_offload_tuple_dir dir,
> +			struct nf_flow_rule *flow_rule)
> +{
> +	if (nf_flow_rule_route_common(net, flow, dir, flow_rule) < 0)
> +		return -1;
> +
> +	flow_offload_redirect(net, flow, dir, flow_rule);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nf_flow_rule_bridge);
> +
>  int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>  			    enum flow_offload_tuple_dir dir,
>  			    struct nf_flow_rule *flow_rule)
> -- 
> 2.53.0
> 
