From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH RFC v3 2/2] br_netfilter: per-netns copy of structure
 for sysctl flags
Date: Mon, 12 May 2014 21:04:01 +0200
Message-ID: <53711B21.1060309@pandora.be>
References: <20140512140706.GA22082@macbook.localnet> <cover.1399909529.git.vvs@openvz.org> <5370F781.7010909@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51738 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaELTEF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 15:04:05 -0400
In-Reply-To: <5370F781.7010909@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 12/05/2014 18:32:
> pernet_operations creates per-netns copy of common structure for sysctl flags
> and initialize it values taken from init_brnf_net.
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>

> +static int __net_init brnf_net_init(struct net *net)
> +{
> +	struct brnf_net *bn = brnf_net(net);
> +
> +	memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
> +	bn->net = net;
> +	return brnf_sysctl_net_register(bn);

This does introduce a bit of backwards incompatibility (easily fixed by 
adapting scripts), but this is really unavoidable when transforming an 
existing global configuration to a per-netns configuration. I'm ok with it.

cheers,
Bart

