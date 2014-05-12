From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH RFC v3 2/2] br_netfilter: per-netns copy of structure
 for sysctl flags
Date: Tue, 13 May 2014 00:11:54 +0400
Message-ID: <53712B0A.7060007@parallels.com>
References: <20140512140706.GA22082@macbook.localnet> <cover.1399909529.git.vvs@openvz.org> <5370F781.7010909@parallels.com> <53711B21.1060309@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:6684 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaELUMO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 16:12:14 -0400
In-Reply-To: <53711B21.1060309@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/12/2014 11:04 PM, Bart De Schuymer wrote:
> Vasily Averin schreef op 12/05/2014 18:32:
>> pernet_operations creates per-netns copy of common structure for sysctl flags
>> and initialize it values taken from init_brnf_net.
>>
>> Signed-off-by: Vasily Averin <vvs@openvz.org>
> 
>> +static int __net_init brnf_net_init(struct net *net)
>> +{
>> +    struct brnf_net *bn = brnf_net(net);
>> +
>> +    memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
>> +    bn->net = net;
>> +    return brnf_sysctl_net_register(bn);
> 
> This does introduce a bit of backwards incompatibility (easily fixed
> by adapting scripts), but this is really unavoidable when
> transforming an existing global configuration to a per-netns
> configuration. I'm ok with it.

Could you please explain, which backward incompatibility you mean here?
Nobody changes values init_brnf_net,
init_net have own copy, like any other network namespaces.
