From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Fri, 27 Mar 2015 10:48:51 +0100
Message-ID: <55152783.4000607@iogearbox.net>
References: <cover.1427394874.git.daniel@iogearbox.net> <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net> <20150327001408.GD3545@salvia> <20150327021014.GA3142@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59146 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbC0Js6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 05:48:58 -0400
In-Reply-To: <20150327021014.GA3142@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/27/2015 03:10 AM, Pablo Neira Ayuso wrote:
> On Fri, Mar 27, 2015 at 01:14:08AM +0100, Pablo Neira Ayuso wrote:
>>> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>>> index 971cd75..044bd22 100644
>>> --- a/net/netfilter/Kconfig
>>> +++ b/net/netfilter/Kconfig
>>> @@ -960,8 +960,13 @@ config NETFILTER_XT_MATCH_BPF
>>>
>>>   config NETFILTER_XT_MATCH_CGROUP
>>>   	tristate '"control group" match support'
>>> +	depends on NETFILTER_XTABLES
>>
>> why this? I think NETFILTER_ADVANCED is sufficient.
>>
>>>   	depends on NETFILTER_ADVANCED
>>> +	depends on !NF_CONNTRACK || NF_CONNTRACK
>>
>> why conntrack?
>>
>>> +	depends on (IPV6 || IPV6=n)
>>
>> Do we depend on any ipv6 symbol?
>>
>>>   	depends on CGROUPS
>>> +	select NF_DEFRAG_IPV4
>>> +	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
>>
>> No need for defrag either.
>
> Wait, now I see why you need this.
>
> What started a simple cgroup match extension is turning into a more
> complicated thing. And you want to do firewalling with this, which
> doesn't work for other socket families than TCP and UDP.

Right, so for me it started out as a simple outgoing match extension
for skb->sk and this should be protocol agnostic, for example, SCTP
sets the skb owner in its output path, so the cgroup id would work
there, too. (That should be the case for every protocol that's doing
proper socket accounting.)

People have since then seen a use case for accounting, so support
was added for local-in (which we try to fix), where it's being used
in Tizen OS apparently, but the idea for realizing a per-application,
per-container, ... firewall for both filtering and accounting sounds
appealing to me.

So, I'd like to get this right for iptables and am also eager to help
out fixing this in nft. I was thinking that if we add --lookup-sock
in a second revision, the man-page would _clearly_ need to describe
that when being used w/o the lookup option, it only works for protocols
making use of early demuxes on ingress, and when being being used with
the lookup option, we would have TCP/UDP covered on ingress. Would
that be fine as a start to have this documented? Or, would nft also
require niche protocols like SCTP/DCCP to be supported for the lookup
up-front?

What I've seen so far is, that besides the basic xt_sctp matching,
the perhaps biggest request SCTP users might have, is that association
tracking currently is missing for the conntracker and ipvs to make
their multi-homed use-cases work, but I guess I'm starting to get
off-topic. :)

Thanks,
Daniel
