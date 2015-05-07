From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Thu, 07 May 2015 14:01:11 +0200
Message-ID: <554B5407.1060203@iogearbox.net>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net> <20150504103451.GA12200@salvia> <55475F13.1000304@iogearbox.net> <20150504130828.GA3607@salvia> <20150504134733.GB1405@pox.localdomain> <20150506142741.GA3547@salvia> <554A56CA.4040101@iogearbox.net> <20150506185040.GA14459@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@suug.ch>, netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54873 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbbEGMBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 08:01:16 -0400
In-Reply-To: <20150506185040.GA14459@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 05/06/2015 08:50 PM, Pablo Neira Ayuso wrote:
> On Wed, May 06, 2015 at 08:00:42PM +0200, Daniel Borkmann wrote:
>> On 05/06/2015 04:27 PM, Pablo Neira Ayuso wrote:
> [...]

Thanks for your feedback!
...
>>> Another question is if it makes sense to have part of the flows using
>>> your flextuple idea while some others not, ie.
>>>
>>>          -s x.y.z.w/24 -j CT --flextuple original
>>>
>>> so shouldn't this be a global switch that includes the skb->mark
>>> only for packets coming in the original direction?
>>
>> I first thought about a global sysctl switch, but eventually found
>> this config possibility from iptables side much cleaner resp. better
>> integrated. I think if the environment is correctly configured for
>> that, such a partial flextuple scenario works, too.
>
> This is consuming two ct status bits, these are exposed to userspace,
> and we have a limited number of bits there. The one in the original
> direction might be justified for the SNAT case in the specific
> scenario that you show.

Okay, agreed. I will respin the set with --flextuple ORIGINAL direction
allowed where we'd for now only consume a single status bit. If later
on there's a need to extend this for REPLY (or even hybrid), we still
have the option to extend it.

Thanks,
Daniel
