From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Fri, 08 May 2015 11:45:29 +0200
Message-ID: <554C85B9.2070206@iogearbox.net>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net> <20150504103451.GA12200@salvia> <55475F13.1000304@iogearbox.net> <20150504130828.GA3607@salvia> <20150504134733.GB1405@pox.localdomain> <20150506142741.GA3547@salvia> <554A56CA.4040101@iogearbox.net> <20150506185040.GA14459@salvia> <554B5407.1060203@iogearbox.net> <20150507181004.GA3470@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@suug.ch>, netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44391 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbbEHJph (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2015 05:45:37 -0400
In-Reply-To: <20150507181004.GA3470@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 05/07/2015 08:10 PM, Pablo Neira Ayuso wrote:
> On Thu, May 07, 2015 at 02:01:11PM +0200, Daniel Borkmann wrote:
>> ...
>>>>> Another question is if it makes sense to have part of the flows using
>>>>> your flextuple idea while some others not, ie.
>>>>>
>>>>>          -s x.y.z.w/24 -j CT --flextuple original
>>>>>
>>>>> so shouldn't this be a global switch that includes the skb->mark
>>>>> only for packets coming in the original direction?
>>>>
>>>> I first thought about a global sysctl switch, but eventually found
>>>> this config possibility from iptables side much cleaner resp. better
>>>> integrated. I think if the environment is correctly configured for
>>>> that, such a partial flextuple scenario works, too.
>>>
>>> This is consuming two ct status bits, these are exposed to userspace,
>>> and we have a limited number of bits there. The one in the original
>>> direction might be justified for the SNAT case in the specific
>>> scenario that you show.
>>
>> Okay, agreed. I will respin the set with --flextuple ORIGINAL direction
>> allowed where we'd for now only consume a single status bit. If later
>> on there's a need to extend this for REPLY (or even hybrid), we still
>> have the option to extend it.
>
> I would like to know if it makes sense to add this later on. Would you
> elaborate a useful DNAT scenario where this can be useful?

What comes to mind in case of hybrid usage for firewalling would be that
flextuple in both directions would act similarly as zones, for example,
you could map things like tunnel id into u32 space and include that into
the match'er w/o many additional rules or memory overhead.

For the reply-only, case I was thinking about a case where you'd have
multiple containers behind the DNAT all with same ip/port each where a
server listens on and you'd select one of the containers e.g. via
xt_statistic module as a mark and do mark-based routing behind the DNAT,
but that itself still has the source in front of the DNAT unique, so it
wouldn't need a mark inclusion in the reply case. So for reply-only, I
currently don't find an intuitive use case.

Best,
Daniel
