From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH RFC v3 2/2] br_netfilter: per-netns copy of structure
 for sysctl flags
Date: Tue, 13 May 2014 21:28:06 +0200
Message-ID: <53727246.4050306@pandora.be>
References: <20140512140706.GA22082@macbook.localnet> <cover.1399909529.git.vvs@openvz.org> <5370F781.7010909@parallels.com> <53711B21.1060309@pandora.be> <53712B0A.7060007@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:45450 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaEMT2K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 15:28:10 -0400
In-Reply-To: <53712B0A.7060007@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 12/05/2014 22:11:
> On 05/12/2014 11:04 PM, Bart De Schuymer wrote:
>> Vasily Averin schreef op 12/05/2014 18:32:
>>> pernet_operations creates per-netns copy of common structure for sysctl flags
>>> and initialize it values taken from init_brnf_net.
>>>
>>> Signed-off-by: Vasily Averin <vvs@openvz.org>
>>
>>> +static int __net_init brnf_net_init(struct net *net)
>>> +{
>>> +    struct brnf_net *bn = brnf_net(net);
>>> +
>>> +    memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
>>> +    bn->net = net;
>>> +    return brnf_sysctl_net_register(bn);
>>
>> This does introduce a bit of backwards incompatibility (easily fixed
>> by adapting scripts), but this is really unavoidable when
>> transforming an existing global configuration to a per-netns
>> configuration. I'm ok with it.
>
> Could you please explain, which backward incompatibility you mean here?
> Nobody changes values init_brnf_net,
> init_net have own copy, like any other network namespaces.

Well, init_brnf_net is never written to, so it keeps the default flags.
If a new netns is created, a copy of the contents of init_brnf_net is 
made. So, whenever a netns is created, it starts with the default flags 
(e.g. brnf_call_iptables is always 1 for a newly created netns).

In the current kernel, when a new netns is created, the configuration of 
the main netns is used (the proc system doesn't even show the flags in 
the created netns): if brnf_call_iptables is 0 before the new netns is 
created, iptables won't see bridged IP traffic in the new netns.
With your patch, this behaviour will change.

It's possible to alter your patch to keep the same behaviour as before 
at netns creation, but always starting from the same defaults is cleaner.

cheers,
Bart

