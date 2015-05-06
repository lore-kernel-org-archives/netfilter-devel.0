From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Wed, 06 May 2015 20:00:42 +0200
Message-ID: <554A56CA.4040101@iogearbox.net>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net> <20150504103451.GA12200@salvia> <55475F13.1000304@iogearbox.net> <20150504130828.GA3607@salvia> <20150504134733.GB1405@pox.localdomain> <20150506142741.GA3547@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52272 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbEFSAq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2015 14:00:46 -0400
In-Reply-To: <20150506142741.GA3547@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 05/06/2015 04:27 PM, Pablo Neira Ayuso wrote:
> On Mon, May 04, 2015 at 03:47:33PM +0200, Thomas Graf wrote:
> [...]
>> Given that the multiple source zones which talk to a common
>> destination zone may have conflicting IPs, the SNAT must either
>> occur in the source zone where the source address is still unique
>> or the CT tuple must be made unique with a source zone identifier
>> so that the SNAT can occur in the destination zone.
>>
>> Doing the SNAT in the source zone requires to use a unique IP pool
>> to map to for each source zone as otherwise IP sources may clash again
>> in the destination zone. We obviously can't do --SNAT -to 10.1.1.1 in
>> two namespaces and then just route into a third namespace. This
>> approach is not scalable in a container environment with 100s or even
>> 1000s of containers each in its own network namespace.
>>
>> What we want to do instead is to do the SNAT in the destination zone
>> where we can have a single SNAT rule which overs all source zones.
>> This allows inter namespace communication in a /31 with minimal waste
>> of addresses.
>
> Thanks for explaining. So you need to allocate an unique tuple using
> the mark to avoid the clashes for the first packet that goes original
> using the same pool. Then, the NAT engine will allocate an unique
> tuple in the reply direction.

Yes, that's correct. In original direction, due to the overlapping
tuple the ct-mark is considered as well for the match, and in reply
direction SNAT chooses already a unique tuple. That's essentially
the rationale for our use case with SNAT.

> But what is the use case for -j CT --flextuple reply ? By when you see
> the reply packet the tuple was already created.

Given this change is completely NAT agnostic, we can keep it as a
generic addition to the conntracker. Given that the mark is very
flexible, I think it could also be used for load balancing as a
different usage.

> Another question is if it makes sense to have part of the flows using
> your flextuple idea while some others not, ie.
>
>          -s x.y.z.w/24 -j CT --flextuple original
>
> so shouldn't this be a global switch that includes the skb->mark
> only for packets coming in the original direction?

I first thought about a global sysctl switch, but eventually found
this config possibility from iptables side much cleaner resp. better
integrated. I think if the environment is correctly configured for
that, such a partial flextuple scenario works, too.

> I also wonder how you're going to deal with port redirections. This
> only seem to be working SNAT/masquerade to me if the NAT happens from
> VRF side.

In our case, we'd like to use the flextuple when we're explicitly
configuring iptables with SNAT. For DNAT, one could reuse it in a
different, somewhat reversed example we previously had and together
with mark based routing and match on the reply side.

Thanks a lot,
Daniel
